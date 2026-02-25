import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct TypeSystemCoverageTests {
    private let checker = ExpressionTypeChecker()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar(identifier: .gregorian).date(
            from: DateComponents(year: year, month: month, day: day)
        )!
    }

    @Test func bqlTypeDescriptionCoversAllCases() {
        #expect(BQLType.int.description == "int")
        #expect(BQLType.decimal.description == "decimal")
        #expect(BQLType.date.description == "date")
        #expect(BQLType.string.description == "string")
        #expect(BQLType.bool.description == "bool")
        #expect(BQLType.null.description == "null")
        #expect(BQLType.list.description == "list")
        #expect(BQLType.object.description == "object")
    }

    @Test func foldsUnaryAndPlaceholderExpressions() throws {
        #expect(
            try checker.validateAndFold(.placeholder(.positional))
                == .placeholder(.positional)
        )
        #expect(
            try checker.validateAndFold(.unary(.not, .constant(.bool(true))))
                == .constant(.bool(false))
        )
        #expect(
            try checker.validateAndFold(.unary(.neg, .constant(.integer(7))))
                == .constant(.integer(-7))
        )
        #expect(
            try checker.validateAndFold(.unary(.neg, .constant(.decimal(Decimal(string: "1.5")!))))
                == .constant(.decimal(Decimal(string: "-1.5")!))
        )
        #expect(
            try checker.validateAndFold(.unary(.isNull, .constant(.null)))
                == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(.unary(.isNotNull, .constant(.null)))
                == .constant(.bool(false))
        )
    }

    @Test func foldsBinaryArithmeticAndComparisons() throws {
        #expect(
            try checker.validateAndFold(
                .binary(.add, .constant(.integer(1)), .constant(.integer(2)))
            ) == .constant(.integer(3))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.add, .constant(.decimal(Decimal(string: "1.2")!)), .constant(.integer(2)))
            ) == .constant(.decimal(Decimal(string: "3.2")!))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.add, .constant(.string("a")), .constant(.string("b")))
            ) == .constant(.string("ab"))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.sub, .constant(.integer(8)), .constant(.integer(3)))
            ) == .constant(.integer(5))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.mul, .constant(.integer(6)), .constant(.integer(7)))
            ) == .constant(.integer(42))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.div, .constant(.integer(7)), .constant(.integer(2)))
            ) == .constant(.decimal(Decimal(string: "3.5")!))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.mod, .constant(.integer(7)), .constant(.integer(4)))
            ) == .constant(.integer(3))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.equal, .constant(.integer(1)), .constant(.integer(1)))
            ) == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.notEqual, .constant(.integer(1)), .constant(.integer(2)))
            ) == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.less, .constant(.integer(1)), .constant(.decimal(Decimal(string: "2.0")!)))
            ) == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.lessOrEqual, .constant(.string("A")), .constant(.string("A")))
            ) == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.greater, .constant(.date(date(2024, 1, 2))), .constant(.date(date(2024, 1, 1))))
            ) == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(
                .binary(.greaterOrEqual, .constant(.bool(true)), .constant(.bool(false)))
            ) == .constant(.bool(true))
        )
    }

    @Test func foldsMembershipLogicalAndStructuralExpressions() throws {
        #expect(
            try checker.validateAndFold(
                .binary(
                    .inList,
                    .constant(.string("USD")),
                    .constant(.list([.string("USD"), .string("CNY")]))
                )
            ) == .constant(.bool(true))
        )
        #expect(
            try checker.validateAndFold(
                .binary(
                    .notInList,
                    .constant(.string("EUR")),
                    .constant(.list([.string("USD"), .string("CNY")]))
                )
            ) == .constant(.bool(true))
        )

        #expect(
            try checker.validateAndFold(
                .and([.constant(.bool(true)), .constant(.bool(false))])
            ) == .constant(.bool(false))
        )
        #expect(
            try checker.validateAndFold(
                .or([.constant(.bool(false)), .constant(.bool(true))])
            ) == .constant(.bool(true))
        )

        #expect(
            try checker.validateAndFold(
                .between(
                    .column("year"),
                    lower: .constant(.integer(2023)),
                    upper: .constant(.integer(2024))
                )
            ) == .between(
                .column("year"),
                lower: .constant(.integer(2023)),
                upper: .constant(.integer(2024))
            )
        )

        #expect(
            try checker.validateAndFold(
                .anyAll(
                    op: .equal,
                    quantifier: .all,
                    left: .column("currency"),
                    right: .column("currencies")
                )
            ) == .anyAll(
                op: .equal,
                quantifier: .all,
                left: .column("currency"),
                right: .column("currencies")
            )
        )

        #expect(
            try checker.validateAndFold(
                .attribute(.column("meta"), name: "key")
            ) == .attribute(.column("meta"), name: "key")
        )
        #expect(
            try checker.validateAndFold(
                .subscriptExpr(.column("meta"), key: "key")
            ) == .subscriptExpr(.column("meta"), key: "key")
        )

        let subSelect = BQLSelectStatement(
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
            try checker.validateAndFold(.select(subSelect)) == .select(subSelect)
        )
        #expect(try checker.validateAndFold(.asterisk) == .asterisk)
    }

    @Test func foldFunctionBranchesAndAccountOps() throws {
        #expect(
            try checker.validateAndFold(.function(name: "units", args: [.constant(.integer(5))]))
                == .constant(.integer(5))
        )
        #expect(
            try checker.validateAndFold(.function(name: "cost", args: [.constant(.integer(6))]))
                == .constant(.integer(6))
        )
        #expect(
            try checker.validateAndFold(.function(name: "weight", args: [.constant(.integer(7))]))
                == .constant(.integer(7))
        )

        #expect(
            try checker.validateAndFold(.function(name: "account_sortkey", args: [.constant(.string("Assets:Cash"))]))
                == .constant(.string("0-Assets:Cash"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "account_sortkey", args: [.constant(.string("Liabilities:Card"))]))
                == .constant(.string("1-Liabilities:Card"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "account_sortkey", args: [.constant(.string("Equity:Open"))]))
                == .constant(.string("2-Equity:Open"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "account_sortkey", args: [.constant(.string("Income:Salary"))]))
                == .constant(.string("3-Income:Salary"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "account_sortkey", args: [.constant(.string("Expenses:Food"))]))
                == .constant(.string("4-Expenses:Food"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "account_sortkey", args: [.constant(.string("Other:Misc"))]))
                == .constant(.string("5-Other:Misc"))
        )

        #expect(
            try checker.validateAndFold(.function(name: "root", args: [.constant(.string("Assets:Cash:Wallet"))]))
                == .constant(.string("Assets"))
        )
        #expect(
            try checker.validateAndFold(
                .function(name: "root", args: [.constant(.string("Assets:Cash:Wallet")), .constant(.integer(2))])
            ) == .constant(.string("Assets:Cash"))
        )
        #expect(
            try checker.validateAndFold(
                .function(name: "root", args: [.constant(.string("Assets:Cash:Wallet")), .constant(.integer(-1))])
            ) == .constant(.string("Assets:Cash"))
        )

        #expect(
            try checker.validateAndFold(.function(name: "parent", args: [.constant(.string("Assets:Cash"))]))
                == .constant(.string("Assets"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "parent", args: [.constant(.string(""))]))
                == .constant(.null)
        )

        #expect(
            try checker.validateAndFold(.function(name: "leaf", args: [.constant(.string("Assets:Cash"))]))
                == .constant(.string("Cash"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "leaf", args: [.constant(.string(""))]))
                == .constant(.null)
        )

        #expect(
            try checker.validateAndFold(
                .function(name: "maxwidth", args: [.constant(.string("abcdef")), .constant(.integer(3))])
            ) == .constant(.string("abc"))
        )
        #expect(
            try checker.validateAndFold(
                .function(name: "maxwidth", args: [.constant(.string("abcdef")), .constant(.integer(-2))])
            ) == .constant(.string(""))
        )

        #expect(
            try checker.validateAndFold(.function(name: "upper", args: [.constant(.string("cash"))]))
                == .constant(.string("CASH"))
        )
        #expect(
            try checker.validateAndFold(.function(name: "lower", args: [.constant(.string("CASH"))]))
                == .constant(.string("cash"))
        )
    }

    @Test func leavesNonFoldableFunctionsAsFunctionExpressions() throws {
        let folded = try checker.validateAndFold(
            .function(name: "today", args: [])
        )
        #expect(folded == .function(name: "today", args: []))

        let keepRegex = try checker.validateAndFold(
            .binary(.match, .constant(.string("Assets")), .constant(.string("A.*")))
        )
        #expect(keepRegex == .binary(.match, .constant(.string("Assets")), .constant(.string("A.*"))))

        let divByZero = try checker.validateAndFold(
            .binary(.div, .constant(.integer(1)), .constant(.integer(0)))
        )
        #expect(divByZero == .binary(.div, .constant(.integer(1)), .constant(.integer(0))))
    }

    @Test func invalidExpressionsThrowExpectedErrors() {
        #expect(throws: BQLCompileError.invalidUnaryOperator(op: .not, operand: .int)) {
            _ = try checker.validateAndFold(.unary(.not, .constant(.integer(1))))
        }

        #expect(throws: BQLCompileError.invalidBinaryOperator(op: .mod, left: .decimal, right: .int)) {
            _ = try checker.validateAndFold(
                .binary(.mod, .constant(.decimal(Decimal(string: "1.1")!)), .constant(.integer(2)))
            )
        }

        #expect(throws: BQLCompileError.invalidBinaryOperator(op: .inList, left: .int, right: .int)) {
            _ = try checker.validateAndFold(
                .binary(.inList, .constant(.integer(1)), .constant(.integer(2)))
            )
        }

        #expect(throws: BQLCompileError.invalidBinaryOperator(op: .match, left: .int, right: .int)) {
            _ = try checker.validateAndFold(
                .binary(.match, .constant(.integer(1)), .constant(.integer(2)))
            )
        }

        #expect(throws: BQLCompileError.invalidBinaryOperator(op: .add, left: .bool, right: .bool)) {
            _ = try checker.validateAndFold(
                .binary(.add, .constant(.bool(true)), .constant(.bool(false)))
            )
        }

        #expect(throws: BQLCompileError.invalidFunctionSignature(name: "upper", argTypes: [.int])) {
            _ = try checker.validateAndFold(.function(name: "upper", args: [.constant(.integer(1))]))
        }

        #expect(throws: BQLCompileError.invalidUnaryOperator(op: .not, operand: .object)) {
            _ = try checker.validateAndFold(.and([.constant(.integer(1)), .constant(.bool(true))]))
        }

        #expect(throws: BQLCompileError.invalidUnaryOperator(op: .not, operand: .object)) {
            _ = try checker.validateAndFold(.or([.constant(.integer(1)), .constant(.bool(true))]))
        }
    }
}
