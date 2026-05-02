import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct BuiltinAccountFunctionExecutionTests {
    private let engine = BeanQueryEngine()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar(identifier: .gregorian).date(
            from: DateComponents(year: year, month: month, day: day)
        )!
    }

    @Test func runRootParentLeafFunctions() throws {
        let result = try engine.run(
            "SELECT root('Assets:Foo:Bar', 2) AS root_two, root('Assets:Foo:Bar') AS root_one, parent('Assets:Foo:Bar') AS parent, leaf('Assets:Foo:Bar') AS leaf, parent('Assets') AS root_parent, leaf('') AS empty_leaf FROM #",
            in: QueryContext()
        )

        #expect(result.columns == ["root_two", "root_one", "parent", "leaf", "root_parent", "empty_leaf"])
        #expect(result.rows == [[
            .string("Assets:Foo"),
            .string("Assets"),
            .string("Assets:Foo"),
            .string("Bar"),
            .string(""),
            .null,
        ]])
    }

    @Test func runRegexAndCaseFunctions() throws {
        let result = try engine.run(
            "SELECT grep('in', 'prev match in context next') AS grep_match, grepn('match (.*) context', 'prev match in context next', 1) AS grep_group, subst('thing', 't', 'Buy thing thing') AS replaced, upper('aBc') AS uppered, lower('aBc') AS lowered FROM #",
            in: QueryContext()
        )

        #expect(result.columns == ["grep_match", "grep_group", "replaced", "uppered", "lowered"])
        #expect(result.rows == [[
            .string("in"),
            .string("in"),
            .string("Buy t t"),
            .string("ABC"),
            .string("abc"),
        ]])
    }

    @Test func runOpenDateAndCloseDateFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleAccountFunctionLedger())
        let result = try engine.run(
            "SELECT open_date('Expenses:Tests') AS open_date, close_date('Expenses:Tests') AS close_date, close_date('Assets:Tests') AS assets_close, open_date('Expenses:Missing') AS missing_open FROM #",
            in: context
        )

        #expect(result.columns == ["open_date", "close_date", "assets_close", "missing_open"])
        #expect(result.rows == [[
            .date(date(2024, 6, 23)),
            .date(date(2024, 6, 24)),
            .null,
            .null,
        ]])
    }

    @Test func runOpenMetaFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleAccountFunctionLedger())
        let result = try engine.run(
            "SELECT open_meta('Assets:Tests') AS meta, open_meta('Assets:Tests', 'key') AS key_value, open_meta('Expenses:Missing', 'key') AS missing FROM #",
            in: context
        )

        #expect(result.columns == ["meta", "key_value", "missing"])
        #expect(result.rows.count == 1)

        guard case .dict(let metadata) = result.rows[0][0] else {
            Issue.record("expected metadata dictionary")
            return
        }
        #expect(metadata["key"] == .string("value"))
        #expect(result.rows[0][1] == .string("value"))
        #expect(result.rows[0][2] == .null)
    }

    @Test func runCurrencyMetaFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleAccountFunctionLedger())
        let result = try engine.run(
            "SELECT currency_meta('TEST') AS meta, currency_meta('TEST', 'answer') AS answer, currency_meta('X', 'answer') AS missing FROM #",
            in: context
        )

        #expect(result.columns == ["meta", "answer", "missing"])
        #expect(result.rows.count == 1)

        guard case .dict(let metadata) = result.rows[0][0] else {
            Issue.record("expected commodity metadata dictionary")
            return
        }
        #expect(metadata["answer"] == .string("42"))
        #expect(result.rows[0][1] == .string("42"))
        #expect(result.rows[0][2] == .null)
    }

    @Test func runAccountSortKeyFunction() throws {
        let result = try engine.run(
            "SELECT account_sortkey('Assets:Foo') AS assets, account_sortkey('Liabilities:Foo') AS liabilities, account_sortkey('Equity:Foo') AS equity, account_sortkey('Income:Foo') AS income, account_sortkey('Expenses:Foo') AS expenses FROM #",
            in: QueryContext()
        )

        #expect(result.columns == ["assets", "liabilities", "equity", "income", "expenses"])
        #expect(result.rows == [[
            .string("0-Assets:Foo"),
            .string("1-Liabilities:Foo"),
            .string("2-Equity:Foo"),
            .string("3-Income:Foo"),
            .string("4-Expenses:Foo"),
        ]])
    }

    @Test func runHasAccountFunction() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleAccountFunctionLedger())

        let entriesResult = try engine.run(
            "SELECT has_account('Assets:Tests') AS has_assets, has_account('Assets:Missing') AS has_missing FROM entries WHERE type = 'transaction'",
            in: context
        )
        #expect(entriesResult.columns == ["has_assets", "has_missing"])
        #expect(entriesResult.rows == [[.bool(true), .bool(false)]])

        let postingResult = try engine.run(
            "SELECT has_account('Assets:Tests') AS has_assets FROM postings WHERE account = 'Expenses:Tests'",
            in: context
        )
        #expect(postingResult.columns == ["has_assets"])
        #expect(postingResult.rows == [[.bool(true)]])
    }

    @Test func runFindfirstFunction() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleAccountFunctionLedger())
        let result = try engine.run(
            "SELECT findfirst('Assets:.*', accounts) AS matched, findfirst('Liabilities:.*', accounts) AS missing FROM entries WHERE type = 'transaction'",
            in: context
        )

        #expect(result.columns == ["matched", "missing"])
        #expect(result.rows == [[.string("Assets:Tests"), .null]])
    }

    @Test func runFindfirstSortsCandidatesBeforeMatching() throws {
        let context = QueryContext(tables: [
            "entries": [[
                "accounts": .list([.string("Expenses:Zed"), .string("Assets:Alpha"), .string("Assets:Beta")]),
            ]]
        ])
        let result = try engine.run(
            "SELECT findfirst('Assets:.*', accounts) AS matched FROM entries",
            in: context
        )

        #expect(result.columns == ["matched"])
        #expect(result.rows == [[.string("Assets:Alpha")]])
    }

    @Test func runJoinstrFunction() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleAccountFunctionLedger())
        let result = try engine.run(
            "SELECT joinstr(accounts) AS joined FROM entries WHERE type = 'transaction'",
            in: context
        )

        #expect(result.columns == ["joined"])
        #expect(result.rows == [[.string("Assets:Tests,Expenses:Tests")]])
    }
}
