import Foundation

public enum RuntimeValue: Hashable, Sendable {
    case int(Int)
    case decimal(Decimal)
    case string(String)
    case bool(Bool)
    case date(Date)
    case list([RuntimeValue])
    case null
}

public typealias QueryRow = [String: RuntimeValue]

protocol QueryTableProvider: Sendable {
    func rows(for qualifiers: EvalQualifiers?) throws -> [QueryRow]
}

public struct QueryContext: Sendable {
    public var tables: [String: [QueryRow]]
    private var providers: [String: any QueryTableProvider]

    public init(tables: [String: [QueryRow]] = [:]) {
        self.tables = tables
        self.providers = [:]
    }

    init(tables: [String: [QueryRow]] = [:], providers: [String: any QueryTableProvider]) {
        self.tables = tables
        self.providers = providers
    }

    func provider(named name: String) -> (any QueryTableProvider)? {
        providers[name]
    }
}

public struct QueryResult: Equatable, Sendable {
    public var columns: [String]
    public var rows: [[RuntimeValue]]

    public init(columns: [String], rows: [[RuntimeValue]]) {
        self.columns = columns
        self.rows = rows
    }
}

enum BQLExecutionError: Error, Equatable, CustomStringConvertible {
    case tableNotFound(String)
    case qualifiersUnsupported(String)
    case unsupportedExpression(String)
    case unsupportedFunction(String)
    case unsupportedOperator
    case invalidType

    var description: String {
        switch self {
        case .tableNotFound(let name):
            return "table not found: \(name)"
        case .qualifiersUnsupported(let table):
            return "FROM qualifiers are unsupported for table: \(table)"
        case .unsupportedExpression(let expression):
            return "unsupported expression: \(expression)"
        case .unsupportedFunction(let function):
            return "unsupported function: \(function)"
        case .unsupportedOperator:
            return "unsupported operator"
        case .invalidType:
            return "invalid runtime type"
        }
    }
}
