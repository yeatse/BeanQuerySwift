import Foundation

indirect enum BQLStatement: Equatable {
    case select(BQLSelectStatement)
    case balances(BQLBalancesStatement)
}

struct BQLSelectStatement: Equatable {
    var distinct: Bool
    var targets: BQLTargetList
    var from: BQLFromClause?
    var `where`: BQLExpression?
    var groupBy: BQLGroupByClause?
    var orderBy: [BQLOrderByItem]?
    var limit: Int?
}

struct BQLBalancesStatement: Equatable {
    var summaryFunction: String?
    var from: BQLFromExpression?
    var `where`: BQLExpression?
}

enum BQLTargetList: Equatable {
    case asterisk
    case values([BQLTarget])
}

struct BQLTarget: Equatable {
    var expression: BQLExpression
    var alias: String?
}

indirect enum BQLFromClause: Equatable {
    case table(BQLTableReference)
    case subselect(BQLSelectStatement)
    case expression(BQLFromExpression)
}

enum BQLTableReference: Equatable {
    case hash(String?)
    case named(String)
}

struct BQLFromExpression: Equatable {
    var expression: BQLExpression?
    var open: Date?
    var close: BQLCloseQualifier?
    var clear: Bool
}

enum BQLCloseQualifier: Equatable {
    case implicit
    case on(Date)
}

struct BQLGroupByClause: Equatable {
    var items: [BQLGroupByItem]
    var having: BQLExpression?
}

enum BQLGroupByItem: Equatable {
    case index(Int)
    case expression(BQLExpression)
}

struct BQLOrderByItem: Equatable {
    var value: BQLOrderByValue
    var ordering: BQLOrdering
}

enum BQLOrderByValue: Equatable {
    case index(Int)
    case expression(BQLExpression)
}

enum BQLOrdering: Equatable {
    case ascending
    case descending
}

enum BQLPlaceholder: Equatable {
    case positional
    case named(String)
}

enum BQLLiteral: Equatable {
    case integer(Int)
    case decimal(Decimal)
    case date(Date)
    case string(String)
    case bool(Bool)
    case null
    case list([BQLLiteral])
}

enum BQLUnaryOperator: Equatable {
    case not
    case neg
    case isNull
    case isNotNull
}

enum BQLBinaryOperator: Equatable {
    case add
    case sub
    case mul
    case div
    case mod
    case less
    case lessOrEqual
    case greater
    case greaterOrEqual
    case equal
    case notEqual
    case inList
    case notInList
    case match
    case notMatch
    case matches
}

enum BQLQuantifier: Equatable {
    case any
    case all
}

indirect enum BQLExpression: Equatable {
    case column(String)
    case function(name: String, args: [BQLExpression])
    case constant(BQLLiteral)
    case placeholder(BQLPlaceholder)
    case unary(BQLUnaryOperator, BQLExpression)
    case binary(BQLBinaryOperator, BQLExpression, BQLExpression)
    case and([BQLExpression])
    case or([BQLExpression])
    case between(BQLExpression, lower: BQLExpression, upper: BQLExpression)
    case anyAll(op: BQLBinaryOperator, quantifier: BQLQuantifier, left: BQLExpression, right: BQLExpression)
    case attribute(BQLExpression, name: String)
    case subscriptExpr(BQLExpression, key: String)
    case select(BQLSelectStatement)
    case asterisk
}

struct BQLASTBuildError: Error, CustomStringConvertible, Equatable {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var description: String {
        message
    }
}
