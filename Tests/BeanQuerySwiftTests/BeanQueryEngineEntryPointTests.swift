import Testing
@testable import BeanQuerySwift

@Suite
struct BeanQueryEngineEntryPointTests {
    @Test func makeEngineCreatesWorkingCompiler() throws {
        let engine = BeanQuerySwift.makeEngine(defaultTableName: "postings", supportImplicitGroupBy: true)
        let compiled = try engine.compile("SELECT 1 + 2 AS total FROM #")

        #expect(compiled.targets.count == 1)
        #expect(compiled.targets[0].name == "total")
    }

    @Test func runWithLedgerOverloads() throws {
        let engine = BeanQueryEngine()
        let ledger = try BeancountTestFixtures.sampleLedger()

        let result = try engine.run(
            "SELECT account FROM postings WHERE account = 'Assets:Cash' ORDER BY account",
            in: ledger
        )
        #expect(result.columns == ["account"])
        #expect(result.rows.count == 2)

        let parameterized = try engine.run(
            "SELECT account FROM postings WHERE account = %(account)s ORDER BY account",
            parameters: .named(["account": .string("Assets:Cash")]),
            in: ledger
        )
        #expect(parameterized.columns == ["account"])
        #expect(parameterized.rows.count == 2)
    }

    @Test func runWithDirectiveParametersOverload() throws {
        let engine = BeanQueryEngine()
        let directives = try BeancountTestFixtures.sampleDirectives()

        let parameterized = try engine.run(
            "SELECT account FROM postings WHERE account = %(account)s ORDER BY account",
            parameters: .named(["account": .string("Assets:Cash")]),
            in: directives
        )

        #expect(parameterized.columns == ["account"])
        #expect(parameterized.rows.count == 2)
    }

    @Test func runAndRenderWithComposedAPI() throws {
        let engine = BeanQueryEngine()
        let ledger = try BeancountTestFixtures.sampleLedger()

        let rendered = try engine.run(
            "SELECT account, number FROM postings WHERE account = 'Assets:Cash' ORDER BY number DESC",
            in: ledger
        ).render(as: .csv)

        #expect(
            rendered ==
            """
            account,number
            Assets:Cash,1000
            Assets:Cash, -80
            """ + "\n"
        )
    }

    @Test func runAndRenderPrintWithExplicitBeancountFormat() throws {
        let engine = BeanQueryEngine()
        let ledger = try BeancountTestFixtures.sampleLedger()

        let rendered = try engine.run("PRINT", in: ledger).render(as: .beancount)

        #expect(rendered == ledger.directives.map { $0.description }.joined())
    }
}
