import Foundation
import Antlr4

struct BQLSyntaxError: Error, Equatable, Sendable {
    let line: Int
    let column: Int
    let message: String
    let token: String?
    let range: BQLSourceRange?
}

struct BQLParseError: Error, CustomStringConvertible, Sendable {
    let errors: [BQLSyntaxError]

    var description: String {
        errors
            .map { error in
                let tokenPart = error.token.map { " token='\($0)'" } ?? ""
                let rangePart = error.range.map { " range=\($0.start)...\($0.end)" } ?? ""
                return "\(error.line):\(error.column) \(error.message)\(tokenPart)\(rangePart)"
            }
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
        let offendingToken = offendingSymbol as? Token
        let tokenText = offendingToken?.getText()
        let tokenRange: BQLSourceRange?
        if let offendingToken {
            let start = offendingToken.getStartIndex()
            let stop = offendingToken.getStopIndex()
            if start >= 0 && stop >= start {
                tokenRange = BQLSourceRange(start: start, end: stop)
            } else {
                tokenRange = nil
            }
        } else {
            tokenRange = nil
        }

        errors.append(
            BQLSyntaxError(
                line: line,
                column: charPositionInLine,
                message: msg,
                token: tokenText,
                range: tokenRange
            ))
    }
}

enum BQLParserFacade {
    private static let parseLock = NSLock()

    static func parse(_ input: String) throws -> BQLParser.BqlContext {
        parseLock.lock()
        defer { parseLock.unlock() }

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
