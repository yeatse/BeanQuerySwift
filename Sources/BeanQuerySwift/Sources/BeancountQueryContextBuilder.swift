import Foundation
import Synchronization
import BeancountSwift

public enum BeancountQueryContextBuilder {
    public static func makeContext(from ledger: ParsedLedger<Cost>) -> QueryContext {
        makeContext(
            directives: ledger.directives,
            summarizeConfig: .from(options: ledger.options)
        )
    }

    public static func makeContext(directives: [Directive<Cost>]) -> QueryContext {
        makeContext(
            directives: directives,
            summarizeConfig: .from(options: nil)
        )
    }

    private static func makeContext(
        directives: [Directive<Cost>],
        summarizeConfig: BeancountSummarizeConfig
    ) -> QueryContext {
        let sortedDirectives = directives.sorted()
        let staticRows = LazyResolver<(accounts: [QueryRow], commodities: [QueryRow])> {
            buildStaticRows(directives: sortedDirectives)
        }
        let postingsProvider = BeancountPostingsTableProvider(
            directives: sortedDirectives,
            summarizeConfig: summarizeConfig
        )
        let entriesProvider = BeancountEntriesTableProvider(
            directives: sortedDirectives,
            summarizeConfig: summarizeConfig
        )

        return QueryContext(
            tables: [:],
            providers: [
                "postings": postingsProvider,
                "entries": entriesProvider,
                "transactions": BeancountTransactionsTableProvider(directives: sortedDirectives),
                "prices": BeancountPricesTableProvider(directives: sortedDirectives),
                "balances": BeancountBalancesTableProvider(directives: sortedDirectives),
                "notes": BeancountNotesTableProvider(directives: sortedDirectives),
                "events": BeancountEventsTableProvider(directives: sortedDirectives),
                "documents": BeancountDocumentsTableProvider(directives: sortedDirectives),
                "custom": BeancountCustomTableProvider(directives: sortedDirectives),
                "accounts": BeancountAccountsTableProvider(staticRows: staticRows),
                "commodities": BeancountCommoditiesTableProvider(staticRows: staticRows),
            ],
            priceMapResolver: LazyResolver { PriceMap.build(from: sortedDirectives) }
        )
    }

    fileprivate static func postingsRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var directiveIndex = 0
            var postingIndex = 0
            var rowID = 0
            var currentDirectiveContext: PostingDirectiveContext?
            // One accumulator per iteration, so re-running a query starts from zero.
            let ids = DirectiveIDCache()
            let balances = PostingBalanceAccumulator()
            let calendar = Calendar(identifier: .gregorian)
            let dateComponents: Set<Calendar.Component> = [.year, .month, .day]

            return AnyIterator {
                while directiveIndex < directives.count {
                    if currentDirectiveContext == nil {
                        let directive = directives[directiveIndex]
                        guard case .transaction(let transaction) = directive.content else {
                            directiveIndex += 1
                            continue
                        }

                        let components = calendar.dateComponents(dateComponents, from: directive.date)
                        currentDirectiveContext = PostingDirectiveContext(
                            directive: directive,
                            transaction: transaction,
                            directiveIndex: directiveIndex,
                            year: components.year ?? 0,
                            month: components.month ?? 0,
                            day: components.day ?? 0
                        )
                        postingIndex = 0
                    }

                    guard let directiveContext = currentDirectiveContext else {
                        continue
                    }

                    if postingIndex < directiveContext.transaction.postings.count {
                        let currentPostingIndex = postingIndex
                        let posting = directiveContext.transaction.postings[postingIndex]
                        postingIndex += 1
                        rowID += 1
                        return QueryRow(
                            storage: .beancountPosting(
                                BeancountPostingQueryRow(
                                    directive: directiveContext.directive,
                                    transaction: directiveContext.transaction,
                                    directiveIndex: directiveContext.directiveIndex,
                                    rowID: rowID,
                                    date: directiveContext.directive.date,
                                    year: directiveContext.year,
                                    month: directiveContext.month,
                                    day: directiveContext.day,
                                    posting: posting,
                                    postingIndex: currentPostingIndex,
                                    ids: ids,
                                    balances: balances
                                )
                            )
                        )
                    }

                    currentDirectiveContext = nil
                    directiveIndex += 1
                }

                return nil
            }
        })
    }

    fileprivate static func entriesRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            let ids = DirectiveIDCache()
            let calendar = Calendar(identifier: .gregorian)
            let dateComponents: Set<Calendar.Component> = [.year, .month, .day]

            return AnyIterator {
                guard index < directives.count else {
                    return nil
                }

                let directive = directives[index]
                defer { index += 1 }

                let components = calendar.dateComponents(dateComponents, from: directive.date)
                return QueryRow(
                    storage: .beancountEntry(
                        BeancountEntryQueryRow(
                            directive: directive,
                            directiveIndex: index,
                            ids: ids,
                            date: directive.date,
                            year: components.year ?? 0,
                            month: components.month ?? 0,
                            day: components.day ?? 0
                        )
                    )
                )
            }
        })
    }

    fileprivate static func transactionsRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .transaction(let transaction) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountTransaction(
                        BeancountTransactionQueryRow(
                            date: directive.date,
                            transaction: transaction,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func pricesRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .price(let price) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountPrice(
                        BeancountPriceQueryRow(
                            date: directive.date,
                            price: price,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func balancesRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .balance(let balance) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountBalance(
                        BeancountBalanceQueryRow(
                            date: directive.date,
                            balance: balance,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func notesRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .note(let note) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountNote(
                        BeancountNoteQueryRow(
                            date: directive.date,
                            note: note,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func documentsRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .document(let document) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountDocument(
                        BeancountDocumentQueryRow(
                            date: directive.date,
                            document: document,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func eventsRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .event(let event) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountEvent(
                        BeancountEventQueryRow(
                            date: directive.date,
                            event: event,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func customRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var index = 0
            return AnyIterator {
                while index < directives.count {
                    let directive = directives[index]
                    index += 1
                    guard case .custom(let custom) = directive.content else {
                        continue
                    }
                    return QueryRow(storage: .beancountCustom(
                        BeancountCustomQueryRow(
                            date: directive.date,
                            custom: custom,
                            meta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                    ))
                }
                return nil
            }
        })
    }

    fileprivate static func buildStaticRows(directives: [Directive<Cost>]) -> (accounts: [QueryRow], commodities: [QueryRow]) {
        var openStructByAccount: [String: RuntimeValue] = [:]
        var openDateByAccount: [String: Date] = [:]
        var closeStructByAccount: [String: RuntimeValue] = [:]
        var closeDateByAccount: [String: Date] = [:]
        var metaByCommodity: [String: RuntimeValue] = [:]
        var dateByCommodity: [String: Date] = [:]

        for directive in directives {
            switch directive.content {
            case .open(let open):
                let account = open.account.id
                let isEarlier = openDateByAccount[account].map { directive.date < $0 } ?? true
                if isEarlier {
                    openDateByAccount[account] = directive.date
                    openStructByAccount[account] = openStructure(
                        directive: directive,
                        open: open
                    )
                }
            case .close(let close):
                let account = close.account.id
                let isEarlier = closeDateByAccount[account].map { directive.date < $0 } ?? true
                if isEarlier {
                    closeDateByAccount[account] = directive.date
                    closeStructByAccount[account] = closeStructure(
                        directive: directive,
                        close: close
                    )
                }
            case .commodity(let commodity):
                let name = commodity.currency.id
                metaByCommodity[name] = .dict(runtimeMetaDictionary(from: directive.meta))
                dateByCommodity[name] = directive.date
            default:
                break
            }
        }

        let accounts = Set(openStructByAccount.keys).union(closeStructByAccount.keys).sorted().map { account in
            QueryRow(
                storage: .beancountAccount(
                    BeancountAccountQueryRow(
                        account: account,
                        open: openStructByAccount[account] ?? .null,
                        close: closeStructByAccount[account] ?? .null,
                        type: .string(accountTypeName(account))
                    )
                )
            )
        }
        let commodities = metaByCommodity.keys.sorted().map { commodity in
            QueryRow([
                "name": .string(commodity),
                "date": dateByCommodity[commodity].map(RuntimeValue.date) ?? .null,
                "meta": metaByCommodity[commodity] ?? .null,
            ])
        }

        return (accounts: accounts, commodities: commodities)
    }

    private static func openStructure(directive: Directive<Cost>, open: Open) -> RuntimeValue {
        var fields: [String: RuntimeValue] = [
            "account": .string(open.account.id),
            "date": .date(directive.date),
            "meta": .dict(runtimeMetaDictionary(from: directive.meta)),
            "currencies": .list(open.currencies.map { .string($0.id) }),
        ]
        if let booking = open.booking {
            fields["booking"] = .string(String(describing: booking))
        } else {
            fields["booking"] = .null
        }
        return .structure(name: "Open", fields: fields)
    }

    private static func closeStructure(directive: Directive<Cost>, close: Close) -> RuntimeValue {
        let fields: [String: RuntimeValue] = [
            "account": .string(close.account.id),
            "date": .date(directive.date),
            "meta": .dict(runtimeMetaDictionary(from: directive.meta)),
        ]
        return .structure(name: "Close", fields: fields)
    }

    fileprivate static func entryTypeName(_ content: DirectiveContent<Cost>) -> String {
        switch content {
        case .open: return "open"
        case .close: return "close"
        case .commodity: return "commodity"
        case .pad: return "pad"
        case .balance: return "balance"
        case .transaction: return "transaction"
        case .note: return "note"
        case .event: return "event"
        case .query: return "query"
        case .price: return "price"
        case .document: return "document"
        case .custom: return "custom"
        }
    }

    fileprivate static func accountTypeName(_ account: String) -> String {
        let root = account.split(separator: ":").first.map(String.init) ?? account
        return root.lowercased()
    }

    fileprivate static func descriptionValue(payee: String?, narration: String?) -> RuntimeValue {
        let parts = [payee, narration].compactMap { value -> String? in
            guard let value, !value.isEmpty else {
                return nil
            }
            return value
        }
        return .string(parts.joined(separator: " | "))
    }

    fileprivate static func runtimeMetaDictionary(from metadata: MetaData) -> [String: RuntimeValue] {
        var result: [String: RuntimeValue] = [:]
        for (key, value) in metadata {
            result[key] = runtimeMetaValue(value)
        }
        return result
    }

    fileprivate static func runtimeMetaValue(_ value: MetaDataValue) -> RuntimeValue {
        switch value {
        case .string(let string):
            return .string(string)
        case .account(let account):
            return .string(account.id)
        case .currency(let currency):
            return .string(currency.id)
        case .date(let date):
            return .date(date)
        case .tag(let tag):
            return .string(tag.id)
        case .number(let number):
            return exactInt(from: number).map(RuntimeValue.int) ?? .decimal(number)
        case .bool(let bool):
            return .bool(bool)
        case .amount(let amount):
            return .amount(amount)
        case .range(let range):
            return .string(String(describing: range))
        }
    }

    fileprivate static func exactInt(from decimal: Decimal) -> Int? {
        var value = decimal
        var rounded = Decimal()
        NSDecimalRound(&rounded, &value, 0, .plain)
        guard rounded == decimal else {
            return nil
        }

        let intValue = NSDecimalNumber(decimal: decimal).intValue
        return Decimal(intValue) == decimal ? intValue : nil
    }
}

private struct PostingDirectiveContext {
    let directive: Directive<Cost>
    let transaction: Transaction<Cost>
    let directiveIndex: Int
    let year: Int
    let month: Int
    let day: Int
}

/// Process-stable string identity for a directive, backing the `id` column.
///
/// beancount derives `id` from the directive's contents (an md5 over its
/// fields, metadata included), so the same directive keeps the same id no
/// matter which query or `FROM` qualifier produced the row. We only need that
/// stability within one process, which lets us use Swift's seeded `Hashable`
/// instead of a cryptographic digest: same value for the same directive within
/// a run, different between runs.
///
/// Hashing a directive walks its whole contents (~3µs for a transaction), so
/// the column is computed on read — never during row construction — and
/// memoized for the directive currently being scanned. That last part matters
/// for `postings`, where every posting of a transaction reports its parent's
/// id and rows arrive grouped by directive.
final class DirectiveIDCache: Sendable {
    private struct Memo {
        var index = -1
        var id = ""
    }

    private let memo = Mutex(Memo())

    func id(index: Int, of directive: @autoclosure () -> Directive<Cost>) -> String {
        memo.withLock { memo in
            if index == memo.index {
                return memo.id
            }
            let digits = String(UInt(bitPattern: directive().hashValue), radix: 16)
            memo.id = String(repeating: "0", count: max(0, 16 - digits.count)) + digits
            memo.index = index
            return memo.id
        }
    }
}

/// Running inventory backing the `balance` column of the `postings` table.
///
/// Beancount computes `balance` lazily: a single inventory accumulates over the
/// rows that actually reach the column, in scan order, so filtered-out rows do
/// not contribute. Repeated reads of the same row must not advance it, which is
/// what `lastRowID` guards — the same one-entry cache beanquery keys on its row
/// id (`sources/beancount.py`, `@cache(maxsize=1)` on `balance`).
final class PostingBalanceAccumulator: Sendable {
    private struct State {
        var running = Inventory()
        var lastRowID = 0
        var cached: RuntimeValue = .inventory(Inventory())
    }

    private let state = Mutex(State())

    func value(rowID: Int, posting: Posting<Cost>) -> RuntimeValue {
        state.withLock { state in
            if rowID == state.lastRowID {
                return state.cached
            }
            _ = state.running.addAmount(posting.units, cost: posting.cost)
            state.lastRowID = rowID
            state.cached = .inventory(state.running)
            return state.cached
        }
    }
}

struct BeancountPostingQueryRow: Sendable {
    let directive: Directive<Cost>
    let transaction: Transaction<Cost>
    let directiveIndex: Int
    let rowID: Int
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let posting: Posting<Cost>
    let postingIndex: Int
    let ids: DirectiveIDCache
    let balances: PostingBalanceAccumulator

    static let wildcardColumns = [
        "date",
        "flag",
        "payee",
        "narration",
        "position",
    ]

    private static let accessors: [String: @Sendable (BeancountPostingQueryRow) -> RuntimeValue] = [
        "account": { .string($0.posting.account.id) },
        "accounts": { .list($0.transaction.postings.map { .string($0.account.id) }) },
        "balance": { $0.balances.value(rowID: $0.rowID, posting: $0.posting) },
        "cost_currency": { row in
            row.posting.cost.map { .string($0.currency.id) } ?? .null
        },
        "cost_date": { row in
            row.posting.cost?.date.map(RuntimeValue.date) ?? .null
        },
        "cost_label": { row in
            row.posting.cost?.label.map(RuntimeValue.string) ?? .string("")
        },
        "cost_number": { row in
            row.posting.cost.map { .decimal($0.number) } ?? .null
        },
        "currency": { .string($0.posting.units.currency.id) },
        "date": { .date($0.date) },
        "day": { .int($0.day) },
        "description": { row in
            BeancountQueryContextBuilder.descriptionValue(
                payee: row.transaction.payee,
                narration: row.transaction.narration
            )
        },
        "entry": { .directive($0.directive) },
        "entry_meta": { .dict(BeancountQueryContextBuilder.runtimeMetaDictionary(from: $0.directive.meta)) },
        "filename": { row in
            (row.posting.meta?.filename ?? row.directive.meta.filename).map(RuntimeValue.string) ?? .null
        },
        "flag": { $0.transaction.flag.map { .string(String($0)) } ?? .null },
        "id": { .string($0.ids.id(index: $0.directiveIndex, of: $0.directive)) },
        "lineno": { row in
            (row.posting.meta?.lineno ?? row.directive.meta.lineno).map { .int(Int($0)) } ?? .null
        },
        "links": { runtimeStringListValue($0.transaction.links.map(\.id)) },
        "location": { row in
            let meta = row.posting.meta ?? row.directive.meta
            guard let filename = meta.filename, let lineno = meta.lineno else { return .null }
            return .string("\(filename):\(lineno):")
        },
        "meta": { $0.posting.meta.map { .dict(BeancountQueryContextBuilder.runtimeMetaDictionary(from: $0)) } ?? .null },
        "month": { .int($0.month) },
        "narration": { $0.transaction.narration.map(RuntimeValue.string) ?? .null },
        "number": { .decimal($0.posting.units.number) },
        "other_accounts": { row in
            otherAccountsValue(in: row.transaction, excludingPostingAt: row.postingIndex)
        },
        "payee": { $0.transaction.payee.map(RuntimeValue.string) ?? .null },
        "posting_flag": { $0.posting.flag.map { .string(String($0)) } ?? .null },
        "position": { .position(Position(posting: $0.posting)) },
        "price": { $0.posting.price.map(RuntimeValue.amount) ?? .null },
        "tags": { runtimeStringListValue($0.transaction.tags.map(\.id)) },
        "type": { _ in .string("transaction") },
        "weight": { .amount($0.posting.weight) },
        "year": { .int($0.year) },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountEntryQueryRow: Sendable {
    let directive: Directive<Cost>
    let directiveIndex: Int
    let ids: DirectiveIDCache
    let date: Date
    let year: Int
    let month: Int
    let day: Int

    static let wildcardColumns = [
        "id",
        "type",
        "filename",
        "lineno",
        "date",
        "year",
        "month",
        "day",
        "flag",
        "payee",
        "narration",
        "description",
        "tags",
        "links",
        "meta",
        "accounts",
    ]

    private static let accessors: [String: @Sendable (BeancountEntryQueryRow) -> RuntimeValue] = [
        "account": { accountValue(for: $0.directive) },
        "accounts": { accountsValue(for: $0.directive) },
        "date": { .date($0.date) },
        "day": { .int($0.day) },
        "description": { entryDescriptionValue(for: $0.directive) },
        "entry": { .directive($0.directive) },
        "entry_meta": { .dict(BeancountQueryContextBuilder.runtimeMetaDictionary(from: $0.directive.meta)) },
        "filename": { $0.directive.meta.filename.map(RuntimeValue.string) ?? .null },
        "flag": { flagValue(for: $0.directive) },
        "id": { .string($0.ids.id(index: $0.directiveIndex, of: $0.directive)) },
        "lineno": { $0.directive.meta.lineno.map { .int(Int($0)) } ?? .null },
        "links": { linksValue(for: $0.directive) },
        "meta": { .dict(BeancountQueryContextBuilder.runtimeMetaDictionary(from: $0.directive.meta)) },
        "month": { .int($0.month) },
        "narration": { narrationValue(for: $0.directive) },
        "payee": { payeeValue(for: $0.directive) },
        "tags": { tagsValue(for: $0.directive) },
        "type": { .string(BeancountQueryContextBuilder.entryTypeName($0.directive.content)) },
        "year": { .int($0.year) },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountAccountQueryRow: Sendable {
    let account: String
    let open: RuntimeValue
    let close: RuntimeValue
    let type: RuntimeValue

    static let wildcardColumns = [
        "account",
        "open",
        "close",
    ]

    private static let accessors: [String: @Sendable (BeancountAccountQueryRow) -> RuntimeValue] = [
        "account": { .string($0.account) },
        "close": { $0.close },
        "open": { $0.open },
        "type": { $0.type },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

private func flagValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return transaction.flag.map { .string(String($0)) } ?? .null
}

private func payeeValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return transaction.payee.map(RuntimeValue.string) ?? .null
}

private func narrationValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return transaction.narration.map(RuntimeValue.string) ?? .null
}

private func entryDescriptionValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return BeancountQueryContextBuilder.descriptionValue(
        payee: transaction.payee,
        narration: transaction.narration
    )
}

private func tagsValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return runtimeStringListValue(transaction.tags.map(\.id))
}

private func linksValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return runtimeStringListValue(transaction.links.map(\.id))
}

private func accountValue(for directive: Directive<Cost>) -> RuntimeValue {
    switch directive.content {
    case .open(let open):
        return .string(open.account.id)
    case .close(let close):
        return .string(close.account.id)
    case .balance(let balance):
        return .string(balance.account.id)
    case .note(let note):
        return .string(note.account.id)
    case .document(let document):
        return .string(document.account.id)
    case .pad(let pad):
        return .string(pad.account.id)
    case .commodity, .event, .price, .query, .custom, .transaction:
        return .null
    }
}

private func accountsValue(for directive: Directive<Cost>) -> RuntimeValue {
    guard case .transaction(let transaction) = directive.content else {
        return .null
    }
    return .list(transaction.postings.map { .string($0.account.id) })
}

private func otherAccountsValue(
    in transaction: Transaction<Cost>,
    excludingPostingAt index: Int
) -> RuntimeValue {
    let accounts = transaction.postings.enumerated().compactMap { offset, posting in
        offset == index ? nil : posting.account.id
    }
    return runtimeStringListValue(accounts)
}

private func runtimeStringListValue<S>(_ values: S) -> RuntimeValue
where S: Sequence, S.Element == String {
    .list(Array(Set(values)).sorted().map(RuntimeValue.string))
}

struct BeancountTransactionQueryRow: Sendable {
    let date: Date
    let transaction: Transaction<Cost>
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "flag",
        "payee",
        "narration",
        "tags",
        "links",
        "accounts",
    ]

    private static let accessors: [String: @Sendable (BeancountTransactionQueryRow) -> RuntimeValue] = [
        "accounts": { row in
            .list(row.transaction.postings.map { .string($0.account.id) })
        },
        "date": { .date($0.date) },
        "flag": { row in
            row.transaction.flag.map { .string(String($0)) } ?? .null
        },
        "links": { row in
            runtimeStringListValue(row.transaction.links.map(\.id))
        },
        "meta": { $0.meta },
        "narration": { row in
            row.transaction.narration.map(RuntimeValue.string) ?? .null
        },
        "payee": { row in
            row.transaction.payee.map(RuntimeValue.string) ?? .null
        },
        "tags": { row in
            runtimeStringListValue(row.transaction.tags.map(\.id))
        },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountPriceQueryRow: Sendable {
    let date: Date
    let price: Price
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "currency",
        "amount",
    ]

    private static let accessors: [String: @Sendable (BeancountPriceQueryRow) -> RuntimeValue] = [
        "amount": { .amount($0.price.amount) },
        "currency": { .string($0.price.currency.id) },
        "date": { .date($0.date) },
        "meta": { $0.meta },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountBalanceQueryRow: Sendable {
    let date: Date
    let balance: Balance
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "account",
        "amount",
        "tolerance",
        "discrepancy",
    ]

    private static let accessors: [String: @Sendable (BeancountBalanceQueryRow) -> RuntimeValue] = [
        "account": { .string($0.balance.account.id) },
        "amount": { .amount($0.balance.amount) },
        "date": { .date($0.date) },
        "discrepancy": { row in
            row.balance.diffAmount.map(RuntimeValue.amount) ?? .null
        },
        "meta": { $0.meta },
        "tolerance": { row in
            row.balance.tolerance.map(RuntimeValue.decimal) ?? .null
        },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountNoteQueryRow: Sendable {
    let date: Date
    let note: Note
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "account",
        "comment",
        "tags",
        "links",
    ]

    private static let accessors: [String: @Sendable (BeancountNoteQueryRow) -> RuntimeValue] = [
        "account": { .string($0.note.account.id) },
        "comment": { .string($0.note.note) },
        "date": { .date($0.date) },
        "links": { _ in .list([]) },
        "meta": { $0.meta },
        "tags": { _ in .list([]) },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountEventQueryRow: Sendable {
    let date: Date
    let event: Event
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "type",
        "description",
    ]

    private static let accessors: [String: @Sendable (BeancountEventQueryRow) -> RuntimeValue] = [
        "date": { .date($0.date) },
        "description": { .string($0.event.description) },
        "meta": { $0.meta },
        "type": { .string($0.event.type) },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountDocumentQueryRow: Sendable {
    let date: Date
    let document: Document
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "account",
        "filename",
        "tags",
        "links",
    ]

    private static let accessors: [String: @Sendable (BeancountDocumentQueryRow) -> RuntimeValue] = [
        "account": { .string($0.document.account.id) },
        "date": { .date($0.date) },
        "filename": { .string($0.document.filename) },
        "links": { row in
            runtimeStringListValue((row.document.links ?? []).map(\.id))
        },
        "meta": { $0.meta },
        "tags": { row in
            runtimeStringListValue((row.document.tags ?? []).map(\.id))
        },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountCustomQueryRow: Sendable {
    let date: Date
    let custom: Custom
    let meta: RuntimeValue

    static let wildcardColumns = [
        "date",
        "type",
        "values",
    ]

    private static let accessors: [String: @Sendable (BeancountCustomQueryRow) -> RuntimeValue] = [
        "date": { .date($0.date) },
        "meta": { $0.meta },
        "type": { .string($0.custom.type) },
        "values": { row in
            .list(row.custom.values.map(BeancountQueryContextBuilder.runtimeMetaValue))
        },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

private struct BeancountCustomTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "custom")
        return BeancountQueryContextBuilder.customRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountCustomQueryRow.wildcardColumns
    }
}

private struct BeancountDocumentsTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "documents")
        return BeancountQueryContextBuilder.documentsRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountDocumentQueryRow.wildcardColumns
    }
}

private struct BeancountAccountsTableProvider: QueryTableProvider {
    var staticRows: LazyResolver<(accounts: [QueryRow], commodities: [QueryRow])>

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "accounts")
        return QueryRowSequence(staticRows.value.accounts)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountAccountQueryRow.wildcardColumns
    }
}

private struct BeancountCommoditiesTableProvider: QueryTableProvider {
    var staticRows: LazyResolver<(accounts: [QueryRow], commodities: [QueryRow])>

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "commodities")
        return QueryRowSequence(staticRows.value.commodities)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        ["meta", "date", "name"]
    }
}

private struct BeancountTransactionsTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "transactions")
        return BeancountQueryContextBuilder.transactionsRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountTransactionQueryRow.wildcardColumns
    }
}

private struct BeancountPricesTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "prices")
        return BeancountQueryContextBuilder.pricesRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountPriceQueryRow.wildcardColumns
    }
}

private struct BeancountBalancesTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "balances")
        return BeancountQueryContextBuilder.balancesRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountBalanceQueryRow.wildcardColumns
    }
}

private struct BeancountNotesTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "notes")
        return BeancountQueryContextBuilder.notesRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountNoteQueryRow.wildcardColumns
    }
}

private struct BeancountEventsTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        try requireNoQualifiers(qualifiers, table: "events")
        return BeancountQueryContextBuilder.eventsRowSequence(directives: directives)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountEventQueryRow.wildcardColumns
    }
}

private func requireNoQualifiers(_ qualifiers: EvalQualifiers?, table: String) throws {
    guard let qualifiers else {
        return
    }
    if qualifiers.open != nil || qualifiers.close != nil || qualifiers.clear {
        throw BQLExecutionError.qualifiersUnsupported(table)
    }
}

private struct BeancountPostingsTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]
    var summarizeConfig: BeancountSummarizeConfig

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        let transformed = applyBeancountQualifiers(
            directives,
            qualifiers: qualifiers,
            summarizeConfig: summarizeConfig
        )
        return BeancountQueryContextBuilder.postingsRowSequence(directives: transformed)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountPostingQueryRow.wildcardColumns
    }
}

private struct BeancountEntriesTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]
    var summarizeConfig: BeancountSummarizeConfig

    func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
        let transformed = applyBeancountQualifiers(
            directives,
            qualifiers: qualifiers,
            summarizeConfig: summarizeConfig
        )
        return BeancountQueryContextBuilder.entriesRowSequence(directives: transformed)
    }

    func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
        BeancountEntryQueryRow.wildcardColumns
    }
}

private func applyBeancountQualifiers(
    _ entries: [Directive<Cost>],
    qualifiers: EvalQualifiers?,
    summarizeConfig: BeancountSummarizeConfig
) -> [Directive<Cost>] {
    guard let qualifiers else {
        return entries
    }

    var transformed = entries

    if let open = qualifiers.open {
        transformed = Summarize.open(
            transformed,
            date: open,
            accountTypes: summarizeConfig.accountTypes,
            conversionCurrency: summarizeConfig.conversionCurrency,
            accountEarnings: summarizeConfig.previousEarnings,
            accountOpening: summarizeConfig.previousBalances,
            accountConversions: summarizeConfig.previousConversions
        ).entries
    }

    if let close = qualifiers.close {
        let closeDate: Date?
        switch close {
        case .implicit:
            closeDate = nil
        case .on(let date):
            closeDate = date
        }

        transformed = Summarize.close(
            transformed,
            date: closeDate,
            conversionCurrency: summarizeConfig.conversionCurrency,
            accountConversions: summarizeConfig.currentConversions
        ).entries
    }

    if qualifiers.clear {
        transformed = Summarize.clear(
            transformed,
            date: nil,
            accountTypes: summarizeConfig.accountTypes,
            accountEarnings: summarizeConfig.currentEarnings
        ).entries
    }

    return transformed
}

private struct BeancountSummarizeConfig: Sendable {
    var accountTypes: AccountTypeConfiguration
    var conversionCurrency: Currency
    var previousEarnings: Account
    var previousBalances: Account
    var previousConversions: Account
    var currentEarnings: Account
    var currentConversions: Account

    static func from(options: Options?) -> Self {
        let accountTypes = options?.accountNames ?? .default
        let raw = options?.rawOptions ?? [:]
        let equity = accountTypes.equity

        return Self(
            accountTypes: accountTypes,
            conversionCurrency: Currency(id: raw["conversion_currency"]?.last ?? "NOTHING"),
            previousEarnings: Account(
                id: "\(equity):" + (raw["account_previous_earnings"]?.last ?? "Earnings:Previous")
            ),
            previousBalances: Account(
                id: "\(equity):" + (raw["account_previous_balances"]?.last ?? "Opening-Balances")
            ),
            previousConversions: Account(
                id: "\(equity):" + (raw["account_previous_conversions"]?.last ?? "Conversions:Previous")
            ),
            currentEarnings: Account(
                id: "\(equity):" + (raw["account_current_earnings"]?.last ?? "Earnings:Current")
            ),
            currentConversions: Account(
                id: "\(equity):" + (raw["account_current_conversions"]?.last ?? "Conversions:Current")
            )
        )
    }
}
