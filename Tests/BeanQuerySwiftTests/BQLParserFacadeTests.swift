import Foundation
import Testing
@testable import BeanQuerySwift

@Suite(.serialized)
struct BQLParserFacadeTests {
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
