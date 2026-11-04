import Foundation
import Testing
@testable import BeanQuerySwift

@Suite
struct RuntimeTypeDiagnosticsTests {
    @Test func builtinTypeErrorsDescribeFunctionAndTypes() throws {
        let evaluator = BuiltinFunctionEvaluator(context: QueryContext())
        let privateValue = RuntimeValue.string("private ledger value")
        let cases: [(String, [RuntimeValue], String)] = [
            ("getitem", [.int(1), privateValue], "getitem(): expected (dict, str[, object]), got (int, str)"),
            ("round", [.int(1), privateValue], "round(): expected (int | decimal[, int]), got (int, str)"),
            ("substr", [privateValue, privateValue, .int(2)], "substr(): expected (str, int, int), got (str, str, int)"),
            ("parse_date", [privateValue, .int(1)], "parse_date(): expected (str[, str]), got (str, int)"),
            ("date_add", [privateValue, .int(1)], "date_add(): expected (date, int), got (str, int)"),
            ("date_bin", [.list([.int(1)]), .date(Date()), .date(Date())],
             "date_bin(): expected (str | list[int] of length 3, date, date), got (list[int], date, date)"),
            ("findfirst", [privateValue, .list([.int(1)])], "findfirst(): expected (str, list[str]), got (str, list[int])"),
            ("joinstr", [.list([.int(1)])], "joinstr(): expected (list[str]), got (list[int])"),
            ("abs", [privateValue], "abs(): expected int | decimal | amount | position | inventory, got str"),
            ("units", [privateValue], "units(): expected int | decimal | amount | position | inventory, got str"),
            ("convert", [privateValue, .string("USD")], "convert(): expected amount | position | inventory, got str"),
            ("number", [privateValue], "number(): expected amount, got str"),
            ("only", [.string("USD"), privateValue], "only(): expected inventory, got str"),
            ("filter_currency", [privateValue, .string("USD")], "filter_currency(): expected position | inventory, got str"),
        ]
        for (name, arguments, expected) in cases {
            do {
                _ = try evaluator.evaluate(name: name, normalizedName: name, arguments: arguments, row: nil)
                Issue.record("expected invalid arguments for \(name)")
            } catch {
                #expect(error.localizedDescription == expected)
                #expect(!error.localizedDescription.contains("private ledger value"))
            }
        }
    }

    @Test func sumMixedNumericTypesIdentifiesInvalidElement() throws {
        let context = QueryContext(tables: ["postings": [
            ["number": .decimal(1)], ["number": .string("bad")],
        ]])
        #expect(throws: BQLExecutionError.invalidType(
            operation: "sum()", expected: "int | decimal", actual: "str"
        )) {
            try BeanQueryEngine().run("SELECT sum(number)", in: context)
        }
    }
}
