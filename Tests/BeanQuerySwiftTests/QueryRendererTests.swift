import Testing
@testable import BeanQuerySwift

@Suite
struct QueryRendererTests {
    @Test func renderTextReturnsEmptyForNoRows() throws {
        let result = QueryResult(columns: ["x"], rows: [])
        let rendered = try QueryRenderer.render(result, format: .text)
        #expect(rendered.isEmpty)
    }

    @Test func renderTextSimpleAndBoxed() throws {
        let result = QueryResult(
            columns: ["x", "y", "z"],
            rows: [
                [.int(1), .int(2), .int(3)],
                [.int(4), .int(5), .int(6)],
            ]
        )

        let plain = try QueryRenderer.render(result, format: .text)
        #expect(
            plain ==
            """
            x  y  z
            -  -  -
            1  2  3
            4  5  6
            """ + "\n"
        )

        let boxed = try QueryRenderer.render(
            result,
            format: .text,
            options: QueryRenderOptions(boxed: true)
        )
        #expect(
            boxed ==
            """
            +---+---+---+
            | x | y | z |
            +---+---+---+
            | 1 | 2 | 3 |
            | 4 | 5 | 6 |
            +---+---+---+
            """ + "\n"
        )
    }

    @Test func renderCSVSupportsNullAndExpand() throws {
        let withNull = QueryResult(
            columns: ["x", "y", "z"],
            rows: [
                [.null, .int(2), .int(3)],
                [.int(4), .null, .int(6)],
            ]
        )
        let simple = try QueryRenderer.render(withNull, format: .csv)
        #expect(
            simple ==
            """
            x,y,z
            ,2,3
            4,,6
            """ + "\n"
        )

        let expanded = QueryResult(
            columns: ["x", "inv", "q"],
            rows: [
                [.int(11), .list([.string("USD"), .string("EUR")]), .int(2)],
            ]
        )
        let expandedCSV = try QueryRenderer.render(
            expanded,
            format: .csv,
            options: QueryRenderOptions(expand: true)
        )
        #expect(
            expandedCSV ==
            """
            x,inv,q
            11,USD,2
            ,EUR,
            """ + "\n"
        )
    }

    @Test func renderBeancountUsesDirectiveValues() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let engine = BeanQueryEngine()
        let result = try engine.run("PRINT", in: context)

        let rendered = try QueryRenderer.render(result, format: .beancount)
        let expected = try BeancountTestFixtures.sampleLedger().directives.map(\.description).joined()

        #expect(rendered == expected)
    }

    @Test func renderBeancountFailsWithoutDirectiveValue() throws {
        let result = QueryResult(columns: ["x"], rows: [[.int(1)]])
        #expect(throws: QueryRenderError.self) {
            _ = try QueryRenderer.render(result, format: .beancount)
        }
    }
}
