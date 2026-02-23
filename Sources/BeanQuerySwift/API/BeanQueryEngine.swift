import Foundation
import BeancountSwift

public struct BeanQueryEngine {
    private let compiler: BQLCompiler
    private let executor = QueryExecutor()

    public init(
        defaultTableName: String = "postings",
        supportImplicitGroupBy: Bool = true
    ) {
        self.compiler = BQLCompiler(
            options: BQLCompilerOptions(
                defaultTableName: defaultTableName,
                supportImplicitGroupBy: supportImplicitGroupBy
            )
        )
    }

    func parse(_ bql: String) throws -> BQLStatement {
        try BQLParserFacade.parseStatement(bql)
    }

    func compile(
        _ bql: String,
        parameters: BQLParameters? = nil,
        context: QueryContext? = nil
    ) throws -> EvalQuery {
        try compiler.compile(parse(bql), parameters: parameters, context: context)
    }

    /// One-step compile entry point, useful for introspecting query plans.
    public func run(_ bql: String) throws -> EvalQuery {
        try compile(bql)
    }

    public func run(_ bql: String, parameters: BQLParameters) throws -> EvalQuery {
        try compile(bql, parameters: parameters)
    }

    public func run(_ bql: String, in context: QueryContext) throws -> QueryResult {
        try executor.execute(compile(bql, context: context), context: context)
    }

    public func run(_ bql: String, parameters: BQLParameters, in context: QueryContext) throws -> QueryResult {
        try executor.execute(
            compile(bql, parameters: parameters, context: context),
            context: context
        )
    }

    public func run(_ bql: String, in ledger: ParsedLedger<Cost>) throws -> QueryResult {
        try run(bql, in: BeancountQueryContextBuilder.makeContext(from: ledger))
    }

    public func run(_ bql: String, parameters: BQLParameters, in ledger: ParsedLedger<Cost>) throws -> QueryResult {
        try run(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(from: ledger)
        )
    }

    public func run(_ bql: String, in directives: [Directive<Cost>]) throws -> QueryResult {
        try run(bql, in: BeancountQueryContextBuilder.makeContext(directives: directives))
    }

    public func run(_ bql: String, parameters: BQLParameters, in directives: [Directive<Cost>]) throws -> QueryResult {
        try run(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(directives: directives)
        )
    }
}
