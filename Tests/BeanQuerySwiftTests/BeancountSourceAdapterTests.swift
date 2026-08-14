import Foundation
import Testing
import BeancountSwift
@testable import BeanQuerySwift

@Suite
struct BeancountSourceAdapterTests {
    private let engine = BeanQueryEngine()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar(identifier: .gregorian).date(
            from: DateComponents(year: year, month: month, day: day)
        )!
    }

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

    /// `balance` is a single running inventory over the rows that reach the
    /// column, in scan order — not a per-account running total. Ground truth,
    /// `bean-query` on the same ledger:
    ///
    /// ```
    ///    account     numbe   balance
    /// -------------  -----  ---------
    /// Assets:Cash     1000   1000 USD
    /// Income:Salary  -1000
    /// Expenses:Food     80     80 USD
    /// Assets:Cash      -80
    /// ```
    @Test func runBalanceColumnIsSingleRunningInventoryInScanOrder() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run("SELECT account, balance FROM postings", in: context)

        let expected: [(String, Inventory)] = [
            ("Assets:Cash", "1000 USD"),
            ("Income:Salary", Inventory()),
            ("Expenses:Food", "80 USD"),
            ("Assets:Cash", Inventory()),
        ]
        #expect(result.rows == expected.map { [.string($0.0), .inventory($0.1)] })
    }

    /// Rows rejected by `WHERE` never touch the accumulator, so a filtered
    /// query yields the running total of the filtered rows. `bean-query`:
    /// `Assets:Cash 1000 → 1000 USD`, `Assets:Cash -80 → 920 USD`.
    @Test func runBalanceColumnAccumulatesOnlyOverRowsPassingTheFilter() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT number, balance FROM postings WHERE account = 'Assets:Cash'",
            in: context
        )

        let expected: [(Decimal, Inventory)] = [(1000, "1000 USD"), (-80, "920 USD")]
        #expect(result.rows == expected.map { [.decimal($0.0), .inventory($0.1)] })
    }

    /// Reading `balance` twice for the same row must not advance the running
    /// inventory twice; `bean-query` prints identical values in both columns.
    @Test func runBalanceColumnSelectedTwiceDoesNotDoubleCount() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run("SELECT balance, balance FROM postings", in: context)

        let expected: [Inventory] = ["1000 USD", Inventory(), "80 USD", Inventory()]
        #expect(result.rows == expected.map { [.inventory($0), .inventory($0)] })
    }

    /// Grouping buffers rows before evaluating them, but `balance` must still
    /// accumulate in source scan order — beanquery updates its aggregates in a
    /// single pass over the scan. `bean-query`:
    ///
    /// ```
    ///    account     last(ba
    /// -------------  -------
    /// Assets:Cash
    /// Income:Salary
    /// Expenses:Food   80 USD
    /// ```
    @Test func runGroupedBalanceAccumulatesInScanOrder() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let query = "SELECT account, last(balance) FROM postings GROUP BY account"

        let expected: [(String, Inventory)] = [
            ("Assets:Cash", Inventory()),
            ("Income:Salary", Inventory()),
            ("Expenses:Food", "80 USD"),
        ]
        let expectedRows = expected.map { [RuntimeValue.string($0.0), .inventory($0.1)] }

        // Groups used to come out of a Swift Dictionary, so both the values and
        // their order changed from run to run.
        for _ in 0..<3 {
            #expect(try engine.run(query, in: context).rows == expectedRows)
        }
    }

    /// Every aggregate over a group re-reads the group's rows; that must not
    /// advance the running inventory again. `bean-query`:
    ///
    /// ```
    ///    account     first(bal  last(ba
    /// -------------  ---------  -------
    /// Assets:Cash     1000 USD
    /// Income:Salary
    /// Expenses:Food     80 USD   80 USD
    /// ```
    @Test func runRepeatedGroupedBalanceAggregatesDoNotDoubleCount() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT account, first(balance), last(balance) FROM postings GROUP BY account",
            in: context
        )

        let expected: [(String, Inventory, Inventory)] = [
            ("Assets:Cash", "1000 USD", Inventory()),
            ("Income:Salary", Inventory(), Inventory()),
            ("Expenses:Food", "80 USD", "80 USD"),
        ]
        #expect(result.rows == expected.map { [.string($0.0), .inventory($0.1), .inventory($0.2)] })
    }

    /// Without `ORDER BY`, groups come out in first-appearance order, like
    /// beanquery iterating its insertion-ordered aggregates dict. `bean-query`:
    /// `Assets:Cash 920`, `Income:Salary -1000`, `Expenses:Food 80`.
    @Test func runGroupedRowsKeepFirstAppearanceOrder() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let query = "SELECT account, sum(number) FROM postings GROUP BY account"

        let expected: [(String, Decimal)] = [
            ("Assets:Cash", 920),
            ("Income:Salary", -1000),
            ("Expenses:Food", 80),
        ]
        let expectedRows = expected.map { [RuntimeValue.string($0.0), .decimal($0.1)] }

        for _ in 0..<3 {
            #expect(try engine.run(query, in: context).rows == expectedRows)
        }
    }

    /// Qualifiers rebuild the directive list before the scan, so the running
    /// inventory also covers the synthetic transfer postings. `bean-query`:
    ///
    /// ```
    ///         account          numbe   balance
    /// -----------------------  -----  ---------
    /// Assets:Cash               1000   1000 USD
    /// Income:Salary            -1000
    /// Expenses:Food               80     80 USD
    /// Assets:Cash                -80
    /// Expenses:Food              -80    -80 USD
    /// Equity:Earnings:Current     80
    /// Income:Salary             1000   1000 USD
    /// Equity:Earnings:Current  -1000
    /// ```
    @Test func runBalanceColumnCoversSummarizedPostingsUnderQualifiers() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run("SELECT account, balance FROM CLEAR", in: context)

        let expected: [(String, Inventory)] = [
            ("Assets:Cash", "1000 USD"),
            ("Income:Salary", Inventory()),
            ("Expenses:Food", "80 USD"),
            ("Assets:Cash", Inventory()),
            ("Expenses:Food", "-80 USD"),
            ("Equity:Earnings:Current", Inventory()),
            ("Income:Salary", "1000 USD"),
            ("Equity:Earnings:Current", Inventory()),
        ]
        #expect(result.rows == expected.map { [.string($0.0), .inventory($0.1)] })
    }

    /// The accumulator lives on the iterator, not on the table provider, so a
    /// second run of the same query starts from an empty inventory again.
    @Test func runBalanceColumnRestartsOnEveryQueryRun() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let query = "SELECT account, balance FROM postings"

        let first = try engine.run(query, in: context)
        let second = try engine.run(query, in: context)

        #expect(first.rows == second.rows)
        #expect(first.rows.first == [.string("Assets:Cash"), .inventory("1000 USD")])
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

    @Test func runOtherAccountsIsASetOfAccounts() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.repeatedAccountsLedger())
        let result = try engine.run(
            "SELECT account, other_accounts FROM postings ORDER BY account, number",
            in: context
        )

        #expect(result.columns == ["account", "other_accounts"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .list([.string("Expenses:Food")])],
            [.string("Expenses:Food"), .list([.string("Assets:Cash"), .string("Expenses:Food")])],
            [.string("Expenses:Food"), .list([.string("Assets:Cash"), .string("Expenses:Food")])],
        ])
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

    /// `id` is a string derived from the directive's contents, so every posting
    /// of a transaction reports its parent's id and distinct transactions get
    /// distinct ids. Beancount does the same with an md5 of the directive.
    @Test func runIDIsAPerDirectiveString() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run("SELECT id, narration FROM postings", in: context)

        let ids = result.rows.map { row -> String in
            guard case .string(let id) = row[0] else {
                Issue.record("expected a string id, got \(row[0])")
                return ""
            }
            return id
        }

        #expect(ids.count == 4)
        #expect(ids[0] == ids[1])  // both postings of the salary transaction
        #expect(ids[2] == ids[3])  // both postings of the groceries transaction
        #expect(ids[0] != ids[2])
        #expect(ids.allSatisfy { !$0.isEmpty })
    }

    /// The id has to identify the directive, not its position in the scan:
    /// qualifiers rebuild the directive list (`OPEN` prepends summarization
    /// entries), and a transaction that survives that must keep its id.
    @Test func runIDIsStableAcrossQualifiersAndRuns() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())

        func groceriesID(_ query: String) throws -> String {
            let result = try engine.run(query, in: context)
            for row in result.rows where row[1] == .string("Groceries") {
                guard case .string(let id) = row[0] else { break }
                return id
            }
            Issue.record("no groceries row in: \(query)")
            return ""
        }

        let plain = try groceriesID("SELECT id, narration FROM postings")
        let rerun = try groceriesID("SELECT id, narration FROM postings")
        let opened = try groceriesID("SELECT id, narration FROM OPEN ON 2024-01-11")
        let cleared = try groceriesID("SELECT id, narration FROM CLEAR")
        let fromEntries = try groceriesID("SELECT id, narration FROM entries")

        #expect(!plain.isEmpty)
        #expect(rerun == plain)
        #expect(opened == plain)
        #expect(cleared == plain)
        #expect(fromEntries == plain)
    }

    /// `SELECT *` on `postings` expands to beancount's five wildcard columns,
    /// in beancount's order — not to every column the table can serve.
    /// `PostingsTable.wildcard_columns = 'date flag payee narration position'`.
    @Test func runSelectAsteriskMatchesUpstreamPostingsWildcard() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run("SELECT * FROM postings", in: context)

        #expect(result.columns == ["date", "flag", "payee", "narration", "position"])
    }

    /// `SELECT *` on `entries` expands to all of the table's columns in
    /// declaration order, which is what beancount does for that table.
    @Test func runSelectAsteriskMatchesUpstreamEntriesWildcard() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run("SELECT * FROM entries", in: context)

        #expect(result.columns == [
            "id", "type", "filename", "lineno", "date", "year", "month", "day",
            "flag", "payee", "narration", "description", "tags", "links", "meta", "accounts",
        ])
    }

    /// Columns outside the wildcard set stay queryable by name; `balance` in
    /// particular still tracks the rows the query selects.
    @Test func runNonWildcardColumnsRemainSelectableByName() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run(
            """
            SELECT balance, tags, links, other_accounts FROM postings \
            WHERE account = 'Assets:Brokerage' ORDER BY date
            """,
            in: context
        )

        #expect(result.columns == ["balance", "tags", "links", "other_accounts"])
        #expect(result.rows.count == 2)

        guard case .inventory(let firstBalance) = result.rows[0][0],
              case .inventory(let secondBalance) = result.rows[1][0]
        else {
            Issue.record("expected running lot inventory in balance column")
            return
        }

        let expectedFirst: Inventory = "10 VTI {100 USD, 2024-01-15}"
        let expectedSecond: Inventory = "10 VTI {100 USD, 2024-01-15}, 5 VTI {110 USD, 2024-02-10}"
        #expect(firstBalance == expectedFirst)
        #expect(secondBalance == expectedSecond)
        #expect(result.rows[0][1] == .list([]))
        #expect(result.rows[0][2] == .list([]))
        #expect(result.rows[0][3] == .list([.string("Assets:Cash")]))
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

    @Test func runQueryAgainstCustomTable() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())
        let result = try engine.run(
            "SELECT date, type, values FROM custom ORDER BY date",
            in: context
        )

        #expect(result.columns == ["date", "type", "values"])
        #expect(result.rows.count == 2)
        #expect(result.rows[0][1] == .string("budget"))
        #expect(result.rows[0][2] == .list([
            .string("Expenses:Food"),
            .string("monthly"),
            .amount(Amount(number: 500, currency: Currency(id: "USD"))),
        ]))
        #expect(result.rows[1][1] == .string("fiscal-year-end"))
        #expect(result.rows[1][2] == .list([.date(date(2024, 12, 31))]))
    }

    @Test func runQueryAgainstCustomTableFiltersAndExposesMeta() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())

        let filtered = try engine.run(
            "SELECT date FROM custom WHERE type = 'budget'",
            in: context
        )
        #expect(filtered.rows.count == 1)

        let meta = try engine.run("SELECT meta FROM custom WHERE type = 'budget'", in: context)
        #expect(meta.columns == ["meta"])
        guard case .dict(let values)? = meta.rows.first?.first else {
            Issue.record("expected meta dictionary")
            return
        }
        #expect(values["source"] == .string("planner"))
    }

    @Test func runWildcardSelectsExposeNewDirectiveColumns() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.directiveTablesLedger())

        let prices = try engine.run("SELECT * FROM prices", in: context)
        #expect(prices.columns == ["date", "currency", "amount"])

        let balances = try engine.run("SELECT * FROM balances", in: context)
        #expect(balances.columns == ["date", "account", "amount", "tolerance", "discrepancy"])

        let notes = try engine.run("SELECT * FROM notes", in: context)
        #expect(notes.columns == ["date", "account", "comment", "tags", "links"])

        let events = try engine.run("SELECT * FROM events", in: context)
        #expect(events.columns == ["date", "type", "description"])

        let custom = try engine.run("SELECT * FROM custom", in: context)
        #expect(custom.columns == ["date", "type", "values"])

        let transactions = try engine.run("SELECT * FROM transactions", in: context)
        #expect(transactions.columns == ["date", "flag", "payee", "narration", "tags", "links", "accounts"])

        let accounts = try engine.run("SELECT * FROM accounts", in: context)
        #expect(accounts.columns == ["account", "open", "close"])

        let commodities = try engine.run("SELECT * FROM commodities", in: context)
        #expect(commodities.columns == ["meta", "date", "name"])
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
