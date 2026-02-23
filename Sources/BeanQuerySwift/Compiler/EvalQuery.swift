import Foundation

public indirect enum BQLParameterValue: Equatable, Sendable {
    case integer(Int)
    case decimal(Decimal)
    case date(Date)
    case string(String)
    case bool(Bool)
    case null
    case list([BQLParameterValue])
}

public enum BQLParameters: Equatable, Sendable {
    case positional([BQLParameterValue])
    case named([String: BQLParameterValue])
}

enum EvalOrdering: Equatable {
    case ascending
    case descending
}

struct EvalOrderSpec: Equatable {
    var index: Int
    var ordering: EvalOrdering
}

struct EvalTarget: Equatable {
    var expression: BQLExpression
    var name: String?
    var isAggregate: Bool
}

struct EvalSource: Equatable {
    var table: EvalTableReference
    var qualifiers: EvalQualifiers?
}

indirect enum EvalTableReference: Equatable {
    case named(String)
    case hash(String?)
    case subquery(EvalQuery)
}

struct EvalQualifiers: Equatable {
    var open: Date?
    var close: BQLCloseQualifier?
    var clear: Bool
}

public struct EvalQuery: Equatable {
    var source: EvalSource
    var targets: [EvalTarget]
    var filter: BQLExpression?
    var groupIndexes: [Int]?
    var havingIndex: Int?
    var orderSpec: [EvalOrderSpec]?
    var pivotIndexes: [Int]?
    var limit: Int?
    var distinct: Bool

    var visibleTargets: [EvalTarget] {
        targets.filter { $0.name != nil }
    }
}

enum BQLCompileError: LocalizedError, Equatable {
    case unsupportedStatement(String)
    case invalidGroupByIndex(Int)
    case invalidOrderByIndex(Int)
    case namedParametersRequired
    case positionalParametersRequired
    case queryParameterMissing([String])
    case placeholderCountMismatch(expected: Int, actual: Int)
    case mixedPlaceholderStyles
    case invalidFunctionSignature(name: String, argTypes: [BQLType])
    case invalidUnaryOperator(op: BQLUnaryOperator, operand: BQLType)
    case invalidBinaryOperator(op: BQLBinaryOperator, left: BQLType, right: BQLType)
    case aggregatesNotAllowedInFrom
    case aggregatesNotAllowedInWhere
    case mixedAggregatesAndNonAggregates
    case aggregatesOfAggregates
    case groupByContainsAggregate
    case groupByReferencesAggregate
    case havingMustBeAggregate
    case aggregateWithoutGroupBy
    case missingGroupByTargets([String])
    case closeDateMustFollowOpenDate
    case invalidFromClause
    case invalidPivotByIndex(Int)
    case pivotByColumnNotInTargets(String)
    case pivotByColumnsMustDiffer
    case pivotBySecondMustBeGroupByColumn
    case invalidPivotByClause
    
    var errorDescription: String? {
        switch self {
        case .unsupportedStatement(let statement):
            return "unsupported statement: \(statement)"
        case .invalidGroupByIndex(let index):
            return "invalid GROUP BY index: \(index)"
        case .invalidOrderByIndex(let index):
            return "invalid ORDER BY index: \(index)"
        case .namedParametersRequired:
            return "query parameters should be a mapping when using named placeholders"
        case .positionalParametersRequired:
            return "query parameters should be a sequence when using positional placeholders"
        case .queryParameterMissing(let names):
            return "query parameter missing: \(names.joined(separator: ", "))"
        case .placeholderCountMismatch(let expected, let actual):
            return "the query has \(expected) placeholders but \(actual) parameters were passed"
        case .mixedPlaceholderStyles:
            return "positional and named parameters cannot be mixed"
        case .invalidFunctionSignature(let name, let argTypes):
            let rendered = argTypes.map(\.description).joined(separator: ", ")
            return "invalid function signature: \(name)(\(rendered))"
        case .invalidUnaryOperator(let op, let operand):
            return "invalid unary operator: \(op) \(operand)"
        case .invalidBinaryOperator(let op, let left, let right):
            return "invalid binary operator: \(left) \(op) \(right)"
        case .aggregatesNotAllowedInFrom:
            return "aggregates are not allowed in FROM clause"
        case .aggregatesNotAllowedInWhere:
            return "aggregates are not allowed in WHERE clause"
        case .mixedAggregatesAndNonAggregates:
            return "mixed aggregates and non-aggregates are not allowed"
        case .aggregatesOfAggregates:
            return "aggregates of aggregates are not allowed"
        case .groupByContainsAggregate:
            return "GROUP BY expressions may not be aggregates"
        case .groupByReferencesAggregate:
            return "GROUP BY references an aggregate target"
        case .havingMustBeAggregate:
            return "HAVING clause must be aggregate"
        case .aggregateWithoutGroupBy:
            return "aggregate query without GROUP BY may only contain aggregates"
        case .missingGroupByTargets(let names):
            return "non-aggregate targets missing from GROUP BY: \(names.joined(separator: ", "))"
        case .closeDateMustFollowOpenDate:
            return "CLOSE date must follow OPEN date"
        case .invalidFromClause:
            return "invalid FROM clause"
        case .invalidPivotByIndex(let index):
            return "invalid PIVOT BY column index: \(index)"
        case .pivotByColumnNotInTargets(let column):
            return "PIVOT BY column '\(column)' is not in the targets list"
        case .pivotByColumnsMustDiffer:
            return "the two PIVOT BY columns cannot be the same column"
        case .pivotBySecondMustBeGroupByColumn:
            return "the second PIVOT BY column must be a GROUP BY column"
        case .invalidPivotByClause:
            return "invalid PIVOT BY clause"
        }
    }
}

struct BQLCompilerOptions: Equatable {
    var defaultTableName: String = "postings"
    var supportImplicitGroupBy: Bool = true
}
