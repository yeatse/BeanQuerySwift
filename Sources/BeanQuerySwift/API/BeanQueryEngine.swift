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

    private func compileStatement(
        _ statement: BQLStatement,
        parameters: BQLParameters? = nil,
        context: QueryContext? = nil
    ) throws -> EvalQuery {
        try compiler.compile(statement, parameters: parameters, context: context)
    }

    func compile(
        _ bql: String,
        parameters: BQLParameters? = nil,
        context: QueryContext? = nil
    ) throws -> EvalQuery {
        try compileStatement(parse(bql), parameters: parameters, context: context)
    }

    private func execute(
        _ statement: BQLStatement,
        parameters: BQLParameters?,
        in context: QueryContext
    ) throws -> QueryResult {
        try executor.execute(
            compileStatement(statement, parameters: parameters, context: context),
            context: context
        )
    }

    private func execute(
        _ bql: String,
        parameters: BQLParameters?,
        in context: QueryContext
    ) throws -> QueryResult {
        try execute(parse(bql), parameters: parameters, in: context)
    }

    private func renderFormat(
        for statement: BQLStatement,
        requested format: QueryRenderFormat
    ) -> QueryRenderFormat {
        if case .print = statement {
            return .beancount
        }
        return format
    }

    /// One-step compile entry point, useful for introspecting query plans.
    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil
    ) throws -> EvalQuery {
        try compile(bql, parameters: parameters)
    }

    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in context: QueryContext
    ) throws -> QueryResult {
        try execute(bql, parameters: parameters, in: context)
    }

    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in ledger: ParsedLedger<Cost>
    ) throws -> QueryResult {
        try execute(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(from: ledger)
        )
    }

    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in directives: [Directive<Cost>]
    ) throws -> QueryResult {
        try execute(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(directives: directives)
        )
    }

    public func render(
        _ result: QueryResult,
        as format: QueryRenderFormat = .text,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        try QueryRenderer.render(result, format: format, options: options)
    }

    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in context: QueryContext,
        as format: QueryRenderFormat,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        let statement = try parse(bql)
        let result = try execute(statement, parameters: parameters, in: context)
        return try render(
            result,
            as: renderFormat(for: statement, requested: format),
            options: options
        )
    }

    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in ledger: ParsedLedger<Cost>,
        as format: QueryRenderFormat,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        try run(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(from: ledger),
            as: format,
            options: options
        )
    }

    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in directives: [Directive<Cost>],
        as format: QueryRenderFormat,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        try run(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(directives: directives),
            as: format,
            options: options
        )
    }
}
