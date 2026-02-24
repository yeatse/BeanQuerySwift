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
        let postingsProvider = BeancountPostingsTableProvider(
            directives: directives,
            summarizeConfig: summarizeConfig
        )
        let entriesProvider = BeancountEntriesTableProvider(
            directives: directives,
            summarizeConfig: summarizeConfig
        )

        return QueryContext(
            tables: [
                "postings": buildPostingsRows(directives: directives),
                "entries": buildEntriesRows(directives: directives),
                "accounts": buildAccountsRows(directives: directives),
            ],
            providers: [
                "postings": postingsProvider,
                "entries": entriesProvider,
            ],
            priceMap: PriceMap.build(from: directives.sorted())
        )
    }

    fileprivate static func buildPostingsRows(directives: [Directive<Cost>]) -> [QueryRow] {
        var rows: [QueryRow] = []
        var runningBalance = Inventory()
        let calendar = Calendar(identifier: .gregorian)

        for directive in directives {
            guard case .transaction(let transaction) = directive.content else {
                continue
            }

            for posting in transaction.postings {
                var row: QueryRow = [:]
                row["date"] = .date(directive.date)
                row["year"] = .int(calendar.component(.year, from: directive.date))
                row["month"] = .int(calendar.component(.month, from: directive.date))
                row["day"] = .int(calendar.component(.day, from: directive.date))

                row["account"] = .string(posting.account.id)
                row["number"] = .decimal(posting.units.number)
                row["position"] = .position(Position(posting: posting))
                row["currency"] = .string(posting.units.currency.id)
                row["price"] = posting.price.map(RuntimeValue.amount) ?? .null
                row["weight"] = .amount(posting.weight)

                if let cost = posting.cost {
                    row["cost_number"] = .decimal(cost.number)
                    row["cost_currency"] = .string(cost.currency.id)
                    row["cost_date"] = cost.date.map(RuntimeValue.date) ?? .null
                    row["cost_label"] = cost.label.map(RuntimeValue.string) ?? .null
                } else {
                    row["cost_number"] = .null
                    row["cost_currency"] = .null
                    row["cost_date"] = .null
                    row["cost_label"] = .string("")
                }

                _ = runningBalance.addAmount(posting.units, cost: posting.cost)
                row["balance"] = .inventory(runningBalance)

                row["flag"] = transaction.flag.map { .string(String($0)) } ?? .null
                row["payee"] = transaction.payee.map(RuntimeValue.string) ?? .null
                row["narration"] = transaction.narration.map(RuntimeValue.string) ?? .null

                rows.append(row)
            }
        }

        return rows
    }

    fileprivate static func buildEntriesRows(directives: [Directive<Cost>]) -> [QueryRow] {
        var rows: [QueryRow] = []
        let calendar = Calendar(identifier: .gregorian)

        for (index, directive) in directives.enumerated() {
            var row: QueryRow = [:]
            row["id"] = .int(index)
            row["date"] = .date(directive.date)
            row["year"] = .int(calendar.component(.year, from: directive.date))
            row["month"] = .int(calendar.component(.month, from: directive.date))
            row["day"] = .int(calendar.component(.day, from: directive.date))
            row["type"] = .string(entryTypeName(directive.content))

            switch directive.content {
            case .transaction(let transaction):
                row["flag"] = transaction.flag.map { .string(String($0)) } ?? .null
                row["payee"] = transaction.payee.map(RuntimeValue.string) ?? .null
                row["narration"] = transaction.narration.map(RuntimeValue.string) ?? .null
                row["accounts"] = .list(transaction.postings.map { .string($0.account.id) })
            case .open(let open):
                row["account"] = .string(open.account.id)
            case .close(let close):
                row["account"] = .string(close.account.id)
            case .balance(let balance):
                row["account"] = .string(balance.account.id)
            case .note(let note):
                row["account"] = .string(note.account.id)
            case .document(let document):
                row["account"] = .string(document.account.id)
            case .pad(let pad):
                row["account"] = .string(pad.account.id)
            case .price, .commodity, .event, .query, .custom:
                break
            }

            if row["flag"] == nil { row["flag"] = .null }
            if row["payee"] == nil { row["payee"] = .null }
            if row["narration"] == nil { row["narration"] = .null }
            if row["account"] == nil { row["account"] = .null }
            if row["accounts"] == nil { row["accounts"] = .null }

            rows.append(row)
        }

        return rows
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
            var row: QueryRow = [:]
            row["account"] = .string(account)
            row["open_date"] = openByAccount[account].map(RuntimeValue.date) ?? .null
            row["close_date"] = closeByAccount[account].map(RuntimeValue.date) ?? .null
            row["open_meta"] = openMetaByAccount[account] ?? .null
            row["type"] = .string(accountTypeName(account))
            return row
        }
    }

    private static func entryTypeName(_ content: DirectiveContent<Cost>) -> String {
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

    private static func accountTypeName(_ account: String) -> String {
        let root = account.split(separator: ":").first.map(String.init) ?? account
        return root.lowercased()
    }

    private static func runtimeMetaDictionary(from metadata: MetaData) -> [String: RuntimeValue] {
        var result: [String: RuntimeValue] = [:]
        for (key, value) in metadata {
            result[key] = runtimeMetaValue(value)
        }
        return result
    }

    private static func runtimeMetaValue(_ value: MetaDataValue) -> RuntimeValue {
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

    private static func exactInt(from decimal: Decimal) -> Int? {
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

private struct BeancountPostingsTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]
    var summarizeConfig: BeancountSummarizeConfig

    func rows(for qualifiers: EvalQualifiers?) throws -> [QueryRow] {
        let transformed = applyBeancountQualifiers(
            directives.sorted(),
            qualifiers: qualifiers,
            summarizeConfig: summarizeConfig
        )
        return BeancountQueryContextBuilder.buildPostingsRows(directives: transformed)
    }
}

private struct BeancountEntriesTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]
    var summarizeConfig: BeancountSummarizeConfig

    func rows(for qualifiers: EvalQualifiers?) throws -> [QueryRow] {
        let transformed = applyBeancountQualifiers(
            directives.sorted(),
            qualifiers: qualifiers,
            summarizeConfig: summarizeConfig
        )
        return BeancountQueryContextBuilder.buildEntriesRows(directives: transformed)
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
