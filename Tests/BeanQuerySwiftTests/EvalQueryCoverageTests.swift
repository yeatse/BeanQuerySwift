import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct EvalQueryCoverageTests {
    @Test func visibleTargetsFiltersUnnamedTargets() {
        let query = EvalQuery(
            source: EvalSource(table: .hash("postings"), qualifiers: nil),
            targets: [
                EvalTarget(expression: .column("account"), name: "account", isAggregate: false),
                EvalTarget(expression: .column("number"), name: nil, isAggregate: false),
            ],
            filter: nil,
            groupIndexes: nil,
            havingIndex: nil,
            orderSpec: nil,
            pivotIndexes: nil,
            limit: nil,
            distinct: false
        )

        #expect(query.visibleTargets.count == 1)
        #expect(query.visibleTargets.first?.name == "account")
    }

    @Test func compileErrorDescriptionsCoverAllCases() {
        let allTypes: [BQLType] = [.int, .decimal, .date, .string, .bool, .null, .list, .object]
        let cases: [(BQLCompileError, String)] = [
            (.unsupportedStatement("PRINT"), "unsupported statement"),
            (.invalidGroupByIndex(3), "invalid GROUP BY index"),
            (.invalidOrderByIndex(2), "invalid ORDER BY index"),
            (.namedParametersRequired, "mapping"),
            (.positionalParametersRequired, "sequence"),
            (.queryParameterMissing(["year", "account"]), "query parameter missing"),
            (.placeholderCountMismatch(expected: 1, actual: 0), "placeholders"),
            (.mixedPlaceholderStyles, "cannot be mixed"),
            (.invalidFunctionSignature(name: "fn", argTypes: allTypes), "invalid function signature"),
            (.invalidUnaryOperator(op: .not, operand: .bool), "invalid unary operator"),
            (.invalidBinaryOperator(op: .equal, left: .int, right: .decimal), "invalid binary operator"),
            (.aggregatesNotAllowedInFrom, "FROM clause"),
            (.aggregatesNotAllowedInWhere, "WHERE clause"),
            (.mixedAggregatesAndNonAggregates, "mixed aggregates"),
            (.aggregatesOfAggregates, "aggregates of aggregates"),
            (.groupByContainsAggregate, "GROUP BY expressions"),
            (.groupByReferencesAggregate, "GROUP BY references"),
            (.havingMustBeAggregate, "HAVING clause"),
            (.aggregateWithoutGroupBy, "without GROUP BY"),
            (.missingGroupByTargets(["account"]), "missing from GROUP BY"),
            (.closeDateMustFollowOpenDate, "CLOSE date"),
            (.invalidFromClause, "invalid FROM clause"),
            (.invalidPivotByIndex(9), "invalid PIVOT BY column index"),
            (.pivotByColumnNotInTargets("missing"), "not in the targets list"),
            (.pivotByColumnsMustDiffer, "cannot be the same"),
            (.pivotBySecondMustBeGroupByColumn, "second PIVOT BY column"),
            (.invalidPivotByClause, "invalid PIVOT BY clause"),
        ]

        for (error, expected) in cases {
            guard let description = error.errorDescription else {
                Issue.record("missing description for \(error)")
                continue
            }
            #expect(description.contains(expected))
        }
    }

    @Test func compilerOptionsDefaultValues() {
        let defaults = BQLCompilerOptions()
        #expect(defaults.defaultTableName == "postings")
        #expect(defaults.supportImplicitGroupBy)

        let custom = BQLCompilerOptions(defaultTableName: "entries", supportImplicitGroupBy: false)
        #expect(custom.defaultTableName == "entries")
        #expect(!custom.supportImplicitGroupBy)
    }

    @Test func parseErrorDescriptionIncludesTokenAndRange() {
        let parseError = BQLParseError(errors: [
            BQLSyntaxError(
                line: 1,
                column: 2,
                message: "m1",
                token: "FROM",
                range: BQLSourceRange(start: 3, end: 6)
            ),
            BQLSyntaxError(
                line: 4,
                column: 5,
                message: "m2",
                token: nil,
                range: nil
            ),
        ])

        guard let description = parseError.errorDescription else {
            Issue.record("missing parse error description")
            return
        }

        #expect(description.contains("1:2 m1 token='FROM' range=3...6"))
        #expect(description.contains("4:5 m2"))
    }

    @Test func astBuildErrorDescription() {
        let error = BQLASTBuildError("bad ast")
        #expect(error.message == "bad ast")
        #expect(error.errorDescription == "bad ast")
    }
}
