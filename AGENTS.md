# AGENTS.md

Repository-specific guidance for engineers and coding agents working on BeanQuerySwift.

## Goal

Keep BeanQuerySwift behavior aligned with Python `beanquery` while staying pragmatic for Swift ergonomics and BeancountSwift integration.

Primary references:

- Python source: `../beanquery`
- Plan doc: `Docs/bean-query-swift-execution-plan.md`
- ANTLR process: `Docs/antlr.md`

## Local Environment

- Package defaults to remote dependency: `https://github.com/yeatse/BeancountSwift` (`from: 1.1.2`)
- During development, it is allowed to temporarily switch to local path dependency: `../BeancountSwift`
- Build/test command:
  - `swift test`
- Current grammar generation command:
  - `./Scripts/generate-antlr.sh`

If grammar changes are made, commit generated files in `Sources/BeanQuerySwift/Generated`.

## Code Map

- Public API: `Sources/BeanQuerySwift/API/BeanQueryEngine.swift`
- Renderer API: `Sources/BeanQuerySwift/API/QueryRenderer.swift`
- Parse and AST:
  - `Sources/BeanQuerySwift/Parser/BQLParserFacade.swift`
  - `Sources/BeanQuerySwift/Parser/BQLAstBuilder.swift`
  - `Sources/BeanQuerySwift/Parser/AST.swift`
- Compiler:
  - `Sources/BeanQuerySwift/Compiler/BQLCompiler.swift`
  - `Sources/BeanQuerySwift/Compiler/TypeSystem.swift`
  - `Sources/BeanQuerySwift/Compiler/EvalQuery.swift`
- Executor:
  - `Sources/BeanQuerySwift/Execution/QueryExecutor.swift`
  - `Sources/BeanQuerySwift/Execution/BuiltinFunctionEvaluator.swift`
- Beancount adapters:
  - `Sources/BeanQuerySwift/Sources/BeancountQueryContextBuilder.swift`

## Alignment Rules

- Prefer Python `beanquery` semantics over convenience shortcuts.
- Keep builtin function order in `BuiltinFunctionEvaluator` aligned with Python `query_env.py` so missing coverage is easy to diff.
- For `BALANCES` / `JOURNAL` / `PRINT`, preserve compiler desugaring behavior and output shape consistency.
- Inventory/lot semantics must be validated against BeancountSwift fixtures and tests.

## Test Rules

When adding/changing behavior, add tests in the matching suite:

- Parser grammar/AST: `Tests/BeanQuerySwiftTests/BQLParserFacadeTests.swift`
- Compilation/type rules: `Tests/BeanQuerySwiftTests/BQLCompilerTests.swift`
- Runtime execution: `Tests/BeanQuerySwiftTests/BQLExecutionTests.swift`
- Builtin functions (general): `Tests/BeanQuerySwiftTests/BuiltinFunctionExecutionTests.swift`
- Builtin functions (account ops): `Tests/BeanQuerySwiftTests/BuiltinAccountFunctionExecutionTests.swift`
- Renderer behavior: `Tests/BeanQuerySwiftTests/QueryRendererTests.swift`
- Beancount adapters/integration: `Tests/BeanQuerySwiftTests/BeancountSourceAdapterTests.swift`

Always run `swift test` before finalizing.

## Change Workflow

1. Reproduce the issue with a failing test.
2. Implement the smallest fix in parser/compiler/executor layer as appropriate.
3. Add/adjust tests to lock behavior.
4. Run `swift test`.
5. Update docs when behavior or supported syntax changes.

## Common Pitfalls

- Changing grammar without regenerating ANTLR output.
- Implementing parser support without compiler/runtime support.
- Adding builtin behavior without null/type semantics parity.
- Forgetting to keep account operation behavior aligned with Python tests.
