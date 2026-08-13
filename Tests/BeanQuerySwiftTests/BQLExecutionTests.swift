import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct BQLExecutionTests {
    private let engine = BeanQueryEngine()

    private final class RowCounter: @unchecked Sendable {
        var yielded = 0
    }

    private struct StreamingProvider: QueryTableProvider {
        let counter: RowCounter

        func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
            QueryRowSequence(makeIterator: {
                var index = 0
                return AnyIterator {
                    guard index < 10 else {
                        return nil
                    }

                    defer {
                        index += 1
                        counter.yielded += 1
                    }

                    return [
                        "number": .int(index),
                        "account": .string(index.isMultiple(of: 2) ? "Assets:Cash" : "Assets:Bank"),
                    ]
                }
            })
        }

        func wildcardColumns(for qualifiers: EvalQualifiers?) throws -> [String] {
            ["account", "number"]
        }
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar(identifier: .gregorian).date(
            from: DateComponents(year: year, month: month, day: day)
        )!
    }

    private var context: QueryContext {
        QueryContext(tables: [
            "postings": [
                [
                    "account": .string("Assets:Cash"),
                    "number": .int(10),
                    "position": .int(10),
                    "balance": .int(10),
                    "year": .int(2024),
                    "date": .date(date(2024, 1, 1)),
                    "flag": .string("*"),
                    "payee": .string("Alice"),
                    "narration": .string("Coffee"),
                ],
                [
                    "account": .string("Assets:Cash"),
                    "number": .int(5),
                    "position": .int(5),
                    "balance": .int(15),
                    "year": .int(2024),
                    "date": .date(date(2024, 1, 2)),
                    "flag": .string("*"),
                    "payee": .string("Bob"),
                    "narration": .string("Lunch"),
                ],
                [
                    "account": .string("Assets:Bank"),
                    "number": .int(7),
                    "position": .int(7),
                    "balance": .int(7),
                    "year": .int(2024),
                    "date": .date(date(2024, 1, 3)),
                    "flag": .string("!"),
                    "payee": .string("Carol"),
                    "narration": .string("Salary"),
                ],
                [
                    "account": .string("Assets:Bank"),
                    "number": .int(3),
                    "position": .int(3),
                    "balance": .int(10),
                    "year": .int(2023),
                    "date": .date(date(2023, 12, 31)),
                    "flag": .string("!"),
                    "payee": .string("Dave"),
                    "narration": .string("Interest"),
                ],
            ],
            "entries": [
                [
                    "id": .int(0),
                    "type": .string("transaction"),
                    "year": .int(2024),
                    "account": .string("Assets:Cash"),
                    "narration": .string("Coffee"),
                ],
                [
                    "id": .int(1),
                    "type": .string("transaction"),
                    "year": .int(2023),
                    "account": .string("Assets:Bank"),
                    "narration": .string("Interest"),
                ],
            ],
        ])
    }

    @Test func runSelectWithFilterAndOrder() throws {
        let result = try engine.run(
            "SELECT account, number FROM #postings WHERE year = 2024 ORDER BY number DESC",
            in: context
        )

        #expect(result.columns == ["account", "number"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .int(10)],
            [.string("Assets:Bank"), .int(7)],
            [.string("Assets:Cash"), .int(5)],
        ])
    }

    @Test func runNumericEqualityAcrossIntAndDecimal() throws {
        let result = try engine.run(
            "SELECT 1 = decimal('1') AS eq, 1 != decimal('1') AS ne FROM #postings LIMIT 1",
            in: context
        )

        #expect(result.columns == ["eq", "ne"])
        #expect(result.rows == [[.bool(true), .bool(false)]])
    }

    @Test func runYearComparisonAgainstTodayArithmetic() throws {
        let calendar = Calendar(identifier: .gregorian)
        let previousYear = calendar.component(.year, from: Date()) - 1
        let dynamicContext = QueryContext(tables: [
            "postings": [
                [
                    "account": .string("Expenses:Food"),
                    "year": .int(previousYear),
                ],
                [
                    "account": .string("Expenses:Food"),
                    "year": .int(previousYear - 1),
                ],
            ],
        ])

        let result = try engine.run(
            "SELECT account, year WHERE account ~ '^Expenses' AND year = year(today()) - 1",
            in: dynamicContext
        )

        #expect(result.columns == ["account", "year"])
        #expect(result.rows == [[.string("Expenses:Food"), .int(previousYear)]])
    }

    @Test func runAnyAllQuantifiersWithTwoCharacterOperators() throws {
        let quantifierContext = QueryContext(tables: [
            "postings": [
                [
                    "account": .string("Assets:Cash"),
                    "number": .int(5),
                    "numbers": .list([.int(5), .int(7)]),
                ],
                [
                    "account": .string("Assets:Bank"),
                    "number": .int(9),
                    "numbers": .list([.int(5), .int(7)]),
                ],
            ],
        ])

        let anyResult = try engine.run(
            "SELECT account WHERE number <= ANY(numbers)",
            in: quantifierContext
        )
        #expect(anyResult.rows == [[.string("Assets:Cash")]])

        let allResult = try engine.run(
            "SELECT account WHERE number >= ALL(numbers)",
            in: quantifierContext
        )
        #expect(allResult.rows == [[.string("Assets:Bank")]])

        let strictAny = try engine.run(
            "SELECT account WHERE number < ANY(numbers)",
            in: quantifierContext
        )
        #expect(strictAny.rows == [[.string("Assets:Cash")]])

        let strictAll = try engine.run(
            "SELECT account WHERE number > ALL(numbers)",
            in: quantifierContext
        )
        #expect(strictAll.rows == [[.string("Assets:Bank")]])
    }

    @Test func runSelectGroupByAggregate() throws {
        let result = try engine.run(
            "SELECT account, sum(number) AS total FROM #postings WHERE year = 2024 GROUP BY account ORDER BY total DESC",
            in: context
        )

        #expect(result.columns == ["account", "total"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .int(15)],
            [.string("Assets:Bank"), .int(7)],
        ])
    }

    @Test func runBalancesQuery() throws {
        let result = try engine.run(
            "BALANCES AT units WHERE year = 2024",
            in: context
        )

        #expect(result.columns == ["account", "sum"])
        #expect(result.rows == [
            [.string("Assets:Bank"), .int(7)],
            [.string("Assets:Cash"), .int(15)],
        ])
    }

    @Test func runSelectWithPositionalParameters() throws {
        let result = try engine.run(
            "SELECT account, number FROM #postings WHERE year = %s ORDER BY number DESC",
            parameters: .positional([.integer(2024)]),
            in: context
        )

        #expect(result.columns == ["account", "number"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .int(10)],
            [.string("Assets:Bank"), .int(7)],
            [.string("Assets:Cash"), .int(5)],
        ])
    }

    @Test func runSelectWithNamedParameters() throws {
        let result = try engine.run(
            "SELECT account, number FROM #postings WHERE year = %(year)s AND account = %(account)s",
            parameters: .named([
                "year": .integer(2024),
                "account": .string("Assets:Cash"),
            ]),
            in: context
        )

        #expect(result.columns == ["account", "number"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .int(10)],
            [.string("Assets:Cash"), .int(5)],
        ])
    }

    @Test func runSelectAsteriskExpandsColumns() throws {
        let result = try engine.run(
            "SELECT * FROM #postings WHERE account = 'Assets:Cash' ORDER BY number DESC",
            in: context
        )

        #expect(result.columns == ["account", "balance", "date", "flag", "narration", "number", "payee", "position", "year"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .int(10), .date(date(2024, 1, 1)), .string("*"), .string("Coffee"), .int(10), .string("Alice"), .int(10), .int(2024)],
            [.string("Assets:Cash"), .int(15), .date(date(2024, 1, 2)), .string("*"), .string("Lunch"), .int(5), .string("Bob"), .int(5), .int(2024)],
        ])
    }

    @Test func runJournalQuery() throws {
        let result = try engine.run(
            "JOURNAL 'Assets:Cash' AT cost",
            in: context
        )

        #expect(result.columns == ["date", "flag", "maxwidth", "maxwidth", "account", "cost", "cost"])
        #expect(result.rows.count == 2)
        #expect(result.rows[0][4] == .string("Assets:Cash"))
        #expect(result.rows[0][5] == .int(10))
        #expect(result.rows[0][6] == .int(10))
    }

    @Test func runPrintQuery() throws {
        let ledger = try BeancountTestFixtures.sampleLedger()
        let result = try engine.run("PRINT", in: ledger)

        #expect(result.columns == ["ROW(*)"])
        #expect(result.rows.count == ledger.directives.count)
        for row in result.rows {
            #expect(row.count == 1)
            guard case .directive = row[0] else {
                Issue.record("expected directive runtime value")
                continue
            }
        }
    }

    @Test func runPivotByQuery() throws {
        let result = try engine.run(
            "SELECT account, year, sum(number) AS total FROM #postings GROUP BY account, year PIVOT BY 1, 2",
            in: context
        )

        #expect(result.columns == ["account/year", "2023", "2024"])
        #expect(result.rows == [
            [.string("Assets:Bank"), .int(3), .int(7)],
            [.string("Assets:Cash"), .null, .int(15)],
        ])
    }

    @Test func runSimpleLimitQueryStopsStreamingProviderEarly() throws {
        let counter = RowCounter()
        let context = QueryContext(
            providers: ["postings": StreamingProvider(counter: counter)],
            priceMap: nil
        )

        let result = try engine.run(
            "SELECT number FROM postings WHERE account = 'Assets:Cash' LIMIT 2",
            in: context
        )

        #expect(result.columns == ["number"])
        #expect(result.rows == [
            [.int(0)],
            [.int(2)],
        ])
        #expect(counter.yielded == 3)
    }
}
