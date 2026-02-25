# BeanQuerySwift

BeanQuerySwift is a Swift implementation of Beancount `bean-query`.
It compiles BQL into `EvalQuery`, then executes against Beancount data (`ParsedLedger<Cost>`, `[Directive<Cost>]`, or a custom `QueryContext`).

## Status

Current implementation is focused on query execution and Python behavior alignment.

Implemented statements:

- `SELECT`
- `BALANCES` (desugared to `SELECT`)
- `JOURNAL` (desugared to `SELECT`)
- `PRINT`

Implemented renderers:

- `text` (table renderer)
- `csv`
- `beancount` (prints directive rows in Beancount syntax)

Implemented clauses and features:

- `FROM` (table/hash/subselect and Beancount qualifiers)
- `WHERE`
- `GROUP BY` / `HAVING`
- `ORDER BY`
- `PIVOT BY`
- `LIMIT`
- `DISTINCT`
- Positional and named placeholders (`%s`, `%(name)s`)
- Line comments with both `;` and `--`

Implemented tables from Beancount adapters:

- `postings`
- `entries`
- `accounts`

Core aggregates:

- `count`, `sum`, `first`, `last`, `min`, `max`

Selected builtin function groups (aligned with Python `query_env.py` scope already implemented):

- Date/time: `date`, `parse_date`, `today`, `date_diff`, `date_add`, `date_trunc`, `date_part`, `interval`, `date_bin`
- Account operations: `root`, `parent`, `leaf`, `grep`, `grepn`, `subst`, `upper`, `lower`, `open_date`, `close_date`, `open_meta`, `account_sortkey`, `has_account`, `findfirst`, `joinstr`
- Inventory/amount/position: `units`, `cost`, `weight`, `convert`, `value`, `getprice`, `number`, `currency`/`commodity`, `only`, `empty`, `filter_currency`, `possign`

Date/interval arithmetic now supports Python-like behavior for:

- `date + interval`
- `interval + date`
- `interval + interval`
- `date - interval`
- `date - date` (returns days)
- `interval - interval`

## Known Gaps

- No DDL/DML (`CREATE TABLE`, `INSERT`, etc.)
- No `JOIN`
- `attribute` and `subscript` expressions are parsed in AST but not yet executable
- Feature surface is intentionally query-first in phase 1; extension points are kept in compiler/executor design

## Requirements

- Swift toolchain: `6.2` (see `Package.swift`)
- Default dependency:
  - `https://github.com/yeatse/BeancountSwift` (`from: 1.1.2`)
- During local development only, you may temporarily switch to a path dependency:
  - `../BeancountSwift`

## Quick Start

Compile only:

```swift
import BeanQuerySwift

let engine = BeanQueryEngine()
let plan = try engine.compile("SELECT account, sum(number) AS total FROM #postings GROUP BY account")
```

Compile + execute with a custom context:

```swift
import BeanQuerySwift

let engine = BeanQueryEngine()
let context = QueryContext(tables: [
    "postings": [
        ["account": .string("Assets:Cash"), "number": .int(10)],
        ["account": .string("Assets:Cash"), "number": .int(5)],
    ]
])

let result = try engine.run(
    "SELECT account, sum(number) AS total FROM #postings GROUP BY account",
    in: context
)
```

Run directly on Beancount data:

```swift
import BeanQuerySwift
import BeancountSwift

let engine = BeanQueryEngine()
let result = try engine.run("BALANCES AT units", in: parsedLedger)
```

Chain `run` + `render`:

```swift
import BeanQuerySwift

let engine = BeanQueryEngine()
let rendered = try engine.run(
    "SELECT account, number FROM postings ORDER BY number DESC",
    in: parsedLedger
).render(as: .csv)
```

## Development

Run tests:

```bash
swift test
```

Regenerate ANTLR parser/lexer code:

```bash
./Scripts/generate-antlr.sh
```

The generation script also applies Swift 6 compatibility adjustments to generated files.

## Project Layout

- `Sources/BeanQuerySwift/Grammar`: ANTLR grammars (`BQLLexer.g4`, `BQLParser.g4`)
- `Sources/BeanQuerySwift/Generated`: generated ANTLR Swift files
- `Sources/BeanQuerySwift/Parser`: parse facade and AST builder
- `Sources/BeanQuerySwift/Compiler`: type checking and BQL -> `EvalQuery` compilation
- `Sources/BeanQuerySwift/Execution`: query execution engine and builtin evaluators
- `Sources/BeanQuerySwift/API`: public entrypoint (`BeanQueryEngine`)
- `Sources/BeanQuerySwift/Sources`: Beancount data adapters (`BeancountQueryContextBuilder`)
- `Tests/BeanQuerySwiftTests`: parser/compiler/execution and Beancount integration tests

## References

- `/Users/yeatse/Developer/Repo/BeanQuerySwift/Docs/bean-query-swift-execution-plan.md`
- `/Users/yeatse/Developer/Repo/BeanQuerySwift/Docs/bean-query.md`
- `/Users/yeatse/Developer/Repo/BeanQuerySwift/Docs/antlr.md`
