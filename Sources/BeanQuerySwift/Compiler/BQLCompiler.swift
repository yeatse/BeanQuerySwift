import Foundation

struct BQLCompiler {
    private static let aggregateFunctions: Set<String> = [
        "count", "sum", "first", "last", "min", "max"
    ]

    let options: BQLCompilerOptions
    private let typeChecker = ExpressionTypeChecker()

    init(options: BQLCompilerOptions = .init()) {
        self.options = options
    }

    func compile(
        _ statement: BQLStatement,
        parameters: BQLParameters? = nil,
        context: QueryContext? = nil
    ) throws -> EvalQuery {
        let boundStatement = try bindPlaceholders(in: statement, parameters: parameters)

        switch boundStatement {
        case .select(let select):
            return try compileSelect(select, context: context)
        case .balances(let balances):
            return try compileSelect(transformBalances(balances), context: context)
        case .journal(let journal):
            return try compileSelect(transformJournal(journal), context: context)
        case .print(let print):
            return try compilePrint(print, context: context)
        }
    }

    private func compileSelect(
        _ select: BQLSelectStatement,
        context: QueryContext?
    ) throws -> EvalQuery {
        let from = try compileFrom(select.from, context: context)
        let source = EvalSource(table: from.table, qualifiers: from.qualifiers)
        var targets = try compileTargets(select.targets, source: source, context: context)

        let whereExpression = try select.where.map(typeChecker.validateAndFold)
        if let whereExpression, containsAggregate(whereExpression) {
            throw BQLCompileError.aggregatesNotAllowedInWhere
        }

        let filter = combineWithAnd(from.filter, whereExpression)

        let groupResult = try compileGroupBy(select.groupBy, existingTargets: targets)
        targets.append(contentsOf: groupResult.newTargets)

        let orderResult = try compileOrderBy(select.orderBy, existingTargets: targets)
        targets.append(contentsOf: orderResult.newTargets)

        let pivotIndexes = try compilePivotBy(
            select.pivotBy,
            targets: targets,
            groupIndexes: groupResult.groupIndexes
        )

        if let groupIndexes = groupResult.groupIndexes {
            let nonAggregateIndexes = Set(targets.enumerated().compactMap { index, target in
                target.isAggregate ? nil : index
            })
            let grouped = Set(groupIndexes)
            if nonAggregateIndexes != grouped {
                let missing = nonAggregateIndexes.subtracting(grouped)
                    .compactMap { targets[$0].name }
                    .sorted()
                throw BQLCompileError.missingGroupByTargets(missing)
            }
        }

        return EvalQuery(
            source: source,
            targets: targets,
            filter: filter,
            groupIndexes: groupResult.groupIndexes,
            havingIndex: groupResult.havingIndex,
            orderSpec: orderResult.orderSpec,
            pivotIndexes: pivotIndexes,
            limit: select.limit,
            distinct: select.distinct
        )
    }

    private func compilePrint(
        _ printStatement: BQLPrintStatement,
        context: QueryContext?
    ) throws -> EvalQuery {
        let source: EvalSource
        let filter: BQLExpression?

        if let from = printStatement.from {
            let compiledFrom = try compileFrom(
                .expression(from),
                context: context,
                defaultTableName: "entries"
            )
            source = EvalSource(table: compiledFrom.table, qualifiers: compiledFrom.qualifiers)
            filter = compiledFrom.filter
        } else {
            source = EvalSource(table: .named("entries"), qualifiers: nil)
            filter = nil
        }

        let targets = try compileTargets(.asterisk, source: source, context: context)
        return EvalQuery(
            source: source,
            targets: targets,
            filter: filter,
            groupIndexes: nil,
            havingIndex: nil,
            orderSpec: nil,
            pivotIndexes: nil,
            limit: nil,
            distinct: false
        )
    }

    private func bindPlaceholders(
        in statement: BQLStatement,
        parameters: BQLParameters?
    ) throws -> BQLStatement {
        let placeholders = collectPlaceholders(in: statement)
        guard !placeholders.isEmpty else {
            return statement
        }

        let hasPositional = placeholders.contains {
            if case .positional = $0 { return true }
            return false
        }
        let hasNamed = placeholders.contains {
            if case .named = $0 { return true }
            return false
        }

        if hasPositional && hasNamed {
            throw BQLCompileError.mixedPlaceholderStyles
        }

        if hasNamed {
            guard case .named(let mapping)? = parameters else {
                throw BQLCompileError.namedParametersRequired
            }

            let names = Set(placeholders.compactMap { placeholder -> String? in
                if case .named(let name) = placeholder {
                    return name
                }
                return nil
            })
            let missing = names.subtracting(mapping.keys).sorted()
            if !missing.isEmpty {
                throw BQLCompileError.queryParameterMissing(missing)
            }

            return try bind(statement) { placeholder in
                guard case .named(let name) = placeholder else {
                    throw BQLCompileError.mixedPlaceholderStyles
                }
                guard let value = mapping[name] else {
                    throw BQLCompileError.queryParameterMissing([name])
                }
                return .constant(try literal(from: value))
            }
        }

        guard case .positional(let values)? = parameters else {
            throw BQLCompileError.positionalParametersRequired
        }
        if values.count != placeholders.count {
            throw BQLCompileError.placeholderCountMismatch(
                expected: placeholders.count,
                actual: values.count
            )
        }

        var index = 0
        return try bind(statement) { placeholder in
            guard case .positional = placeholder else {
                throw BQLCompileError.mixedPlaceholderStyles
            }
            defer { index += 1 }
            return .constant(try literal(from: values[index]))
        }
    }

    private func collectPlaceholders(in statement: BQLStatement) -> [BQLPlaceholder] {
        var placeholders: [BQLPlaceholder] = []
        appendPlaceholders(in: statement, to: &placeholders)
        return placeholders
    }

    private func appendPlaceholders(
        in statement: BQLStatement,
        to placeholders: inout [BQLPlaceholder]
    ) {
        switch statement {
        case .select(let select):
            appendPlaceholders(in: select, to: &placeholders)
        case .balances(let balances):
            appendPlaceholders(in: balances, to: &placeholders)
        case .journal(let journal):
            appendPlaceholders(in: journal, to: &placeholders)
        case .print(let print):
            appendPlaceholders(in: print, to: &placeholders)
        }
    }

    private func appendPlaceholders(
        in select: BQLSelectStatement,
        to placeholders: inout [BQLPlaceholder]
    ) {
        switch select.targets {
        case .asterisk:
            break
        case .values(let targets):
            for target in targets {
                appendPlaceholders(in: target.expression, to: &placeholders)
            }
        }

        if let from = select.from {
            appendPlaceholders(in: from, to: &placeholders)
        }
        if let filter = select.where {
            appendPlaceholders(in: filter, to: &placeholders)
        }
        if let groupBy = select.groupBy {
            for item in groupBy.items {
                if case .expression(let expression) = item {
                    appendPlaceholders(in: expression, to: &placeholders)
                }
            }
            if let having = groupBy.having {
                appendPlaceholders(in: having, to: &placeholders)
            }
        }
        if let orderBy = select.orderBy {
            for item in orderBy {
                if case .expression(let expression) = item.value {
                    appendPlaceholders(in: expression, to: &placeholders)
                }
            }
        }
    }

    private func appendPlaceholders(
        in balances: BQLBalancesStatement,
        to placeholders: inout [BQLPlaceholder]
    ) {
        if let from = balances.from {
            if let expression = from.expression {
                appendPlaceholders(in: expression, to: &placeholders)
            }
        }
        if let filter = balances.where {
            appendPlaceholders(in: filter, to: &placeholders)
        }
    }

    private func appendPlaceholders(
        in journal: BQLJournalStatement,
        to placeholders: inout [BQLPlaceholder]
    ) {
        if let from = journal.from, let expression = from.expression {
            appendPlaceholders(in: expression, to: &placeholders)
        }
    }

    private func appendPlaceholders(
        in printStatement: BQLPrintStatement,
        to placeholders: inout [BQLPlaceholder]
    ) {
        if let from = printStatement.from, let expression = from.expression {
            appendPlaceholders(in: expression, to: &placeholders)
        }
    }

    private func appendPlaceholders(
        in from: BQLFromClause,
        to placeholders: inout [BQLPlaceholder]
    ) {
        switch from {
        case .table:
            break
        case .subselect(let select):
            appendPlaceholders(in: select, to: &placeholders)
        case .expression(let expression):
            if let filter = expression.expression {
                appendPlaceholders(in: filter, to: &placeholders)
            }
        }
    }

    private func appendPlaceholders(
        in expression: BQLExpression,
        to placeholders: inout [BQLPlaceholder]
    ) {
        switch expression {
        case .placeholder(let placeholder):
            placeholders.append(placeholder)
        case .function(_, let args):
            for arg in args {
                appendPlaceholders(in: arg, to: &placeholders)
            }
        case .unary(_, let value):
            appendPlaceholders(in: value, to: &placeholders)
        case .binary(_, let left, let right):
            appendPlaceholders(in: left, to: &placeholders)
            appendPlaceholders(in: right, to: &placeholders)
        case .and(let values), .or(let values):
            for value in values {
                appendPlaceholders(in: value, to: &placeholders)
            }
        case .between(let value, let lower, let upper):
            appendPlaceholders(in: value, to: &placeholders)
            appendPlaceholders(in: lower, to: &placeholders)
            appendPlaceholders(in: upper, to: &placeholders)
        case .anyAll(_, _, let left, let right):
            appendPlaceholders(in: left, to: &placeholders)
            appendPlaceholders(in: right, to: &placeholders)
        case .attribute(let value, _):
            appendPlaceholders(in: value, to: &placeholders)
        case .subscriptExpr(let value, _):
            appendPlaceholders(in: value, to: &placeholders)
        case .select(let select):
            appendPlaceholders(in: select, to: &placeholders)
        case .column, .constant, .asterisk:
            break
        }
    }

    private func bind(
        _ statement: BQLStatement,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLStatement {
        switch statement {
        case .select(let select):
            return .select(try bind(select, replacing: replacing))
        case .balances(let balances):
            return .balances(try bind(balances, replacing: replacing))
        case .journal(let journal):
            return .journal(try bind(journal, replacing: replacing))
        case .print(let print):
            return .print(try bind(print, replacing: replacing))
        }
    }

    private func bind(
        _ select: BQLSelectStatement,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLSelectStatement {
        BQLSelectStatement(
            distinct: select.distinct,
            targets: try bind(select.targets, replacing: replacing),
            from: try select.from.map { try bind($0, replacing: replacing) },
            where: try select.where.map { try bind($0, replacing: replacing) },
            groupBy: try select.groupBy.map { try bind($0, replacing: replacing) },
            orderBy: try select.orderBy.map { try bind($0, replacing: replacing) },
            pivotBy: select.pivotBy,
            limit: select.limit,
            sourceRange: select.sourceRange
        )
    }

    private func bind(
        _ balances: BQLBalancesStatement,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLBalancesStatement {
        BQLBalancesStatement(
            summaryFunction: balances.summaryFunction,
            from: try balances.from.map { from in
                BQLFromExpression(
                    expression: try from.expression.map { try bind($0, replacing: replacing) },
                    open: from.open,
                    close: from.close,
                    clear: from.clear,
                    sourceRange: from.sourceRange
                )
            },
            where: try balances.where.map { try bind($0, replacing: replacing) },
            sourceRange: balances.sourceRange
        )
    }

    private func bind(
        _ journal: BQLJournalStatement,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLJournalStatement {
        BQLJournalStatement(
            account: journal.account,
            summaryFunction: journal.summaryFunction,
            from: try journal.from.map { from in
                BQLFromExpression(
                    expression: try from.expression.map { try bind($0, replacing: replacing) },
                    open: from.open,
                    close: from.close,
                    clear: from.clear,
                    sourceRange: from.sourceRange
                )
            },
            sourceRange: journal.sourceRange
        )
    }

    private func bind(
        _ printStatement: BQLPrintStatement,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLPrintStatement {
        BQLPrintStatement(
            from: try printStatement.from.map { from in
                BQLFromExpression(
                    expression: try from.expression.map { try bind($0, replacing: replacing) },
                    open: from.open,
                    close: from.close,
                    clear: from.clear,
                    sourceRange: from.sourceRange
                )
            },
            sourceRange: printStatement.sourceRange
        )
    }

    private func bind(
        _ targets: BQLTargetList,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLTargetList {
        switch targets {
        case .asterisk:
            return .asterisk
        case .values(let values):
            return .values(try values.map { target in
                BQLTarget(
                    expression: try bind(target.expression, replacing: replacing),
                    alias: target.alias,
                    sourceRange: target.sourceRange
                )
            })
        }
    }

    private func bind(
        _ from: BQLFromClause,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLFromClause {
        switch from {
        case .table:
            return from
        case .subselect(let select):
            return .subselect(try bind(select, replacing: replacing))
        case .expression(let expression):
            return .expression(
                BQLFromExpression(
                    expression: try expression.expression.map { try bind($0, replacing: replacing) },
                    open: expression.open,
                    close: expression.close,
                    clear: expression.clear,
                    sourceRange: expression.sourceRange
                )
            )
        }
    }

    private func bind(
        _ groupBy: BQLGroupByClause,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLGroupByClause {
        BQLGroupByClause(
            items: try groupBy.items.map { item in
                switch item {
                case .index:
                    return item
                case .expression(let expression):
                    return .expression(try bind(expression, replacing: replacing))
                }
            },
            having: try groupBy.having.map { try bind($0, replacing: replacing) },
            sourceRange: groupBy.sourceRange
        )
    }

    private func bind(
        _ orderBy: [BQLOrderByItem],
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> [BQLOrderByItem] {
        try orderBy.map { item in
            let value: BQLOrderByValue
            switch item.value {
            case .index:
                value = item.value
            case .expression(let expression):
                value = .expression(try bind(expression, replacing: replacing))
            }

            return BQLOrderByItem(value: value, ordering: item.ordering, sourceRange: item.sourceRange)
        }
    }

    private func bind(
        _ expression: BQLExpression,
        replacing: (BQLPlaceholder) throws -> BQLExpression
    ) throws -> BQLExpression {
        switch expression {
        case .placeholder(let placeholder):
            return try replacing(placeholder)

        case .function(let name, let args):
            return .function(
                name: name,
                args: try args.map { try bind($0, replacing: replacing) }
            )

        case .unary(let op, let value):
            return .unary(op, try bind(value, replacing: replacing))

        case .binary(let op, let left, let right):
            return .binary(
                op,
                try bind(left, replacing: replacing),
                try bind(right, replacing: replacing)
            )

        case .and(let values):
            return .and(try values.map { try bind($0, replacing: replacing) })

        case .or(let values):
            return .or(try values.map { try bind($0, replacing: replacing) })

        case .between(let value, let lower, let upper):
            return .between(
                try bind(value, replacing: replacing),
                lower: try bind(lower, replacing: replacing),
                upper: try bind(upper, replacing: replacing)
            )

        case .anyAll(let op, let quantifier, let left, let right):
            return .anyAll(
                op: op,
                quantifier: quantifier,
                left: try bind(left, replacing: replacing),
                right: try bind(right, replacing: replacing)
            )

        case .attribute(let value, let name):
            return .attribute(try bind(value, replacing: replacing), name: name)

        case .subscriptExpr(let value, let key):
            return .subscriptExpr(try bind(value, replacing: replacing), key: key)

        case .select(let select):
            return .select(try bind(select, replacing: replacing))

        case .column, .constant, .asterisk:
            return expression
        }
    }

    private func literal(from value: BQLParameterValue) throws -> BQLLiteral {
        switch value {
        case .integer(let int):
            return .integer(int)
        case .decimal(let decimal):
            return .decimal(decimal)
        case .date(let date):
            return .date(date)
        case .string(let string):
            return .string(string)
        case .bool(let bool):
            return .bool(bool)
        case .null:
            return .null
        case .list(let values):
            return .list(try values.map(literal(from:)))
        }
    }

    private func compileFrom(
        _ from: BQLFromClause?,
        context: QueryContext?,
        defaultTableName: String? = nil
    ) throws -> (
        table: EvalTableReference,
        qualifiers: EvalQualifiers?,
        filter: BQLExpression?
    ) {
        let fallbackTableName = defaultTableName ?? options.defaultTableName
        guard let from else {
            return (.named(fallbackTableName), nil, nil)
        }

        switch from {
        case .table(let table):
            switch table {
            case .hash(let name):
                return (.hash(name), nil, nil)
            case .named(let name):
                return (.named(name), nil, nil)
            }

        case .subselect(let subquery):
            return (
                .subquery(try compileSelect(subquery, context: context)),
                nil,
                nil
            )

        case .expression(let expression):
            if let open = expression.open,
               case .on(let closeDate)? = expression.close,
               open > closeDate
            {
                throw BQLCompileError.closeDateMustFollowOpenDate
            }

            let qualifiers = EvalQualifiers(
                open: expression.open,
                close: expression.close,
                clear: expression.clear
            )

            let normalizedFilter = try expression.expression.map(typeChecker.validateAndFold)
            if let normalizedFilter, containsAggregate(normalizedFilter) {
                throw BQLCompileError.aggregatesNotAllowedInFrom
            }

            return (
                .named(fallbackTableName),
                qualifiers,
                normalizedFilter
            )
        }
    }

    private func compileTargets(
        _ targets: BQLTargetList,
        source: EvalSource,
        context: QueryContext?
    ) throws -> [EvalTarget] {
        switch targets {
        case .asterisk:
            if let columns = try wildcardColumns(source: source, context: context),
               !columns.isEmpty
            {
                return columns.map { column in
                    EvalTarget(expression: .column(column), name: column, isAggregate: false)
                }
            }

            return [EvalTarget(expression: .asterisk, name: "*", isAggregate: false)]

        case .values(let values):
            return try values.map { target in
                let expression = try typeChecker.validateAndFold(target.expression)
                let analysis = analyzeAggregateUsage(expression)

                if analysis.hasAggregate && analysis.hasNonAggregateColumn {
                    throw BQLCompileError.mixedAggregatesAndNonAggregates
                }
                if analysis.hasAggregateUnderAggregate {
                    throw BQLCompileError.aggregatesOfAggregates
                }

                let name = targetName(target)
                return EvalTarget(
                    expression: expression,
                    name: name,
                    isAggregate: analysis.hasAggregate
                )
            }
        }
    }

    private func wildcardColumns(
        source: EvalSource,
        context: QueryContext?
    ) throws -> [String]? {
        switch source.table {
        case .named(let name):
            return try context?.wildcardColumns(table: name, qualifiers: source.qualifiers)

        case .hash(let tableName):
            guard let tableName else {
                return []
            }
            return try context?.wildcardColumns(table: tableName, qualifiers: source.qualifiers)

        case .subquery(let query):
            return query.visibleTargets.compactMap(\.name)
        }
    }

    private func compileGroupBy(
        _ groupBy: BQLGroupByClause?,
        existingTargets: [EvalTarget]
    ) throws -> (newTargets: [EvalTarget], groupIndexes: [Int]?, havingIndex: Int?) {
        var newTargets = existingTargets
        var expressions = newTargets.map(\.expression)

        if let groupBy {
            var indexes: [Int] = []
            let targetNames: [String: Int] = Dictionary(uniqueKeysWithValues: newTargets.enumerated().compactMap { index, target in
                guard let name = target.name else { return nil }
                return (name, index)
            })

            for item in groupBy.items {
                let index: Int

                switch item {
                case .index(let oneBased):
                    let resolved = oneBased - 1
                    guard resolved >= 0 && resolved < existingTargets.count else {
                        throw BQLCompileError.invalidGroupByIndex(oneBased)
                    }
                    index = resolved

                case .expression(let expression):
                    let normalizedExpression = try typeChecker.validateAndFold(expression)
                    if containsAggregate(normalizedExpression) {
                        throw BQLCompileError.groupByContainsAggregate
                    }

                    if case .column(let name) = normalizedExpression, let resolved = targetNames[name] {
                        index = resolved
                    } else if let resolved = expressions.firstIndex(of: normalizedExpression) {
                        index = resolved
                    } else {
                        index = newTargets.count
                        newTargets.append(
                            EvalTarget(expression: normalizedExpression, name: nil, isAggregate: false)
                        )
                        expressions.append(normalizedExpression)
                    }
                }

                guard !newTargets[index].isAggregate else {
                    throw BQLCompileError.groupByReferencesAggregate
                }
                indexes.append(index)
            }

            var havingIndex: Int?
            if let having = groupBy.having {
                let normalizedHaving = try typeChecker.validateAndFold(having)
                guard containsAggregate(normalizedHaving) else {
                    throw BQLCompileError.havingMustBeAggregate
                }

                havingIndex = newTargets.count
                newTargets.append(
                    EvalTarget(expression: normalizedHaving, name: nil, isAggregate: true)
                )
            }

            return (Array(newTargets.dropFirst(existingTargets.count)), indexes, havingIndex)
        }

        let aggregateFlags = existingTargets.map(\.isAggregate)
        if aggregateFlags.contains(true) {
            if aggregateFlags.allSatisfy({ $0 }) {
                return ([], [], nil)
            }

            if options.supportImplicitGroupBy {
                let indexes = existingTargets.enumerated().compactMap { index, target in
                    target.isAggregate ? nil : index
                }
                return ([], indexes, nil)
            }

            throw BQLCompileError.aggregateWithoutGroupBy
        }

        return ([], nil, nil)
    }

    private func compileOrderBy(
        _ orderBy: [BQLOrderByItem]?,
        existingTargets: [EvalTarget]
    ) throws -> (newTargets: [EvalTarget], orderSpec: [EvalOrderSpec]?) {
        guard let orderBy else {
            return ([], nil)
        }

        var targets = existingTargets
        var expressions = targets.map(\.expression)
        let visibleIndexes = targets.enumerated().compactMap { index, target in
            target.name == nil ? nil : index
        }
        let targetNames: [String: Int] = Dictionary(uniqueKeysWithValues: targets.enumerated().compactMap { index, target in
            guard let name = target.name else { return nil }
            return (name, index)
        })

        var specs: [EvalOrderSpec] = []

        for item in orderBy {
            let index: Int

            switch item.value {
            case .index(let oneBased):
                let resolved = oneBased - 1
                guard resolved >= 0 && resolved < visibleIndexes.count else {
                    throw BQLCompileError.invalidOrderByIndex(oneBased)
                }
                index = visibleIndexes[resolved]

            case .expression(let expression):
                let normalizedExpression = try typeChecker.validateAndFold(expression)
                if case .column(let name) = normalizedExpression, let resolved = targetNames[name] {
                    index = resolved
                } else if let resolved = expressions.firstIndex(of: normalizedExpression) {
                    index = resolved
                } else {
                    index = targets.count
                    targets.append(
                        EvalTarget(
                            expression: normalizedExpression,
                            name: nil,
                            isAggregate: containsAggregate(normalizedExpression)
                        )
                    )
                    expressions.append(normalizedExpression)
                }
            }

            specs.append(
                EvalOrderSpec(
                    index: index,
                    ordering: item.ordering == .descending ? .descending : .ascending
                )
            )
        }

        return (Array(targets.dropFirst(existingTargets.count)), specs)
    }

    private func compilePivotBy(
        _ pivotBy: BQLPivotByClause?,
        targets: [EvalTarget],
        groupIndexes: [Int]?
    ) throws -> [Int]? {
        guard let pivotBy else {
            return nil
        }

        let visibleIndexes = targets.enumerated().compactMap { index, target in
            target.name == nil ? nil : index
        }
        let names: [String: Int] = Dictionary(uniqueKeysWithValues: targets.enumerated().compactMap { index, target in
            guard let name = target.name else { return nil }
            return (name, index)
        })

        var indexes: [Int] = []

        for item in pivotBy.items {
            switch item {
            case .index(let oneBased):
                let resolved = oneBased - 1
                guard resolved >= 0 && resolved < visibleIndexes.count else {
                    throw BQLCompileError.invalidPivotByIndex(oneBased)
                }
                indexes.append(visibleIndexes[resolved])

            case .column(let name):
                guard let index = names[name] else {
                    throw BQLCompileError.pivotByColumnNotInTargets(name)
                }
                indexes.append(index)
            }
        }

        guard indexes.count == 2 else {
            throw BQLCompileError.invalidPivotByClause
        }

        if indexes[0] == indexes[1] {
            throw BQLCompileError.pivotByColumnsMustDiffer
        }

        guard let groupIndexes, groupIndexes.contains(indexes[1]) else {
            throw BQLCompileError.pivotBySecondMustBeGroupByColumn
        }

        return indexes
    }

    private func combineWithAnd(_ left: BQLExpression?, _ right: BQLExpression?) -> BQLExpression? {
        switch (left, right) {
        case (nil, nil):
            return nil
        case (let value?, nil), (nil, let value?):
            return value
        case (.and(let lhs), .and(let rhs)):
            return .and(lhs + rhs)
        case (.and(let lhs), let rhs?):
            return .and(lhs + [rhs])
        case (let lhs?, .and(let rhs)):
            return .and([lhs] + rhs)
        case (let lhs?, let rhs?):
            return .and([lhs, rhs])
        }
    }

    private func targetName(_ target: BQLTarget) -> String {
        if let alias = target.alias {
            return alias
        }

        if case .column(let name) = target.expression {
            return name
        }

        return renderExpression(target.expression)
    }

    private func renderExpression(_ expression: BQLExpression) -> String {
        switch expression {
        case .column(let name):
            return name
        case .function(let name, _):
            return name
        case .constant(let literal):
            switch literal {
            case .integer(let value): return String(value)
            case .decimal(let value): return NSDecimalNumber(decimal: value).stringValue
            case .date: return "date"
            case .string(let value): return value
            case .bool(let value): return value ? "true" : "false"
            case .null: return "null"
            case .list: return "list"
            }
        case .placeholder:
            return "placeholder"
        case .unary:
            return "expr"
        case .binary:
            return "expr"
        case .and:
            return "and"
        case .or:
            return "or"
        case .between:
            return "between"
        case .anyAll:
            return "anyall"
        case .attribute:
            return "attribute"
        case .subscriptExpr:
            return "subscript"
        case .select:
            return "subquery"
        case .asterisk:
            return "*"
        }
    }

    private func containsAggregate(_ expression: BQLExpression) -> Bool {
        analyzeAggregateUsage(expression).hasAggregate
    }

    private func analyzeAggregateUsage(
        _ expression: BQLExpression,
        insideAggregate: Bool = false
    ) -> AggregateUsage {
        switch expression {
        case .column:
            return AggregateUsage(
                hasAggregate: false,
                hasNonAggregateColumn: !insideAggregate,
                hasAggregateUnderAggregate: false
            )

        case .function(let name, let args):
            let isAggregate = Self.aggregateFunctions.contains(name.lowercased())
            var usage = AggregateUsage(
                hasAggregate: isAggregate,
                hasNonAggregateColumn: false,
                hasAggregateUnderAggregate: false
            )

            for arg in args {
                let child = analyzeAggregateUsage(
                    arg,
                    insideAggregate: insideAggregate || isAggregate
                )
                usage = usage.merging(child)
                if isAggregate && child.hasAggregate {
                    usage.hasAggregateUnderAggregate = true
                }
            }

            return usage

        case .unary(_, let operand):
            return analyzeAggregateUsage(operand, insideAggregate: insideAggregate)

        case .binary(_, let left, let right):
            return analyzeAggregateUsage(left, insideAggregate: insideAggregate)
                .merging(analyzeAggregateUsage(right, insideAggregate: insideAggregate))

        case .and(let args), .or(let args):
            return args.reduce(AggregateUsage()) { partial, expression in
                partial.merging(analyzeAggregateUsage(expression, insideAggregate: insideAggregate))
            }

        case .between(let value, let lower, let upper):
            return analyzeAggregateUsage(value, insideAggregate: insideAggregate)
                .merging(analyzeAggregateUsage(lower, insideAggregate: insideAggregate))
                .merging(analyzeAggregateUsage(upper, insideAggregate: insideAggregate))

        case .anyAll(_, _, let left, let right):
            return analyzeAggregateUsage(left, insideAggregate: insideAggregate)
                .merging(analyzeAggregateUsage(right, insideAggregate: insideAggregate))

        case .attribute(let operand, _):
            return analyzeAggregateUsage(operand, insideAggregate: insideAggregate)

        case .subscriptExpr(let operand, _):
            return analyzeAggregateUsage(operand, insideAggregate: insideAggregate)

        case .select:
            return AggregateUsage()

        case .constant, .placeholder, .asterisk:
            return AggregateUsage()
        }
    }

    private func transformBalances(_ balances: BQLBalancesStatement) -> BQLSelectStatement {
        let account = BQLExpression.column("account")
        let position = BQLExpression.column("position")

        let summarizedPosition: BQLExpression
        if let summaryFunction = balances.summaryFunction {
            summarizedPosition = .function(name: summaryFunction, args: [position])
        } else {
            summarizedPosition = position
        }

        let sumExpression = BQLExpression.function(name: "sum", args: [summarizedPosition])
        let sortKey = BQLExpression.function(name: "account_sortkey", args: [account])

        return BQLSelectStatement(
            distinct: false,
            targets: .values([
                BQLTarget(expression: account, alias: nil),
                BQLTarget(expression: sumExpression, alias: nil),
            ]),
            from: balances.from.map { .expression($0) },
            where: balances.where,
            groupBy: BQLGroupByClause(items: [.expression(account), .expression(sortKey)], having: nil),
            orderBy: [
                BQLOrderByItem(value: .expression(sortKey), ordering: .ascending)
            ],
            pivotBy: nil,
            limit: nil
        )
    }

    private func transformJournal(_ journal: BQLJournalStatement) -> BQLSelectStatement {
        let date = BQLExpression.column("date")
        let flag = BQLExpression.column("flag")
        let payee = BQLExpression.column("payee")
        let narration = BQLExpression.column("narration")
        let account = BQLExpression.column("account")
        let position = BQLExpression.column("position")
        let balance = BQLExpression.column("balance")

        let payeeWithWidth = BQLExpression.function(
            name: "maxwidth",
            args: [payee, .constant(.integer(48))]
        )
        let narrationWithWidth = BQLExpression.function(
            name: "maxwidth",
            args: [narration, .constant(.integer(80))]
        )

        let summaryPosition: BQLExpression
        let summaryBalance: BQLExpression
        if let summaryFunction = journal.summaryFunction {
            summaryPosition = .function(name: summaryFunction, args: [position])
            summaryBalance = .function(name: summaryFunction, args: [balance])
        } else {
            summaryPosition = position
            summaryBalance = balance
        }

        let accountFilter: BQLExpression?
        if let accountPattern = journal.account {
            accountFilter = .binary(.match, account, .constant(.string(accountPattern)))
        } else {
            accountFilter = nil
        }

        return BQLSelectStatement(
            distinct: false,
            targets: .values([
                BQLTarget(expression: date, alias: nil),
                BQLTarget(expression: flag, alias: nil),
                BQLTarget(expression: payeeWithWidth, alias: nil),
                BQLTarget(expression: narrationWithWidth, alias: nil),
                BQLTarget(expression: account, alias: nil),
                BQLTarget(expression: summaryPosition, alias: nil),
                BQLTarget(expression: summaryBalance, alias: nil),
            ]),
            from: journal.from.map { .expression($0) },
            where: accountFilter,
            groupBy: nil,
            orderBy: nil,
            pivotBy: nil,
            limit: nil
        )
    }
}

private struct AggregateUsage {
    var hasAggregate = false
    var hasNonAggregateColumn = false
    var hasAggregateUnderAggregate = false

    func merging(_ other: AggregateUsage) -> AggregateUsage {
        AggregateUsage(
            hasAggregate: hasAggregate || other.hasAggregate,
            hasNonAggregateColumn: hasNonAggregateColumn || other.hasNonAggregateColumn,
            hasAggregateUnderAggregate: hasAggregateUnderAggregate || other.hasAggregateUnderAggregate
        )
    }
}
