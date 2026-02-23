import Foundation
import BeancountSwift

public enum RuntimeValue: Hashable, Sendable {
    case int(Int)
    case decimal(Decimal)
    case amount(Amount)
    case position(Position)
    case inventory(Inventory)
    case string(String)
    case bool(Bool)
    case date(Date)
    case list([RuntimeValue])
    case null
}

public typealias QueryRow = [String: RuntimeValue]

protocol QueryTableProvider: Sendable {
    func rows(for qualifiers: EvalQualifiers?) throws -> [QueryRow]
    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String]
}

extension QueryTableProvider {
    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        let rows = try rows(for: qualifiers)
        return rows
            .reduce(into: Set<String>()) { partialResult, row in
                partialResult.formUnion(row.keys)
            }
            .sorted()
    }
}

public struct QueryContext: Sendable {
    public var tables: [String: [QueryRow]]
    public var priceMap: PriceMap?
    private var providers: [String: any QueryTableProvider]

    public init(tables: [String: [QueryRow]] = [:], priceMap: PriceMap? = nil) {
        self.tables = tables
        self.priceMap = priceMap
        self.providers = [:]
    }

    init(
        tables: [String: [QueryRow]] = [:],
        providers: [String: any QueryTableProvider],
        priceMap: PriceMap? = nil
    ) {
        self.tables = tables
        self.priceMap = priceMap
        self.providers = providers
    }

    func provider(named name: String) -> (any QueryTableProvider)? {
        providers[name]
    }

    func wildcardColumns(table: String, qualifiers: EvalQualifiers?) throws -> [String]? {
        if let provider = providers[table] {
            return try provider.wildcardColumns(for: qualifiers)
        }

        guard let rows = tables[table] else {
            return nil
        }
        return rows
            .reduce(into: Set<String>()) { partialResult, row in
                partialResult.formUnion(row.keys)
            }
            .sorted()
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

enum BQLExecutionError: LocalizedError, Equatable {
    case tableNotFound(String)
    case qualifiersUnsupported(String)
    case unsupportedExpression(String)
    case unsupportedFunction(String)
    case unsupportedOperator
    case invalidType
    case invalidPivotByColumns
    
    var errorDescription: String? {
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
        case .invalidPivotByColumns:
            return "invalid PIVOT BY columns"
        }
    }
}
