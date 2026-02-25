import Foundation
import Testing
import BeancountSwift
@testable import BeanQuerySwift

@Suite
struct BuiltinFunctionExecutionTests {
    private let engine = BeanQueryEngine()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar(identifier: .gregorian).date(
            from: DateComponents(year: year, month: month, day: day)
        )!
    }

    private func todayDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components)!
    }

    @Test func runUnitsAndCostOnAggregatedInventory() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
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
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
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
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
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

    @Test func runConvertFunctionsOnLotData() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())

        let convertedPositions = try engine.run(
            "SELECT convert(position, 'USD') AS converted FROM postings WHERE account = 'Assets:Brokerage' ORDER BY date",
            in: context
        )
        #expect(convertedPositions.columns == ["converted"])
        #expect(convertedPositions.rows == [
            [.amount(Amount(number: 1200, currency: Currency(id: "USD")))],
            [.amount(Amount(number: 600, currency: Currency(id: "USD")))],
        ])

        let convertedInventory = try engine.run(
            "SELECT convert(sum(position), 'USD') AS converted FROM postings WHERE account = 'Assets:Brokerage'",
            in: context
        )
        #expect(convertedInventory.columns == ["converted"])
        #expect(convertedInventory.rows.count == 1)
        guard case .inventory(let converted) = convertedInventory.rows[0][0] else {
            Issue.record("expected converted inventory")
            return
        }
        let expected: Inventory = "1800 USD"
        #expect(converted == expected)
    }

    @Test func runInventoryHelpersFromQueryEnv() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run(
            "SELECT only('USD', cost(sum(position))) AS usd_cost, empty(sum(position)) AS is_empty, filter_currency(sum(position), 'VTI') AS vti_lots FROM postings WHERE account = 'Assets:Brokerage'",
            in: context
        )

        #expect(result.columns == ["usd_cost", "is_empty", "vti_lots"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][0] == .amount(Amount(number: 1550, currency: Currency(id: "USD"))))
        #expect(result.rows[0][1] == .bool(false))

        guard case .inventory(let vtiLots) = result.rows[0][2] else {
            Issue.record("expected filtered inventory")
            return
        }
        let expectedLots: Inventory = "10 VTI {100 USD, 2024-01-15}, 5 VTI {110 USD, 2024-02-10}"
        #expect(vtiLots == expectedLots)
    }

    @Test func runAmountHelpersFromQueryEnv() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run(
            "SELECT number(convert(position, 'USD')) AS number, currency(convert(position, 'USD')) AS currency, commodity(convert(position, 'USD')) AS commodity, filter_currency(position, 'USD') AS usd_only FROM postings WHERE account = 'Assets:Brokerage' ORDER BY date LIMIT 1",
            in: context
        )

        #expect(result.columns == ["number", "currency", "commodity", "usd_only"])
        #expect(result.rows == [
            [.decimal(Decimal(1200)), .string("USD"), .string("USD"), .null]
        ])
    }

    @Test func runGetPriceFunction() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run(
            "SELECT getprice('VTI', 'USD') AS px FROM #",
            in: context
        )

        #expect(result.columns == ["px"])
        #expect(result.rows == [[.decimal(Decimal(120))]])
    }

    @Test func runPossignFunction() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT account, possign(number, account) AS signed FROM postings WHERE account IN ('Assets:Cash', 'Income:Salary') ORDER BY account, date",
            in: context
        )

        #expect(result.columns == ["account", "signed"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .decimal(Decimal(1000))],
            [.string("Assets:Cash"), .decimal(Decimal(-80))],
            [.string("Income:Salary"), .decimal(Decimal(1000))],
        ])
    }

    @Test func runDateConstructionAndExtractionFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT date('2024-02-29') AS cast_date, date(2024, 2, 29) AS built_date, year(2024-02-29) AS y, month(2024-02-29) AS m, day(2024-02-29) AS d, yearmonth(2024-02-29) AS ym, quarter(2024-02-29) AS q, weekday(2024-02-29) AS wd FROM #",
            in: context
        )

        let expectedRows: [[RuntimeValue]] = [[
            .date(date(2024, 2, 29)),
            .date(date(2024, 2, 29)),
            .int(2024),
            .int(2),
            .int(29),
            .date(date(2024, 2, 1)),
            .string("2024-Q1"),
            .string("Thu"),
        ]]

        #expect(result.columns == ["cast_date", "built_date", "y", "m", "d", "ym", "q", "wd"])
        #expect(result.rows == expectedRows)
    }

    @Test func runParseDateAndTodayFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT parse_date('2024-03-20') AS parsed_auto, parse_date('20/03/2024', '%d/%m/%Y') AS parsed_fmt, today() AS t FROM #",
            in: context
        )

        #expect(result.columns == ["parsed_auto", "parsed_fmt", "t"])
        #expect(result.rows.count == 1)
        #expect(result.rows[0][0] == .date(date(2024, 3, 20)))
        #expect(result.rows[0][1] == .date(date(2024, 3, 20)))
        #expect(result.rows[0][2] == .date(todayDate()))
    }

    @Test func runDateArithmeticAndTruncationFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT date_diff(2024-03-10, 2024-03-01) AS diff, date_add(2024-03-01, 9) AS added, date_trunc('week', 2024-03-06) AS week_start, date_trunc('quarter', 2024-05-30) AS quarter_start, date_part('weekday', 2024-03-06) AS dow, date_part('isoweekday', 2024-03-06) AS isodow, date_part('week', 2024-01-01) AS week_num, date_part('epoch', 1970-01-03) AS epoch FROM #",
            in: context
        )

        let expectedRows: [[RuntimeValue]] = [[
            .int(9),
            .date(date(2024, 3, 10)),
            .date(date(2024, 3, 4)),
            .date(date(2024, 4, 1)),
            .int(2),
            .int(3),
            .int(1),
            .int(172800),
        ]]

        #expect(result.columns == ["diff", "added", "week_start", "quarter_start", "dow", "isodow", "week_num", "epoch"])
        #expect(result.rows == expectedRows)
    }

    @Test func runIntervalAndDateBinFunctions() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT interval('2 weeks') AS stride, date_bin('1 month', 2024-05-17, 2024-01-01) AS month_bin, date_bin(interval('7 days'), 2024-01-10, 2024-01-01) AS week_bin, date_bin('7 days', 2023-12-30, 2024-01-01) AS before_origin FROM #",
            in: context
        )

        let expectedRows: [[RuntimeValue]] = [[
            .list([.int(0), .int(0), .int(14)]),
            .date(date(2024, 5, 1)),
            .date(date(2024, 1, 8)),
            .date(date(2023, 12, 25)),
        ]]

        #expect(result.columns == ["stride", "month_bin", "week_bin", "before_origin"])
        #expect(result.rows == expectedRows)
    }

    @Test func runDateFunctionsInvalidInputsReturnNull() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT date('not-a-date') AS bad_date, parse_date('not-a-date') AS bad_parse, date_trunc('unknown', 2024-01-01) AS bad_trunc, date_part('unknown', 2024-01-01) AS bad_part, interval('garbage') AS bad_interval, date_bin('0 day', 2024-01-10, 2024-01-01) AS bad_bin FROM #",
            in: context
        )

        let expectedRows: [[RuntimeValue]] = [[.null, .null, .null, .null, .null, .null]]

        #expect(result.columns == ["bad_date", "bad_parse", "bad_trunc", "bad_part", "bad_interval", "bad_bin"])
        #expect(result.rows == expectedRows)
    }

    @Test func runMonthEndNetWorthQueryUsingIntervalArithmetic() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLotLedger())
        let result = try engine.run(
            """
            SELECT
              date_bin(interval('1 month'), date, 1970-01-01)
                + INTERVAL('1 month') - INTERVAL('1 day') AS month_end,
              CONVERT(
                LAST(balance),
                'CNY',
                date_bin(interval('1 month'), LAST(date), 1970-01-01)
                  + INTERVAL('1 month') - INTERVAL('1 day')
              ) AS net_worth_cny
            WHERE
              account_sortkey(account) ~ '^[01]'
            GROUP BY
              month_end
            ORDER BY
              month_end DESC
            LIMIT 5;
            """,
            in: context
        )

        #expect(result.columns == ["month_end", "net_worth_cny"])
        #expect(!result.rows.isEmpty)
        #expect(result.rows[0][0] == .date(date(2024, 2, 29)))

        let monthEnds = Set(result.rows.compactMap { row -> Date? in
            guard case .date(let value) = row[0] else {
                return nil
            }
            return value
        })
        #expect(monthEnds.contains(date(2024, 1, 31)))
    }

    @Test func runDateIntervalOperatorsLikePythonBeanQuery() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let result = try engine.run(
            "SELECT 2016-11-20 + interval('1 months') AS add_month, 2016-11-01 + interval('1 months') - interval('1 days') AS month_end, 2024-02-05 + interval('-1 days') AS prev_day, 2024-02-05 + interval('1 day') + interval('2 days') AS plus_three_days, 2024-05-24 + interval('1 year') AS plus_year, 2024-05-24 + interval('-2 years') AS minus_two_years FROM #",
            in: context
        )

        #expect(result.columns == [
            "add_month",
            "month_end",
            "prev_day",
            "plus_three_days",
            "plus_year",
            "minus_two_years",
        ])
        #expect(result.rows == [[
            .date(date(2016, 12, 20)),
            .date(date(2016, 11, 30)),
            .date(date(2024, 2, 4)),
            .date(date(2024, 2, 8)),
            .date(date(2025, 5, 24)),
            .date(date(2022, 5, 24)),
        ]])
    }
}
