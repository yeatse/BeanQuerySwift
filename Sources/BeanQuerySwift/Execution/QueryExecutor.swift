import Foundation
import BeancountSwift

struct QueryExecutor {
    /// Kept in sync with `BQLCompiler.aggregateFunctions`.
    private static let aggregateFunctionNames: Set<String> = [
        "count", "sum", "first", "last", "min", "max"
    ]

    private struct DateStride: Equatable, Sendable {
        var years: Int
        var months: Int
        var days: Int

        var negated: DateStride {
            DateStride(years: -years, months: -months, days: -days)
        }

        var runtimeValue: RuntimeValue {
            .list([.int(years), .int(months), .int(days)])
        }

        static func fromRuntimeValue(_ value: RuntimeValue) -> DateStride? {
            guard case .list(let values) = value,
                  values.count == 3,
                  case .int(let years) = values[0],
                  case .int(let months) = values[1],
                  case .int(let days) = values[2]
            else {
                return nil
            }
            return DateStride(years: years, months: months, days: days)
        }
    }

    func execute(_ query: EvalQuery, context: QueryContext) throws -> QueryResult {
        let visible = query.targets.enumerated().compactMap { index, target in
            target.name == nil ? nil : (index, target.name!)
        }
        let sourceRows = try loadSourceRows(query.source, context: context)
        let columns = visible.map(\.1)

        if canStreamProjectedRows(query) {
            let projectedRows = try evaluateVisibleRows(
                query: query,
                rows: sourceRows,
                visibleIndexes: visible.map(\.0),
                context: context
            )
            return QueryResult(columns: columns, rows: projectedRows)
        }

        let fullRows = try evaluateRows(query: query, rows: sourceRows, context: context)
        var projectedRows = fullRows.map { row in
            visible.map { row[$0.0] }
        }

        if query.distinct {
            var seen = Set<[RuntimeValue]>()
            projectedRows = projectedRows.filter { seen.insert($0).inserted }
        }

        if let limit = query.limit {
            projectedRows = Array(projectedRows.prefix(limit))
        }

        if let pivotIndexes = query.pivotIndexes {
            let visibleIndexes = Dictionary(uniqueKeysWithValues: visible.enumerated().map { offset, item in
                (item.0, offset)
            })
            guard let first = visibleIndexes[pivotIndexes[0]],
                  let second = visibleIndexes[pivotIndexes[1]]
            else {
                throw BQLExecutionError.invalidPivotByColumns
            }

            let pivoted = pivot(
                rows: projectedRows,
                columns: columns,
                firstColumn: first,
                secondColumn: second
            )
            var columns = columns
            columns = pivoted.columns
            projectedRows = pivoted.rows
            return QueryResult(columns: columns, rows: projectedRows)
        }

        return QueryResult(columns: columns, rows: projectedRows)
    }

    private func canStreamProjectedRows(_ query: EvalQuery) -> Bool {
        query.groupIndexes == nil
            && query.orderSpec == nil
            && !query.distinct
            && query.pivotIndexes == nil
    }

    private func loadSourceRows(_ source: EvalSource, context: QueryContext) throws -> QueryRowSequence {
        switch source.table {
        case .named(let name):
            if let provider = context.provider(named: name) {
                return try provider.rows(for: source.qualifiers)
            }

            guard let rows = context.tables[name] else {
                throw BQLExecutionError.tableNotFound(name)
            }

            guard source.qualifiers == nil else {
                throw BQLExecutionError.qualifiersUnsupported(name)
            }

            return QueryRowSequence(rows)

        case .hash(let name):
            if let name {
                if let provider = context.provider(named: name) {
                    return try provider.rows(for: source.qualifiers)
                }

                guard let rows = context.tables[name] else {
                    throw BQLExecutionError.tableNotFound(name)
                }

                guard source.qualifiers == nil else {
                    throw BQLExecutionError.qualifiersUnsupported(name)
                }

                return QueryRowSequence(rows)
            }

            guard source.qualifiers == nil else {
                throw BQLExecutionError.qualifiersUnsupported("#")
            }
            return QueryRowSequence([[:]])

        case .subquery(let subquery):
            let result = try execute(subquery, context: context)
            return QueryRowSequence(
                result.rows.lazy.map { row in
                    QueryRow(Dictionary(uniqueKeysWithValues: zip(result.columns, row)))
                }
            )
        }
    }

    private func evaluateRows(
        query: EvalQuery,
        rows: QueryRowSequence,
        context: QueryContext
    ) throws -> [[RuntimeValue]] {
        if query.groupIndexes == nil {
            var output: [[RuntimeValue]] = []
            for row in rows {
                if let filter = query.filter {
                    guard try evaluateBoolean(
                        filter,
                        row: row,
                        aggregates: nil,
                        context: context
                    ) else {
                        continue
                    }
                }

                let values = try query.targets.map { target in
                    try evaluateExpression(
                        target.expression,
                        row: row,
                        aggregates: nil,
                        context: context
                    )
                }
                output.append(values)
            }
            return applyOrdering(output, orderSpec: query.orderSpec)
        }

        let groupIndexes = query.groupIndexes ?? []
        // Like beanquery (`query_execute.execute_select`), the aggregates are
        // fed from a single pass over the source: every aggregate argument is
        // evaluated once per row, as the row arrives. Columns such as `balance`
        // accumulate as they are read, so buffering the rows and evaluating them
        // afterwards would accumulate in group order, and re-evaluating them
        // once per aggregate would accumulate twice.
        let aggregateExpressions = self.aggregateExpressions(of: query)
        // Groups are kept in an array so they come out in first-appearance
        // order, like beanquery iterating its insertion-ordered `aggregates`
        // dict; a Swift Dictionary hands back a different order on every run.
        var groupIndexOfKey: [GroupKey: Int] = [:]
        var groups: [(key: GroupKey, state: GroupState)] = []

        for row in rows {
            if let filter = query.filter {
                guard try evaluateBoolean(
                    filter,
                    row: row,
                    aggregates: nil,
                    context: context
                ) else {
                    continue
                }
            }

            let keyValues = try groupIndexes.map { index in
                try evaluateExpression(
                    query.targets[index].expression,
                    row: row,
                    aggregates: nil,
                    context: context
                )
            }

            let key = GroupKey(values: keyValues)
            let groupIndex: Int
            if let existing = groupIndexOfKey[key] {
                groupIndex = existing
            } else {
                groupIndex = groups.count
                groupIndexOfKey[key] = groupIndex
                groups.append((
                    key,
                    GroupState(
                        representativeRow: row,
                        argumentValues: Array(repeating: [], count: aggregateExpressions.count)
                    )
                ))
            }

            groups[groupIndex].state.rowCount += 1
            for (index, aggregate) in aggregateExpressions.enumerated() {
                guard let argument = aggregate.argument else {
                    continue
                }
                let value = try evaluateExpression(
                    argument,
                    row: row,
                    aggregates: nil,
                    context: context
                )
                groups[groupIndex].state.argumentValues[index].append(value)
            }
        }

        var output: [[RuntimeValue]] = []
        for (key, state) in groups {
            let aggregates = AggregateResults(
                expressions: aggregateExpressions,
                values: try aggregateExpressions.enumerated().map { index, aggregate in
                    try reduceAggregate(
                        aggregate,
                        argumentValues: state.argumentValues[index],
                        rowCount: state.rowCount
                    )
                }
            )

            let values = try query.targets.enumerated().map { index, target in
                if let keyIndex = groupIndexes.firstIndex(of: index) {
                    return key.values[keyIndex]
                }
                return try evaluateExpression(
                    target.expression,
                    row: state.representativeRow,
                    aggregates: aggregates,
                    context: context
                )
            }

            if let havingIndex = query.havingIndex {
                if try !asBool(values[havingIndex]) {
                    continue
                }
            }

            output.append(values)
        }

        return applyOrdering(output, orderSpec: query.orderSpec)
    }

    /// The aggregate calls the query's non-key targets make, in the order a
    /// pre-order walk finds them.
    ///
    /// beanquery collects the same set with `get_columns_and_aggregates` and
    /// updates each of them per row; nested aggregates are rejected by the
    /// compiler, so the walk stops at an aggregate call.
    private func aggregateExpressions(of query: EvalQuery) -> [AggregateCall] {
        let groupIndexes = Set(query.groupIndexes ?? [])
        var calls: [AggregateCall] = []

        for (index, target) in query.targets.enumerated() where !groupIndexes.contains(index) {
            collectAggregateCalls(target.expression, into: &calls)
        }
        return calls
    }

    private func collectAggregateCalls(_ expression: BQLExpression, into calls: inout [AggregateCall]) {
        switch expression {
        case .function(let name, let args):
            let normalized = name.lowercased()
            if Self.aggregateFunctionNames.contains(normalized) {
                let call = AggregateCall(name: normalized, args: args)
                if !calls.contains(call) {
                    calls.append(call)
                }
                return
            }
            for arg in args {
                collectAggregateCalls(arg, into: &calls)
            }

        case .and(let args), .or(let args):
            for arg in args {
                collectAggregateCalls(arg, into: &calls)
            }

        case .unary(_, let operand), .attribute(let operand, _), .subscriptExpr(let operand, _):
            collectAggregateCalls(operand, into: &calls)

        case .binary(_, let left, let right), .anyAll(_, _, let left, let right):
            collectAggregateCalls(left, into: &calls)
            collectAggregateCalls(right, into: &calls)

        case .between(let value, let lower, let upper):
            collectAggregateCalls(value, into: &calls)
            collectAggregateCalls(lower, into: &calls)
            collectAggregateCalls(upper, into: &calls)

        case .column, .constant, .placeholder, .select, .asterisk:
            break
        }
    }

    /// Fold the per-row argument values a group collected into the aggregate's
    /// result. The values arrive in scan order, so `first`/`last` are the first
    /// and last row of the group.
    private func reduceAggregate(
        _ aggregate: AggregateCall,
        argumentValues values: [RuntimeValue],
        rowCount: Int
    ) throws -> RuntimeValue {
        switch aggregate.name {
        case "count":
            if aggregate.isCountStar {
                return .int(rowCount)
            }
            return .int(values.filter { $0 != .null }.count)

        case "sum":
            return try sum(values)

        case "first":
            return values.first ?? .null

        case "last":
            return values.last ?? .null

        case "min":
            return values.filter { $0 != .null }.min { compare($0, $1) == .orderedAscending } ?? .null

        case "max":
            return values.filter { $0 != .null }.max { compare($0, $1) == .orderedAscending } ?? .null

        default:
            throw BQLExecutionError.unsupportedFunction(aggregate.name)
        }
    }

    private func evaluateVisibleRows(
        query: EvalQuery,
        rows: QueryRowSequence,
        visibleIndexes: [Int],
        context: QueryContext
    ) throws -> [[RuntimeValue]] {
        if query.limit == 0 {
            return []
        }

        var output: [[RuntimeValue]] = []
        if let limit = query.limit {
            output.reserveCapacity(limit)
        }

        for row in rows {
            if let filter = query.filter {
                guard try evaluateBoolean(
                    filter,
                    row: row,
                    aggregates: nil,
                    context: context
                ) else {
                    continue
                }
            }

            let values = try visibleIndexes.map { index in
                try evaluateExpression(
                    query.targets[index].expression,
                    row: row,
                    aggregates: nil,
                    context: context
                )
            }
            output.append(values)

            if let limit = query.limit, output.count >= limit {
                break
            }
        }

        return output
    }

    private func applyOrdering(_ rows: [[RuntimeValue]], orderSpec: [EvalOrderSpec]?) -> [[RuntimeValue]] {
        guard let orderSpec, !orderSpec.isEmpty else {
            return rows
        }

        return rows.sorted { left, right in
            for spec in orderSpec {
                let result = compare(left[spec.index], right[spec.index])
                guard result != .orderedSame else {
                    continue
                }

                if spec.ordering == .ascending {
                    return result == .orderedAscending
                }
                return result == .orderedDescending
            }
            return false
        }
    }

    private func pivot(
        rows: [[RuntimeValue]],
        columns: [String],
        firstColumn: Int,
        secondColumn: Int
    ) -> (columns: [String], rows: [[RuntimeValue]]) {
        let pivotLabel = "\(columns[firstColumn])/\(columns[secondColumn])"
        let otherColumns = (0..<columns.count).filter { index in
            index != firstColumn && index != secondColumn
        }
        let nonPivotCount = otherColumns.count

        let keys = Array(Set(rows.map { $0[secondColumn] })).sorted { left, right in
            compare(left, right) == .orderedAscending
        }

        var outputColumns: [String] = [pivotLabel]
        if nonPivotCount > 1 {
            for key in keys {
                let keyName = renderValue(key)
                for index in otherColumns {
                    outputColumns.append("\(keyName)/\(columns[index])")
                }
            }
        } else {
            outputColumns.append(contentsOf: keys.map(renderValue))
        }

        let grouped = Dictionary(grouping: rows, by: { $0[firstColumn] })
        let sortedGroupKeys = grouped.keys.sorted { left, right in
            compare(left, right) == .orderedAscending
        }
        let keyOffsets = Dictionary(uniqueKeysWithValues: keys.enumerated().map { ($1, $0) })

        var outputRows: [[RuntimeValue]] = []
        for groupKey in sortedGroupKeys {
            var outputRow = Array(repeating: RuntimeValue.null, count: outputColumns.count)
            outputRow[0] = groupKey

            guard let groupRows = grouped[groupKey], nonPivotCount > 0 else {
                outputRows.append(outputRow)
                continue
            }

            for row in groupRows {
                guard let keyOffset = keyOffsets[row[secondColumn]] else {
                    continue
                }

                let start = keyOffset * nonPivotCount + 1
                for (offset, index) in otherColumns.enumerated() {
                    outputRow[start + offset] = row[index]
                }
            }

            outputRows.append(outputRow)
        }

        return (outputColumns, outputRows)
    }

    private func evaluateBoolean(
        _ expression: BQLExpression,
        row: QueryRow,
        aggregates: AggregateResults?,
        context: QueryContext
    ) throws -> Bool {
        let value = try evaluateExpression(expression, row: row, aggregates: aggregates, context: context)
        return try asBool(value)
    }

    private func evaluateExpression(
        _ expression: BQLExpression,
        row: QueryRow,
        aggregates: AggregateResults?,
        context: QueryContext
    ) throws -> RuntimeValue {
        switch expression {
        case .column(let name):
            return row[name] ?? .null

        case .constant(let literal):
            return try mapLiteral(literal)

        case .placeholder(let placeholder):
            throw BQLExecutionError.unsupportedExpression("placeholder \(placeholder)")

        case .unary(let op, let operand):
            let value = try evaluateExpression(operand, row: row, aggregates: aggregates, context: context)
            switch op {
            case .not:
                return .bool(try !asBool(value))
            case .neg:
                return try value.negated()
            case .isNull:
                return .bool(value == .null)
            case .isNotNull:
                return .bool(value != .null)
            }

        case .binary(let op, let leftExpr, let rightExpr):
            let left = try evaluateExpression(leftExpr, row: row, aggregates: aggregates, context: context)
            let right = try evaluateExpression(rightExpr, row: row, aggregates: aggregates, context: context)
            return try evaluateBinary(op: op, left: left, right: right)

        case .and(let args):
            for arg in args {
                if try !evaluateBoolean(arg, row: row, aggregates: aggregates, context: context) {
                    return .bool(false)
                }
            }
            return .bool(true)

        case .or(let args):
            for arg in args {
                if try evaluateBoolean(arg, row: row, aggregates: aggregates, context: context) {
                    return .bool(true)
                }
            }
            return .bool(false)

        case .between(let valueExpr, let lowerExpr, let upperExpr):
            let value = try evaluateExpression(valueExpr, row: row, aggregates: aggregates, context: context)
            let lower = try evaluateExpression(lowerExpr, row: row, aggregates: aggregates, context: context)
            let upper = try evaluateExpression(upperExpr, row: row, aggregates: aggregates, context: context)
            guard value != .null, lower != .null, upper != .null else {
                return .null
            }
            let lowerCmp = compare(value, lower)
            let upperCmp = compare(value, upper)
            return .bool((lowerCmp == .orderedSame || lowerCmp == .orderedDescending)
                         && (upperCmp == .orderedSame || upperCmp == .orderedAscending))

        case .anyAll(let op, let quantifier, let leftExpr, let rightExpr):
            let left = try evaluateExpression(leftExpr, row: row, aggregates: aggregates, context: context)
            let right = try evaluateExpression(rightExpr, row: row, aggregates: aggregates, context: context)
            guard left != .null, right != .null else {
                return .null
            }
            guard case .list(let values) = right else {
                throw BQLExecutionError.invalidType
            }

            let results = try values.map { value in
                try evaluateBinary(op: op, left: left, right: value)
            }
            let bools = try results.map(asBool)

            switch quantifier {
            case .any:
                return .bool(bools.contains(true))
            case .all:
                return .bool(!bools.contains(false))
            }

        case .attribute(let operandExpr, let name):
            let value = try evaluateExpression(operandExpr, row: row, aggregates: aggregates, context: context)
            return try resolveAttribute(value, name: name)

        case .subscriptExpr:
            throw BQLExecutionError.unsupportedExpression("subscript")

        case .select:
            throw BQLExecutionError.unsupportedExpression("subquery expression")

        case .asterisk:
            return .null

        case .function(let name, let args):
            return try evaluateFunction(
                name: name,
                args: args,
                row: row,
                aggregates: aggregates,
                context: context
            )
        }
    }

    private func evaluateFunction(
        name: String,
        args: [BQLExpression],
        row: QueryRow,
        aggregates: AggregateResults?,
        context: QueryContext
    ) throws -> RuntimeValue {
        let normalized = name.lowercased()

        if normalized == "coalesce" {
            guard !args.isEmpty else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            for arg in args {
                let value = try evaluateExpression(arg, row: row, aggregates: aggregates, context: context)
                if value != .null {
                    return value
                }
            }
            return .null
        }

        if Self.aggregateFunctionNames.contains(normalized) {
            // Aggregates are folded from the values collected during the scan;
            // reaching one outside a grouped query is a compile-time error.
            guard let value = aggregates?.value(for: AggregateCall(name: normalized, args: args)) else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return value
        }

        let values = try args.map { try evaluateExpression($0, row: row, aggregates: aggregates, context: context) }
        return try BuiltinFunctionEvaluator(context: context).evaluate(
            name: name,
            normalizedName: normalized,
            arguments: values,
            row: row
        )
    }

    private func evaluateBinary(op: BQLBinaryOperator, left: RuntimeValue, right: RuntimeValue) throws -> RuntimeValue {
        guard left != .null, right != .null else {
            return .null
        }

        switch op {
        case .add:
            if let l = asInt(left), let r = asInt(right) {
                return .int(l + r)
            }
            if let lhsDate = asDate(left), let rhsStride = asDateStride(right) {
                return addStride(lhsDate, rhsStride).map(RuntimeValue.date) ?? .null
            }
            if let lhsStride = asDateStride(left), let rhsDate = asDate(right) {
                return addStride(rhsDate, lhsStride).map(RuntimeValue.date) ?? .null
            }
            if let lhsStride = asDateStride(left), let rhsStride = asDateStride(right) {
                return DateStride(
                    years: lhsStride.years + rhsStride.years,
                    months: lhsStride.months + rhsStride.months,
                    days: lhsStride.days + rhsStride.days
                ).runtimeValue
            }
            if let l = asDecimal(left), let r = asDecimal(right) {
                return .decimal(l + r)
            }
            if case .string(let l) = left, case .string(let r) = right {
                return .string(l + r)
            }
            throw BQLExecutionError.invalidType

        case .sub:
            if let l = asInt(left), let r = asInt(right) {
                return .int(l - r)
            }
            if let lhsDate = asDate(left), let rhsStride = asDateStride(right) {
                return addStride(lhsDate, rhsStride.negated).map(RuntimeValue.date) ?? .null
            }
            if let lhsDate = asDate(left), let rhsDate = asDate(right) {
                guard let days = daysBetween(rhsDate, lhsDate) else {
                    return .null
                }
                return .int(days)
            }
            if let lhsStride = asDateStride(left), let rhsStride = asDateStride(right) {
                return DateStride(
                    years: lhsStride.years - rhsStride.years,
                    months: lhsStride.months - rhsStride.months,
                    days: lhsStride.days - rhsStride.days
                ).runtimeValue
            }
            if let l = asDecimal(left), let r = asDecimal(right) {
                return .decimal(l - r)
            }
            throw BQLExecutionError.invalidType

        case .mul:
            if let l = asInt(left), let r = asInt(right) {
                return .int(l * r)
            }
            if let l = asDecimal(left), let r = asDecimal(right) {
                return .decimal(l * r)
            }
            throw BQLExecutionError.invalidType

        case .div:
            if let l = asDecimal(left), let r = asDecimal(right) {
                return r == .zero ? .null : .decimal(l / r)
            }
            if let l = asInt(left), let r = asInt(right) {
                return r == 0 ? .null : .decimal(Decimal(l) / Decimal(r))
            }
            throw BQLExecutionError.invalidType

        case .mod:
            if let l = asInt(left), let r = asInt(right) {
                return r == 0 ? .null : .int(l % r)
            }
            throw BQLExecutionError.invalidType

        case .equal:
            return .bool(numericEquals(left, right))

        case .notEqual:
            return .bool(!numericEquals(left, right))

        case .less:
            return .bool(compare(left, right) == .orderedAscending)

        case .lessOrEqual:
            let cmp = compare(left, right)
            return .bool(cmp == .orderedAscending || cmp == .orderedSame)

        case .greater:
            return .bool(compare(left, right) == .orderedDescending)

        case .greaterOrEqual:
            let cmp = compare(left, right)
            return .bool(cmp == .orderedDescending || cmp == .orderedSame)

        case .inList:
            guard case .list(let values) = right else {
                throw BQLExecutionError.invalidType
            }
            return .bool(values.contains(left))

        case .notInList:
            guard case .list(let values) = right else {
                throw BQLExecutionError.invalidType
            }
            return .bool(!values.contains(left))

        case .match:
            guard case .string(let input) = left, case .string(let pattern) = right else {
                throw BQLExecutionError.invalidType
            }
            return .bool(matches(pattern: pattern, in: input, caseInsensitive: true))

        case .notMatch:
            guard case .string(let input) = left, case .string(let pattern) = right else {
                throw BQLExecutionError.invalidType
            }
            return .bool(!matches(pattern: pattern, in: input, caseInsensitive: true))

        case .matches:
            guard case .string(let pattern) = left, case .string(let input) = right else {
                throw BQLExecutionError.invalidType
            }
            return .bool(matches(pattern: pattern, in: input, caseInsensitive: false))
        }
    }

    private func sum(_ values: [RuntimeValue]) throws -> RuntimeValue {
        let nonNull = values.filter { $0 != .null }
        if nonNull.isEmpty {
            return .null
        }

        if nonNull.contains(where: { if case .decimal = $0 { return true } else { return false } }) {
            let total = try nonNull.reduce(Decimal.zero) { partial, value in
                guard let decimal = asDecimal(value) else {
                    throw BQLExecutionError.invalidType
                }
                return partial + decimal
            }
            return .decimal(total)
        }

        if nonNull.allSatisfy({
            if case .int = $0 { return true }
            return false
        }) {
            let total = nonNull.reduce(0) { partial, value in
                guard case .int(let int) = value else { return partial }
                return partial + int
            }
            return .int(total)
        }

        var inventory = Inventory()
        for value in nonNull {
            switch value {
            case .amount(let amount):
                _ = inventory.addAmount(amount)
            case .position(let position):
                _ = inventory.addAmount(position.units, cost: position.cost)
            case .inventory(let partial):
                inventory = inventory + partial
            default:
                throw BQLExecutionError.invalidType
            }
        }
        return .inventory(inventory)
    }

    private func mapLiteral(_ literal: BQLLiteral) throws -> RuntimeValue {
        switch literal {
        case .integer(let value):
            return .int(value)
        case .decimal(let value):
            return .decimal(value)
        case .date(let value):
            return .date(value)
        case .string(let value):
            return .string(value)
        case .bool(let value):
            return .bool(value)
        case .null:
            return .null
        case .list(let values):
            return .list(try values.map(mapLiteral))
        }
    }

    private func asBool(_ value: RuntimeValue) throws -> Bool {
        switch value {
        case .bool(let bool): return bool
        case .null: return false
        default: throw BQLExecutionError.invalidType
        }
    }

    private func asDecimal(_ value: RuntimeValue) -> Decimal? {
        switch value {
        case .decimal(let decimal): return decimal
        case .int(let int): return Decimal(int)
        default: return nil
        }
    }

    private func asAmount(_ value: RuntimeValue) -> Amount? {
        if case .amount(let amount) = value {
            return amount
        }
        return nil
    }

    private func asPosition(_ value: RuntimeValue) -> Position? {
        if case .position(let position) = value {
            return position
        }
        return nil
    }

    private func asInventory(_ value: RuntimeValue) -> Inventory? {
        if case .inventory(let inventory) = value {
            return inventory
        }
        return nil
    }

    private func asInt(_ value: RuntimeValue) -> Int? {
        if case .int(let int) = value {
            return int
        }
        return nil
    }

    private func asDate(_ value: RuntimeValue) -> Date? {
        if case .date(let date) = value {
            return date
        }
        return nil
    }

    private func asDateStride(_ value: RuntimeValue) -> DateStride? {
        DateStride.fromRuntimeValue(value)
    }

    private func dateCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar
    }

    private func dateParts(_ date: Date) -> (year: Int, month: Int, day: Int) {
        let components = dateCalendar().dateComponents([.year, .month, .day], from: date)
        return (components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }

    private func buildDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.calendar = dateCalendar()
        components.year = year
        components.month = month
        components.day = day
        return components.date
    }

    private func normalizeDate(_ date: Date) -> Date? {
        let parts = dateParts(date)
        return buildDate(year: parts.year, month: parts.month, day: parts.day)
    }

    private func addStride(_ date: Date, _ stride: DateStride) -> Date? {
        var components = DateComponents()
        components.year = stride.years
        components.month = stride.months
        components.day = stride.days
        return dateCalendar().date(byAdding: components, to: date).flatMap(normalizeDate)
    }

    private func daysBetween(_ start: Date, _ end: Date) -> Int? {
        dateCalendar().dateComponents([.day], from: start, to: end).day
    }

    private func compare(_ left: RuntimeValue, _ right: RuntimeValue) -> ComparisonResult {
        if left == right {
            return .orderedSame
        }

        if left == .null { return .orderedAscending }
        if right == .null { return .orderedDescending }

        if let lhs = asDecimal(left), let rhs = asDecimal(right) {
            if lhs < rhs { return .orderedAscending }
            if lhs > rhs { return .orderedDescending }
            return .orderedSame
        }

        switch (left, right) {
        case (.amount(let lhs), .amount(let rhs)):
            if lhs < rhs { return .orderedAscending }
            if lhs > rhs { return .orderedDescending }
            return .orderedSame

        case (.position(let lhs), .position(let rhs)):
            if lhs < rhs { return .orderedAscending }
            if lhs > rhs { return .orderedDescending }
            return .orderedSame

        case (.inventory(let lhs), .inventory(let rhs)):
            if lhs < rhs { return .orderedAscending }
            if lhs > rhs { return .orderedDescending }
            return .orderedSame

        case (.string(let lhs), .string(let rhs)):
            if lhs < rhs { return .orderedAscending }
            if lhs > rhs { return .orderedDescending }
            return .orderedSame

        case (.bool(let lhs), .bool(let rhs)):
            if lhs == rhs { return .orderedSame }
            return lhs ? .orderedDescending : .orderedAscending

        case (.date(let lhs), .date(let rhs)):
            if lhs < rhs { return .orderedAscending }
            if lhs > rhs { return .orderedDescending }
            return .orderedSame

        default:
            return .orderedSame
        }
    }

    private func numericEquals(_ left: RuntimeValue, _ right: RuntimeValue) -> Bool {
        if left == right {
            return true
        }

        guard let lhs = asDecimal(left), let rhs = asDecimal(right) else {
            return false
        }
        return lhs == rhs
    }

    private func matches(pattern: String, in input: String, caseInsensitive: Bool) -> Bool {
        guard let regex = try? Regex(pattern) else { return false }
        let r = caseInsensitive ? regex.ignoresCase() : regex
        return input.contains(r)
    }

    private func renderValue(_ value: RuntimeValue) -> String {
        switch value {
        case .int(let number):
            return String(number)
        case .decimal(let number):
            return NSDecimalNumber(decimal: number).stringValue
        case .amount(let amount):
            return amount.description
        case .position(let position):
            return position.description
        case .inventory(let inventory):
            return inventory.description
        case .directive(let directive):
            return directive.description.trimmingCharacters(in: .newlines)
        case .dict(let dictionary):
            let keys = dictionary.keys.sorted()
            let parts = keys.map { key in
                let value = dictionary[key] ?? .null
                return "\(key):\(renderValue(value))"
            }
            return "{\(parts.joined(separator: ","))}"
        case .structure(let name, let fields):
            let keys = fields.keys.sorted()
            let parts = keys.map { key -> String in
                let value = fields[key] ?? .null
                return "\(key):\(renderValue(value))"
            }
            return "\(name)(\(parts.joined(separator: ", ")))"
        case .string(let text):
            return text
        case .bool(let value):
            return value ? "true" : "false"
        case .date(let date):
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            guard let year = components.year,
                  let month = components.month,
                  let day = components.day
            else {
                return "date"
            }
            return String(format: "%04d-%02d-%02d", year, month, day)
        case .list(let values):
            return values.map(renderValue).joined(separator: ",")
        case .null:
            return "null"
        }
    }
}

private func resolveAttribute(_ value: RuntimeValue, name: String) throws -> RuntimeValue {
    switch value {
    case .null:
        return .null
    case .structure(_, let fields):
        return fields[name] ?? .null
    case .dict(let map):
        return map[name] ?? .null
    case .amount(let amount):
        switch name {
        case "number": return .decimal(amount.number)
        case "currency": return .string(amount.currency.id)
        default: return .null
        }
    case .position(let position):
        switch name {
        case "units": return .amount(position.units)
        case "cost":
            guard let cost = position.cost else { return .null }
            return costStructure(cost)
        default: return .null
        }
    case .date(let date):
        let parts = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: date)
        switch name {
        case "year": return parts.year.map(RuntimeValue.int) ?? .null
        case "month": return parts.month.map(RuntimeValue.int) ?? .null
        case "day": return parts.day.map(RuntimeValue.int) ?? .null
        default: return .null
        }
    case .directive(let directive):
        return directiveAttribute(directive, name: name)
    default:
        throw BQLExecutionError.invalidType
    }
}

private func costStructure(_ cost: Cost) -> RuntimeValue {
    .structure(name: "Cost", fields: [
        "number": .decimal(cost.number),
        "currency": .string(cost.currency.id),
        "date": cost.date.map(RuntimeValue.date) ?? .null,
        "label": cost.label.map(RuntimeValue.string) ?? .null,
    ])
}

private func directiveAttribute(_ directive: Directive<Cost>, name: String) -> RuntimeValue {
    switch name {
    case "date":
        return .date(directive.date)
    case "meta":
        var fields: [String: RuntimeValue] = [:]
        for (key, value) in directive.meta {
            fields[key] = directiveMetaValue(value)
        }
        return .dict(fields)
    case "type":
        return .string(directiveTypeName(directive.content))
    default:
        break
    }
    switch directive.content {
    case .transaction(let transaction):
        switch name {
        case "flag": return transaction.flag.map { .string(String($0)) } ?? .null
        case "payee": return transaction.payee.map(RuntimeValue.string) ?? .null
        case "narration": return transaction.narration.map(RuntimeValue.string) ?? .null
        case "tags": return .list(transaction.tags.map { .string($0.id) })
        case "links": return .list(transaction.links.map { .string($0.id) })
        case "postings": return .list(transaction.postings.map { .position(Position(posting: $0)) })
        case "accounts": return .list(transaction.postings.map { .string($0.account.id) })
        default: return .null
        }
    case .open(let open):
        switch name {
        case "account": return .string(open.account.id)
        case "currencies": return .list(open.currencies.map { .string($0.id) })
        case "booking": return open.booking.map { .string(String(describing: $0)) } ?? .null
        default: return .null
        }
    case .close(let close):
        if name == "account" { return .string(close.account.id) }
        return .null
    case .balance(let balance):
        switch name {
        case "account": return .string(balance.account.id)
        case "amount": return .amount(balance.amount)
        case "tolerance": return balance.tolerance.map(RuntimeValue.decimal) ?? .null
        case "discrepancy": return balance.diffAmount.map(RuntimeValue.amount) ?? .null
        default: return .null
        }
    case .price(let price):
        switch name {
        case "currency": return .string(price.currency.id)
        case "amount": return .amount(price.amount)
        default: return .null
        }
    case .note(let note):
        switch name {
        case "account": return .string(note.account.id)
        case "comment": return .string(note.note)
        default: return .null
        }
    case .event(let event):
        switch name {
        case "type": return .string(event.type)
        case "description": return .string(event.description)
        default: return .null
        }
    case .document(let document):
        switch name {
        case "account": return .string(document.account.id)
        case "filename": return .string(document.filename)
        case "tags": return .list((document.tags ?? []).map { .string($0.id) })
        case "links": return .list((document.links ?? []).map { .string($0.id) })
        default: return .null
        }
    case .commodity(let commodity):
        if name == "currency" { return .string(commodity.currency.id) }
        return .null
    case .pad(let pad):
        switch name {
        case "account": return .string(pad.account.id)
        case "source_account": return .string(pad.sourceAccount.id)
        default: return .null
        }
    case .query, .custom:
        return .null
    }
}

private func directiveTypeName(_ content: DirectiveContent<Cost>) -> String {
    switch content {
    case .open: return "open"
    case .close: return "close"
    case .commodity: return "commodity"
    case .pad: return "pad"
    case .balance: return "balance"
    case .transaction: return "transaction"
    case .note: return "note"
    case .event: return "event"
    case .query: return "query"
    case .price: return "price"
    case .document: return "document"
    case .custom: return "custom"
    }
}

private func directiveMetaValue(_ value: MetaDataValue) -> RuntimeValue {
    switch value {
    case .string(let text): return .string(text)
    case .account(let account): return .string(account.id)
    case .currency(let currency): return .string(currency.id)
    case .date(let date): return .date(date)
    case .tag(let tag): return .string(tag.id)
    case .number(let number): return .decimal(number)
    case .bool(let bool): return .bool(bool)
    case .amount(let amount): return .amount(amount)
    case .range(let range): return .string(String(describing: range))
    }
}

private struct GroupKey: Hashable {
    var values: [RuntimeValue]
}

/// An aggregate call the query makes, e.g. `last(balance)`.
///
/// Identical calls share one entry: reading a column twice for the same row
/// yields the same value anyway, and for `balance` a second read must not
/// advance the running inventory — beanquery relies on a one-entry cache keyed
/// by row id for the same reason.
private struct AggregateCall: Equatable {
    let name: String
    let args: [BQLExpression]

    var isCountStar: Bool {
        args.count == 1 && args[0] == .asterisk
    }

    /// The expression evaluated once per row, if the call takes one.
    var argument: BQLExpression? {
        isCountStar ? nil : args.first
    }
}

/// What a group accumulates while the source is scanned.
private struct GroupState {
    /// Kept for the parts of a target that read neither the group key nor an
    /// aggregate; the compiler rejects bare columns there, so this only backs
    /// row-independent expressions.
    var representativeRow: QueryRow
    var rowCount = 0
    var argumentValues: [[RuntimeValue]]
}

/// The folded aggregate values of one group, looked up while the output row is
/// evaluated.
private struct AggregateResults {
    let expressions: [AggregateCall]
    let values: [RuntimeValue]

    func value(for call: AggregateCall) -> RuntimeValue? {
        expressions.firstIndex(of: call).map { values[$0] }
    }
}
