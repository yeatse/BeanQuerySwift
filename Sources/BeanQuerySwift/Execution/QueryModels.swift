import Foundation
import BeancountSwift

public enum RuntimeValue: Hashable, Sendable {
    case int(Int)
    case decimal(Decimal)
    case amount(Amount)
    case position(Position)
    case inventory(Inventory)
    case directive(Directive<Cost>)
    case dict([String: RuntimeValue])
    case string(String)
    case bool(Bool)
    case date(Date)
    case list([RuntimeValue])
    case null
}

public struct QueryRow: ExpressibleByDictionaryLiteral, Sendable {
    let storage: QueryRowStorage

    public init(dictionaryLiteral elements: (String, RuntimeValue)...) {
        self.storage = .dictionary(Dictionary(uniqueKeysWithValues: elements))
    }

    init(storage: QueryRowStorage) {
        self.storage = storage
    }

    init(_ values: [String: RuntimeValue]) {
        self.storage = .dictionary(values)
    }

    subscript(_ column: String) -> RuntimeValue? {
        storage.value(for: column)
    }

    var columnNames: [String] {
        storage.columnNames
    }

    func overlaying(_ overrides: [String: RuntimeValue]) -> QueryRow {
        guard !overrides.isEmpty else {
            return self
        }
        return QueryRow(storage: .overlay(base: self, overrides: overrides))
    }
}

struct QueryRowSequence: Sequence {
    private let makeIteratorImpl: () -> AnyIterator<QueryRow>

    init(makeIterator: @escaping () -> AnyIterator<QueryRow>) {
        self.makeIteratorImpl = makeIterator
    }

    init<S>(_ base: S) where S: Sequence, S.Element == QueryRow {
        self.makeIteratorImpl = {
            var iterator = base.makeIterator()
            return AnyIterator {
                iterator.next()
            }
        }
    }

    func makeIterator() -> AnyIterator<QueryRow> {
        makeIteratorImpl()
    }
}

indirect enum QueryRowStorage: Sendable {
    case dictionary([String: RuntimeValue])
    case overlay(base: QueryRow, overrides: [String: RuntimeValue])
    case beancountPosting(BeancountPostingQueryRow)
    case beancountEntry(BeancountEntryQueryRow)
    case beancountAccount(BeancountAccountQueryRow)

    func value(for column: String) -> RuntimeValue? {
        switch self {
        case .dictionary(let values):
            return values[column]
        case .overlay(let base, let overrides):
            return overrides[column] ?? base[column]
        case .beancountPosting(let row):
            return row.value(for: column)
        case .beancountEntry(let row):
            return row.value(for: column)
        case .beancountAccount(let row):
            return row.value(for: column)
        }
    }

    var columnNames: [String] {
        switch self {
        case .dictionary(let values):
            return Array(values.keys)
        case .overlay(let base, let overrides):
            return Array(Set(base.columnNames).union(overrides.keys))
        case .beancountPosting:
            return BeancountPostingQueryRow.wildcardColumns
        case .beancountEntry:
            return BeancountEntryQueryRow.wildcardColumns
        case .beancountAccount:
            return BeancountAccountQueryRow.wildcardColumns
        }
    }
}

protocol QueryTableProvider: Sendable {
    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence
    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String]
}

extension QueryTableProvider {
    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        try rows(for: qualifiers)
            .reduce(into: Set<String>()) { partialResult, row in
                partialResult.formUnion(row.columnNames)
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
                partialResult.formUnion(row.columnNames)
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
