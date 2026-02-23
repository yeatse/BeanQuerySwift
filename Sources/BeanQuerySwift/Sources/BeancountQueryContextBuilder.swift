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
        let provider = BeancountPostingsTableProvider(
            directives: directives,
            summarizeConfig: summarizeConfig
        )

        return QueryContext(
            tables: [
                "postings": buildPostingsRows(directives: directives),
            ],
            providers: [
                "postings": provider,
            ]
        )
    }

    fileprivate static func buildPostingsRows(directives: [Directive<Cost>]) -> [QueryRow] {
        var rows: [QueryRow] = []
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
                row["position"] = .decimal(posting.units.number)
                row["currency"] = .string(posting.units.currency.id)

                row["flag"] = transaction.flag.map { .string(String($0)) } ?? .null
                row["payee"] = transaction.payee.map(RuntimeValue.string) ?? .null
                row["narration"] = transaction.narration.map(RuntimeValue.string) ?? .null

                rows.append(row)
            }
        }

        return rows
    }
}

private struct BeancountPostingsTableProvider: QueryTableProvider {
    var directives: [Directive<Cost>]
    var summarizeConfig: BeancountSummarizeConfig

    func rows(for qualifiers: EvalQualifiers?) throws -> [QueryRow] {
        let transformed = applyQualifiers(directives.sorted(), qualifiers: qualifiers)
        return BeancountQueryContextBuilder.buildPostingsRows(directives: transformed)
    }

    private func applyQualifiers(
        _ entries: [Directive<Cost>],
        qualifiers: EvalQualifiers?
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
