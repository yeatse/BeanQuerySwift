import Antlr4

struct BQLSyntaxError: Error, Equatable, Sendable {
    let line: Int
    let column: Int
    let message: String
}

struct BQLParseError: Error, CustomStringConvertible, Sendable {
    let errors: [BQLSyntaxError]

    var description: String {
        errors
            .map { "\($0.line):\($0.column) \($0.message)" }
            .joined(separator: "\n")
    }
}

private final class CollectingErrorListener: BaseErrorListener {
    private(set) var errors: [BQLSyntaxError] = []

    override func syntaxError<T>(
        _ recognizer: Recognizer<T>,
        _ offendingSymbol: AnyObject?,
        _ line: Int,
        _ charPositionInLine: Int,
        _ msg: String,
        _ e: AnyObject?
    ) {
        errors.append(
            BQLSyntaxError(
                line: line,
                column: charPositionInLine,
                message: msg
            ))
    }
}

enum BQLParserFacade {
    static func parse(_ input: String) throws -> BQLParser.BqlContext {
        let inputStream = ANTLRInputStream(input)
        let lexer = BQLLexer(inputStream)
        lexer.setTokenFactory(CommonTokenFactory(true))
        let tokenStream = CommonTokenStream(lexer)
        let parser = try BQLParser(tokenStream)

        let errorListener = CollectingErrorListener()
        lexer.removeErrorListeners()
        parser.removeErrorListeners()
        lexer.addErrorListener(errorListener)
        parser.addErrorListener(errorListener)

        let tree = try parser.bql()
        if !errorListener.errors.isEmpty {
            throw BQLParseError(errors: errorListener.errors)
        }
        return tree
    }
}

extension BQLParserFacade {
    static func parseStatement(_ input: String) throws -> BQLStatement {
        let tree = try parse(input)
        return try BQLAstBuilder.build(tree)
    }
}
