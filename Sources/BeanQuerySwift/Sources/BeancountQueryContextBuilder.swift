import Foundation
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
        let postingsProvider = BeancountPostingsTableProvider(
            directives: sortedDirectives,
            summarizeConfig: summarizeConfig
        )
        let entriesProvider = BeancountEntriesTableProvider(
            directives: sortedDirectives,
            summarizeConfig: summarizeConfig
        )

        return QueryContext(
            tables: [
                "accounts": buildAccountsRows(directives: sortedDirectives),
            ],
            providers: [
                "postings": postingsProvider,
                "entries": entriesProvider,
            ],
            priceMap: PriceMap.build(from: sortedDirectives)
        )
    }

    fileprivate static func postingsRowSequence(directives: [Directive<Cost>]) -> QueryRowSequence {
        QueryRowSequence(makeIterator: {
            var directiveIndex = 0
            var postingIndex = 0
            var currentDirectiveContext: PostingDirectiveContext?
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
                            year: components.year ?? 0,
                            month: components.month ?? 0,
                            day: components.day ?? 0,
                            flag: transaction.flag.map { RuntimeValue.string(String($0)) } ?? .null,
                            payee: transaction.payee.map(RuntimeValue.string) ?? .null,
                            narration: transaction.narration.map(RuntimeValue.string) ?? .null,
                            description: descriptionValue(
                                payee: transaction.payee,
                                narration: transaction.narration
                            ),
                            entryMeta: .dict(runtimeMetaDictionary(from: directive.meta))
                        )
                        postingIndex = 0
                    }

                    guard let directiveContext = currentDirectiveContext else {
                        continue
                    }

                    if postingIndex < directiveContext.transaction.postings.count {
                        let posting = directiveContext.transaction.postings[postingIndex]
                        postingIndex += 1
                        return QueryRow(
                            storage: .beancountPosting(
                                BeancountPostingQueryRow(
                                    date: directiveContext.directive.date,
                                    year: directiveContext.year,
                                    month: directiveContext.month,
                                    day: directiveContext.day,
                                    posting: posting,
                                    position: Position(posting: posting),
                                    flag: directiveContext.flag,
                                    payee: directiveContext.payee,
                                    narration: directiveContext.narration,
                                    description: directiveContext.description,
                                    meta: posting.meta.map { .dict(runtimeMetaDictionary(from: $0)) } ?? .null,
                                    entryMeta: directiveContext.entryMeta
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
            let calendar = Calendar(identifier: .gregorian)
            let dateComponents: Set<Calendar.Component> = [.year, .month, .day]

            return AnyIterator {
                guard index < directives.count else {
                    return nil
                }

                let directive = directives[index]
                defer { index += 1 }

                let components = calendar.dateComponents(dateComponents, from: directive.date)
                let metaValue: RuntimeValue = .dict(runtimeMetaDictionary(from: directive.meta))
                return QueryRow(
                    storage: .beancountEntry(
                        BeancountEntryQueryRow(
                            directive: directive,
                            id: index,
                            date: directive.date,
                            year: components.year ?? 0,
                            month: components.month ?? 0,
                            day: components.day ?? 0,
                            type: entryTypeName(directive.content),
                            meta: metaValue,
                            entryMeta: metaValue,
                            flag: flagValue(for: directive),
                            payee: payeeValue(for: directive),
                            narration: narrationValue(for: directive),
                            description: entryDescriptionValue(for: directive),
                            account: accountValue(for: directive),
                            accounts: accountsValue(for: directive)
                        )
                    )
                )
            }
        })
    }

    fileprivate static func buildAccountsRows(directives: [Directive<Cost>]) -> [QueryRow] {
        var openByAccount: [String: Date] = [:]
        var closeByAccount: [String: Date] = [:]
        var openMetaByAccount: [String: RuntimeValue] = [:]

        for directive in directives {
            switch directive.content {
            case .open(let open):
                let account = open.account.id
                if let existing = openByAccount[account] {
                    if directive.date < existing {
                        openByAccount[account] = directive.date
                        openMetaByAccount[account] = .dict(runtimeMetaDictionary(from: directive.meta))
                    }
                } else {
                    openByAccount[account] = directive.date
                    openMetaByAccount[account] = .dict(runtimeMetaDictionary(from: directive.meta))
                }
            case .close(let close):
                let account = close.account.id
                if let existing = closeByAccount[account] {
                    closeByAccount[account] = min(existing, directive.date)
                } else {
                    closeByAccount[account] = directive.date
                }
            default:
                break
            }
        }

        let accountNames = Set(openByAccount.keys).union(closeByAccount.keys).sorted()
        return accountNames.map { account in
            QueryRow(
                storage: .beancountAccount(
                    BeancountAccountQueryRow(
                        account: account,
                        openDate: openByAccount[account].map(RuntimeValue.date) ?? .null,
                        closeDate: closeByAccount[account].map(RuntimeValue.date) ?? .null,
                        openMeta: openMetaByAccount[account] ?? .null,
                        type: .string(accountTypeName(account))
                    )
                )
            )
        }
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
    let year: Int
    let month: Int
    let day: Int
    let flag: RuntimeValue
    let payee: RuntimeValue
    let narration: RuntimeValue
    let description: RuntimeValue
    let entryMeta: RuntimeValue
}

struct BeancountPostingQueryRow: Sendable {
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let posting: Posting<Cost>
    let position: Position
    let flag: RuntimeValue
    let payee: RuntimeValue
    let narration: RuntimeValue
    let description: RuntimeValue
    let meta: RuntimeValue
    let entryMeta: RuntimeValue

    static let wildcardColumns = [
        "account",
        "balance",
        "cost_currency",
        "cost_date",
        "cost_label",
        "cost_number",
        "currency",
        "date",
        "day",
        "description",
        "entry_meta",
        "flag",
        "meta",
        "month",
        "narration",
        "number",
        "payee",
        "position",
        "price",
        "weight",
        "year",
    ]

    private static let accessors: [String: @Sendable (BeancountPostingQueryRow) -> RuntimeValue] = [
        "account": { .string($0.posting.account.id) },
        "balance": { _ in .null },
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
        "description": { $0.description },
        "entry_meta": { $0.entryMeta },
        "flag": { $0.flag },
        "meta": { $0.meta },
        "month": { .int($0.month) },
        "narration": { $0.narration },
        "number": { .decimal($0.posting.units.number) },
        "payee": { $0.payee },
        "position": { .position($0.position) },
        "price": { $0.posting.price.map(RuntimeValue.amount) ?? .null },
        "weight": { .amount($0.posting.weight) },
        "year": { .int($0.year) },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountEntryQueryRow: Sendable {
    let directive: Directive<Cost>
    let id: Int
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let type: String
    let meta: RuntimeValue
    let entryMeta: RuntimeValue
    let flag: RuntimeValue
    let payee: RuntimeValue
    let narration: RuntimeValue
    let description: RuntimeValue
    let account: RuntimeValue
    let accounts: RuntimeValue

    static let wildcardColumns = [
        "account",
        "accounts",
        "date",
        "day",
        "description",
        "entry",
        "entry_meta",
        "flag",
        "id",
        "meta",
        "month",
        "narration",
        "payee",
        "type",
        "year",
    ]

    private static let accessors: [String: @Sendable (BeancountEntryQueryRow) -> RuntimeValue] = [
        "account": { $0.account },
        "accounts": { $0.accounts },
        "date": { .date($0.date) },
        "day": { .int($0.day) },
        "description": { $0.description },
        "entry": { .directive($0.directive) },
        "entry_meta": { $0.entryMeta },
        "flag": { $0.flag },
        "id": { .int($0.id) },
        "meta": { $0.meta },
        "month": { .int($0.month) },
        "narration": { $0.narration },
        "payee": { $0.payee },
        "type": { .string($0.type) },
        "year": { .int($0.year) },
    ]

    func value(for column: String) -> RuntimeValue? {
        Self.accessors[column].map { $0(self) }
    }
}

struct BeancountAccountQueryRow: Sendable {
    let account: String
    let openDate: RuntimeValue
    let closeDate: RuntimeValue
    let openMeta: RuntimeValue
    let type: RuntimeValue

    static let wildcardColumns = [
        "account",
        "close_date",
        "open_date",
        "open_meta",
        "type",
    ]

    private static let accessors: [String: @Sendable (BeancountAccountQueryRow) -> RuntimeValue] = [
        "account": { .string($0.account) },
        "close_date": { $0.closeDate },
        "open_date": { $0.openDate },
        "open_meta": { $0.openMeta },
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
        BeancountPostingQueryRow.wildcardColumns.sorted()
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
        BeancountEntryQueryRow.wildcardColumns.sorted()
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
