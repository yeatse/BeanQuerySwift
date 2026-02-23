# beanquery 源码阅读笔记

## 目录

- [1. 工程介绍](#1-工程介绍)
- [2. Parser 工作流程](#2-parser-工作流程)
- [3. Compiler 工作流程](#3-compiler-工作流程)
- [4. BQL 与 SQL 的语法区别](#4-bql-与-sql-的语法区别)

---

## 1. 工程介绍

**beanquery** 是一个轻量级、可扩展的 SQL 查询工具，专为 [Beancount](https://beancount.github.io/) 复式记账账本数据设计。

- **版本**: 0.3.0.dev0（开发中）
- **协议**: GPL-2.0
- **作者**: Martin Blais、Daniele Nicolodi

### 核心功能

beanquery 实现了一种叫做 **BQL（Beancount Query Language）** 的类 SQL 查询语言，可以对 Beancount 账本数据进行结构化查询。

| 特性 | 说明 |
|---|---|
| SQL 语法支持 | `SELECT`、`WHERE`、`GROUP BY`、`HAVING`、`ORDER BY` 等 |
| DB-API 2.0 兼容 | 通过标准的 `connect()` / `cursor()` / `execute()` 方式使用 |
| 交互式 Shell | 通过命令行工具 `bean-query` 启动交互式查询界面 |
| 多数据源 | 支持 Beancount 账本、CSV 文件、内存表等数据源 |
| 多输出格式 | 支持文本、CSV 格式输出 |

### 目录结构

```
beanquery/
├── parser/          # BQL 语法解析器（基于 TatSu）
├── sources/         # 数据源插件
│   ├── beancount.py # Beancount 账本数据源
│   ├── csv.py       # CSV 数据源
│   └── memory.py    # 内存表数据源
├── render/          # 输出渲染
│   ├── text.py      # 文本表格渲染
│   └── csv.py       # CSV 渲染
├── compiler.py      # BQL 查询编译器
├── query_execute.py # 查询执行引擎
├── query_env.py     # 内置函数/列定义（BQL 环境）
├── shell.py         # 交互式 CLI（bean-query 命令）
└── types.py         # 类型系统
```

### 使用方式

**命令行**：
```bash
bean-query ledger.beancount
```

**Python API**：
```python
import beanquery
conn = beanquery.connect('beancount:///path/to/ledger.beancount')
cursor = conn.execute('SELECT account, sum(units(position)) WHERE year = 2024 GROUP BY account')
```

---

## 2. Parser 工作流程

Parser 的源码位于 `beanquery/parser/` 目录，整个解析过程分为三个层次：**语法定义 → 语法解析 → 语义动作 → AST 输出**。

### 第一层：语法定义（`bql.ebnf`）

使用 **[TatSu](https://tatsu.readthedocs.io/)** 框架，以 EBNF 格式定义 BQL 语法规则。

**入口规则：**
```
bql = @:statement [';'] $
```

**支持的语句类型：**

| 语句类型 | 示例 |
|---|---|
| `select` | `SELECT account, sum(position) WHERE year = 2024` |
| `balances` | `BALANCES AT units FROM date = 2024-01-01 CLOSE` |
| `journal` | `JOURNAL 'Assets:Checking' AT cost` |
| `print` | `PRINT FROM date = 2024-01-01` |
| `create_table` | `CREATE TABLE foo AS SELECT ...` |
| `insert` | `INSERT INTO foo VALUES (...)` |

**表达式优先级**（从低到高，完全对应标准 SQL）：

```
disjunction (OR)
  └── conjunction (AND)
        └── inversion (NOT)
              └── comparison (=, !=, <, >, IS NULL, BETWEEN, IN, ~)
                    └── sum (+ -)
                          └── term (* / %)
                                └── factor (括号)
                                      └── unary (正负号)
                                            └── primary (属性访问、下标)
                                                  └── atom (函数调用、列名、常量)
```

**字面量类型：**

| 类型 | 正则 | Python 类型 |
|---|---|---|
| `integer` | `/[0-9]+/` | `int` |
| `decimal` | `/[0-9]+\.[0-9]*/` | `Decimal` |
| `date` | `/[0-9]{4}-[0-9]{2}-[0-9]{2}/` | `datetime.date` |
| `string` | 单引号或双引号 | `str` |
| `boolean` | `TRUE` / `FALSE` | `bool` |
| `null` | `NULL` | `None` |

### 第二层：解析器生成（`parser.py`）

`parser.py` 是由 TatSu 从 `bql.ebnf` **自动生成**的，不直接手写。`pyproject.toml` 中也将其排除在 lint 检查之外：

```toml
exclude = ['beanquery/parser/parser.py']
```

调用方式：
```python
BQLParser().parse(text, semantics=BQLSemantics())
```

### 第三层：语义动作（`__init__.py` 中的 `BQLSemantics`）

TatSu 在每匹配一条规则后，会调用 `BQLSemantics` 中对应的方法，将原始 token 转换为 Python 类型或 AST 节点：

```python
class BQLSemantics:

    def integer(self, value):
        return int(value)           # "42" → 42

    def decimal(self, value):
        return decimal.Decimal(value)  # "3.14" → Decimal('3.14')

    def date(self, value):
        return datetime.date.fromisoformat(value)  # "2024-01-01" → date(2024,1,1)

    def string(self, value):
        return value[1:-1]          # 去掉引号

    def boolean(self, value):
        return value == 'TRUE'      # → True / False

    def unquoted_identifier(self, value):
        return value.lower()        # 统一转小写（大小写不敏感）

    def ordering(self, value):
        return ast.Ordering[value or 'ASC']  # 默认升序

    def _default(self, value, typename=None):
        # 对所有在 ebnf 中标注了 ::NodeType 的规则
        # 自动反射调用 ast.NodeType(**kwargs) 构造 AST 节点
        if typename is not None:
            func = getattr(ast, typename)
            return func(**{name.rstrip('_'): value for name, value in value.items()})
        return value
```

关键机制是 `_default`：ebnf 中凡是标注了 `::TypeName` 的规则（如 `select::Select`、`eq::Equal::BinaryOp`），TatSu 匹配后会自动调用 `_default` 并传入 `typename`，从而自动实例化对应的 AST 节点类。

### 第四层：AST 节点（`ast.py`）

所有节点继承自 `Node` 基类，用 `dataclasses.make_dataclass` 动态生成：

```python
def node(name, fields):
    return dataclasses.make_dataclass(
        name,
        [*fields.split(), ('parseinfo', None, ...)],
        bases=(Node,), ...)
```

**主要节点类型：**

| 类别 | 节点 |
|---|---|
| 语句 | `Select`, `Balances`, `Journal`, `Print` |
| 子句 | `From`, `GroupBy`, `OrderBy`, `PivotBy` |
| 表达式 | `Column`, `Function`, `Constant`, `Placeholder` |
| 布尔运算 | `And`, `Or`, `Not` |
| 比较运算 | `Equal`, `NotEqual`, `Less`, `Greater`, `IsNull`, `Between`, `In`, `Match` |
| 算术运算 | `Add`, `Sub`, `Mul`, `Div`, `Mod`, `Neg` |
| 访问器 | `Attribute`（`.`），`Subscript`（`[]`） |

每个节点都带有 `parseinfo` 字段，记录原始文本位置，可通过 `.text` 属性取回源码片段（用于错误提示）。

AST 还提供两个实用工具：
- **`tosexp()`**：将 AST 转为 S-表达式字符串，便于调试
- **`walk()`**：后序遍历整棵 AST，可用于提取特定类型节点（如查找所有 `Placeholder`）

### 完整流程图

```
BQL 字符串
    │
    ▼
BQLParser().parse(text, semantics=BQLSemantics())   ← TatSu 自动生成的解析器
    │
    │  匹配每条语法规则时，回调 BQLSemantics 对应方法
    │
    ├─ 字面量规则 → int / Decimal / date / str / bool / None
    │
    ├─ 标注了 ::NodeType 的规则 → _default() → ast.NodeType(**kwargs)
    │
    └─ 其他规则 → 直接透传匹配结果
    │
    ▼
AST 根节点（Select / Balances / Journal / ...）
    │
    ▼
传给 compiler.compile() 进行类型检查和编译
```

### 错误处理

```python
def parse(text):
    try:
        return BQLParser().parse(text, semantics=BQLSemantics())
    except tatsu.exceptions.ParseError as exc:
        # 捕获 TatSu 原始异常，包装为带位置信息的 ParseError
        parseinfo = tatsu.infos.ParseInfo(exc.tokenizer, exc.item, exc.pos, ...)
        raise ParseError(parseinfo) from exc
```

`ParseError` 继承自 `ProgrammingError`（DB-API 2.0 标准异常），携带 `parseinfo` 位置信息，供 shell 层渲染出带光标指示的错误提示。

---

## 3. Compiler 工作流程

Compiler 横跨 `compiler.py` 和 `query_compile.py` 两个文件，核心职责是将 Parser 输出的 AST 转换为**可直接执行的求值树（EvalNode tree）**。

### 整体架构

```
AST（来自 parser）
      │
      ▼
  Compiler（compiler.py）
      │  singledispatch 分发到各节点处理方法
      │  类型检查、语义校验
      │  查找 OPERATORS/FUNCTIONS 注册表
      ▼
 EvalNode 树（query_compile.py）
      │
      ▼
 query_execute.execute_select()  ← 执行阶段
```

### 第一步：入口与参数处理

```python
# compiler.py:912
def compile(context, statement, parameters=None):
    return Compiler(context).compile(statement, parameters)
```

`Compiler` 初始化时持有两个关键状态：
- `context`：数据库连接对象，含所有注册的 `tables`
- `stack`：当前活跃表的栈，支持子查询嵌套（`FROM (SELECT ...)`）

`compile()` 首先处理**查询参数（Placeholder）**：

```python
# 支持两种参数风格：
#   命名参数：%(foo)s  → parameters 必须是 Mapping
#   位置参数：%s       → parameters 必须是 Sequence，按源码位置排序
```

### 第二步：singledispatch 分发

编译器的核心是 `_compile` 方法，用 `@singledispatchmethod` 实现**按节点类型分发**：

```python
@singledispatchmethod
def _compile(self, node): ...

@_compile.register
def _select(self, node: ast.Select): ...

@_compile.register
def _column(self, node: ast.Column): ...

@_compile.register
def _binaryop(self, node: ast.BinaryOp): ...
```

### 第三步：SELECT 编译（最核心路径）

`_select` 按固定顺序编译各子句：

```
① FROM 子句  →  确定当前表 (self.table)
② targets    →  编译 SELECT 列表
③ WHERE 子句 →  编译过滤条件
④ GROUP BY   →  分组索引 + HAVING
⑤ ORDER BY   →  排序规格
⑥ PIVOT BY   →  列旋转
⑦ 组装 EvalQuery
```

**FROM 子句**有三种形态：

| FROM 形态 | 处理方式 |
|---|---|
| `FROM (SELECT ...)` 子查询 | 递归编译子查询，包装为 `SubqueryTable` 并压栈 |
| `FROM #tablename` 表引用 | 从 `context.tables` 查找并切换 `self.table` |
| `FROM expression OPEN/CLOSE/CLEAR` | 编译过滤表达式，调用 `table.evolve()` 产生新的时间窗口表 |

**GROUP BY** 支持三种引用方式：
- **按索引**：`GROUP BY 1` → 第一个 target（1-based）
- **按名字**：`GROUP BY account` → 匹配 target 名或列名
- **按表达式**：`GROUP BY length(account) > 5` → 编译新表达式，作为隐藏 target 追加

**隐式 GROUP BY**（`SUPPORT_IMPLICIT_GROUPBY = True`）：当查询有聚合函数但没有 `GROUP BY` 时，非聚合列自动成为分组键：

```sql
-- 以下两条查询等价
SELECT account, sum(amount) FROM postings;
SELECT account, sum(amount) FROM postings GROUP BY account;
```

### 第四步：表达式节点编译

**函数调用**中几个特殊函数先做 AST 重写再递归编译：

| 函数 | 重写为 |
|---|---|
| `row(*)` | `EvalRow()`（返回整行原始对象）|
| `coalesce(a, b)` | `EvalCoalesce([a, b])`（特殊短路逻辑）|
| `meta('key')` | `meta['key']`（下标访问）|
| `entry_meta('key')` | `entry.meta['key']`（属性+下标）|
| `any_meta('key')` | `getitem(meta, key, entry.meta[key])` |
| `has_account(re)` | `('(?i)' + re) ?~ any(accounts)` |

**运算符**实现存储在 `OPERATORS` 注册表，按 `(节点类型, 输入类型列表)` 匹配，支持多态重载：

```python
@binaryop(ast.Add, [Decimal, Decimal], Decimal)
@binaryop(ast.Add, [int, int], int)
@binaryop(ast.Add, [str, str], str)
@binaryop(ast.Add, [datetime.date, int], datetime.date)
def add_(x, y): return x + y
```

**类型推断**：当一侧是无类型的 `object`（来自 `meta` 等字段），编译器自动插入类型转换函数，将 `object` 提升为另一侧的类型。

**常量折叠**：若所有操作数都是 `EvalConstant` 且函数是纯函数（`pure=True`），编译期直接求值，替换为新的 `EvalConstant`。

### 第五步：高级语句转换

`BALANCES` 和 `JOURNAL` 在编译期被**降级**为等价的 `SELECT`：

```python
# BALANCES AT units FROM ...
# 等价于：
SELECT account, SUM(units(position))
FROM ...
GROUP BY account, ACCOUNT_SORTKEY(account)
ORDER BY ACCOUNT_SORTKEY(account)

# JOURNAL 'Assets:Checking' AT cost
# 等价于：
SELECT date, flag, MAXWIDTH(payee,48), MAXWIDTH(narration,80),
       account, cost(position), cost(balance)
WHERE account ~ "Assets:Checking"
```

### 第六步：最终产物 `EvalQuery`

```python
@dataclasses.dataclass
class EvalQuery:
    table: Table          # 数据源
    c_targets: list       # 编译后的列列表（含隐藏列）
    c_where: EvalNode     # 过滤条件树
    group_indexes: list   # 分组用的列索引（None=非聚合查询）
    having_index: int     # HAVING 条件的列索引
    order_spec: list      # [(列索引, ASC/DESC), ...]
    limit: int
    distinct: bool

    def __call__(self):
        return query_execute.execute_select(self)
```

调用 `EvalQuery()` 就触发实际执行。

### 完整流程图

```
AST: Select(targets, from_clause, where_clause, group_by, order_by, ...)
            │
            ▼
① _compile_from()
   ├── ast.Select  → 递归编译子查询 → SubqueryTable 压栈
   ├── ast.Table   → 切换 self.table
   └── ast.From    → 编译表达式 + evolve(open/close/clear)
            │
            ▼ self.table 已确定
② _compile_targets()
   ├── ast.Asterisk → 展开通配符列
   └── 每个 Target  → _compile(expression) → EvalTarget
            │
            ▼
③ _compile(where_clause)  → EvalNode 过滤树
   merge: EvalAnd([from_expr, where_expr])
            │
            ▼
④ _compile_group_by()
   → group_indexes[], having_index
   → 追加隐藏 target（新分组表达式）
            │
            ▼
⑤ _compile_order_by()
   → order_spec[(index, ordering)]
   → 追加隐藏 target（新排序表达式）
            │
            ▼
⑥ 校验：非聚合列必须全部出现在 GROUP BY 中
            │
            ▼
⑦ EvalQuery(table, c_targets, c_where, group_indexes, ...)
   └── 若有 PIVOT BY → 包装为 EvalPivot(query, [col1, col2])
```

### 关键设计亮点

| 设计 | 说明 |
|---|---|
| **singledispatch** | 按节点类型分发，OCP 原则，新增节点类型不影响已有逻辑 |
| **OPERATORS/FUNCTIONS 注册表** | 装饰器在模块导入时注册，支持在 `query_env.py` 中扩展新函数 |
| **类型推断** | `object` 类型自动提升，让 metadata 字段可以参与运算 |
| **常量折叠** | 纯函数在编译期求值，避免重复运算 |
| **隐式 GROUP BY** | 省略 GROUP BY 时自动推断分组键，简化常见查询写法 |
| **降级转换** | `BALANCES`/`JOURNAL` 在编译期转换为 `SELECT`，复用执行引擎 |

---

## 4. BQL 与 SQL 的语法区别

### 一、BQL 独有的语句

BQL 新增了三个专用查询语句，SQL 中不存在：

```sql
-- 账户余额汇总（等价于一个固定格式的 SELECT + GROUP BY）
BALANCES AT units FROM date > 2024-01-01

-- 账户流水日志
JOURNAL 'Assets:Checking' AT cost FROM date > 2024-01-01

-- 原始格式打印账本条目
PRINT FROM year = 2024
```

这三个语句在编译期被**降级（desugar）**为等价的 `SELECT` 语句，本质上是常用查询模板的语法糖。

### 二、FROM 子句：时间窗口扩展

BQL 的 `FROM` 子句在 SQL 过滤表达式之外，新增了时间窗口控制修饰符：

```sql
-- SQL FROM：只能指定表名
SELECT * FROM postings WHERE ...

-- BQL FROM：可以直接写过滤表达式 + 时间窗口
SELECT account, sum(position)
FROM  year >= 2023               -- 过滤表达式（替代 WHERE 对数据集的筛选）
OPEN  ON 2023-01-01              -- 插入开账结转分录
CLOSE ON 2023-12-31              -- 插入关账结转分录
CLEAR                            -- 清除未实现收益
```

另外 BQL 支持用 `#name` 引用具名表，`#` 单独使用表示默认空表：

```sql
SELECT * FROM #postings   -- 引用名为 postings 的表
SELECT * FROM #           -- 引用空表
```

### 三、正则匹配运算符

SQL 用 `LIKE` 做模式匹配，BQL 则直接引入正则运算符：

| BQL 运算符 | 含义 |
|---|---|
| `account ~ 'Assets'` | 正则匹配（大小写不敏感）|
| `account !~ 'Assets'` | 正则不匹配 |
| `pattern ?~ account` | 左侧为模式，右侧为字符串 |

```sql
-- BQL
WHERE account ~ 'Assets:.*:Checking'

-- SQL 只能用 LIKE，不支持正则
WHERE account LIKE '%Checking%'
```

### 四、隐式 GROUP BY

SQL 规定：凡是出现在 `SELECT` 中的非聚合列，**必须**出现在 `GROUP BY` 中，否则报错。BQL 放宽了这一限制：

```sql
-- SQL（必须显式写 GROUP BY）
SELECT account, sum(amount) FROM postings GROUP BY account;

-- BQL（GROUP BY 可省略，效果相同）
SELECT account, sum(amount) FROM postings;
```

### 五、PIVOT BY（列转行）

BQL 内置了 `PIVOT BY` 语法，SQL 标准中没有：

```sql
SELECT year, currency, sum(amount)
FROM postings
GROUP BY year, currency
PIVOT BY year, currency
```

执行后将 `currency` 列的值转为列头，`year` 列的值展开为多行。`PIVOT BY` 接受且仅接受两个列引用，第二列必须是 `GROUP BY` 列。

### 六、注释语法

| 注释方式 | BQL | SQL |
|---|---|---|
| 行注释 | `;`（分号）| `--`（双减号）|
| 块注释 | `/* ... */` | `/* ... */` |

### 七、字符串引号歧义

SQL 标准中单引号 `'...'` 是字符串，双引号 `"..."` 是标识符。BQL 为向后兼容，**两种引号都能表示字符串**，但双引号字符串在编译期会做额外检查——若其值与当前表的某列名相同，则解析为列名引用。

```sql
-- 如果 "checking" 在当前表中存在同名列，则解析为列名；否则为字符串
WHERE account = "checking"

-- 单引号始终是字符串
WHERE account = 'checking'
```

### 八、查询参数风格

```sql
-- 位置参数（Python %s 风格）
SELECT * FROM postings WHERE year = %s

-- 命名参数（Python %(name)s 风格）
SELECT * FROM postings WHERE year = %(year)s AND account ~ %(pattern)s
```

SQL 常见的参数占位符是 `?`（SQLite）或 `$1`（PostgreSQL），BQL 使用 Python 风格。两种风格不能在同一条查询中混用。

### 九、不支持 JOIN

BQL 没有 `JOIN` 语法，多表关联只能通过子查询实现：

```sql
-- BQL：无 JOIN，只能嵌套子查询
SELECT account FROM (SELECT account FROM postings WHERE ...)
```

### 十、财务专用数据类型与函数

BQL 原生支持 Beancount 的财务类型：

| BQL 类型 | 含义 | 示例 |
|---|---|---|
| `Amount` | 数量+货币 | `100 USD` |
| `Position` | 持仓（含成本）| `10 AAPL {150 USD}` |
| `Inventory` | 持仓组合（多种资产）| `{100 USD, 10 AAPL {150 USD}}` |

**专用函数（SQL 中不存在）：**

```sql
-- 持仓相关
units(position)          -- 提取面值（剥离成本）
cost(position)           -- 提取成本价
value(position)          -- 按市价估值
convert(amount, 'USD')   -- 货币转换

-- 账户相关
root(account, 2)         -- 取账户名前 N 级，如 Assets:Cash
parent(account)          -- 父账户
leaf(account)            -- 最末级子账户
has_account('Expenses')  -- 判断交易是否含有匹配账户

-- 元数据
meta('key')              -- 获取当前行的元数据字段
entry_meta('key')        -- 获取父交易的元数据字段
any_meta('key')          -- 优先取行元数据，否则取交易元数据
```

### 十一、日期字面量

```sql
-- SQL（多数方言需要 CAST 或 DATE 前缀）
WHERE date > DATE '2024-01-01'

-- BQL：日期格式直接是原生字面量，不加引号
WHERE date > 2024-01-01
WHERE date > today()     -- 内置函数，返回今天日期
```

### 汇总对比表

| 特性 | BQL | SQL |
|---|---|---|
| 专用语句 | `BALANCES` / `JOURNAL` / `PRINT` | 无 |
| FROM 时间窗口 | `OPEN ON` / `CLOSE ON` / `CLEAR` | 无 |
| 正则匹配 | `~` / `!~` / `?~` | `LIKE`（不支持正则）|
| 列转行 | `PIVOT BY` | 无（标准）|
| 隐式 GROUP BY | 支持 | 不支持 |
| JOIN | 不支持 | 支持 |
| 行注释符 | `;` | `--` |
| 字符串引号 | 单双引号均可（有歧义）| 单引号为字符串，双引号为标识符 |
| 查询参数 | `%s` / `%(name)s` | `?` / `$1` |
| 日期字面量 | 裸写 `2024-01-01` | 需 `DATE` 前缀或引号 |
| 财务类型 | `Amount`/`Position`/`Inventory` | 无 |
