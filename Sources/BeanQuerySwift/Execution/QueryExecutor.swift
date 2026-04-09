import Foundation
import BeancountSwift

struct QueryExecutor {
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

    private final class EvaluationState {
        private var resolvedBalance: RuntimeValue?
        private var runningBalance = Inventory()

        func beginRow() {
            resolvedBalance = nil
        }

        func resolveBalance(for row: QueryRow) -> RuntimeValue {
            if let resolvedBalance {
                return resolvedBalance
            }

            let value: RuntimeValue
            if let position = row["position"] {
                switch position {
                case .position(let postingPosition):
                    _ = runningBalance.addAmount(postingPosition.units, cost: postingPosition.cost)
                    value = .inventory(runningBalance)

                case .amount(let amount):
                    _ = runningBalance.addAmount(amount)
                    value = .inventory(runningBalance)

                case .inventory(let inventory):
                    runningBalance = runningBalance + inventory
                    value = .inventory(runningBalance)

                default:
                    value = row["balance"] ?? .null
                }
            } else {
                value = row["balance"] ?? .null
            }

            resolvedBalance = value
            return value
        }
    }

    func execute(_ query: EvalQuery, context: QueryContext) throws -> QueryResult {
        let sourceRows = try loadSourceRows(query.source, context: context)
        let fullRows = try evaluateRows(query: query, rows: sourceRows, context: context)

        let visible = query.targets.enumerated().compactMap { index, target in
            target.name == nil ? nil : (index, target.name!)
        }
        var columns = visible.map(\.1)
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
            columns = pivoted.columns
            projectedRows = pivoted.rows
        }

        return QueryResult(columns: columns, rows: projectedRows)
    }

    private func loadSourceRows(_ source: EvalSource, context: QueryContext) throws -> [QueryRow] {
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

            return rows

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

                return rows
            }

            guard source.qualifiers == nil else {
                throw BQLExecutionError.qualifiersUnsupported("#")
            }
            return [[:]]

        case .subquery(let subquery):
            let result = try execute(subquery, context: context)
            return result.rows.map { row in
                Dictionary(uniqueKeysWithValues: zip(result.columns, row))
            }
        }
    }

    private func evaluateRows(
        query: EvalQuery,
        rows: [QueryRow],
        context: QueryContext
    ) throws -> [[RuntimeValue]] {
        if query.groupIndexes == nil {
            var output: [[RuntimeValue]] = []
            let state = EvaluationState()
            for row in rows {
                state.beginRow()

                if let filter = query.filter {
                    guard try evaluateBoolean(
                        filter,
                        row: row,
                        group: nil,
                        context: context,
                        state: state
                    ) else {
                        continue
                    }
                }

                let values = try query.targets.map { target in
                    try evaluateExpression(
                        target.expression,
                        row: row,
                        group: nil,
                        context: context,
                        state: state
                    )
                }
                output.append(values)
            }
            return applyOrdering(output, orderSpec: query.orderSpec)
        }

        let groupIndexes = query.groupIndexes ?? []
        var buckets: [GroupKey: [QueryRow]] = [:]
        let state = EvaluationState()

        for row in rows {
            state.beginRow()

            if let filter = query.filter {
                guard try evaluateBoolean(
                    filter,
                    row: row,
                    group: nil,
                    context: context,
                    state: state
                ) else {
                    continue
                }
            }

            var effectiveRow = row
            effectiveRow["balance"] = state.resolveBalance(for: row)

            let keyValues = try groupIndexes.map { index in
                try evaluateExpression(
                    query.targets[index].expression,
                    row: effectiveRow,
                    group: nil,
                    context: context,
                    state: nil
                )
            }
            buckets[GroupKey(values: keyValues), default: []].append(effectiveRow)
        }

        var output: [[RuntimeValue]] = []
        for (_, groupRows) in buckets {
            guard let first = groupRows.first else { continue }

            let values = try query.targets.map { target in
                try evaluateExpression(
                    target.expression,
                    row: first,
                    group: groupRows,
                    context: context,
                    state: nil
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
        group: [QueryRow]?,
        context: QueryContext,
        state: EvaluationState?
    ) throws -> Bool {
        let value = try evaluateExpression(expression, row: row, group: group, context: context, state: state)
        return try asBool(value)
    }

    private func evaluateExpression(
        _ expression: BQLExpression,
        row: QueryRow,
        group: [QueryRow]?,
        context: QueryContext,
        state: EvaluationState?
    ) throws -> RuntimeValue {
        switch expression {
        case .column(let name):
            if name.lowercased() == "balance", let state {
                return state.resolveBalance(for: row)
            }
            return row[name] ?? .null

        case .constant(let literal):
            return try mapLiteral(literal)

        case .placeholder(let placeholder):
            throw BQLExecutionError.unsupportedExpression("placeholder \(placeholder)")

        case .unary(let op, let operand):
            let value = try evaluateExpression(operand, row: row, group: group, context: context, state: state)
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
            let left = try evaluateExpression(leftExpr, row: row, group: group, context: context, state: state)
            let right = try evaluateExpression(rightExpr, row: row, group: group, context: context, state: state)
            return try evaluateBinary(op: op, left: left, right: right)

        case .and(let args):
            for arg in args {
                if try !evaluateBoolean(arg, row: row, group: group, context: context, state: state) {
                    return .bool(false)
                }
            }
            return .bool(true)

        case .or(let args):
            for arg in args {
                if try evaluateBoolean(arg, row: row, group: group, context: context, state: state) {
                    return .bool(true)
                }
            }
            return .bool(false)

        case .between(let valueExpr, let lowerExpr, let upperExpr):
            let value = try evaluateExpression(valueExpr, row: row, group: group, context: context, state: state)
            let lower = try evaluateExpression(lowerExpr, row: row, group: group, context: context, state: state)
            let upper = try evaluateExpression(upperExpr, row: row, group: group, context: context, state: state)
            guard value != .null, lower != .null, upper != .null else {
                return .null
            }
            let lowerCmp = compare(value, lower)
            let upperCmp = compare(value, upper)
            return .bool((lowerCmp == .orderedSame || lowerCmp == .orderedDescending)
                         && (upperCmp == .orderedSame || upperCmp == .orderedAscending))

        case .anyAll(let op, let quantifier, let leftExpr, let rightExpr):
            let left = try evaluateExpression(leftExpr, row: row, group: group, context: context, state: state)
            let right = try evaluateExpression(rightExpr, row: row, group: group, context: context, state: state)
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

        case .attribute:
            throw BQLExecutionError.unsupportedExpression("attribute")

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
                group: group,
                context: context,
                state: state
            )
        }
    }

    private func evaluateFunction(
        name: String,
        args: [BQLExpression],
        row: QueryRow,
        group: [QueryRow]?,
        context: QueryContext,
        state: EvaluationState?
    ) throws -> RuntimeValue {
        let normalized = name.lowercased()

        if normalized == "coalesce" {
            guard !args.isEmpty else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            for arg in args {
                let value = try evaluateExpression(arg, row: row, group: group, context: context, state: state)
                if value != .null {
                    return value
                }
            }
            return .null
        }

        if ["count", "sum", "min", "max", "first", "last"].contains(normalized) {
            guard let group else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try evaluateAggregateFunction(
                name: normalized,
                args: args,
                rows: group,
                context: context,
                state: state
            )
        }

        let values = try args.map { try evaluateExpression($0, row: row, group: group, context: context, state: state) }
        return try BuiltinFunctionEvaluator(context: context).evaluate(
            name: name,
            normalizedName: normalized,
            arguments: values,
            row: row
        )
    }

    private func evaluateAggregateFunction(
        name: String,
        args: [BQLExpression],
        rows: [QueryRow],
        context: QueryContext,
        state: EvaluationState?
    ) throws -> RuntimeValue {
        switch name {
        case "count":
            if args.count == 1, args[0] == .asterisk {
                return .int(rows.count)
            }
            let values = try evaluateOverRows(args.first, rows: rows, context: context, state: state)
            return .int(values.filter { $0 != .null }.count)

        case "sum":
            let values = try evaluateOverRows(args.first, rows: rows, context: context, state: state)
            return try sum(values)

        case "first":
            let values = try evaluateOverRows(args.first, rows: rows, context: context, state: state)
            return values.first ?? .null

        case "last":
            let values = try evaluateOverRows(args.first, rows: rows, context: context, state: state)
            return values.last ?? .null

        case "min":
            let values = try evaluateOverRows(args.first, rows: rows, context: context, state: state).filter { $0 != .null }
            guard let minValue = values.min(by: { compare($0, $1) == .orderedAscending }) else {
                return .null
            }
            return minValue

        case "max":
            let values = try evaluateOverRows(args.first, rows: rows, context: context, state: state).filter { $0 != .null }
            guard let maxValue = values.max(by: { compare($0, $1) == .orderedAscending }) else {
                return .null
            }
            return maxValue

        default:
            throw BQLExecutionError.unsupportedFunction(name)
        }
    }

    private func evaluateOverRows(
        _ expression: BQLExpression?,
        rows: [QueryRow],
        context: QueryContext,
        state: EvaluationState?
    ) throws -> [RuntimeValue] {
        guard let expression else {
            return []
        }

        return try rows.map { row in
            state?.beginRow()
            return try evaluateExpression(expression, row: row, group: nil, context: context, state: state)
        }
    }

    private func evaluateBinary(op: BQLBinaryOperator, left: RuntimeValue, right: RuntimeValue) throws -> RuntimeValue {
        guard left != .null, right != .null else {
            return .null
        }

        switch op {
        case .add:
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
            if let l = asInt(left), let r = asInt(right) {
                return .int(l + r)
            }
            if case .string(let l) = left, case .string(let r) = right {
                return .string(l + r)
            }
            throw BQLExecutionError.invalidType

        case .sub:
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
            if let l = asInt(left), let r = asInt(right) {
                return .int(l - r)
            }
            throw BQLExecutionError.invalidType

        case .mul:
            if let l = asDecimal(left), let r = asDecimal(right) {
                return .decimal(l * r)
            }
            if let l = asInt(left), let r = asInt(right) {
                return .int(l * r)
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
            return .bool(left == right)

        case .notEqual:
            return .bool(left != right)

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

private struct GroupKey: Hashable {
    var values: [RuntimeValue]
}
