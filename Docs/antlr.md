下面给你一套把 [ANTLR](chatgpt://generic-entity?number=0) 落地到 **iOS（SwiftUI）** 里，实现「用户输入 BQL → 解析 → 执行 → 展示结果」的可操作流程（偏工程化、可维护）。

---

## 0) 总体架构（你最终会得到什么）
你会把 BQL 变成三层：

1) **Parser 层（ANTLR 生成）**：`BQLLexer.swift / BQLParser.swift / ...` → 产物是 **Parse Tree**（语法树，ANTLR 的 `ParserRuleContext` 那套）
2) **AST/IR 层（你自己写）**：把 Parse Tree 转成你稳定的 `Query` / `Expr` / `Select` / `From` 等 Swift struct/enum
3) **Executor 层（你自己写）**：AST → 执行计划（可选）→ 在你的账本/表上跑 → 输出 `ResultSet`（表格：columns + rows + types）

> iOS App 内只包含 “Swift runtime + 生成代码 + 你的 AST/执行器”。ANTLR 的 Java 工具只在 **Mac 构建期**用，不会进 App。

---

## 1) 把 TatSu/EBNF 语法迁移成 ANTLR `.g4`
你现有 TatSu 语法已经把表达式优先级拆成了 `sum/term/factor` 这类层级，这对 ANTLR 很友好（几乎可直接照搬）。

### 1.1 建议拆成 lexer + parser（更稳）
- `BQLLexer.g4`：关键字、标识符、字符串、数字、注释、空白
- `BQLParser.g4`：select/balances/journal/print/create/insert 以及表达式规则

这样你能更好控制 “关键字 vs identifier” 的冲突（SQL-like 语法的常见坑）。

### 1.2 关键字大小写不敏感（对应你 TatSu 的 `@@ignorecase`)
ANTLR 现在支持 `caseInsensitive`（4.10+）这类能力；你可以：
- **方案 A（更省事）**：在 lexer 里对关键字 token 开 `options { caseInsensitive=true; }`（或全局开）  
- **方案 B（最通用）**：用片段 `fragment A:[aA]; ...` 写大小写关键字，或者用 CaseChangingCharStream 方案（“把输入流喂给 lexer 时统一变大写/小写”）  
两类机制在 ANTLR 的案例文档里都有说明。 [oai_citation:0‡GitHub](https://raw.githubusercontent.com/tunnelvisionlabs/antlr4/master/doc/case-insensitive-lexing.md)

> 你这类 SQL-ish（SELECT/WHERE/AND/OR…）我一般选 **A**：更短、更不容易写错。

### 1.3 注释与分号：务必在迁移时“定规矩”
你 TatSu 里既有 `[';']` 结尾，又把 `;...` 当行注释（`@@eol_comments`），这在 ANTLR lexer 里会变成“分号到底是终止符还是注释起始符”的冲突源。建议二选一：
- 分号做 **语句终止符**，行注释改成 `-- ...`
- 或者分号做 **行注释**，语句终止符改成换行/EOF/`GO` 之类

（这一步不需要问我也能推进，但你最好在迁移时就定下来，后面执行器和 UI 才好解释错误位置。）

---

## 2) 在 Mac 上安装/准备 ANTLR 工具（只用于生成代码）
ANTLR Swift 目标的官方说明里，生成命令是：  
`antlr4 -Dlanguage=Swift MyGrammar.g4`，并建议在 Xcode 集成时用 `-message-format gnu` 让错误能被 Xcode 识别。 [oai_citation:1‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)

你最终会对 `.g4` 做一次生成，产出一堆 `.swift` 文件（Lexer/Parser/Listener/Visitor）。

---

## 3) 生成 Swift 代码（并放进工程）
建议输出到固定目录（比如 `Sources/BQLGenerated/`）：

```bash
antlr4 -Dlanguage=Swift -message-format gnu -o Sources/BQLGenerated BQLLexer.g4 BQLParser.g4
```

这条命令与参数组合是官方 Swift target notes 明确建议的（`-message-format gnu` + `-o`）。 [oai_citation:2‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)

**工程实践建议：**
- 生成文件 **要么提交到 git**（团队协作最稳）
- 要么在 Xcode Build Phase 里自动生成（见第 5 节），但要做好 **增量生成**，否则每次 build 都全量生成会很烦

---

## 4) 把 ANTLR Swift Runtime 引入 iOS（两条路线）
### 路线 A：SwiftPM 直接依赖 `antlr/antlr4`（推荐先走通）
官方 Swift target notes 给了 SwiftPM 的依赖写法：  
`.package(url: "https://github.com/antlr/antlr4", from: "4.13.2")`  [oai_citation:3‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)

同时，这个包在 `Package.swift` 里暴露的产品名是 **`Antlr4`**（以及 `Antlr4Static`/`Antlr4Dynamic`）。 [oai_citation:4‡GitHub](https://raw.githubusercontent.com/antlr/antlr4/dev/Package.swift)

Xcode 添加 Swift package 依赖的入口是 `File > Add Package Dependency…`，这是 [Apple](chatgpt://generic-entity?number=1) 官方文档的标准流程。 [oai_citation:5‡Apple Developer](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app?utm_source=chatgpt.com)

> 备注：官方旧文档里曾提到 SwiftPM 对 iOS/watchOS/tvOS 的限制，但 Xcode 的 Swift Packages 早已支持全平台 app 集成（Xcode 11 起）。 [oai_citation:6‡Apple Developer](https://developer.apple.com/videos/play/wwdc2019/408/?utm_source=chatgpt.com)  
> 所以你在 iOS 工程里用 SwiftPM 引 runtime 是可行且常规的。

### 路线 B：把 `Antlr4.xcodeproj` 拖进工程（遇到 SPM 坑再用）
官方也提供了 “clone repo → `python boot.py --gen-xcodeproj` → 拖 `Antlr4.xcodeproj`” 的方式。 [oai_citation:7‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)  
这个适合你需要更手动地改 build settings 或规避某些 SwiftPM/平台问题时用。

---

## 5) 在 Xcode 里做“自动生成”（可选但推荐）
目标：只要 `.g4` 改了，就自动重新生成 `.swift`，并且支持增量。

做法（建议在你自己的 `BQLKit` Swift Package 或 App target 里）：
1) `Build Phases` 增加一个 **Run Script**
2) 脚本里判断时间戳：只有当 `.g4` 更新了才运行 `antlr4 ...`
3) 配置 **Input Files / Output Files**（让 Xcode 认识依赖，减少无效 build）

脚本骨架（示意）：

```bash
set -euo pipefail
GRAMMAR_DIR="${SRCROOT}/BQLGrammar"
OUT_DIR="${SRCROOT}/Sources/BQLGenerated"

mkdir -p "$OUT_DIR"

antlr4 -Dlanguage=Swift -message-format gnu -o "$OUT_DIR" \
  "$GRAMMAR_DIR/BQLLexer.g4" "$GRAMMAR_DIR/BQLParser.g4"
```

---

## 6) App 内：解析一条查询（String → Parse Tree）
典型调用流程（Swift）是：CharStream → Lexer → TokenStream → Parser → entry rule。Swift target notes 也强调要用 release/优化模式保证解析速度。 [oai_citation:8‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)

示例（你需要把类名换成你生成出来的名字，比如 `BQLLexer/BQLParser`）：

```swift
import Antlr4

struct BQLParseError: Error, CustomStringConvertible {
    let message: String
    let line: Int
    let column: Int
    var description: String { "\(line):\(column) \(message)" }
}

final class CollectingErrorListener: BaseErrorListener {
    private(set) var errors: [BQLParseError] = []

    override func syntaxError<T>(
        _ recognizer: Recognizer<T>,
        _ offendingSymbol: AnyObject?,
        _ line: Int, _ charPositionInLine: Int,
        _ msg: String, _ e: Error?
    ) {
        errors.append(.init(message: msg, line: line, column: charPositionInLine))
    }
}

func parseBQL(_ text: String) throws -> BQLParser.BqlContext {
    let input = ANTLRInputStream(text)
    let lexer = try BQLLexer(input)
    let tokens = CommonTokenStream(lexer)

    let parser = try BQLParser(tokens)

    let err = CollectingErrorListener()
    lexer.removeErrorListeners()
    parser.removeErrorListeners()
    lexer.addErrorListener(err)
    parser.addErrorListener(err)

    let tree = try parser.bql()   // entry rule：对应你 TatSu 的 bql
    if let first = err.errors.first { throw first }
    return tree
}
```

---

## 7) Parse Tree → 你自己的 AST（Visitor 模式最常用）
ANTLR 会给你生成：
- `BQLParserBaseVisitor<T>`
- 或 `BQLParserListener` + `ParseTreeWalker`

建议你用 Visitor：返回值就是 AST 节点，最直观。

你可以定义：

```swift
enum Query {
    case select(SelectQuery)
    case balances(BalancesQuery)
    // ...
}

struct SelectQuery { /* targets, from, where, groupBy, ... */ }
enum Expr { /* or/and/not/binary/unary/literal/column/... */ }
```

然后写一个 `AstBuilder: BQLParserBaseVisitor<Any>`（或泛型拆分为多个 visitor）。

> 关键点：**不要**把执行逻辑写在 visitor 里。visitor 只负责“语法 → AST”，执行器只吃 AST。这样你后面做缓存、优化、解释错误都会更轻松。

---

## 8) AST → 执行 → ResultSet → SwiftUI 展示
最后的接口建议长这样：

```swift
struct ResultSet {
    let columns: [String]
    let rows: [[Value]]
}

func runBQL(_ text: String, on db: LedgerDB) throws -> ResultSet {
    let tree = try parseBQL(text)
    let ast = try AstBuilder().build(tree)
    return try Executor(db: db).execute(ast)
}
```

SwiftUI 展示就是 `Table` / `List` / `Grid`，这部分跟 ANTLR 无关了。

---

## 9) 测试与迭代（强烈建议一开始就做）
- **Golden tests**：输入 SQL → 输出 AST/结果（JSON snapshot）
- **错误提示测试**：故意写错，确保能报出 line/column + 友好信息
- **性能测试**：一段长查询/大量表达式，确认 release 下速度 OK（Swift target notes 明确强调 release/优化的重要性） [oai_citation:9‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)

---

## 你现在推进的最短路径（我会这么做）
1) 先写一个最小 `BQLLexer.g4/BQLParser.g4`：只支持 `SELECT ... FROM ... WHERE ... LIMIT ...`
2) SwiftPM 引入 `antlr/antlr4` 的 `Antlr4` runtime（路线 A） [oai_citation:10‡GitHub](https://github.com/antlr/antlr4/blob/master/doc/swift-target.md)
3) 手动生成一次 `.swift` 并编译跑通
4) 再加 Xcode Build Phase 自动生成
5) 再扩展 balances/journal/insert/create_table 等语句 + 完整表达式

---

如果你愿意，我可以直接按你这份 TatSu 语法，把 **一版可编译的 `.g4`（lexer+parser）骨架**写出来（包含关键字、大小写不敏感、注释/空白、表达式优先级、入口规则 bql），你拿去就能开始生成 Swift 代码。