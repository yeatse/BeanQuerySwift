import Foundation
import Synchronization
import BeancountSwift

public enum RuntimeValue: Hashable, Sendable {
    case int(Int)
    case decimal(Decimal)
    case amount(Amount)
    case position(Position)
    case inventory(Inventory)
    case directive(Directive<Cost>)
    case dict([String: RuntimeValue])
    case structure(name: String, fields: [String: RuntimeValue])
    case string(String)
    case bool(Bool)
    case date(Date)
    case list([RuntimeValue])
    case null

    private static func formatDate(_ date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        let year = parts.year ?? 0
        let month = parts.month ?? 0
        let day = parts.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
    
    public func stringRepresentation(placeholder: String = "") -> String {
        switch self {
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
            let parts = dictionary.keys.sorted().map { key -> String in
                "\(key):\(dictionary[key, default: .null].stringRepresentation(placeholder: placeholder))"
            }
            return "{\(parts.joined(separator: ","))}"
        case .structure(let name, let fields):
            let parts = fields.keys.sorted().map { key -> String in
                "\(key):\(fields[key, default: .null].stringRepresentation(placeholder: placeholder))"
            }
            return "\(name)(\(parts.joined(separator: ", ")))"
        case .string(let text):
            return text
        case .bool(let value):
            return value ? "TRUE" : "FALSE"
        case .date(let date):
            return Self.formatDate(date)
        case .list(let values):
            return values.map { $0.stringRepresentation(placeholder: placeholder) }.joined(separator: ", ")
        case .null:
            return placeholder
        }
    }
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
    case beancountTransaction(BeancountTransactionQueryRow)
    case beancountPrice(BeancountPriceQueryRow)
    case beancountBalance(BeancountBalanceQueryRow)
    case beancountNote(BeancountNoteQueryRow)
    case beancountEvent(BeancountEventQueryRow)

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
        case .beancountTransaction(let row):
            return row.value(for: column)
        case .beancountPrice(let row):
            return row.value(for: column)
        case .beancountBalance(let row):
            return row.value(for: column)
        case .beancountNote(let row):
            return row.value(for: column)
        case .beancountEvent(let row):
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
        case .beancountTransaction:
            return BeancountTransactionQueryRow.wildcardColumns
        case .beancountPrice:
            return BeancountPriceQueryRow.wildcardColumns
        case .beancountBalance:
            return BeancountBalanceQueryRow.wildcardColumns
        case .beancountNote:
            return BeancountNoteQueryRow.wildcardColumns
        case .beancountEvent:
            return BeancountEventQueryRow.wildcardColumns
        }
    }
}

final class LazyResolver<T: Sendable>: Sendable {
    private struct State {
        var cached: T?
        var build: (@Sendable () -> T)?
    }

    private let state: Mutex<State>

    init(eager value: T) {
        self.state = Mutex(State(cached: value, build: nil))
    }

    init(_ build: @escaping @Sendable () -> T) {
        self.state = Mutex(State(cached: nil, build: build))
    }

    var value: T {
        state.withLock { state in
            if let cached = state.cached { return cached }
            let produced = state.build!()
            state.cached = produced
            state.build = nil
            return produced
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
    private var priceMapResolver: LazyResolver<PriceMap?>
    private var providers: [String: any QueryTableProvider]

    public var priceMap: PriceMap? {
        get { priceMapResolver.value }
        set { priceMapResolver = LazyResolver(eager: newValue) }
    }

    public init(tables: [String: [QueryRow]] = [:], priceMap: PriceMap? = nil) {
        self.tables = tables
        self.priceMapResolver = LazyResolver(eager: priceMap)
        self.providers = [:]
    }

    init(
        tables: [String: [QueryRow]] = [:],
        providers: [String: any QueryTableProvider],
        priceMap: PriceMap? = nil
    ) {
        self.tables = tables
        self.priceMapResolver = LazyResolver(eager: priceMap)
        self.providers = providers
    }

    init(
        tables: [String: [QueryRow]] = [:],
        providers: [String: any QueryTableProvider],
        priceMapResolver: LazyResolver<PriceMap?>
    ) {
        self.tables = tables
        self.priceMapResolver = priceMapResolver
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
