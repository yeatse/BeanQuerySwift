import Foundation
import Testing
import BeancountSwift
@testable import BeanQuerySwift

@Suite
struct BeancountSourceAdapterTests {
    private let engine = BeanQueryEngine()

    @Test func runQueryAgainstBeancountDirectives() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLedger())

        let result = try engine.run(
            "SELECT account, sum(number) AS total FROM postings WHERE year = 2024 GROUP BY account ORDER BY account",
            in: context
        )

        #expect(result.columns == ["account", "total"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .decimal(Decimal(920))],
            [.string("Expenses:Food"), .decimal(Decimal(80))],
            [.string("Income:Salary"), .decimal(Decimal(-1000))],
        ])
    }

    @Test func runCloseQualifierAgainstDirectiveInput() throws {
        let full = try engine.run(
            "SELECT sum(number) AS total FROM postings WHERE account = 'Assets:Cash'",
            in: try sampleDirectives()
        )
        #expect(full.columns == ["total"])
        #expect(full.rows == [[.decimal(Decimal(920))]])

        let closed = try engine.run(
            "SELECT sum(number) AS total FROM CLOSE ON 2024-01-12 WHERE account = 'Assets:Cash'",
            in: try sampleDirectives()
        )
        #expect(closed.columns == ["total"])
        #expect(closed.rows == [[.decimal(Decimal(1000))]])
    }

    @Test func runQueryAgainstEntriesTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLedger())
        let result = try engine.run(
            "SELECT type, count(*) AS cnt FROM entries GROUP BY type ORDER BY type",
            in: context
        )

        #expect(result.columns == ["type", "cnt"])
        #expect(result.rows == [
            [.string("close"), .int(1)],
            [.string("open"), .int(3)],
            [.string("transaction"), .int(2)],
        ])
    }

    @Test func runQueryAgainstAccountsTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLedger())
        let result = try engine.run(
            "SELECT account, type, close_date FROM accounts ORDER BY account",
            in: context
        )

        #expect(result.columns == ["account", "type", "close_date"])
        #expect(result.rows.count == 3)
        #expect(result.rows[0][0] == .string("Assets:Cash"))
        #expect(result.rows[0][1] == .string("assets"))
        #expect(result.rows[0][2] == .null)
        #expect(result.rows[1][0] == .string("Expenses:Food"))
        #expect(result.rows[1][1] == .string("expenses"))
        #expect(result.rows[1][2] != .null)
        #expect(result.rows[2][0] == .string("Income:Salary"))
        #expect(result.rows[2][1] == .string("income"))
    }

    @Test func runInventorySumOnPositionColumn() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLotLedger())
        let result = try engine.run(
            "SELECT account, sum(position) AS total FROM postings WHERE account = 'Assets:Brokerage' GROUP BY account",
            in: context
        )

        #expect(result.columns == ["account", "total"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][0] == .string("Assets:Brokerage"))

        guard case .inventory(let totalInventory) = result.rows[0][1] else {
            Issue.record("expected inventory result")
            return
        }

        let expected: Inventory = "10 VTI {100 USD, 2024-01-15}, 5 VTI {110 USD, 2024-02-10}"
        #expect(totalInventory == expected)
    }

    @Test func runUnitsAndCostOnAggregatedInventory() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLotLedger())
        let result = try engine.run(
            "SELECT units(sum(position)) AS units, cost(sum(position)) AS cost FROM postings WHERE account = 'Assets:Brokerage'",
            in: context
        )

        #expect(result.columns == ["units", "cost"])
        #expect(result.rows.count == 1)

        guard case .inventory(let unitsInventory) = result.rows[0][0] else {
            Issue.record("expected units inventory")
            return
        }
        guard case .inventory(let costInventory) = result.rows[0][1] else {
            Issue.record("expected cost inventory")
            return
        }

        let expectedUnits: Inventory = "15 VTI"
        let expectedCost: Inventory = "1550 USD"
        #expect(unitsInventory == expectedUnits)
        #expect(costInventory == expectedCost)
    }

    @Test func runValueOnAggregatedInventory() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLotLedger())
        let result = try engine.run(
            "SELECT value(sum(position)) AS market_value FROM postings WHERE account = 'Assets:Brokerage'",
            in: context
        )

        #expect(result.columns == ["market_value"])
        #expect(result.rows.count == 1)

        guard case .inventory(let valueInventory) = result.rows[0][0] else {
            Issue.record("expected market value inventory")
            return
        }

        let expected: Inventory = "1800 USD"
        #expect(valueInventory == expected)
    }

    @Test func runBalancesAtValueOnLotPostings() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLotLedger())
        let result = try engine.run(
            "BALANCES AT value WHERE account = 'Assets:Brokerage'",
            in: context
        )

        #expect(result.columns == ["account", "sum"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][0] == .string("Assets:Brokerage"))

        guard case .inventory(let valueInventory) = result.rows[0][1] else {
            Issue.record("expected market value inventory")
            return
        }
        let expected: Inventory = "1800 USD"
        #expect(valueInventory == expected)
    }

    @Test func runJournalCostTracksRunningLotBalance() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLotLedger())
        let result = try engine.run(
            "JOURNAL 'Assets:Brokerage' AT cost",
            in: context
        )

        #expect(result.columns == ["date", "flag", "maxwidth", "maxwidth", "account", "cost", "cost"])
        #expect(result.rows.count == 2)

        guard case .amount(let firstCost) = result.rows[0][5],
              case .amount(let secondCost) = result.rows[1][5]
        else {
            Issue.record("expected cost amounts in journal position column")
            return
        }
        #expect(firstCost == Amount(number: 1000, currency: Currency(id: "USD")))
        #expect(secondCost == Amount(number: 550, currency: Currency(id: "USD")))

        guard case .inventory(let firstBalance) = result.rows[0][6],
              case .inventory(let secondBalance) = result.rows[1][6]
        else {
            Issue.record("expected running inventory in journal balance column")
            return
        }

        let expectedFirst: Inventory = "1000 USD"
        let expectedSecond: Inventory = "1550 USD"
        #expect(firstBalance == expectedFirst)
        #expect(secondBalance == expectedSecond)
    }

    @Test func runBalanceColumnTracksSelectedRowsForLots() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLotLedger())
        let result = try engine.run(
            "SELECT date, account, balance FROM postings WHERE account = 'Assets:Brokerage'",
            in: context
        )

        #expect(result.columns == ["date", "account", "balance"])
        #expect(result.rows.count == 2)

        guard case .inventory(let firstBalance) = result.rows[0][2],
              case .inventory(let secondBalance) = result.rows[1][2]
        else {
            Issue.record("expected running lot inventory in balance column")
            return
        }

        let expectedFirst: Inventory = "10 VTI {100 USD, 2024-01-15}"
        let expectedSecond: Inventory = "10 VTI {100 USD, 2024-01-15}, 5 VTI {110 USD, 2024-02-10}"
        #expect(firstBalance == expectedFirst)
        #expect(secondBalance == expectedSecond)
    }

    @Test func runCostLabelDefaultsToEmptyStringWhenCostIsMissing() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try sampleLedger())
        let result = try engine.run(
            "SELECT account, cost_label FROM postings WHERE account = 'Assets:Cash' ORDER BY date",
            in: context
        )

        #expect(result.columns == ["account", "cost_label"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .string("")],
            [.string("Assets:Cash"), .string("")],
        ])
    }

    private func sampleDirectives() throws -> [Directive<Cost>] {
        try sampleLedger().directives
    }

    private func sampleLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "USD"

        2024-01-01 open Assets:Cash USD
        2024-01-01 open Income:Salary USD
        2024-01-01 open Expenses:Food USD

        2024-01-10 * "Employer" "Salary"
          Assets:Cash      1000 USD
          Income:Salary   -1000 USD

        2024-01-12 * "Store" "Groceries"
          Expenses:Food      80 USD
          Assets:Cash       -80 USD

        2024-01-20 close Expenses:Food
        """)
        return try Loader.load(file: "test.bean", contentProvider: provider)
    }

    private func sampleLotLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "USD"

        2024-01-01 open Assets:Cash USD
        2024-01-01 open Assets:Brokerage VTI
        2024-01-01 open Equity:Opening-Balances USD

        2024-01-01 * "Init" "Funding"
          Assets:Cash                5000 USD
          Equity:Opening-Balances   -5000 USD

        2024-01-15 * "Broker" "Buy lot 1"
          Assets:Brokerage             10 VTI {100 USD}
          Assets:Cash               -1000 USD

        2024-02-10 * "Broker" "Buy lot 2"
          Assets:Brokerage              5 VTI {110 USD}
          Assets:Cash                -550 USD

        2024-02-15 price VTI 120 USD
        """)
        return try Loader.load(file: "test-lot.bean", contentProvider: provider)
    }
}

private struct StringContentProvider: ContentProviding {
    var source: String

    func provideContent(for file: String) throws -> String {
        source
    }
}
