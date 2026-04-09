import BeancountSwift

enum BeancountTestFixtures {
    static func sampleDirectives() throws -> [Directive<Cost>] {
        try sampleLedger().directives
    }

    static func sampleLedger() throws -> ParsedLedger<Cost> {
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

    static func sampleLotLedger() throws -> ParsedLedger<Cost> {
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

    static func sampleAccountFunctionLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "USD"

        2024-06-23 commodity TEST
          answer: "42"

        2024-06-23 open Assets:Tests
          key: "value"

        2024-06-23 open Expenses:Tests

        2024-06-23 price TEST 2.0 USD

        2024-06-23 * "Test"
          Assets:Tests     10 TEST
          Expenses:Tests

        2024-06-24 close Expenses:Tests
        """)
        return try Loader.load(file: "test-account-functions.bean", contentProvider: provider)
    }

    static func sampleBudgetSearchLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "CNY"

        2024-01-01 open Assets:Cash CNY
        2024-01-01 open Expenses:Plan CNY

        2024-01-05 * "Planner" "Budget 2024"
          budget: "annual"
          Assets:Cash     -100 CNY
          Expenses:Plan    100 CNY

        2024-01-06 * "Planner" "目标储蓄"
          Assets:Cash      -50 CNY
            budget: "savings"
          Expenses:Plan     50 CNY
        """)
        return try Loader.load(file: "test-budget-search.bean", contentProvider: provider)
    }
}

private struct StringContentProvider: ContentProviding {
    var source: String

    func provideContent(for file: String) throws -> String {
        source
    }
}
