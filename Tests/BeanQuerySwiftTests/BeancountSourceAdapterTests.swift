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
}

private struct StringContentProvider: ContentProviding {
    var source: String

    func provideContent(for file: String) throws -> String {
        source
    }
}
