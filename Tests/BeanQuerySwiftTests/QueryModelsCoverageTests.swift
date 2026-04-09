import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct QueryModelsCoverageTests {
    private struct StaticProvider: QueryTableProvider {
        let value: [QueryRow]

        func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
            QueryRowSequence(value)
        }
    }

    private struct StreamingProvider: QueryTableProvider {
        func rows(for qualifiers: EvalQualifiers?) throws -> QueryRowSequence {
            QueryRowSequence(makeIterator: {
                var index = 0
                return AnyIterator {
                    guard index < 2 else {
                        return nil
                    }
                    defer { index += 1 }
                    if index == 0 {
                        return ["z": .int(1), "a": .int(2)]
                    }
                    return ["m": .int(3)]
                }
            })
        }
    }

    @Test func queryTableProviderDefaultWildcardColumnsSortsUnion() throws {
        let provider = StaticProvider(value: [
            ["z": .int(1), "a": .int(2)],
            ["m": .int(3)],
        ])

        let columns = try provider.wildcardColumns(for: nil)
        #expect(columns == ["a", "m", "z"])
    }

    @Test func queryTableProviderDefaultWildcardColumnsSupportsStreamingRows() throws {
        let columns = try StreamingProvider().wildcardColumns(for: nil)
        #expect(columns == ["a", "m", "z"])
    }

    @Test func queryContextWildcardColumnsAndProviderLookup() throws {
        let providerRows: [QueryRow] = [
            ["currency": .string("USD"), "number": .int(1)],
            ["account": .string("Assets:Cash")],
        ]

        let context = QueryContext(
            tables: [
                "postings": [
                    ["b": .int(1), "a": .int(2)],
                ]
            ],
            providers: ["entries": StaticProvider(value: providerRows)],
            priceMap: nil
        )

        #expect(context.provider(named: "entries") != nil)
        #expect(context.provider(named: "missing") == nil)

        let providerColumns = try context.wildcardColumns(table: "entries", qualifiers: nil)
        #expect(providerColumns == ["account", "currency", "number"])

        let tableColumns = try context.wildcardColumns(table: "postings", qualifiers: nil)
        #expect(tableColumns == ["a", "b"])

        let missingColumns = try context.wildcardColumns(table: "missing", qualifiers: nil)
        #expect(missingColumns == nil)
    }

    @Test func executionErrorDescriptionsCoverAllCases() {
        let samples: [(BQLExecutionError, String)] = [
            (.tableNotFound("postings"), "table not found: postings"),
            (.qualifiersUnsupported("entries"), "FROM qualifiers are unsupported for table: entries"),
            (.unsupportedExpression("expr"), "unsupported expression: expr"),
            (.unsupportedFunction("fn"), "unsupported function: fn"),
            (.unsupportedOperator, "unsupported operator"),
            (.invalidType, "invalid runtime type"),
            (.invalidPivotByColumns, "invalid PIVOT BY columns"),
        ]

        for (error, expected) in samples {
            #expect(error.errorDescription == expected)
        }
    }
}
