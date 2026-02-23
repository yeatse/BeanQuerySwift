import Foundation
import Testing
import BeancountSwift
@testable import BeanQuerySwift

@Suite(.serialized)
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
