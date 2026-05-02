import Foundation
import Testing
import BeancountSwift
@testable import BeanQuerySwift

@Suite
struct BeancountSourceAdapterTests {
    private let engine = BeanQueryEngine()

    @Test func runQueryAgainstBeancountDirectives() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())

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
            in: try BeancountTestFixtures.sampleDirectives()
        )
        #expect(full.columns == ["total"])
        #expect(full.rows == [[.decimal(Decimal(920))]])

        let closed = try engine.run(
            "SELECT sum(number) AS total FROM CLOSE ON 2024-01-12 WHERE account = 'Assets:Cash'",
            in: try BeancountTestFixtures.sampleDirectives()
        )
        #expect(closed.columns == ["total"])
        #expect(closed.rows == [[.decimal(Decimal(1000))]])
    }

    @Test func runQueryAgainstEntriesTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
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
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT account, type, close.date AS closed FROM accounts ORDER BY account",
            in: context
        )

        #expect(result.columns == ["account", "type", "closed"])
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
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
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

    @Test func runJournalCostTracksRunningLotBalance() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
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
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
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

    @Test func runBalanceColumnIsPerAccountAcrossInterleavedPostings() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT account, balance FROM postings ORDER BY date, account",
            in: context
        )

        let inventories = result.rows.map { row -> (String, Inventory) in
            guard case .string(let account) = row[0],
                  case .inventory(let balance) = row[1]
            else {
                Issue.record("expected (account, inventory) tuple in row \(row)")
                return ("", Inventory())
            }
            return (account, balance)
        }

        let cashSnapshots = inventories.filter { $0.0 == "Assets:Cash" }.map(\.1)
        let salarySnapshots = inventories.filter { $0.0 == "Income:Salary" }.map(\.1)
        let foodSnapshots = inventories.filter { $0.0 == "Expenses:Food" }.map(\.1)

        let expectedCash: [Inventory] = ["1000 USD", "920 USD"]
        let expectedSalary: [Inventory] = ["-1000 USD"]
        let expectedFood: [Inventory] = ["80 USD"]

        #expect(cashSnapshots == expectedCash)
        #expect(salarySnapshots == expectedSalary)
        #expect(foodSnapshots == expectedFood)
    }

    @Test func runCostLabelDefaultsToEmptyStringWhenCostIsMissing() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
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

    @Test func runPostingFieldsExposeOtherAccountsTagsAndLinks() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT account, posting_flag, other_accounts, tags, links FROM postings WHERE account = 'Expenses:Food'",
            in: context
        )

        #expect(result.columns == ["account", "posting_flag", "other_accounts", "tags", "links"])
        #expect(result.rows == [[
            .string("Expenses:Food"),
            .string("!"),
            .list([.string("Assets:Cash")]),
            .list([.string("food"), .string("groceries")]),
            .list([.string("receipt")]),
        ]])
    }

    @Test func runEntryFieldsExposeTagsAndLinksForFiltering() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())

        let result = try engine.run(
            "SELECT narration, tags, links FROM entries WHERE narration = 'Groceries'",
            in: context
        )
        #expect(result.columns == ["narration", "tags", "links"])
        #expect(result.rows == [[
            .string("Groceries"),
            .list([.string("food"), .string("groceries")]),
            .list([.string("receipt")]),
        ]])

        let filtered = try engine.run(
            "SELECT narration FROM entries WHERE 'food' IN tags AND 'receipt' IN links",
            in: context
        )
        #expect(filtered.columns == ["narration"])
        #expect(filtered.rows == [[.string("Groceries")]])
    }

    @Test func makeContextKeepsPostingsAndEntriesLazy() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())

        #expect(context.tables["postings"] == nil)
        #expect(context.tables["entries"] == nil)
        #expect(context.tables["accounts"] == nil)
        #expect(context.tables["commodities"] == nil)

        let postings = try engine.run(
            "SELECT count(*) AS cnt FROM postings",
            in: context
        )
        #expect(postings.columns == ["cnt"])
        #expect(postings.rows == [[.int(4)]])

        let entries = try engine.run(
            "SELECT count(*) AS cnt FROM entries",
            in: context
        )
        #expect(entries.columns == ["cnt"])
        #expect(entries.rows == [[.int(6)]])
    }

    @Test func runSelectAsteriskIncludesLazyBalanceColumn() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run(
            "SELECT * FROM postings WHERE account = 'Assets:Brokerage' ORDER BY date",
            in: context
        )

        guard let balanceIndex = result.columns.firstIndex(of: "balance") else {
            Issue.record("expected wildcard columns to contain balance")
            return
        }
        guard let tagsIndex = result.columns.firstIndex(of: "tags"),
              let linksIndex = result.columns.firstIndex(of: "links"),
              let otherAccountsIndex = result.columns.firstIndex(of: "other_accounts")
        else {
            Issue.record("expected wildcard columns to contain tags, links and other_accounts")
            return
        }

        #expect(result.rows.count == 2)
        guard case .inventory(let firstBalance) = result.rows[0][balanceIndex],
              case .inventory(let secondBalance) = result.rows[1][balanceIndex]
        else {
            Issue.record("expected running lot inventory in wildcard balance column")
            return
        }

        let expectedFirst: Inventory = "10 VTI {100 USD, 2024-01-15}"
        let expectedSecond: Inventory = "10 VTI {100 USD, 2024-01-15}, 5 VTI {110 USD, 2024-02-10}"
        #expect(firstBalance == expectedFirst)
        #expect(secondBalance == expectedSecond)
        #expect(result.rows[0][tagsIndex] == .list([]))
        #expect(result.rows[0][linksIndex] == .list([]))
        #expect(result.rows[0][otherAccountsIndex] == .list([.string("Assets:Cash")]))
    }

    @Test func runQueryAgainstTransactionsTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())
        let result = try engine.run(
            "SELECT date, payee, narration, flag, accounts, tags FROM transactions ORDER BY date",
            in: context
        )

        #expect(result.columns == ["date", "payee", "narration", "flag", "accounts", "tags"])
        #expect(result.rows.count == 2)
        #expect(result.rows[0][1] == .string("Employer"))
        #expect(result.rows[0][2] == .string("Salary"))
        #expect(result.rows[0][3] == .string("*"))
        #expect(result.rows[0][4] == .list([.string("Assets:Cash"), .string("Income:Salary")]))
        #expect(result.rows[0][5] == .list([.string("income")]))
        #expect(result.rows[1][1] == .string("Store"))
        #expect(result.rows[1][4] == .list([.string("Expenses:Food"), .string("Assets:Cash")]))
    }

    @Test func runQueryAgainstPricesTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())
        let result = try engine.run(
            "SELECT date, currency, amount FROM prices ORDER BY date",
            in: context
        )

        #expect(result.columns == ["date", "currency", "amount"])
        #expect(result.rows.count == 2)
        #expect(result.rows[0][1] == .string("EUR"))
        #expect(result.rows[0][2] == .amount(Amount(number: Decimal(string: "1.10")!, currency: Currency(id: "USD"))))
        #expect(result.rows[1][2] == .amount(Amount(number: Decimal(string: "1.12")!, currency: Currency(id: "USD"))))
    }

    @Test func runQueryAgainstBalancesTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())
        let result = try engine.run(
            "SELECT date, account, amount, tolerance, discrepancy FROM balances",
            in: context
        )

        #expect(result.columns == ["date", "account", "amount", "tolerance", "discrepancy"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][1] == .string("Assets:Cash"))
        #expect(result.rows[0][2] == .amount(Amount(number: 920, currency: Currency(id: "USD"))))
        #expect(result.rows[0][4] == .null)
    }

    @Test func runQueryAgainstNotesTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())
        let result = try engine.run(
            "SELECT date, account, comment FROM notes",
            in: context
        )

        #expect(result.columns == ["date", "account", "comment"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][1] == .string("Assets:Cash"))
        #expect(result.rows[0][2] == .string("Reconciled with statement"))
    }

    @Test func runQueryAgainstEventsTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())
        let result = try engine.run(
            "SELECT date, type, description FROM events",
            in: context
        )

        #expect(result.columns == ["date", "type", "description"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][1] == .string("location"))
        #expect(result.rows[0][2] == .string("Tokyo"))
    }

    @Test func runWildcardSelectsExposeNewDirectiveColumns() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())

        let prices = try engine.run("SELECT * FROM prices", in: context)
        #expect(prices.columns == ["amount", "currency", "date"])

        let balances = try engine.run("SELECT * FROM balances", in: context)
        #expect(balances.columns == ["account", "amount", "date", "discrepancy", "tolerance"])

        let notes = try engine.run("SELECT * FROM notes", in: context)
        #expect(notes.columns == ["account", "comment", "date", "links", "tags"])

        let events = try engine.run("SELECT * FROM events", in: context)
        #expect(events.columns == ["date", "description", "type"])

        let transactions = try engine.run("SELECT * FROM transactions", in: context)
        #expect(transactions.columns == ["accounts", "date", "flag", "links", "narration", "payee", "tags"])
    }

    @Test func runBudgetSearchQueriesLikeBeanQuery() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleBudgetSearchLedger())

        let descriptionResult = try engine.run(
            "SELECT DISTINCT description FROM description ~ '预算|budget|Budget|目标|goal' ORDER BY description LIMIT 20",
            in: context
        )
        #expect(descriptionResult.columns == ["description"])
        #expect(descriptionResult.rows == [
            [.string("Planner | Budget 2024")],
            [.string("Planner | 目标储蓄")],
        ])

        let narrationResult = try engine.run(
            "SELECT DISTINCT narration WHERE narration ~ '预算|budget|Budget|目标|goal' ORDER BY narration LIMIT 20",
            in: context
        )
        #expect(narrationResult.columns == ["narration"])
        #expect(narrationResult.rows == [
            [.string("Budget 2024")],
            [.string("目标储蓄")],
        ])

        let budgetMetaResult = try engine.run(
            "SELECT DISTINCT str(any_meta('budget')) AS budget_meta WHERE str(any_meta('budget')) != 'None' GROUP BY str(any_meta('budget')) ORDER BY budget_meta LIMIT 20",
            in: context
        )
        #expect(budgetMetaResult.columns == ["budget_meta"])
        #expect(budgetMetaResult.rows == [
            [.string("annual")],
            [.string("savings")],
        ])
    }

}
