import Testing
import Foundation
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

    @Test func runtimeValueDescriptionMatchesRendererStringifySemantics() throws {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 2026, month: 4, day: 10))!
        let result = QueryResult(columns: ["value"], rows: [[.bool(false)]])

        let rendered = try QueryRenderer.render(result, format: .text)
        #expect(
            rendered ==
            """
            value
            -----
            FALSE
            """ + "\n"
        )
        #expect(RuntimeValue.bool(true).stringRepresentation() == "TRUE")
        #expect(RuntimeValue.date(date).stringRepresentation() == "2026-04-10")
        #expect(RuntimeValue.dict(["b": .null, "a": .int(1)]).stringRepresentation() == "{a:1,b:}")
        #expect(RuntimeValue.list([.string("USD"), .bool(false)]).stringRepresentation() == "USD, FALSE")
        #expect(RuntimeValue.null.stringRepresentation().isEmpty)
        #expect(RuntimeValue.null.stringRepresentation(placeholder: "--") == "--")
    }

    @Test func renderBeancountUsesDirectiveValues() throws {
        let context = BeancountQueryContextBuilder.makeContext(from: try BeancountTestFixtures.sampleLedger())
        let engine = BeanQueryEngine()
        let result = try engine.run("PRINT", in: context)

        let rendered = try QueryRenderer.render(result, format: .beancount)
        let expected = try BeancountTestFixtures.sampleLedger().directives.map { $0.description }.joined()

        #expect(rendered == expected)
    }

    @Test func renderBeancountFailsWithoutDirectiveValue() throws {
        let result = QueryResult(columns: ["x"], rows: [[.int(1)]])
        #expect(throws: QueryRenderError.self) {
            _ = try QueryRenderer.render(result, format: .beancount)
        }
    }
}
