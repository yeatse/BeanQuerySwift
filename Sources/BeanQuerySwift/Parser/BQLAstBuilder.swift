import Foundation
import Antlr4

struct BQLAstBuilder {
    static func build(_ tree: BQLParser.BqlContext) throws -> BQLStatement {
        guard let statement = tree.statement() else {
            throw BQLASTBuildError("missing statement")
        }

        if let select = statement.selectStmt() {
            return .select(try buildSelect(select))
        }

        if let balances = statement.balancesStmt() {
            return .balances(try buildBalances(balances))
        }

        throw BQLASTBuildError("unsupported statement")
    }

    private static func buildSelect(_ ctx: BQLParser.SelectStmtContext) throws -> BQLSelectStatement {
        BQLSelectStatement(
            distinct: ctx.distinctClause() != nil,
            targets: try buildTargets(require(ctx.targets(), "missing targets")),
            from: try buildFromClause(ctx.fromClause()),
            where: try buildWhere(ctx.whereClause()),
            groupBy: try buildGroupBy(ctx.groupByClause()),
            orderBy: try buildOrderBy(ctx.orderByClause()),
            limit: try buildLimit(ctx.limitClause())
        )
    }

    private static func buildBalances(_ ctx: BQLParser.BalancesStmtContext) throws -> BQLBalancesStatement {
        BQLBalancesStatement(
            summaryFunction: try ctx.identifier().map(buildIdentifier),
            from: try ctx.balancesFromClause().map { fromClause in
                try buildFromExpr(require(fromClause.fromExpr(), "missing from expression"))
            },
            where: try buildWhere(ctx.whereClause())
        )
    }

    private static func buildTargets(_ ctx: BQLParser.TargetsContext) throws -> BQLTargetList {
        if ctx.asterisk() != nil {
            return .asterisk
        }

        let values = try ctx.target().map { target in
            try BQLTarget(
                expression: buildExpression(require(target.expression(), "missing target expression")),
                alias: try target.identifier().map(buildIdentifier)
            )
        }

        return .values(values)
    }

    private static func buildFromClause(_ ctx: BQLParser.FromClauseContext?) throws -> BQLFromClause? {
        guard let ctx else { return nil }

        if let table = ctx.tableRef()?.tableName() {
            return .table(try buildTableReference(table))
        }

        if let select = ctx.subselect()?.selectStmt() {
            return .subselect(try buildSelect(select))
        }

        if let fromExpr = ctx.fromExpr() {
            return .expression(try buildFromExpr(fromExpr))
        }

        throw BQLASTBuildError("unsupported FROM clause")
    }

    private static func buildTableReference(_ ctx: BQLParser.TableNameContext) throws -> BQLTableReference {
        if ctx.HASH_TABLE() != nil {
            let raw = try tokenText(ctx.getStart(), "missing hash table token")
            return .hash(String(raw.dropFirst()).lowercased())
        }

        if ctx.HASH_EMPTY() != nil {
            return .hash(nil)
        }

        if let identifier = ctx.identifier() {
            return .named(try buildIdentifier(identifier))
        }

        throw BQLASTBuildError("invalid table reference")
    }

    private static func buildFromExpr(_ ctx: BQLParser.FromExprContext) throws -> BQLFromExpression {
        var dateIndex = 0
        let dates = try ctx.dateLiteral().map(buildDate)

        func popDateIfAvailable() -> Date? {
            guard dateIndex < dates.count else { return nil }
            defer { dateIndex += 1 }
            return dates[dateIndex]
        }

        let expression = try ctx.expression().map(buildExpression)

        var open: Date?
        if ctx.OPEN() != nil {
            open = popDateIfAvailable()
            if open == nil {
                throw BQLASTBuildError("OPEN ON requires a date")
            }
        }

        var close: BQLCloseQualifier?
        if ctx.CLOSE() != nil {
            if let closeDate = popDateIfAvailable() {
                close = .on(closeDate)
            } else {
                close = .implicit
            }
        }

        return BQLFromExpression(
            expression: expression,
            open: open,
            close: close,
            clear: ctx.clearClause() != nil || (ctx.CLEAR() != nil && expression == nil && open == nil && close == nil)
        )
    }

    private static func buildWhere(_ ctx: BQLParser.WhereClauseContext?) throws -> BQLExpression? {
        guard let expression = ctx?.expression() else { return nil }
        return try buildExpression(expression)
    }

    private static func buildGroupBy(_ ctx: BQLParser.GroupByClauseContext?) throws -> BQLGroupByClause? {
        guard let ctx else { return nil }

        let items: [BQLGroupByItem] = try ctx.groupItem().map { item in
            if let index = item.integerLiteral() {
                return BQLGroupByItem.index(try buildInt(index))
            }
            return BQLGroupByItem.expression(try buildExpression(require(item.expression(), "missing GROUP BY expression")))
        }

        let having = try ctx.expression().map(buildExpression)

        return BQLGroupByClause(items: items, having: having)
    }

    private static func buildOrderBy(_ ctx: BQLParser.OrderByClauseContext?) throws -> [BQLOrderByItem]? {
        guard let ctx else { return nil }

        return try ctx.orderItem().map { item in
            let value: BQLOrderByValue
            if let index = item.integerLiteral() {
                value = .index(try buildInt(index))
            } else {
                value = .expression(try buildExpression(require(item.expression(), "missing ORDER BY expression")))
            }

            let ordering: BQLOrdering
            if let order = item.ordering(), order.DESC() != nil {
                ordering = .descending
            } else {
                ordering = .ascending
            }

            return BQLOrderByItem(value: value, ordering: ordering)
        }
    }

    private static func buildLimit(_ ctx: BQLParser.LimitClauseContext?) throws -> Int? {
        guard let literal = ctx?.integerLiteral() else { return nil }
        return try buildInt(literal)
    }

    private static func buildExpression(_ ctx: BQLParser.ExpressionContext) throws -> BQLExpression {
        try buildDisjunction(require(ctx.disjunction(), "missing disjunction"))
    }

    private static func buildDisjunction(_ ctx: BQLParser.DisjunctionContext) throws -> BQLExpression {
        let args = try ctx.conjunction().map(buildConjunction)
        if args.count == 1, let first = args.first {
            return first
        }
        return .or(args)
    }

    private static func buildConjunction(_ ctx: BQLParser.ConjunctionContext) throws -> BQLExpression {
        let args = try ctx.inversion().map(buildInversion)
        if args.count == 1, let first = args.first {
            return first
        }
        return .and(args)
    }

    private static func buildInversion(_ ctx: BQLParser.InversionContext) throws -> BQLExpression {
        if let nested = ctx.inversion() {
            return .unary(.not, try buildInversion(nested))
        }
        return try buildComparison(require(ctx.comparison(), "missing comparison"))
    }

    private static func buildComparison(_ ctx: BQLParser.ComparisonContext) throws -> BQLExpression {
        let left = try buildSumExpr(require(ctx.sumExpr(), "missing comparison left"))

        guard let suffix = ctx.comparisonSuffix() else {
            return left
        }

        if suffix.IS() != nil {
            if suffix.NOT() != nil {
                return .unary(.isNotNull, left)
            }
            return .unary(.isNull, left)
        }

        if suffix.BETWEEN() != nil {
            let bounds = try suffix.sumExpr().map(buildSumExpr)
            guard bounds.count == 2 else {
                throw BQLASTBuildError("BETWEEN requires lower and upper expressions")
            }
            return .between(left, lower: bounds[0], upper: bounds[1])
        }

        if let opCtx = suffix.anyAllOp() {
            let op = try buildBinaryOperator(opCtx)
            let quantifier: BQLQuantifier = suffix.ANY() != nil ? .any : .all
            let right = try buildExpression(require(suffix.expression(), "missing ANY/ALL expression"))
            return .anyAll(op: op, quantifier: quantifier, left: left, right: right)
        }

        if suffix.NOT() != nil && suffix.IN() != nil {
            let right = try buildSumExpr(require(suffix.sumExpr(0), "missing right operand"))
            return .binary(.notInList, left, right)
        }

        let right = try buildSumExpr(require(suffix.sumExpr(0), "missing right operand"))

        if suffix.LT() != nil { return .binary(.less, left, right) }
        if suffix.LTE() != nil { return .binary(.lessOrEqual, left, right) }
        if suffix.GT() != nil { return .binary(.greater, left, right) }
        if suffix.GTE() != nil { return .binary(.greaterOrEqual, left, right) }
        if suffix.EQ() != nil { return .binary(.equal, left, right) }
        if suffix.NEQ() != nil { return .binary(.notEqual, left, right) }
        if suffix.IN() != nil { return .binary(.inList, left, right) }
        if suffix.MATCH() != nil { return .binary(.match, left, right) }
        if suffix.NOT_MATCH() != nil { return .binary(.notMatch, left, right) }
        if suffix.MATCHES() != nil { return .binary(.matches, left, right) }

        throw BQLASTBuildError("unsupported comparison suffix")
    }

    private static func buildSumExpr(_ ctx: BQLParser.SumExprContext) throws -> BQLExpression {
        if let leftCtx = ctx.sumExpr() {
            let left = try buildSumExpr(leftCtx)
            let right = try buildTermExpr(require(ctx.termExpr(), "missing right sum operand"))
            if ctx.PLUS() != nil {
                return .binary(.add, left, right)
            }
            if ctx.MINUS() != nil {
                return .binary(.sub, left, right)
            }
            throw BQLASTBuildError("unsupported sum operator")
        }

        return try buildTermExpr(require(ctx.termExpr(), "missing term expression"))
    }

    private static func buildTermExpr(_ ctx: BQLParser.TermExprContext) throws -> BQLExpression {
        if let leftCtx = ctx.termExpr() {
            let left = try buildTermExpr(leftCtx)
            let right = try buildFactorExpr(require(ctx.factorExpr(), "missing right term operand"))
            if ctx.STAR() != nil {
                return .binary(.mul, left, right)
            }
            if ctx.SLASH() != nil {
                return .binary(.div, left, right)
            }
            if ctx.PERCENT() != nil {
                return .binary(.mod, left, right)
            }
            throw BQLASTBuildError("unsupported term operator")
        }

        return try buildFactorExpr(require(ctx.factorExpr(), "missing factor expression"))
    }

    private static func buildFactorExpr(_ ctx: BQLParser.FactorExprContext) throws -> BQLExpression {
        if let unary = ctx.unaryExpr() {
            return try buildUnaryExpr(unary)
        }
        return try buildExpression(require(ctx.expression(), "missing parenthesized expression"))
    }

    private static func buildUnaryExpr(_ ctx: BQLParser.UnaryExprContext) throws -> BQLExpression {
        if ctx.PLUS() != nil {
            return try buildAtomExpr(require(ctx.atomExpr(), "missing unary plus operand"))
        }
        if ctx.MINUS() != nil {
            return .unary(.neg, try buildFactorExpr(require(ctx.factorExpr(), "missing unary minus operand")))
        }
        return try buildPrimaryExpr(require(ctx.primaryExpr(), "missing primary expression"))
    }

    private static func buildPrimaryExpr(_ ctx: BQLParser.PrimaryExprContext) throws -> BQLExpression {
        if let leftCtx = ctx.primaryExpr() {
            let left = try buildPrimaryExpr(leftCtx)
            if ctx.DOT() != nil {
                return .attribute(left, name: try buildIdentifier(require(ctx.identifier(), "missing attribute")))
            }
            if ctx.LBRACK() != nil {
                return .subscriptExpr(left, key: try buildStringLiteral(require(ctx.stringLiteral(), "missing subscript key")))
            }
            throw BQLASTBuildError("unsupported primary expression")
        }

        return try buildAtomExpr(require(ctx.atomExpr(), "missing atom expression"))
    }

    private static func buildAtomExpr(_ ctx: BQLParser.AtomExprContext) throws -> BQLExpression {
        if let select = ctx.selectStmt() {
            return .select(try buildSelect(select))
        }
        if let function = ctx.functionCall() {
            return try buildFunction(function)
        }
        if let constant = ctx.constant() {
            return .constant(try buildConstant(constant))
        }
        if let column = ctx.columnRef() {
            return .column(try buildIdentifier(require(column.identifier(), "missing column identifier")))
        }
        if let placeholder = ctx.placeholder() {
            return .placeholder(try buildPlaceholder(placeholder))
        }
        throw BQLASTBuildError("unsupported atom expression")
    }

    private static func buildFunction(_ ctx: BQLParser.FunctionCallContext) throws -> BQLExpression {
        let name = try buildIdentifier(require(ctx.identifier(), "missing function name"))

        if ctx.asterisk() != nil {
            return .function(name: name, args: [.asterisk])
        }

        let args: [BQLExpression]
        if let expressionList = ctx.expressionList() {
            args = try expressionList.expression().map(buildExpression)
        } else {
            args = []
        }
        return .function(name: name, args: args)
    }

    private static func buildPlaceholder(_ ctx: BQLParser.PlaceholderContext) throws -> BQLPlaceholder {
        if ctx.POSITIONAL_PLACEHOLDER() != nil {
            return .positional
        }
        let name = try buildIdentifier(require(ctx.identifier(), "missing placeholder name"))
        return .named(name)
    }

    private static func buildConstant(_ ctx: BQLParser.ConstantContext) throws -> BQLLiteral {
        if let literal = ctx.literal() {
            return try buildLiteral(literal)
        }

        if let list = ctx.listLiteral() {
            return .list(try list.literal().map(buildLiteral))
        }

        throw BQLASTBuildError("unsupported constant")
    }

    private static func buildLiteral(_ ctx: BQLParser.LiteralContext) throws -> BQLLiteral {
        if let integer = ctx.integerLiteral() {
            return .integer(try buildInt(integer))
        }

        if let decimal = ctx.decimalLiteral() {
            let text = try tokenText(decimal.getStart(), "missing decimal token")
            guard let value = Decimal(string: text, locale: Locale(identifier: "en_US_POSIX")) else {
                throw BQLASTBuildError("invalid decimal literal: \(text)")
            }
            return .decimal(value)
        }

        if let date = ctx.dateLiteral() {
            return .date(try buildDate(date))
        }

        if let string = ctx.stringLiteral() {
            return .string(try buildStringLiteral(string))
        }

        if let boolean = ctx.booleanLiteral() {
            return .bool(boolean.TRUE() != nil)
        }

        if ctx.nullLiteral() != nil {
            return .null
        }

        throw BQLASTBuildError("unsupported literal")
    }

    private static func buildInt(_ ctx: BQLParser.IntegerLiteralContext) throws -> Int {
        let text = try tokenText(ctx.getStart(), "missing integer token")
        guard let value = Int(text) else {
            throw BQLASTBuildError("invalid integer literal: \(text)")
        }
        return value
    }

    private static func buildDate(_ ctx: BQLParser.DateLiteralContext) throws -> Date {
        let text = try tokenText(ctx.getStart(), "missing date token")

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.date(from: text) else {
            throw BQLASTBuildError("invalid date literal: \(text)")
        }

        return date
    }

    private static func buildIdentifier(_ ctx: BQLParser.IdentifierContext) throws -> String {
        let raw = try tokenText(ctx.getStart(), "missing identifier token")
        if ctx.DOUBLE_QUOTED_TEXT() != nil {
            return decodeQuotedString(raw)
        }
        return raw.lowercased()
    }

    private static func buildStringLiteral(_ ctx: BQLParser.StringLiteralContext) throws -> String {
        decodeQuotedString(try tokenText(ctx.getStart(), "missing string token"))
    }

    private static func buildBinaryOperator(_ ctx: BQLParser.AnyAllOpContext) throws -> BQLBinaryOperator {
        if ctx.LT() != nil { return .less }
        if ctx.LTE() != nil { return .lessOrEqual }
        if ctx.GT() != nil { return .greater }
        if ctx.GTE() != nil { return .greaterOrEqual }
        if ctx.EQ() != nil { return .equal }
        if ctx.NEQ() != nil { return .notEqual }
        if ctx.MATCH() != nil { return .match }
        if ctx.NOT_MATCH() != nil { return .notMatch }
        if ctx.MATCHES() != nil { return .matches }
        throw BQLASTBuildError("unsupported ANY/ALL operator")
    }

    private static func decodeQuotedString(_ raw: String) -> String {
        guard raw.count >= 2 else { return raw }

        let start = raw.startIndex
        let end = raw.index(before: raw.endIndex)
        let quote = raw[start]
        let body = String(raw[raw.index(after: start)..<end])

        if quote == "\"" {
            return body.replacingOccurrences(of: "\"\"", with: "\"")
        }

        if quote == "'" {
            return body.replacingOccurrences(of: "''", with: "'")
        }

        return body
    }

    private static func require<T>(_ value: T?, _ message: String) throws -> T {
        guard let value else {
            throw BQLASTBuildError(message)
        }
        return value
    }

    private static func tokenText(_ token: Token?, _ message: String) throws -> String {
        guard let token, let text = token.getText() else {
            throw BQLASTBuildError(message)
        }
        return text
    }
}
