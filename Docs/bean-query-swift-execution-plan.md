# BeanQuerySwift 执行计划（ANTLR + BeancountSwift）

## 1. 目标与边界

### 1.1 目标
- 输入 BQL 字符串，输出可执行的 `EvalQuery`（或等价执行计划）。
- 能在 `BeancountSwift` 的账本数据上执行查询并返回结构化结果（列定义 + 行数据）。
- 解析层使用 ANTLR（Swift target）实现，替代 TatSu。
- 尽量对齐 Python `beanquery` 的行为（语法、类型规则、聚合规则、错误语义）。

### 1.2 非目标（首版）
- 不优先实现 shell/CLI 渲染（只做库 API）。
- 不优先实现全部数据源（CSV/memory 等），先聚焦 Beancount 数据源。
- 不优先做 SQL 方言扩展（先兼容 BQL 现有行为）。

## 2. 总体架构

将实现拆成 5 层：

1. `Parser`（ANTLR 生成）
- 输入：`String`
- 输出：ANTLR Parse Tree

2. `AST Builder`（手写）
- 输入：Parse Tree
- 输出：稳定的 Swift AST（`Select`, `Expr`, `GroupBy`...）

3. `Compiler`
- 输入：AST + 编译上下文（tables/functions/operators）
- 输出：`EvalQuery`（compiled query plan）

4. `Executor`
- 输入：`EvalQuery`
- 输出：`QueryResult`（columns + rows）

5. `Beancount Adapter`
- 输入：`ParsedLedger<Cost>`
- 输出：`postings / entries / accounts / ...` 查询表

## 3. 目录与模块规划

建议新增目录结构（在 `Sources/BeanQuerySwift` 下）：

```text
Sources/BeanQuerySwift/
  API/
    BeanQueryEngine.swift
    QueryResult.swift
    Errors.swift
  Grammar/
    BQLLexer.g4
    BQLParser.g4
  Generated/                 # ANTLR 生成产物
    BQLLexer.swift
    BQLParser.swift
    ...
  Parser/
    ParseFacade.swift
    AstBuilder.swift
    AST.swift
  Compiler/
    Compiler.swift
    TypeSystem.swift
    FunctionRegistry.swift
    OperatorRegistry.swift
    Rewrite.swift            # balances/journal/print desugar
  Eval/
    EvalNode.swift
    EvalQuery.swift
    EvalAggregators.swift
    Executor.swift
  Tables/
    TableProtocol.swift
    NullTable.swift
    SubqueryTable.swift
  Sources/
    BeancountSource.swift
    BeancountTables/
      PostingsTable.swift
      EntriesTable.swift
      AccountsTable.swift
      ...
  Internal/
    DateUtils.swift
    DecimalUtils.swift
```

## 4. 里程碑计划（详细）

## M0. 脚手架与依赖（0.5~1 天）

### 任务
- 在 `Package.swift` 增加 `Antlr4` runtime 依赖。
- 增加 ANTLR 代码生成脚本（如 `Scripts/generate-antlr.sh`）：
  - 固定输入：`Sources/BeanQuerySwift/Grammar/*.g4`
  - 固定输出：`Sources/BeanQuerySwift/Generated/`
- 约定是否提交 generated files（建议提交，减少环境差异）。

### 交付
- 可执行生成脚本 + 最小编译通过。

### 验收
- 本地执行脚本后 `swift build` 通过。

---

## M1. 语法迁移（ANTLR）与 Parse Facade（2~3 天）

### 任务
- 从 `beanquery/parser/bql.ebnf` 迁移到 `BQLLexer.g4` + `BQLParser.g4`。
- 先覆盖核心语句：
  - `SELECT ... FROM ... WHERE ... GROUP BY ... ORDER BY ... LIMIT ...`
  - 表达式优先级（OR/AND/NOT/comparison/sum/term/unary/atom）。
- 实现大小写不敏感关键字策略（统一词法规则）。
- 处理注释/分号策略（见第 10 节待确认问题）。
- 实现 parse 错误包装：`line/column/token/range`。

### 交付
- `parse(_:) -> ParseTree`
- 基础语法测试（至少 40+ cases）。

### 验收
- `SELECT`、表达式优先级、函数调用、placeholder、字面量解析通过测试。

---

## M2. Swift AST 与 AstBuilder（2~3 天）

### 任务
- 对齐 Python `ast.py` 建立 Swift AST：
  - 语句节点：`Select/Balances/Journal/Print/CreateTable/Insert`
  - 表达式节点：`Column/Function/Constant/Placeholder/...`
  - 运算节点：`And/Or/Not/Equal/.../Between/...`
- AST 节点携带 `SourceRange`（用于错误提示）。
- 实现 Parse Tree -> AST Visitor。
- 实现 AST dump（用于 golden test）。

### 交付
- `parseToAST(_:) -> Statement`

### 验收
- AST 与 Python 版关键 case 结构一致（golden 对比）。

---

## M3. 类型系统 + 注册表（3~4 天）

### 任务
- 实现 `BQLType` 抽象（`int/decimal/date/str/bool/object/null/list/set/dict/...`）。
- 实现函数/运算符重载查找（对齐 Python `types.function_lookup` 行为）。
- 建立 `FunctionRegistry` 与 `OperatorRegistry`：
  - 先落地最小集合：`count/sum/min/max/first/last` + 基础算术/比较/逻辑。
- 支持常量折叠（pure function + constant args）。

### 交付
- 编译器可进行函数签名匹配和类型校验。

### 验收
- 不合法签名报错可读、合法签名能成功编译。

---

## M4. Compiler（SELECT 主路径）（4~6 天）

### 任务
- 实现 `Compiler.compile(statement, parameters)`：
  - placeholder 绑定（命名/位置参数，且不可混用）
  - `FROM`（table、subquery、from-expression）
  - `targets` 编译（含 `*` 展开）
  - `WHERE`
  - `GROUP BY/HAVING`
  - `ORDER BY`
  - `LIMIT/DISTINCT`
- 实现关键校验：
  - aggregate 与 non-aggregate 混用检查
  - aggregate of aggregate 检查
  - 非聚合列与 group_indexes 一致性检查
- 支持隐式 GROUP BY（可配置开关，默认与 Python 一致启用）。

### 交付
- `EvalQuery` compiled plan。

### 验收
- 覆盖至少 60+ 编译测试（含错误路径）。

---

## M5. Executor（3~4 天）

### 任务
- 实现 `executeSelect`：
  - 非聚合路径
  - 聚合路径（allocator/store/update/finalize）
  - `HAVING`
  - `ORDER BY`（含 `NULL` 排序语义）
  - `DISTINCT`
  - `LIMIT`
- 实现 `EvalNode` 体系（`EvalConstant/EvalBinaryOp/EvalFunction/EvalAggregator/...`）。

### 交付
- `EvalQuery.__call__`（或 Swift 等价接口）可直接产出结果。

### 验收
- 执行结果与 Python 版样例一致（至少 20 条查询对照）。

---

## M6. BeancountSwift 数据源适配（5~7 天）

### 任务
- 提供 `attachBeancount(ledger:)`，建立上下文默认表：
  - `postings`（优先）
  - `entries`
  - `accounts`
  - 后续再补 `prices/balances/notes/events/documents/...`
- 映射 `BeancountSwift` 结构到行上下文：
  - 利用 `Directive<Cost>`、`Transaction<Cost>`、`Posting<Cost>`。
- 对齐 Python `postings` 关键列：
  - `date/year/month/day/flag/payee/narration/account/number/currency/position/price/weight/balance/meta/entry/accounts...`
- 复用 `BeancountSwift.Operation.Summarize` 对应 `FROM ... OPEN/CLOSE/CLEAR` 语义（已存在 `openOpt/closeOpt/clearOpt`）。

### 交付
- 查询可直接跑在真实账本上（至少一份回归账本）。

### 验收
- `SELECT account, sum(position) ...` 等核心查询可返回正确结果。

---

## M7. BQL 语法糖与扩展语句（3~5 天）

### 任务
- 实现 `BALANCES/JOURNAL/PRINT` 到 `SELECT` 的编译期重写（desugar）。
- 实现 `PIVOT BY`。
- 评估并实现 `CREATE TABLE / INSERT`（如首版需要）。
- 补齐特殊函数重写：
  - `row(*)`, `coalesce()`, `meta()`, `entry_meta()`, `any_meta()`, `has_account()`

### 交付
- 与 Python 版高级语句行为接近。

### 验收
- 对应语句通过功能和错误路径测试。

---

## M8. 兼容性验证、性能与文档（2~3 天）

### 任务
- Golden 回归：
  - 选择一组固定 BQL + ledger，Swift 与 Python 输出对照。
- 性能基线：
  - 编译耗时、执行耗时、内存占用。
- API 文档与示例：
  - `compile`、`execute`、`run` 三种入口示例。

### 交付
- 首个可发布版本（建议 `0.1.0`）。

### 验收
- CI 稳定通过，核心查询无已知回归。

## 5. API 设计建议（首版）

```swift
public struct QueryColumn {
    public let name: String
    public let type: BQLType
}

public struct QueryResult {
    public let columns: [QueryColumn]
    public let rows: [[BQLValue]]
}

public protocol CompiledQuery {
    func execute() throws -> QueryResult
}

public final class BeanQueryEngine {
    public init(context: QueryContext)
    public func parse(_ bql: String) throws -> Statement
    public func compile(_ statement: Statement, params: QueryParameters? = nil) throws -> EvalQuery
    public func run(_ bql: String, params: QueryParameters? = nil) throws -> QueryResult
}
```

## 6. 测试计划

### 6.1 Parser 测试
- 语句覆盖：`SELECT/BALANCES/JOURNAL/PRINT/CREATE/INSERT`
- 表达式覆盖：优先级、结合性、`IN/BETWEEN/IS NULL/regex`。
- 错误覆盖：非法 token、缺失子句、括号不匹配。

### 6.2 Compiler 测试
- 占位符绑定规则、函数重载解析、类型推断、常量折叠。
- GROUP BY/ORDER BY/HAVING 各类引用（名称、索引、表达式）。

### 6.3 Executor 测试
- 非聚合、聚合、排序、分页、去重、NULL 语义。

### 6.4 兼容性测试
- 选取 Python `beanquery` 的核心测试样例移植为 Swift 测试。
- 真实账本回归（至少 1~2 份）。

## 7. 风险与应对

- 语法迁移风险（TatSu -> ANTLR）：
  - 应对：先做最小语法闭环（SELECT + expression），再逐步扩展。
- 类型系统差异（Python 动态 vs Swift 静态）：
  - 应对：引入 `BQLType + BQLValue`，编译期校验，运行期保留 `object` 兜底。
- Beancount 日期类型差异（Python `date` vs Swift `Date`）：
  - 应对：统一“日粒度”处理与比较，避免时区漂移。
- 函数数量大、迁移成本高：
  - 应对：按查询频率做优先级清单，先聚合与常用函数。

## 8. 建议实施顺序（可直接开工）

1. M0 + M1：先把 ANTLR 解析链路跑通。
2. M2 + M4（并行一部分）：AST 与 SELECT 编译主干。
3. M5：执行器跑通基础查询。
4. M6：接入 `BeancountSwift` 的 `postings/entries`。
5. M7 + M8：补齐语法糖、兼容性与性能。

## 9. 预计工期（首版）

- MVP（可查询真实 ledger，支持 SELECT + 聚合 + 分组 + 排序）：约 3~4 周。
- 接近 Python 行为（含 BALANCES/JOURNAL/PRINT/PIVOT 和更多函数）：约 5~7 周。

## 10. 待你确认的问题（开始 M1 前建议定稿）

1. 首版功能范围：
- 仅 `SELECT` 先上线，还是必须同时包含 `BALANCES/JOURNAL/PRINT`？

2. 注释/分号策略：
- 是否严格兼容 Python 版的 `;` 行注释（会与语句末分号产生歧义），还是改为 `--` 行注释并保留 `;` 作为终止符？

3. 兼容目标：
- 以“行为接近”为目标，还是要尽量逐条对齐 Python `beanquery`（包含边界行为）？

4. `CREATE TABLE/INSERT`：
- 是否纳入首版里程碑，还是放到第二阶段？

5. 默认表策略：
- 是否与 Python 一致，`beancount` 数据源默认表设置为 `postings`？

6. 对外 API 形态：
- 你更偏好 `run(query)` 一步接口，还是保留 `parse -> compile -> execute` 三段式 API？
