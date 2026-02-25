import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct BQLAstDumperCoverageTests {
    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(
            from: DateComponents(year: year, month: month, day: day)
        )!
    }

    private static let binaryOperators: [(BQLBinaryOperator, String)] = [
        (.add, "+"),
        (.sub, "-"),
        (.mul, "*"),
        (.div, "/"),
        (.mod, "%"),
        (.less, "<"),
        (.lessOrEqual, "<="),
        (.greater, ">"),
        (.greaterOrEqual, ">="),
        (.equal, "="),
        (.notEqual, "!="),
        (.inList, "IN"),
        (.notInList, "NOT IN"),
        (.match, "~"),
        (.notMatch, "!~"),
        (.matches, "?~"),
    ]

    private func selectStatement(
        target: BQLExpression,
        from: BQLFromClause? = nil,
        groupBy: BQLGroupByClause? = nil,
        orderBy: [BQLOrderByItem]? = nil,
        pivotBy: BQLPivotByClause? = nil
    ) -> BQLStatement {
        .select(
            BQLSelectStatement(
                distinct: false,
                targets: .values([BQLTarget(expression: target, alias: nil)]),
                from: from,
                where: nil,
                groupBy: groupBy,
                orderBy: orderBy,
                pivotBy: pivotBy,
                limit: nil
            )
        )
    }

    @Test func dumpStatementKindsAndFromVariants() {
        let select = BQLStatement.select(
            BQLSelectStatement(
                distinct: true,
                targets: .asterisk,
                from: .table(.named("postings")),
                where: nil,
                groupBy: nil,
                orderBy: nil,
                pivotBy: nil,
                limit: nil
            )
        )
        #expect(BQLAstDumper.dump(select) == "SELECT DISTINCT * FROM postings")

        let balances = BQLStatement.balances(
            BQLBalancesStatement(
                summaryFunction: "cost",
                from: BQLFromExpression(
                    expression: .column("account"),
                    open: date(2024, 1, 1),
                    close: .on(date(2024, 12, 31)),
                    clear: true
                ),
                where: .binary(.equal, .column("year"), .constant(.integer(2024)))
            )
        )
        #expect(
            BQLAstDumper.dump(balances)
                == "BALANCES AT cost FROM account OPEN ON 2024-01-01 CLOSE ON 2024-12-31 CLEAR WHERE (year = 2024)"
        )

        let journal = BQLStatement.journal(
            BQLJournalStatement(
                account: "Assets:Cash",
                summaryFunction: "units",
                from: BQLFromExpression(
                    expression: nil,
                    open: nil,
                    close: .implicit,
                    clear: false
                )
            )
        )
        #expect(BQLAstDumper.dump(journal) == "JOURNAL 'Assets:Cash' AT units FROM CLOSE")

        let printStatement = BQLStatement.print(
            BQLPrintStatement(
                from: BQLFromExpression(
                    expression: nil,
                    open: nil,
                    close: .on(date(2024, 2, 2)),
                    clear: false
                )
            )
        )
        #expect(BQLAstDumper.dump(printStatement) == "PRINT FROM CLOSE ON 2024-02-02")
    }

    @Test func dumpFromSubselectAndExpression() {
        let nested = BQLSelectStatement(
            distinct: false,
            targets: .values([BQLTarget(expression: .column("account"), alias: nil)]),
            from: .table(.hash("postings")),
            where: nil,
            groupBy: nil,
            orderBy: nil,
            pivotBy: nil,
            limit: nil
        )
        let subselect = BQLStatement.select(
            BQLSelectStatement(
                distinct: false,
                targets: .values([BQLTarget(expression: .column("account"), alias: nil)]),
                from: .subselect(nested),
                where: nil,
                groupBy: nil,
                orderBy: nil,
                pivotBy: nil,
                limit: nil
            )
        )
        #expect(
            BQLAstDumper.dump(subselect)
                == "SELECT account FROM (SELECT account FROM #postings)"
        )

        let fromExpression = BQLStatement.select(
            BQLSelectStatement(
                distinct: false,
                targets: .values([BQLTarget(expression: .column("account"), alias: nil)]),
                from: .expression(
                    BQLFromExpression(
                        expression: .binary(.match, .column("account"), .constant(.string("Assets:.*"))),
                        open: nil,
                        close: nil,
                        clear: true
                    )
                ),
                where: nil,
                groupBy: nil,
                orderBy: nil,
                pivotBy: nil,
                limit: nil
            )
        )
        #expect(
            BQLAstDumper.dump(fromExpression)
                == "SELECT account FROM (account ~ 'Assets:.*') CLEAR"
        )
    }

    @Test func dumpGroupOrderAndPivotVariants() {
        let statement = BQLStatement.select(
            BQLSelectStatement(
                distinct: false,
                targets: .values([
                    BQLTarget(expression: .column("account"), alias: nil),
                    BQLTarget(expression: .function(name: "sum", args: [.column("number")]), alias: "total"),
                ]),
                from: .table(.hash("postings")),
                where: nil,
                groupBy: BQLGroupByClause(
                    items: [.index(1), .expression(.column("account"))],
                    having: .binary(.greater, .function(name: "sum", args: [.column("number")]), .constant(.integer(0)))
                ),
                orderBy: [
                    BQLOrderByItem(value: .index(2), ordering: .ascending),
                    BQLOrderByItem(value: .expression(.column("account")), ordering: .descending),
                ],
                pivotBy: BQLPivotByClause(items: [.index(1), .column("account")]),
                limit: 3
            )
        )

        #expect(
            BQLAstDumper.dump(statement)
                == "SELECT account, sum(number) AS total FROM #postings GROUP BY 1, account HAVING (sum(number) > 0) ORDER BY 2 ASC, account DESC PIVOT BY 1, account LIMIT 3"
        )
    }

    @Test(arguments: binaryOperators)
    func dumpBinaryOperatorSymbols(_ argument: (BQLBinaryOperator, String)) {
        let (op, symbol) = argument
        let dumped = BQLAstDumper.dump(
            selectStatement(target: .binary(op, .column("a"), .column("b")))
        )
        #expect(dumped == "SELECT (a \(symbol) b)")
    }

    @Test func dumpExpressionVariants() {
        #expect(
            BQLAstDumper.dump(selectStatement(target: .function(name: "root", args: [.column("account")])))
                == "SELECT root(account)"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .placeholder(.positional)))
                == "SELECT %s"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .placeholder(.named("year"))))
                == "SELECT %(year)s"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .unary(.not, .column("flag"))))
                == "SELECT NOT flag"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .unary(.neg, .column("number"))))
                == "SELECT -number"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .unary(.isNull, .column("payee"))))
                == "SELECT payee IS NULL"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .unary(.isNotNull, .column("payee"))))
                == "SELECT payee IS NOT NULL"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .and([.column("a"), .column("b"), .column("c")])))
                == "SELECT a AND b AND c"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .or([.column("a"), .column("b"), .column("c")])))
                == "SELECT a OR b OR c"
        )
        #expect(
            BQLAstDumper.dump(
                selectStatement(
                    target: .between(.column("year"), lower: .constant(.integer(2023)), upper: .constant(.integer(2024)))
                )
            ) == "SELECT year BETWEEN 2023 AND 2024"
        )
        #expect(
            BQLAstDumper.dump(
                selectStatement(
                    target: .anyAll(
                        op: .equal,
                        quantifier: .any,
                        left: .column("currency"),
                        right: .column("currencies")
                    )
                )
            ) == "SELECT currency = ANY(currencies)"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .attribute(.column("meta"), name: "key")))
                == "SELECT meta.key"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .subscriptExpr(.column("meta"), key: "key")))
                == "SELECT meta[\"key\"]"
        )

        let nestedSelect = BQLSelectStatement(
            distinct: false,
            targets: .values([BQLTarget(expression: .column("account"), alias: nil)]),
            from: .table(.hash("postings")),
            where: nil,
            groupBy: nil,
            orderBy: nil,
            pivotBy: nil,
            limit: nil
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .select(nestedSelect)))
                == "SELECT (SELECT account FROM #postings)"
        )
        #expect(BQLAstDumper.dump(selectStatement(target: .asterisk)) == "SELECT *")
    }

    @Test func dumpLiteralVariants() {
        #expect(BQLAstDumper.dump(selectStatement(target: .constant(.integer(8)))) == "SELECT 8")
        #expect(
            BQLAstDumper.dump(selectStatement(target: .constant(.decimal(Decimal(string: "1.25")!))))
                == "SELECT 1.25"
        )
        #expect(
            BQLAstDumper.dump(selectStatement(target: .constant(.date(date(2024, 1, 6)))))
                == "SELECT 2024-01-06"
        )
        #expect(BQLAstDumper.dump(selectStatement(target: .constant(.string("abc")))) == "SELECT 'abc'")
        #expect(BQLAstDumper.dump(selectStatement(target: .constant(.bool(true)))) == "SELECT TRUE")
        #expect(BQLAstDumper.dump(selectStatement(target: .constant(.bool(false)))) == "SELECT FALSE")
        #expect(BQLAstDumper.dump(selectStatement(target: .constant(.null))) == "SELECT NULL")
        #expect(
            BQLAstDumper.dump(
                selectStatement(
                    target: .constant(.list([.integer(1), .string("x")]))
                )
            ) == "SELECT (1, 'x')"
        )
    }
}
