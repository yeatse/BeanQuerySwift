# BQL Guide Capability Checklist

对照文档：`Docs/BQL_guide.md`  
说明：`[x]` 已支持，`[ ]` 未完全支持（含部分支持）

## 语句与查询结构

- [x] `SELECT` 主流程（`WHERE / GROUP BY / HAVING / ORDER BY / LIMIT / DISTINCT / *`）
- [x] `BALANCES`（编译期降级到 `SELECT`）
- [x] `JOURNAL`（编译期降级到 `SELECT`）
- [x] `PRINT` 语法与执行入口
- [x] `PIVOT BY`（两列、索引/列名、编译校验 + 执行透视）
- [x] `FROM ... OPEN / CLOSE / CLEAR`（在 Beancount provider 上）
- [x] `FROM (SELECT ...)` 子查询
- [x] 占位符参数（`%s`、`%(name)s`）

## 运算符与函数

- [x] 常见运算符：`= != < <= > >= IN NOT IN ~ !~ ?~ AND OR NOT BETWEEN IS NULL`
- [x] 聚合函数：`count / sum / min / max / first / last`
- [x] 函数：`units / cost / maxwidth / account_sortkey`

## 部分支持或未支持

- [ ] `PRINT` 输出 Beancount 文本格式（当前输出为 `QueryResult` 表格）
- [ ] `EXPLAIN ...` 前缀
- [ ] `FLATTEN` 语法与执行
- [ ] 文档中的完整函数集（如 `YEAR/MONTH/DAY/LENGTH/PARENT/HAS_ACCOUNT` 等）
- [ ] `balance` 特殊累计列的内建计算
- [ ] `id` 稳定交易哈希语义（当前 `entries.id` 为行序号）
- [ ] 文档里的“`*` 默认精选列”语义（当前为全列展开）
- [ ] 完整 inventory/lot 语义对齐（当前 `units/cost` 为简化实现）
- [ ] 完整双层过滤语义对齐（`FROM` transaction-level + `WHERE` posting-level 的严格模型）
