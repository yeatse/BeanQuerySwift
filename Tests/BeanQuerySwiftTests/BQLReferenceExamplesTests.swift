import Foundation
import Testing
import BeancountSwift
@testable import BeanQuerySwift

@Suite
struct BQLReferenceExamplesTests {
    private let engine = BeanQueryEngine()

    private func context() throws -> QueryContext {
        BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.bqlReferenceLedger())
    }

    @Test func tableQueryAccountsWithAttributeAccess() throws {
        let result = try engine.run(
            "SELECT account, open.date AS opened FROM \"accounts\" WHERE account ~ '^Assets'",
            in: try context()
        )
        #expect(result.columns == ["account", "opened"])
        #expect(result.rows.count == 2)
        for row in result.rows {
            guard case .date = row[1] else {
                Issue.record("expected open.date to be a date")
                return
            }
        }
    }

    @Test func tableQueryAccountsOpenMetaAttribute() throws {
        let result = try engine.run(
            "SELECT account, open.meta FROM \"accounts\" WHERE account = 'Assets:Cash'",
            in: try context()
        )
        #expect(result.rows.count == 1)
        guard case .dict = result.rows[0][1] else {
            Issue.record("expected open.meta to be a dict")
            return
        }
    }

    @Test func tableQueryAccountsCloseIsNullForOpenAccounts() throws {
        let result = try engine.run(
            "SELECT account, close FROM \"accounts\" WHERE account = 'Assets:Cash'",
            in: try context()
        )
        #expect(result.rows.count == 1)
        #expect(result.rows[0][1] == .null)
    }

    @Test func tableQueryPricesOrderedByDateDesc() throws {
        let result = try engine.run(
            "SELECT date, currency, amount FROM \"prices\" ORDER BY date DESC LIMIT 10",
            in: try context()
        )
        #expect(result.columns == ["date", "currency", "amount"])
        #expect(result.rows.count == 3)
        guard case .date(let firstDate) = result.rows[0][0] else {
            Issue.record("expected date in first row")
            return
        }
        let calendar = Calendar(identifier: .gregorian)
        let parts = calendar.dateComponents([.year, .month, .day], from: firstDate)
        #expect(parts.day == 27)
    }

    @Test func defaultPostingsExpenseGroupBy() throws {
        let result = try engine.run(
            "SELECT account, sum(position) WHERE account ~ '^Expenses' GROUP BY account",
            in: try context()
        )
        #expect(result.columns.count == 2)
        #expect(result.rows.count == 3)
    }

    @Test func fromExpressionWithDateBound() throws {
        let result = try engine.run(
            "SELECT account, sum(position) FROM date >= 2026-01-01 WHERE account ~ '^Expenses' GROUP BY account",
            in: try context()
        )
        #expect(result.rows.count == 3)
    }

    @Test func fromOpenCloseQualifiers() throws {
        let result = try engine.run(
            "SELECT account, sum(position) FROM OPEN ON 2026-01-01 CLOSE ON 2026-05-01 WHERE account ~ '^(Assets|Liabilities)' GROUP BY account",
            in: try context()
        )
        #expect(result.columns.count == 2)
        #expect(!result.rows.isEmpty)
    }

    @Test func aggregateOrderedByAlias() throws {
        let result = try engine.run(
            "SELECT account, sum(position) AS total WHERE account ~ '^Expenses' GROUP BY account ORDER BY total DESC",
            in: try context()
        )
        #expect(result.columns == ["account", "total"])
        #expect(result.rows.count == 3)
    }

    @Test func dateTruncMonthAggregate() throws {
        let result = try engine.run(
            "SELECT date_trunc('month', date) AS month, sum(position) AS total WHERE account ~ '^Expenses' GROUP BY month ORDER BY month DESC",
            in: try context()
        )
        #expect(result.columns == ["month", "total"])
        #expect(!result.rows.isEmpty)
    }

    @Test func havingClauseWithOnlyAndNumber() throws {
        let result = try engine.run(
            "SELECT account, only('CNY', sum(position)) AS cny WHERE account ~ '^Assets' GROUP BY account HAVING number(only('CNY', sum(position))) > 0 ORDER BY cny DESC",
            in: try context()
        )
        #expect(result.columns == ["account", "cny"])
        #expect(!result.rows.isEmpty)
    }

    @Test func discoverAccountsWithDistinct() throws {
        let result = try engine.run(
            "SELECT DISTINCT account WHERE account ~ 'Food|Dining|Restaurant' ORDER BY account",
            in: try context()
        )
        #expect(result.columns == ["account"])
        #expect(result.rows == [
            [.string("Expenses:Food:Groceries")],
            [.string("Expenses:Food:Restaurant")],
        ])
    }

    @Test func expensesWithHalfOpenDateRange() throws {
        let result = try engine.run(
            "SELECT account, sum(position) AS total WHERE account ~ '^Expenses' AND date >= 2026-04-01 AND date < 2026-05-01 GROUP BY account ORDER BY total DESC",
            in: try context()
        )
        #expect(result.columns == ["account", "total"])
        #expect(result.rows.count == 3)
    }

    @Test func recentActivityWithLimit() throws {
        let result = try engine.run(
            "SELECT date, payee, narration, account, position WHERE account ~ '^Expenses' AND date >= 2026-04-01 AND date < 2026-05-01 ORDER BY date DESC LIMIT 20",
            in: try context()
        )
        #expect(result.columns == ["date", "payee", "narration", "account", "position"])
        #expect(result.rows.count == 4)
    }

    @Test func monthlyTrendGroupBy() throws {
        let result = try engine.run(
            "SELECT year, month, sum(position) AS total WHERE account ~ '^Expenses' GROUP BY year, month ORDER BY year DESC, month DESC LIMIT 12",
            in: try context()
        )
        #expect(result.columns == ["year", "month", "total"])
        #expect(!result.rows.isEmpty)
    }

    @Test func balancesConvenienceCommand() throws {
        let result = try engine.run(
            "BALANCES WHERE account ~ '^(Assets|Liabilities)'",
            in: try context()
        )
        #expect(!result.rows.isEmpty)
    }

    @Test func netWorthRootGrouping() throws {
        let result = try engine.run(
            "SELECT root(account, 1) AS kind, sum(position) AS total WHERE account ~ '^(Assets|Liabilities)' GROUP BY kind ORDER BY kind",
            in: try context()
        )
        #expect(result.columns == ["kind", "total"])
        #expect(result.rows.count == 2)
        #expect(result.rows[0][0] == .string("Assets"))
        #expect(result.rows[1][0] == .string("Liabilities"))
    }

    @Test func payerEntryMetaGroup() throws {
        let result = try engine.run(
            "SELECT entry_meta('payer') AS payer, sum(position) AS total WHERE account ~ '^Expenses' GROUP BY payer ORDER BY total DESC",
            in: try context()
        )
        #expect(result.columns == ["payer", "total"])
        #expect(result.rows.count >= 1)
    }

    @Test func amountAttributeAccess() throws {
        let result = try engine.run(
            "SELECT date, amount.number AS num, amount.currency AS cur FROM \"prices\" ORDER BY date DESC LIMIT 1",
            in: try context()
        )
        #expect(result.columns == ["date", "num", "cur"])
        #expect(result.rows.count == 1)
        guard case .decimal = result.rows[0][1] else {
            Issue.record("expected amount.number to be decimal")
            return
        }
        guard case .string = result.rows[0][2] else {
            Issue.record("expected amount.currency to be string")
            return
        }
    }

    @Test func positionUnitsAttributeAccess() throws {
        let result = try engine.run(
            "SELECT account, position.units.currency AS cur, position.units.number AS num WHERE account ~ '^Assets' ORDER BY account, cur LIMIT 5",
            in: try context()
        )
        #expect(result.columns == ["account", "cur", "num"])
        #expect(!result.rows.isEmpty)
        for row in result.rows {
            guard case .string = row[1] else {
                Issue.record("expected currency string")
                return
            }
            guard case .decimal = row[2] else {
                Issue.record("expected number decimal")
                return
            }
        }
    }

    @Test func dateYearMonthDayAttributeAccess() throws {
        let result = try engine.run(
            "SELECT date.year AS y, date.month AS m, date.day AS d FROM \"prices\" ORDER BY date DESC LIMIT 1",
            in: try context()
        )
        #expect(result.columns == ["y", "m", "d"])
        #expect(result.rows.count == 1)
        guard case .int = result.rows[0][0],
              case .int = result.rows[0][1],
              case .int = result.rows[0][2]
        else {
            Issue.record("expected integer year/month/day")
            return
        }
    }

    @Test func entryDirectiveAttributeAccess() throws {
        let result = try engine.run(
            "SELECT entry.type AS t, entry.date AS d FROM entries WHERE type = 'transaction' ORDER BY date LIMIT 1",
            in: try context()
        )
        #expect(result.columns == ["t", "d"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][0] == .string("transaction"))
        guard case .date = result.rows[0][1] else {
            Issue.record("expected entry.date to be a date")
            return
        }
    }
}
