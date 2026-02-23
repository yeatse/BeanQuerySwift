import Foundation

enum BQLAstDumper {
    static func dump(_ statement: BQLStatement) -> String {
        switch statement {
        case .select(let select):
            return dump(select)
        case .balances(let balances):
            return dump(balances)
        case .journal(let journal):
            return dump(journal)
        case .print(let print):
            return dump(print)
        }
    }

    private static func dump(_ select: BQLSelectStatement) -> String {
        let targets = switch select.targets {
        case .asterisk:
            "*"
        case .values(let values):
            values.map {
                if let alias = $0.alias {
                    return "\(dump($0.expression)) AS \(alias)"
                }
                return dump($0.expression)
            }.joined(separator: ", ")
        }

        let from = select.from.map { " FROM \(dump($0))" } ?? ""
        let whereClause = select.where.map { " WHERE \(dump($0))" } ?? ""
        let groupBy = select.groupBy.map(dump) ?? ""
        let orderBy = select.orderBy.map(dump) ?? ""
        let pivotBy = select.pivotBy.map(dump) ?? ""
        let limit = select.limit.map { " LIMIT \($0)" } ?? ""
        let distinct = select.distinct ? "DISTINCT " : ""

        return "SELECT \(distinct)\(targets)\(from)\(whereClause)\(groupBy)\(orderBy)\(pivotBy)\(limit)"
    }

    private static func dump(_ balances: BQLBalancesStatement) -> String {
        let summary = balances.summaryFunction.map { " AT \($0)" } ?? ""
        let from = balances.from.map { " FROM \(dump($0))" } ?? ""
        let whereClause = balances.where.map { " WHERE \(dump($0))" } ?? ""
        return "BALANCES\(summary)\(from)\(whereClause)"
    }

    private static func dump(_ journal: BQLJournalStatement) -> String {
        let account = journal.account.map { " '\($0)'" } ?? ""
        let summary = journal.summaryFunction.map { " AT \($0)" } ?? ""
        let from = journal.from.map { " FROM \(dump($0))" } ?? ""
        return "JOURNAL\(account)\(summary)\(from)"
    }

    private static func dump(_ print: BQLPrintStatement) -> String {
        let from = print.from.map { " FROM \(dump($0))" } ?? ""
        return "PRINT\(from)"
    }

    private static func dump(_ from: BQLFromClause) -> String {
        switch from {
        case .table(.hash(let name)):
            return name.map { "#\($0)" } ?? "#"
        case .table(.named(let name)):
            return name
        case .subselect(let select):
            return "(\(dump(select)))"
        case .expression(let expression):
            return dump(expression)
        }
    }

    private static func dump(_ from: BQLFromExpression) -> String {
        var parts: [String] = []
        if let expression = from.expression {
            parts.append(dump(expression))
        }
        if let open = from.open {
            parts.append("OPEN ON \(formatDate(open))")
        }
        if let close = from.close {
            switch close {
            case .implicit:
                parts.append("CLOSE")
            case .on(let date):
                parts.append("CLOSE ON \(formatDate(date))")
            }
        }
        if from.clear {
            parts.append("CLEAR")
        }
        return parts.joined(separator: " ")
    }

    private static func dump(_ groupBy: BQLGroupByClause) -> String {
        let items = groupBy.items.map { item in
            switch item {
            case .index(let index):
                return String(index)
            case .expression(let expression):
                return dump(expression)
            }
        }.joined(separator: ", ")

        let having = groupBy.having.map { " HAVING \(dump($0))" } ?? ""
        return " GROUP BY \(items)\(having)"
    }

    private static func dump(_ orderBy: [BQLOrderByItem]) -> String {
        let items = orderBy.map { item in
            let value: String
            switch item.value {
            case .index(let index):
                value = String(index)
            case .expression(let expression):
                value = dump(expression)
            }

            let ordering = item.ordering == .descending ? " DESC" : " ASC"
            return value + ordering
        }.joined(separator: ", ")
        return " ORDER BY \(items)"
    }

    private static func dump(_ pivotBy: BQLPivotByClause) -> String {
        let items = pivotBy.items.map { item in
            switch item {
            case .index(let index):
                return String(index)
            case .column(let name):
                return name
            }
        }.joined(separator: ", ")
        return " PIVOT BY \(items)"
    }

    private static func dump(_ expression: BQLExpression) -> String {
        switch expression {
        case .column(let name):
            return name
        case .function(let name, let args):
            let rendered = args.map(dump).joined(separator: ", ")
            return "\(name)(\(rendered))"
        case .constant(let literal):
            return dump(literal)
        case .placeholder(.positional):
            return "%s"
        case .placeholder(.named(let name)):
            return "%(\(name))s"
        case .unary(let op, let value):
            switch op {
            case .not: return "NOT \(dump(value))"
            case .neg: return "-\(dump(value))"
            case .isNull: return "\(dump(value)) IS NULL"
            case .isNotNull: return "\(dump(value)) IS NOT NULL"
            }
        case .binary(let op, let left, let right):
            return "(\(dump(left)) \(renderBinaryOperator(op)) \(dump(right)))"
        case .and(let args):
            return args.map(dump).joined(separator: " AND ")
        case .or(let args):
            return args.map(dump).joined(separator: " OR ")
        case .between(let value, let lower, let upper):
            return "\(dump(value)) BETWEEN \(dump(lower)) AND \(dump(upper))"
        case .anyAll(let op, let quantifier, let left, let right):
            let q = quantifier == .any ? "ANY" : "ALL"
            return "\(dump(left)) \(renderBinaryOperator(op)) \(q)(\(dump(right)))"
        case .attribute(let value, let name):
            return "\(dump(value)).\(name)"
        case .subscriptExpr(let value, let key):
            return "\(dump(value))[\"\(key)\"]"
        case .select(let select):
            return "(\(dump(select)))"
        case .asterisk:
            return "*"
        }
    }

    private static func dump(_ literal: BQLLiteral) -> String {
        switch literal {
        case .integer(let value):
            return String(value)
        case .decimal(let value):
            return NSDecimalNumber(decimal: value).stringValue
        case .date(let date):
            return formatDate(date)
        case .string(let value):
            return "'\(value)'"
        case .bool(let value):
            return value ? "TRUE" : "FALSE"
        case .null:
            return "NULL"
        case .list(let values):
            return "(\(values.map(dump).joined(separator: ", ")))"
        }
    }

    private static func renderBinaryOperator(_ op: BQLBinaryOperator) -> String {
        switch op {
        case .add: return "+"
        case .sub: return "-"
        case .mul: return "*"
        case .div: return "/"
        case .mod: return "%"
        case .less: return "<"
        case .lessOrEqual: return "<="
        case .greater: return ">"
        case .greaterOrEqual: return ">="
        case .equal: return "="
        case .notEqual: return "!="
        case .inList: return "IN"
        case .notInList: return "NOT IN"
        case .match: return "~"
        case .notMatch: return "!~"
        case .matches: return "?~"
        }
    }

    private static func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year,
              let month = components.month,
              let day = components.day
        else {
            return "date"
        }
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}
