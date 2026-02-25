import Foundation

enum BQLType: Equatable, Sendable, CustomStringConvertible {
    case int
    case decimal
    case date
    case string
    case bool
    case null
    case list
    case object

    var description: String {
        switch self {
        case .int: return "int"
        case .decimal: return "decimal"
        case .date: return "date"
        case .string: return "string"
        case .bool: return "bool"
        case .null: return "null"
        case .list: return "list"
        case .object: return "object"
        }
    }
}

private struct FunctionSignature {
    var name: String
    var arguments: [BQLType]
    var result: BQLType
}

private struct FunctionRegistry {
    private let signatures: [FunctionSignature] = [
        FunctionSignature(name: "count", arguments: [.object], result: .int),
        FunctionSignature(name: "sum", arguments: [.int], result: .int),
        FunctionSignature(name: "sum", arguments: [.decimal], result: .decimal),
        FunctionSignature(name: "first", arguments: [.object], result: .object),
        FunctionSignature(name: "last", arguments: [.object], result: .object),
        FunctionSignature(name: "min", arguments: [.object], result: .object),
        FunctionSignature(name: "max", arguments: [.object], result: .object),
        FunctionSignature(name: "abs", arguments: [.object], result: .object),
        FunctionSignature(name: "units", arguments: [.object], result: .object),
        FunctionSignature(name: "cost", arguments: [.object], result: .object),
        FunctionSignature(name: "weight", arguments: [.object], result: .object),
        FunctionSignature(name: "value", arguments: [.object], result: .object),
        FunctionSignature(name: "value", arguments: [.object, .date], result: .object),
        FunctionSignature(name: "convert", arguments: [.object, .string], result: .object),
        FunctionSignature(name: "convert", arguments: [.object, .string, .date], result: .object),
        FunctionSignature(name: "getprice", arguments: [.string, .string], result: .decimal),
        FunctionSignature(name: "getprice", arguments: [.string, .string, .date], result: .decimal),
        FunctionSignature(name: "number", arguments: [.object], result: .decimal),
        FunctionSignature(name: "currency", arguments: [.object], result: .string),
        FunctionSignature(name: "commodity", arguments: [.object], result: .string),
        FunctionSignature(name: "findfirst", arguments: [.string, .list], result: .string),
        FunctionSignature(name: "joinstr", arguments: [.list], result: .string),
        FunctionSignature(name: "only", arguments: [.string, .object], result: .object),
        FunctionSignature(name: "empty", arguments: [.object], result: .bool),
        FunctionSignature(name: "filter_currency", arguments: [.object, .string], result: .object),
        FunctionSignature(name: "possign", arguments: [.object, .string], result: .object),
        FunctionSignature(name: "maxwidth", arguments: [.string, .int], result: .string),
        FunctionSignature(name: "root", arguments: [.string], result: .string),
        FunctionSignature(name: "root", arguments: [.string, .int], result: .string),
        FunctionSignature(name: "parent", arguments: [.string], result: .string),
        FunctionSignature(name: "leaf", arguments: [.string], result: .string),
        FunctionSignature(name: "grep", arguments: [.string, .string], result: .string),
        FunctionSignature(name: "grepn", arguments: [.string, .string, .int], result: .string),
        FunctionSignature(name: "subst", arguments: [.string, .string, .string], result: .string),
        FunctionSignature(name: "upper", arguments: [.string], result: .string),
        FunctionSignature(name: "lower", arguments: [.string], result: .string),
        FunctionSignature(name: "open_date", arguments: [.string], result: .date),
        FunctionSignature(name: "close_date", arguments: [.string], result: .date),
        FunctionSignature(name: "open_meta", arguments: [.string], result: .object),
        FunctionSignature(name: "open_meta", arguments: [.string, .string], result: .object),
        FunctionSignature(name: "account_sortkey", arguments: [.string], result: .string),
        FunctionSignature(name: "has_account", arguments: [.string], result: .bool),
        FunctionSignature(name: "date", arguments: [.date], result: .date),
        FunctionSignature(name: "date", arguments: [.string], result: .date),
        FunctionSignature(name: "date", arguments: [.object], result: .date),
        FunctionSignature(name: "date", arguments: [.int, .int, .int], result: .date),
        FunctionSignature(name: "year", arguments: [.date], result: .int),
        FunctionSignature(name: "month", arguments: [.date], result: .int),
        FunctionSignature(name: "day", arguments: [.date], result: .int),
        FunctionSignature(name: "yearmonth", arguments: [.date], result: .date),
        FunctionSignature(name: "quarter", arguments: [.date], result: .string),
        FunctionSignature(name: "weekday", arguments: [.date], result: .string),
        FunctionSignature(name: "today", arguments: [], result: .date),
        FunctionSignature(name: "parse_date", arguments: [.string], result: .date),
        FunctionSignature(name: "parse_date", arguments: [.string, .string], result: .date),
        FunctionSignature(name: "date_diff", arguments: [.date, .date], result: .int),
        FunctionSignature(name: "date_add", arguments: [.date, .int], result: .date),
        FunctionSignature(name: "date_trunc", arguments: [.string, .date], result: .date),
        FunctionSignature(name: "date_part", arguments: [.string, .date], result: .int),
        FunctionSignature(name: "interval", arguments: [.string], result: .object),
        FunctionSignature(name: "date_bin", arguments: [.object, .date, .date], result: .date),
        FunctionSignature(name: "date_bin", arguments: [.string, .date, .date], result: .date),
    ]

    func lookup(name: String, arguments: [BQLType]) -> BQLType? {
        for signature in signatures where signature.name == name.lowercased() {
            guard signature.arguments.count == arguments.count else {
                continue
            }

            var matched = true
            for (expected, actual) in zip(signature.arguments, arguments) {
                if expected != .object && actual != .object && expected != actual {
                    matched = false
                    break
                }
            }
            if matched {
                return signature.result
            }
        }
        return nil
    }
}

private struct OperatorRegistry {
    func lookupUnary(_ op: BQLUnaryOperator, operand: BQLType) -> BQLType? {
        switch op {
        case .not:
            return operand == .bool || operand == .object ? .bool : nil
        case .neg:
            if operand == .int { return .int }
            if operand == .decimal { return .decimal }
            if operand == .object { return .object }
            return nil
        case .isNull, .isNotNull:
            return .bool
        }
    }

    func lookupBinary(_ op: BQLBinaryOperator, left: BQLType, right: BQLType) -> BQLType? {
        switch op {
        case .add:
            if left == .string && right == .string { return .string }
            return numericResult(left: left, right: right)
        case .sub, .mul, .div:
            return numericResult(left: left, right: right)
        case .mod:
            if (left == .int && right == .int) || left == .object || right == .object {
                return left == .object || right == .object ? .object : .int
            }
            return nil
        case .less, .lessOrEqual, .greater, .greaterOrEqual, .equal, .notEqual:
            return comparable(left: left, right: right) ? .bool : nil
        case .inList, .notInList:
            if right == .list || right == .object {
                return .bool
            }
            return nil
        case .match, .notMatch, .matches:
            if (left == .string && right == .string) || left == .object || right == .object {
                return .bool
            }
            return nil
        }
    }

    private func numericResult(left: BQLType, right: BQLType) -> BQLType? {
        if left == .object || right == .object {
            return .object
        }

        let types = Set([left, right])
        if types == [.int] { return .int }
        if types == [.decimal] || types == [.int, .decimal] {
            return .decimal
        }
        return nil
    }

    private func comparable(left: BQLType, right: BQLType) -> Bool {
        if left == .object || right == .object {
            return true
        }
        if left == right {
            return true
        }
        let types = Set([left, right])
        return types == [.int, .decimal]
    }
}

struct ExpressionTypeChecker {
    private let functions = FunctionRegistry()
    private let operators = OperatorRegistry()

    func validateAndFold(_ expression: BQLExpression) throws -> BQLExpression {
        let normalized = try normalize(expression)
        return normalized.expression
    }

    private func normalize(_ expression: BQLExpression) throws -> NormalizedExpression {
        switch expression {
        case .column:
            return NormalizedExpression(expression: expression, type: .object, constant: nil)

        case .constant(let literal):
            return NormalizedExpression(expression: expression, type: type(of: literal), constant: literal)

        case .placeholder:
            return NormalizedExpression(expression: expression, type: .object, constant: nil)

        case .unary(let op, let operand):
            let normalizedOperand = try normalize(operand)
            guard let resultType = operators.lookupUnary(op, operand: normalizedOperand.type) else {
                throw BQLCompileError.invalidUnaryOperator(op: op, operand: normalizedOperand.type)
            }

            let folded = normalizedOperand.constant.flatMap { foldUnary(op: op, operand: $0) }
            let normalizedExpression = folded.map(BQLExpression.constant)
                ?? .unary(op, normalizedOperand.expression)
            return NormalizedExpression(expression: normalizedExpression, type: resultType, constant: folded)

        case .binary(let op, let left, let right):
            let normalizedLeft = try normalize(left)
            let normalizedRight = try normalize(right)

            guard let resultType = operators.lookupBinary(op, left: normalizedLeft.type, right: normalizedRight.type) else {
                throw BQLCompileError.invalidBinaryOperator(
                    op: op,
                    left: normalizedLeft.type,
                    right: normalizedRight.type
                )
            }

            let folded: BQLLiteral?
            if let leftLiteral = normalizedLeft.constant, let rightLiteral = normalizedRight.constant {
                folded = foldBinary(op: op, left: leftLiteral, right: rightLiteral)
            } else {
                folded = nil
            }

            let normalizedExpression = folded.map(BQLExpression.constant)
                ?? .binary(op, normalizedLeft.expression, normalizedRight.expression)
            return NormalizedExpression(expression: normalizedExpression, type: resultType, constant: folded)

        case .and(let args):
            let normalizedArgs = try args.map(normalize)
            let folded: BQLLiteral?
            if normalizedArgs.allSatisfy({ $0.type == .bool || $0.type == .object }) {
                if normalizedArgs.allSatisfy({ $0.constant != nil }) {
                    folded = .bool(normalizedArgs.compactMap(\.constant).allSatisfy(asBool))
                } else {
                    folded = nil
                }
            } else {
                throw BQLCompileError.invalidUnaryOperator(op: .not, operand: .object)
            }

            let normalizedExpression = folded.map(BQLExpression.constant)
                ?? .and(normalizedArgs.map(\.expression))
            return NormalizedExpression(expression: normalizedExpression, type: .bool, constant: folded)

        case .or(let args):
            let normalizedArgs = try args.map(normalize)
            let folded: BQLLiteral?
            if normalizedArgs.allSatisfy({ $0.type == .bool || $0.type == .object }) {
                if normalizedArgs.allSatisfy({ $0.constant != nil }) {
                    folded = .bool(normalizedArgs.compactMap(\.constant).contains(where: asBool))
                } else {
                    folded = nil
                }
            } else {
                throw BQLCompileError.invalidUnaryOperator(op: .not, operand: .object)
            }

            let normalizedExpression = folded.map(BQLExpression.constant)
                ?? .or(normalizedArgs.map(\.expression))
            return NormalizedExpression(expression: normalizedExpression, type: .bool, constant: folded)

        case .between(let value, let lower, let upper):
            let normalizedValue = try normalize(value)
            let normalizedLower = try normalize(lower)
            let normalizedUpper = try normalize(upper)
            let normalizedExpression = BQLExpression.between(
                normalizedValue.expression,
                lower: normalizedLower.expression,
                upper: normalizedUpper.expression
            )
            return NormalizedExpression(expression: normalizedExpression, type: .bool, constant: nil)

        case .anyAll(let op, let quantifier, let left, let right):
            let normalizedLeft = try normalize(left)
            let normalizedRight = try normalize(right)

            guard operators.lookupBinary(op, left: normalizedLeft.type, right: .object) != nil else {
                throw BQLCompileError.invalidBinaryOperator(op: op, left: normalizedLeft.type, right: .object)
            }

            let normalizedExpression = BQLExpression.anyAll(
                op: op,
                quantifier: quantifier,
                left: normalizedLeft.expression,
                right: normalizedRight.expression
            )
            return NormalizedExpression(expression: normalizedExpression, type: .bool, constant: nil)

        case .function(let name, let args):
            let normalizedArgs = try args.map(normalize)
            let argTypes = normalizedArgs.map(\.type)
            guard let result = functions.lookup(name: name, arguments: argTypes) else {
                throw BQLCompileError.invalidFunctionSignature(name: name, argTypes: argTypes)
            }

            let folded = try foldFunction(
                name: name,
                args: normalizedArgs.compactMap(\.constant),
                expectedCount: args.count
            )
            let normalizedExpression = folded.map(BQLExpression.constant)
                ?? .function(name: name, args: normalizedArgs.map(\.expression))
            return NormalizedExpression(expression: normalizedExpression, type: result, constant: folded)

        case .attribute(let value, let name):
            let normalizedValue = try normalize(value)
            return NormalizedExpression(
                expression: .attribute(normalizedValue.expression, name: name),
                type: .object,
                constant: nil
            )

        case .subscriptExpr(let value, let key):
            let normalizedValue = try normalize(value)
            return NormalizedExpression(
                expression: .subscriptExpr(normalizedValue.expression, key: key),
                type: .object,
                constant: nil
            )

        case .select(let select):
            return NormalizedExpression(expression: .select(select), type: .object, constant: nil)

        case .asterisk:
            return NormalizedExpression(expression: .asterisk, type: .object, constant: nil)
        }
    }

    private func type(of literal: BQLLiteral) -> BQLType {
        switch literal {
        case .integer: return .int
        case .decimal: return .decimal
        case .date: return .date
        case .string: return .string
        case .bool: return .bool
        case .null: return .null
        case .list: return .list
        }
    }

    private func foldUnary(op: BQLUnaryOperator, operand: BQLLiteral) -> BQLLiteral? {
        switch op {
        case .not:
            return .bool(!asBool(operand))
        case .neg:
            switch operand {
            case .integer(let value): return .integer(-value)
            case .decimal(let value): return .decimal(-value)
            default: return nil
            }
        case .isNull:
            return .bool(operand == .null)
        case .isNotNull:
            return .bool(operand != .null)
        }
    }

    private func foldBinary(op: BQLBinaryOperator, left: BQLLiteral, right: BQLLiteral) -> BQLLiteral? {
        switch op {
        case .add:
            if let l = asDecimal(left), let r = asDecimal(right) {
                if case .integer(let li) = left, case .integer(let ri) = right {
                    return .integer(li + ri)
                }
                return .decimal(l + r)
            }
            if case .string(let l) = left, case .string(let r) = right {
                return .string(l + r)
            }
            return nil

        case .sub:
            if let l = asDecimal(left), let r = asDecimal(right) {
                if case .integer(let li) = left, case .integer(let ri) = right {
                    return .integer(li - ri)
                }
                return .decimal(l - r)
            }
            return nil

        case .mul:
            if let l = asDecimal(left), let r = asDecimal(right) {
                if case .integer(let li) = left, case .integer(let ri) = right {
                    return .integer(li * ri)
                }
                return .decimal(l * r)
            }
            return nil

        case .div:
            if let l = asDecimal(left), let r = asDecimal(right), r != .zero {
                return .decimal(l / r)
            }
            return nil

        case .mod:
            if case .integer(let l) = left, case .integer(let r) = right, r != 0 {
                return .integer(l % r)
            }
            return nil

        case .equal:
            return .bool(left == right)

        case .notEqual:
            return .bool(left != right)

        case .less, .lessOrEqual, .greater, .greaterOrEqual:
            guard let comparison = compare(left, right) else { return nil }
            switch op {
            case .less: return .bool(comparison < 0)
            case .lessOrEqual: return .bool(comparison <= 0)
            case .greater: return .bool(comparison > 0)
            case .greaterOrEqual: return .bool(comparison >= 0)
            default: return nil
            }

        case .inList:
            if case .list(let values) = right {
                return .bool(values.contains(left))
            }
            return nil

        case .notInList:
            if case .list(let values) = right {
                return .bool(!values.contains(left))
            }
            return nil

        case .match, .notMatch, .matches:
            return nil
        }
    }

    private func foldFunction(
        name: String,
        args: [BQLLiteral],
        expectedCount: Int
    ) throws -> BQLLiteral? {
        guard args.count == expectedCount else { return nil }

        switch name.lowercased() {
        case "units", "cost", "weight":
            return args.first
        case "account_sortkey":
            guard args.count == 1, case .string(let account) = args[0] else {
                return nil
            }
            let root = account.split(separator: ":").first.map(String.init) ?? account
            let index: Int
            switch root.lowercased() {
            case "assets":
                index = 0
            case "liabilities":
                index = 1
            case "equity":
                index = 2
            case "income":
                index = 3
            case "expenses":
                index = 4
            default:
                index = 5
            }
            return .string("\(index)-\(account)")
        case "root":
            guard case .string(let account) = args[0] else {
                return nil
            }
            let components = account.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
            let count: Int
            if args.count == 2 {
                guard case .integer(let parsedCount) = args[1] else {
                    return nil
                }
                count = parsedCount
            } else {
                count = 1
            }
            if count >= 0 {
                return .string(components.prefix(count).joined(separator: ":"))
            }
            let suffixToDrop = min(-count, components.count)
            return .string(components.dropLast(suffixToDrop).joined(separator: ":"))
        case "parent":
            guard args.count == 1, case .string(let account) = args[0] else {
                return nil
            }
            if account.isEmpty {
                return .null
            }
            var components = account.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
            _ = components.popLast()
            return .string(components.joined(separator: ":"))
        case "leaf":
            guard args.count == 1, case .string(let account) = args[0] else {
                return nil
            }
            if account.isEmpty {
                return .null
            }
            return .string(account.split(separator: ":", omittingEmptySubsequences: false).last.map(String.init) ?? "")
        case "maxwidth":
            guard args.count == 2,
                  case .string(let text) = args[0],
                  case .integer(let width) = args[1]
            else {
                return nil
            }
            let clipped = String(text.prefix(max(width, 0)))
            return .string(clipped)
        case "upper":
            guard args.count == 1, case .string(let text) = args[0] else {
                return nil
            }
            return .string(text.uppercased())
        case "lower":
            guard args.count == 1, case .string(let text) = args[0] else {
                return nil
            }
            return .string(text.lowercased())
        default:
            return nil
        }
    }

    private func asBool(_ literal: BQLLiteral) -> Bool {
        if case .bool(let value) = literal {
            return value
        }
        return false
    }

    private func asDecimal(_ literal: BQLLiteral) -> Decimal? {
        switch literal {
        case .integer(let value):
            return Decimal(value)
        case .decimal(let value):
            return value
        default:
            return nil
        }
    }

    private func compare(_ left: BQLLiteral, _ right: BQLLiteral) -> Int? {
        if let l = asDecimal(left), let r = asDecimal(right) {
            if l < r { return -1 }
            if l > r { return 1 }
            return 0
        }

        switch (left, right) {
        case (.string(let l), .string(let r)):
            if l < r { return -1 }
            if l > r { return 1 }
            return 0
        case (.date(let l), .date(let r)):
            if l < r { return -1 }
            if l > r { return 1 }
            return 0
        case (.bool(let l), .bool(let r)):
            if l == r { return 0 }
            return l ? 1 : -1
        default:
            return nil
        }
    }
}

private struct NormalizedExpression {
    var expression: BQLExpression
    var type: BQLType
    var constant: BQLLiteral?
}
