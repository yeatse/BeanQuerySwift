import Foundation
import Testing
@testable import BeanQuerySwift

@Suite(.serialized)
struct BQLCompilerTests {
    private let engine = BeanQueryEngine()

    @Test func compileSelectImplicitGroupBy() throws {
        let compiled = try engine.run("SELECT account, sum(number) FROM #postings")

        #expect(compiled.groupIndexes == [0])
        #expect(compiled.targets.count == 2)
        #expect(compiled.targets[0].name == "account")
        #expect(compiled.targets[1].isAggregate)

        guard case .hash(let tableName) = compiled.source.table else {
            Issue.record("expected hash table source")
            return
        }
        #expect(tableName == "postings")
    }

    @Test func compileBalancesDesugarsToSelectPlan() throws {
        let compiled = try engine.run(
            "BALANCES AT units FROM CLOSE ON 2024-12-31 WHERE account ~ 'Assets:.*'"
        )

        #expect(compiled.targets.count == 3)
        #expect(compiled.targets[0].name == "account")
        #expect(compiled.targets[1].isAggregate)
        #expect(compiled.groupIndexes == [0, 2])

        guard let order = compiled.orderSpec else {
            Issue.record("expected ORDER BY spec")
            return
        }
        #expect(order.count == 1)
        #expect(order[0].index == 2)
        #expect(order[0].ordering == .ascending)

        #expect(compiled.source.qualifiers?.close != nil)
        #expect(compiled.source.qualifiers?.clear == false)

        guard case .named(let tableName) = compiled.source.table else {
            Issue.record("expected named default table source")
            return
        }
        #expect(tableName == "postings")
    }

    @Test func compileInvalidGroupByIndexFails() throws {
        do {
            _ = try engine.run("SELECT account, sum(number) FROM #postings GROUP BY 3")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .invalidGroupByIndex(3))
        }
    }

    @Test func compileOpenAfterCloseFails() throws {
        do {
            _ = try engine.run("SELECT account FROM OPEN ON 2024-02-01 CLOSE ON 2024-01-01")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .closeDateMustFollowOpenDate)
        }
    }

    @Test func compileMixedAggregateAndNonAggregateFails() throws {
        do {
            _ = try engine.run("SELECT number + sum(number) FROM #postings")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .mixedAggregatesAndNonAggregates)
        }
    }

    @Test func compileAggregateOfAggregateFails() throws {
        do {
            _ = try engine.run("SELECT sum(max(number)) FROM #postings")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .aggregatesOfAggregates)
        }
    }

    @Test func compilePositionalPlaceholdersBindsToConstants() throws {
        let compiled = try engine.run(
            "SELECT account FROM #postings WHERE year = %s AND account = %s",
            parameters: .positional([.integer(2024), .string("assets:cash")])
        )

        guard case .and(let filters)? = compiled.filter else {
            Issue.record("expected combined filter")
            return
        }
        #expect(filters.count == 2)
    }

    @Test func compileNamedPlaceholdersBindsToConstants() throws {
        let compiled = try engine.run(
            "SELECT account FROM #postings WHERE year = %(year)s AND account = %(account)s",
            parameters: .named([
                "year": .integer(2024),
                "account": .string("assets:cash"),
            ])
        )

        #expect(compiled.filter != nil)
    }

    @Test func compilePositionalPlaceholderRequiresSequence() throws {
        do {
            _ = try engine.run(
                "SELECT account FROM #postings WHERE year = %s",
                parameters: .named(["year": .integer(2024)])
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .positionalParametersRequired)
        }
    }

    @Test func compileNamedPlaceholderRequiresMapping() throws {
        do {
            _ = try engine.run(
                "SELECT account FROM #postings WHERE year = %(year)s",
                parameters: .positional([.integer(2024)])
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .namedParametersRequired)
        }
    }

    @Test func compileMissingNamedPlaceholderFails() throws {
        do {
            _ = try engine.run(
                "SELECT account FROM #postings WHERE year = %(year)s AND account = %(account)s",
                parameters: .named(["year": .integer(2024)])
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .queryParameterMissing(["account"]))
        }
    }

    @Test func compilePlaceholderCountMismatchFails() throws {
        do {
            _ = try engine.run(
                "SELECT account FROM #postings WHERE year = %s AND day = %s",
                parameters: .positional([.integer(2024)])
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .placeholderCountMismatch(expected: 2, actual: 1))
        }
    }

    @Test func compileMixedPlaceholderStylesFails() throws {
        do {
            _ = try engine.run(
                "SELECT account FROM #postings WHERE year = %s AND account = %(account)s",
                parameters: .named(["account": .string("assets:cash")])
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .mixedPlaceholderStyles)
        }
    }
}
