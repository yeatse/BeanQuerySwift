import Foundation
import BeancountSwift

/// Public entrypoint for compiling, executing, and rendering BQL queries.
///
/// The engine provides three semantic layers:
/// - `compile`: Parse and compile only, returning an `EvalQuery` plan.
/// - `run`: Compile and execute, returning a structured `QueryResult`.
/// - `render`: Render a `QueryResult` as text/csv/beancount.
public struct BeanQueryEngine {
    private let compiler: BQLCompiler
    private let executor = QueryExecutor()

    /// Creates a query engine with configurable compiler defaults.
    ///
    /// - Parameters:
    ///   - defaultTableName: Default `FROM` table used when omitted in a query.
    ///   - supportImplicitGroupBy: Whether non-aggregate targets should be auto-added to `GROUP BY`.
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

    /// Compiles BQL into an executable query plan (`EvalQuery`) without running it.
    ///
    /// - Parameters:
    ///   - bql: The BQL statement to compile.
    ///   - parameters: Optional placeholder bindings (`%s` / `%(name)s`).
    ///   - context: Optional context used for compile-time wildcard expansion and source validation.
    /// - Returns: A compiled `EvalQuery` plan.
    /// - Throws: Parse or compile errors (for example invalid syntax, invalid function signatures,
    ///   placeholder mismatches, or aggregate misuse).
    public func compile(
        _ bql: String,
        parameters: BQLParameters? = nil,
        context: QueryContext? = nil
    ) throws -> EvalQuery {
        try compileStatement(parse(bql), parameters: parameters, context: context)
    }

    private func executeStatement(
        _ statement: BQLStatement,
        parameters: BQLParameters?,
        in context: QueryContext
    ) throws -> QueryResult {
        try executor.execute(
            compileStatement(statement, parameters: parameters, context: context),
            context: context
        )
    }

    /// Runs BQL against a query context and returns a structured query result.
    ///
    /// - Parameters:
    ///   - bql: The BQL statement to run.
    ///   - parameters: Optional placeholder bindings (`%s` / `%(name)s`).
    ///   - context: In-memory query context containing tables/providers/price map.
    /// - Returns: A `QueryResult` containing projected column names and rows.
    /// - Throws: Parse, compile, or runtime execution errors.
    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in context: QueryContext
    ) throws -> QueryResult {
        try executeStatement(
            parse(bql),
            parameters: parameters,
            in: context
        )
    }

    /// Runs BQL directly against a parsed ledger.
    ///
    /// - Parameters:
    ///   - bql: The BQL statement to run.
    ///   - parameters: Optional placeholder bindings (`%s` / `%(name)s`).
    ///   - ledger: Parsed Beancount ledger.
    /// - Returns: A `QueryResult` containing projected column names and rows.
    /// - Throws: Parse, compile, or runtime execution errors.
    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in ledger: ParsedLedger<Cost>
    ) throws -> QueryResult {
        try run(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(from: ledger)
        )
    }

    /// Runs BQL directly against directive values.
    ///
    /// - Parameters:
    ///   - bql: The BQL statement to run.
    ///   - parameters: Optional placeholder bindings (`%s` / `%(name)s`).
    ///   - directives: Directive list used to build internal source tables.
    /// - Returns: A `QueryResult` containing projected column names and rows.
    /// - Throws: Parse, compile, or runtime execution errors.
    public func run(
        _ bql: String,
        parameters: BQLParameters? = nil,
        in directives: [Directive<Cost>]
    ) throws -> QueryResult {
        try run(
            bql,
            parameters: parameters,
            in: BeancountQueryContextBuilder.makeContext(directives: directives)
        )
    }

    /// Renders a `QueryResult` using the selected output format.
    ///
    /// - Parameters:
    ///   - result: Query result to render.
    ///   - format: Output format (`text`, `csv`, or `beancount`).
    ///   - options: Renderer options used by text/csv renderers.
    /// - Returns: Rendered string output.
    /// - Throws: Rendering errors (for example invalid beancount row shape).
    public func render(
        _ result: QueryResult,
        as format: QueryRenderFormat = .text,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        try QueryRenderer.render(result, format: format, options: options)
    }
}
