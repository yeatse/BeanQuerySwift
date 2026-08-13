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

        2024-01-10 * "Employer" "Salary" #income ^job
          Assets:Cash      1000 USD
          Income:Salary   -1000 USD

        2024-01-12 * "Store" "Groceries" #food #groceries ^receipt
          ! Expenses:Food      80 USD
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

    static func repeatedAccountsLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "USD"

        2024-01-01 open Assets:Cash USD
        2024-01-01 open Expenses:Food USD

        2024-01-10 * "Store" "Split payment"
          Expenses:Food       30 USD
          Expenses:Food       20 USD
          Assets:Cash        -50 USD
        """)
        return try Loader.load(file: "test-repeated-accounts.bean", contentProvider: provider)
    }

    static func directiveTablesLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "USD"

        2024-01-01 open Assets:Cash USD
        2024-01-01 open Income:Salary USD
        2024-01-01 open Expenses:Food USD

        2024-01-10 * "Employer" "Salary" #income ^job
          Assets:Cash      1000 USD
          Income:Salary   -1000 USD

        2024-01-12 * "Store" "Groceries" #food
          Expenses:Food      80 USD
          Assets:Cash       -80 USD

        2024-01-15 price EUR 1.10 USD
          source: "manual"

        2024-01-16 price EUR 1.12 USD

        2024-01-20 balance Assets:Cash 920 USD
          checked: "yes"

        2024-01-21 note Assets:Cash "Reconciled with statement"

        2024-01-22 event "location" "Tokyo"

        2024-01-23 custom "budget" "Expenses:Food" "monthly" 500.00 USD
          source: "planner"

        2024-01-24 custom "fiscal-year-end" 2024-12-31
        """)
        return try Loader.load(file: "test-directive-tables.bean", contentProvider: provider)
    }

    static func bqlReferenceLedger() throws -> ParsedLedger<Cost> {
        let provider = StringContentProvider(source: """
        option "operating_currency" "CNY"

        2026-01-01 open Assets:Cash CNY
        2026-01-01 open Assets:Bank CNY
        2026-01-01 open Liabilities:CreditCard CNY
        2026-01-01 open Income:Salary CNY
        2026-01-01 open Expenses:Food:Restaurant CNY
        2026-01-01 open Expenses:Food:Groceries CNY
        2026-01-01 open Expenses:Transport CNY
        2026-01-01 open Equity:Opening-Balances CNY

        2026-01-02 * "Init" "Opening"
          Assets:Cash                  5000 CNY
          Equity:Opening-Balances     -5000 CNY

        2026-04-03 * "Salary Co" "Monthly salary"
          Assets:Bank                  8000 CNY
          Income:Salary               -8000 CNY

        2026-04-05 * "Cafe" "Dining out"
          payer: "Alice"
          Expenses:Food:Restaurant      120 CNY
          Assets:Cash                  -120 CNY

        2026-04-10 * "Market" "Weekly groceries"
          payer: "Bob"
          Expenses:Food:Groceries       350 CNY
          Assets:Cash                  -350 CNY

        2026-04-15 * "Metro" "Subway pass"
          Expenses:Transport             80 CNY
          Liabilities:CreditCard        -80 CNY

        2026-04-20 * "Restaurant" "Dinner"
          payer: "Alice"
          Expenses:Food:Restaurant      200 CNY
          Liabilities:CreditCard       -200 CNY

        2026-04-25 price USD 7.20 CNY
        2026-04-26 price USD 7.21 CNY
        2026-04-27 price USD 7.22 CNY
        """)
        return try Loader.load(file: "test-bql-reference.bean", contentProvider: provider)
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
