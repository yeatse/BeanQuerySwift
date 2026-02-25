import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct BQLCompilerTests {
    private let engine = BeanQueryEngine()
    private static let compileableQueries: [String] = [
        "SELECT account FROM #postings",
        "SELECT account, number FROM #postings",
        "SELECT DISTINCT account FROM #postings",
        "SELECT account FROM #",
        "SELECT account FROM postings",
        "SELECT account FROM #postings WHERE year = 2024",
        "SELECT account FROM #postings WHERE account ~ 'Assets:.*'",
        "SELECT account FROM #postings WHERE account !~ 'Income:.*'",
        "SELECT account FROM #postings WHERE payee IS NULL",
        "SELECT account FROM #postings WHERE payee IS NOT NULL",
        "SELECT account, number + 1 FROM #postings",
        "SELECT account, number - 1 FROM #postings",
        "SELECT account, number * 2 FROM #postings",
        "SELECT account, number / 2 FROM #postings",
        "SELECT account, number % 2 FROM #postings",
        "SELECT account, -number FROM #postings",
        "SELECT account, sum(number) FROM #postings GROUP BY account",
        "SELECT account, sum(number) FROM #postings GROUP BY 1",
        "SELECT account, sum(number) FROM #postings GROUP BY account HAVING sum(number) > 0",
        "SELECT account, year, sum(number) FROM #postings GROUP BY account, year PIVOT BY 1, 2",
        "SELECT account, year, sum(number) FROM #postings GROUP BY account, year PIVOT BY account, year",
        "SELECT account, sum(number) AS total FROM #postings GROUP BY account ORDER BY total DESC",
        "SELECT account, number FROM #postings ORDER BY number DESC",
        "SELECT account, number FROM #postings ORDER BY 2 ASC",
        "SELECT account, number FROM #postings LIMIT 10",
        "SELECT account FROM OPEN ON 2024-01-01",
        "SELECT account FROM CLOSE",
        "SELECT account FROM CLOSE ON 2024-12-31",
        "SELECT account FROM CLEAR",
        "SELECT account FROM account ~ 'Assets:.*' OPEN ON 2024-01-01 CLOSE ON 2024-12-31 CLEAR",
        "SELECT account FROM (SELECT account FROM #postings)",
        "SELECT * FROM #postings",
        "SELECT root(account) FROM #postings",
        "SELECT root(account, 2) FROM #postings",
        "SELECT parent(account) FROM #postings",
        "SELECT leaf(account) FROM #postings",
        "SELECT grep('Assets:.*', account) FROM #postings",
        "SELECT grepn('(Assets):(.*)', account, 2) FROM #postings",
        "SELECT subst('Assets', 'A', account) FROM #postings",
        "SELECT upper(account) FROM #postings",
        "SELECT lower(account) FROM #postings",
        "SELECT open_date(account) FROM #postings",
        "SELECT close_date(account) FROM #postings",
        "SELECT open_meta(account, 'key') FROM #postings",
        "SELECT has_account('Assets:Cash') FROM #postings",
        "SELECT findfirst('Assets:.*', accounts) FROM entries",
        "SELECT joinstr(accounts) FROM entries",
        "SELECT 1 + 2 FROM #",
        "SELECT true AND false FROM #",
        "SELECT account_sortkey(account) FROM #postings",
        "SELECT convert(position, 'USD') FROM #postings",
        "SELECT getprice('VTI', 'USD') FROM #",
        "SELECT only('USD', cost(sum(position))) FROM #postings",
        "SELECT empty(sum(position)) FROM #postings",
        "SELECT filter_currency(position, 'USD') FROM #postings",
        "SELECT possign(number, account) FROM #postings",
        "SELECT number(convert(position, 'USD')) FROM #postings",
        "SELECT currency(convert(position, 'USD')) FROM #postings",
        "BALANCES",
        "BALANCES WHERE account ~ 'Assets:.*'",
        "BALANCES AT units",
        "BALANCES AT units FROM CLOSE",
        "BALANCES AT units FROM CLOSE ON 2024-12-31 WHERE year = 2024",
        "JOURNAL",
        "JOURNAL 'Assets:Cash'",
        "JOURNAL AT cost",
        "JOURNAL 'Assets:Cash' AT cost FROM CLOSE ON 2024-12-31",
        "PRINT",
        "PRINT FROM CLOSE ON 2024-12-31",
    ]

    @Test(arguments: compileableQueries)
    func compileManyValidQueries(_ query: String) throws {
        let compiled = try engine.run(query)
        #expect(!compiled.targets.isEmpty)
    }

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

    @Test func compileJournalDesugarsToSelectPlan() throws {
        let compiled = try engine.run(
            "JOURNAL 'Assets:Cash' AT cost FROM CLOSE ON 2024-12-31"
        )

        #expect(compiled.targets.count == 7)
        #expect(compiled.targets[0].name == "date")
        #expect(compiled.targets[4].name == "account")
        #expect(compiled.source.qualifiers?.close != nil)
        #expect(compiled.filter != nil)
    }

    @Test func compilePrintUsesEntriesAsDefaultTable() throws {
        let compiled = try engine.run("PRINT FROM CLOSE ON 2024-12-31")

        guard case .named(let tableName) = compiled.source.table else {
            Issue.record("expected named table source")
            return
        }
        #expect(tableName == "entries")
        #expect(compiled.source.qualifiers?.close != nil)
        #expect(compiled.groupIndexes == nil)
        #expect(compiled.pivotIndexes == nil)
    }

    @Test func compilePivotByResolvesIndexes() throws {
        let compiled = try engine.run(
            "SELECT account, year, sum(number) AS total FROM #postings GROUP BY account, year PIVOT BY 1, 2"
        )
        #expect(compiled.pivotIndexes == [0, 1])
    }

    @Test func compileInvalidGroupByIndexFails() throws {
        do {
            _ = try engine.run("SELECT account, sum(number) FROM #postings GROUP BY 3")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .invalidGroupByIndex(3))
        }
    }

    @Test func compileInvalidPivotByIndexFails() throws {
        do {
            _ = try engine.run(
                "SELECT account, year, sum(number) FROM #postings GROUP BY account, year PIVOT BY 1, 4"
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .invalidPivotByIndex(4))
        }
    }

    @Test func compilePivotByMissingTargetFails() throws {
        do {
            _ = try engine.run(
                "SELECT account, year, sum(number) FROM #postings GROUP BY account, year PIVOT BY account, missing"
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .pivotByColumnNotInTargets("missing"))
        }
    }

    @Test func compilePivotByDuplicateColumnsFails() throws {
        do {
            _ = try engine.run(
                "SELECT account, year, sum(number) FROM #postings GROUP BY account, year PIVOT BY 1, 1"
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .pivotByColumnsMustDiffer)
        }
    }

    @Test func compilePivotBySecondMustBeGroupByColumnFails() throws {
        do {
            _ = try engine.run(
                "SELECT account, year, sum(number) AS total FROM #postings GROUP BY account, year PIVOT BY account, total"
            )
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .pivotBySecondMustBeGroupByColumn)
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

    @Test func compileAggregateInWhereFails() throws {
        do {
            _ = try engine.run("SELECT account FROM #postings WHERE sum(number) > 0")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .aggregatesNotAllowedInWhere)
        }
    }

    @Test func compileAggregateInFromFails() throws {
        do {
            _ = try engine.run("SELECT account FROM sum(number)")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(error == .aggregatesNotAllowedInFrom)
        }
    }

    @Test func compileInvalidFunctionSignatureFails() throws {
        do {
            _ = try engine.run("SELECT account_sortkey(1) FROM #postings")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(
                error == .invalidFunctionSignature(
                    name: "account_sortkey",
                    argTypes: [.int]
                )
            )
        }
    }

    @Test func compileInvalidBinaryOperatorFails() throws {
        do {
            _ = try engine.run("SELECT 'a' - 'b' FROM #postings")
            Issue.record("expected compile failure")
        } catch let error as BQLCompileError {
            #expect(
                error == .invalidBinaryOperator(
                    op: .sub,
                    left: .string,
                    right: .string
                )
            )
        }
    }

    @Test func compileConstantExpressionFolding() throws {
        let compiled = try engine.run("SELECT 1 + 2 AS total FROM #")
        guard case .constant(.integer(let value)) = compiled.targets[0].expression else {
            Issue.record("expected folded integer constant")
            return
        }
        #expect(value == 3)

        let foldedRoot = try engine.run("SELECT root('Assets:Cash', 1) AS root FROM #")
        guard case .constant(.string(let rootValue)) = foldedRoot.targets[0].expression else {
            Issue.record("expected folded string constant")
            return
        }
        #expect(rootValue == "Assets")
    }
}
