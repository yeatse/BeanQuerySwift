import Foundation
import Testing
@testable import BeanQuerySwift

@Suite(.serialized)
struct BQLExecutionTests {
    private let engine = BeanQueryEngine()

    private var context: QueryContext {
        QueryContext(tables: [
            "postings": [
                [
                    "account": .string("Assets:Cash"),
                    "number": .int(10),
                    "position": .int(10),
                    "year": .int(2024),
                ],
                [
                    "account": .string("Assets:Cash"),
                    "number": .int(5),
                    "position": .int(5),
                    "year": .int(2024),
                ],
                [
                    "account": .string("Assets:Bank"),
                    "number": .int(7),
                    "position": .int(7),
                    "year": .int(2024),
                ],
                [
                    "account": .string("Assets:Bank"),
                    "number": .int(3),
                    "position": .int(3),
                    "year": .int(2023),
                ],
            ]
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

        #expect(result.columns == ["account", "number", "position", "year"])
        #expect(result.rows == [
            [.string("Assets:Cash"), .int(10), .int(10), .int(2024)],
            [.string("Assets:Cash"), .int(5), .int(5), .int(2024)],
        ])
    }
}
