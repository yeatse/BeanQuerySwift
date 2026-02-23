import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct BQLParserFacadeTests {
    private static let validQueries: [String] = [
        "SELECT account FROM #postings",
        "SELECT account, number FROM #postings",
        "SELECT DISTINCT account FROM #postings",
        "SELECT account FROM postings",
        "SELECT account FROM #",
        "SELECT account FROM #postings WHERE year = 2024",
        "SELECT account FROM #postings WHERE NOT year = 2024",
        "SELECT account FROM #postings WHERE year >= 2024",
        "SELECT account FROM #postings WHERE year BETWEEN 2020 AND 2024",
        "SELECT account FROM #postings WHERE account IN ('Assets:Cash', 'Assets:Bank')",
        "SELECT account FROM #postings WHERE account NOT IN ('Assets:Cash', 'Assets:Bank')",
        "SELECT account FROM #postings WHERE account ~ 'Assets:.*'",
        "SELECT account FROM #postings WHERE account !~ 'Income:.*'",
        "SELECT account FROM #postings WHERE 'Assets:Cash' ?~ account",
        "SELECT account FROM #postings WHERE payee IS NULL",
        "SELECT account FROM #postings WHERE payee IS NOT NULL",
        "SELECT account FROM #postings WHERE year = %s",
        "SELECT account FROM #postings WHERE year = %(year)s",
        "SELECT account, number + 1 FROM #postings",
        "SELECT account, number - 1 FROM #postings",
        "SELECT account, number * 2 FROM #postings",
        "SELECT account, number / 2 FROM #postings",
        "SELECT account, number % 2 FROM #postings",
        "SELECT account, -number FROM #postings",
        "SELECT account, sum(number) FROM #postings GROUP BY account",
        "SELECT account, sum(number) FROM #postings GROUP BY 1",
        "SELECT account, sum(number) FROM #postings GROUP BY account HAVING sum(number) > 0",
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
        "BALANCES",
        "BALANCES WHERE account ~ 'Assets:.*'",
        "BALANCES AT units",
        "BALANCES AT units FROM CLOSE",
        "BALANCES AT units FROM CLOSE ON 2024-12-31 WHERE year = 2024",
    ]

    @Test(arguments: validQueries)
    func parseManyValidQueries(_ query: String) throws {
        let tree = try BQLParserFacade.parse(query)
        #expect(tree.statement() != nil)
    }

    @Test func parseSelectStatement() throws {
        let tree = try BQLParserFacade.parse("SELECT date, account FROM #postings WHERE year = 2024")
        #expect(tree.statement()?.selectStmt() != nil)
    }

    @Test func parseBalancesStatement() throws {
        let tree = try BQLParserFacade.parse("BALANCES AT units FROM CLOSE ON 2024-12-31 WHERE account ~ 'Assets:.*'")
        #expect(tree.statement()?.balancesStmt() != nil)
    }

    @Test func parsePositionalPlaceholder() throws {
        let tree = try BQLParserFacade.parse("SELECT account FROM #postings WHERE account = %s")
        #expect(tree.statement()?.selectStmt() != nil)
    }

    @Test func parseSemicolonLineComment() throws {
        let tree = try BQLParserFacade.parse("SELECT account FROM #postings ; this is a comment")
        #expect(tree.statement()?.selectStmt() != nil)
    }

    @Test func parseInvalidSQLFails() {
        #expect(throws: BQLParseError.self) {
            _ = try BQLParserFacade.parse("SELECT FROM")
        }
    }

    @Test func parseErrorIncludesTokenAndRange() {
        do {
            _ = try BQLParserFacade.parse("SELECT account, FROM #postings")
            Issue.record("expected parse error")
        } catch let error as BQLParseError {
            #expect(!error.errors.isEmpty)
            #expect(error.errors[0].token != nil)
            #expect(error.errors[0].range != nil)
        } catch {
            Issue.record("unexpected error \(error)")
        }
    }

    @Test func buildSelectAst() throws {
        let statement = try BQLParserFacade.parseStatement(
            "SELECT DISTINCT account, sum(number) AS total FROM #postings WHERE year = 2024 GROUP BY 1 ORDER BY total DESC LIMIT 10"
        )

        guard case .select(let select) = statement else {
            Issue.record("expected SELECT AST")
            return
        }

        #expect(select.distinct)
        #expect(select.limit == 10)

        guard case .table(.hash(let tableName)) = select.from else {
            Issue.record("expected hash table reference")
            return
        }
        #expect(tableName == "postings")

        guard case .values(let targets) = select.targets else {
            Issue.record("expected explicit targets")
            return
        }
        #expect(targets.count == 2)

        guard case .column(let columnName) = targets[0].expression else {
            Issue.record("expected target column")
            return
        }
        #expect(columnName == "account")

        guard let groupBy = select.groupBy else {
            Issue.record("expected GROUP BY")
            return
        }
        #expect(groupBy.items.count == 1)

        guard let orderBy = select.orderBy else {
            Issue.record("expected ORDER BY")
            return
        }
        #expect(orderBy.count == 1)
        #expect(orderBy[0].ordering == .descending)
    }

    @Test func buildBalancesAst() throws {
        let statement = try BQLParserFacade.parseStatement(
            "BALANCES AT units FROM CLOSE ON 2024-12-31 WHERE account ~ 'Assets:.*'"
        )

        guard case .balances(let balances) = statement else {
            Issue.record("expected BALANCES AST")
            return
        }

        #expect(balances.summaryFunction == "units")
        #expect(balances.from?.close != nil)
    }

    @Test func dumpAst() throws {
        let statement = try BQLParserFacade.parseStatement(
            "SELECT account, sum(number) AS total FROM #postings WHERE year = 2024 GROUP BY account ORDER BY total DESC LIMIT 5"
        )

        let dumped = BQLAstDumper.dump(statement)
        #expect(
            dumped ==
            "SELECT account, sum(number) AS total FROM #postings WHERE (year = 2024) GROUP BY account ORDER BY total DESC LIMIT 5"
        )
    }

    @Test func unquotedIdentifiersAreLowercased() throws {
        let statement = try BQLParserFacade.parseStatement("SELECT ACCOUNT FROM #POSTINGS")

        guard case .select(let select) = statement,
              case .values(let targets) = select.targets,
              case .column(let column) = targets[0].expression
        else {
            Issue.record("expected column expression")
            return
        }

        #expect(column == "account")
    }
}
