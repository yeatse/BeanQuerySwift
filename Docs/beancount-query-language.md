# Beancount Query Language - SQL-like Financial Queries
Beancount features a powerful, SQL-like Query Language (BQL) that allows you to slice, dice, and analyze your financial data with precision. Whether you want to generate a quick report, debug an entry, or perform complex analysis, mastering BQL is key to unlocking the full potential of your plaintext accounting ledger. This guide will walk you through its structure, functions, and best practices.
## 🔍 Query Structure and Execution
The core of BQL is its familiar, SQL-inspired syntax. Queries are executed using the `bean-query` command-line tool, which processes your ledger file and returns the results directly in your terminal.
### Basic Query Format
A BQL query is composed of three main clauses: `SELECT`, `FROM`, and `WHERE`.
```sql
SELECT <target1>, <target2>, ...
FROM <entry-filter-expression>
WHERE <posting-filter-expression>;
```
- **SELECT**: Specifies which columns of data you want to retrieve.
- **FROM**: Filters entire transactions *before* they are processed.
- **WHERE**: Filters the individual posting lines *after* the transaction has been selected.
### Two-Level Filtering System
Understanding the difference between the `FROM` and `WHERE` clauses is crucial for writing accurate queries. BQL uses a two-level filtering process.
- **Transaction Level (`FROM`)**: This clause acts on entire transactions. If a transaction matches the `FROM` condition, the entire transaction (including all its postings) is passed to the next stage. This is the primary way to filter data, as it preserves the integrity of the double-entry accounting system. For example, filtering `FROM year = 2024` selects all transactions that occurred in 2024.
- **Posting Level (`WHERE`)**: This clause filters the individual postings within the transactions selected by the `FROM` clause. This is useful for presentation and for focusing on specific legs of a transaction. However, be aware that filtering at this level can "break" the integrity of a transaction in the output, as you might only see one side of an entry. For example, you could select all postings to your `Expenses:Groceries` account.
## Data Model
To query your data effectively, you need to understand how Beancount structures it. A ledger is a list of directives, but BQL primarily focuses on `Transaction` entries.
### Transaction Structure
Each `Transaction` is a container with top-level attributes and a list of `Posting` objects.
```
Transaction
├── date
├── flag
├── payee
├── narration
├── tags
├── links
└── Postings[]
    ├── account
    ├── units
    ├── cost
    ├── price
    └── metadata
```
### Available Column Types
You can `SELECT` any of the attributes from the transaction or its postings.
**Transaction Attributes** — These columns are the same for every posting within a single transaction.
```sql
SELECT
  date,        -- The date of the transaction (datetime.date)
  year,        -- The year of the transaction (int)
  month,       -- The month of the transaction (int)
  day,         -- The day of the transaction (int)
  flag,        -- The transaction flag, e.g., "*" or "!" (str)
  payee,       -- The payee (str)
  narration,   -- The description or memo (str)
  tags,        -- A set of tags, e.g., #trip-2024 (set[str])
  links        -- A set of links, e.g., ^expense-report (set[str])
```
**Posting Attributes** — These columns are specific to each individual posting line.
```sql
SELECT
  account,     -- The account name (str)
  posting_flag, -- The flag on the posting itself (str)
  other_accounts, -- Other accounts in the same transaction (set[str]-like list)
  position,    -- The full amount, including units and cost (Position)
  units,       -- The number and currency of the posting (Amount)
  cost,        -- The cost basis of the posting (Cost)
  price,       -- The price used in the posting (Amount)
  weight,      -- The position converted to its cost basis (Amount)
  tags,        -- Parent transaction tags
  links,       -- Parent transaction links
  balance      -- The running total of units in the account (Inventory)
```
## Query Functions
BQL includes a suite of functions for aggregation and data transformation, much like SQL.
### Aggregation Functions
Aggregation functions summarize data across multiple rows. When used with `GROUP BY`, they provide grouped summaries.
```sql
-- Count the number of postings
SELECT COUNT(*)
-- Sum the value of all postings (converted to a common currency)
SELECT SUM(position)
-- Find the date of the first and last transaction
SELECT FIRST(date), LAST(date)
-- Find the minimum and maximum position values
SELECT MIN(position), MAX(position)
-- Group by account to get a sum for each
SELECT account, SUM(position) GROUP BY account
```
### Position/Inventory Functions
The `position` column is a composite object. These functions let you extract specific parts of it or calculate its market value.
```sql
-- Extract just the number and currency from a position
SELECT UNITS(position)
-- Negate a position or aggregated inventory before further conversion/math
SELECT NEG(position)
-- Show the total cost of a position
SELECT COST(position)
-- Show the position converted to its cost basis (useful for investments)
SELECT WEIGHT(position)
-- Calculate the market value using the latest price data
SELECT VALUE(position)
```
You can combine these for powerful reports. For example, to see the total cost and current market value of your investment portfolio:
```sql
SELECT account,
  COST(SUM(position)) AS total_cost,
  VALUE(SUM(position)) AS market_value
FROM account ~ "Assets:Investments"
GROUP BY account
```

### Scalar / Metadata Helper Functions
BeanQuerySwift also supports the common beanquery helper functions used in prompt-driven queries and report builders.
```sql
-- Scalar helpers
SELECT ROUND(1.234, 2), SAFEDIV(1.0, 0.0), REPR(1.2)
SELECT LENGTH(account), SUBSTR(account, 0, 6), SPLITCOMP(account, ":", 1)

-- Metadata lookups
SELECT GETITEM(open_meta('Assets:Cash'), 'booking')
SELECT currency_meta('VTI', 'sector')  -- alias: commodity_meta(...)
```
## Advanced Features
Beyond basic `SELECT` statements, BQL offers specialized commands for common financial reports.
### Balance Reports
The `BALANCES` statement generates a balance sheet or income statement for a specific period.
```sql
-- Generate a simple balance sheet as of the start of 2024
BALANCES FROM close ON 2024-01-01
WHERE account ~ "^Assets|^Liabilities"
-- Generate an income statement for the 2024 fiscal year
BALANCES FROM OPEN ON 2024-01-01 CLOSE ON 2024-12-31
WHERE account ~ "^Income|^Expenses"
```
### Journal Reports
The `JOURNAL` statement shows the detailed activity for one or more accounts, similar to a traditional ledger view.
```sql
-- Show all activity in your checking account at its original cost
JOURNAL "Assets:Checking" AT COST
-- Show all 401k transactions, displaying only the units (shares)
JOURNAL "Assets:.*:401k" AT UNITS
```
### Print Operations
The `PRINT` statement is a debugging tool that outputs full, matching transactions in their original Beancount file format.
```sql
-- Print all investment-related transactions from 2024
PRINT FROM year = 2024
WHERE account ~ "Assets:Investments"
-- Find a transaction by its unique ID (generated by some tools)
PRINT FROM id = "8e7c47250d040ae2b85de580dd4f5c2a"
```
### Filtering Expressions
You can build sophisticated filters using logical operators (`AND`, `OR`), regular expressions (`~`), and comparisons.
```sql
-- Find all travel expenses from the second half of 2024
SELECT * FROM year = 2024 AND month >= 6
WHERE account ~ "Expenses:Travel"
-- Find all transactions related to a vacation or business
SELECT * FROM "vacation-2024" IN tags OR "business-trip" IN links
```
## Performance Considerations ⚙️
`bean-query` is designed for efficiency, but understanding its operational flow can help you write faster queries on large ledgers.
- **Data Loading**: Beancount first parses your entire ledger file and sorts all transactions chronologically. This entire dataset is held in memory.
- **Query Optimization**: The query engine applies filters in a specific order for maximum efficiency: `FROM` (transactions) → `WHERE` (postings) → Aggregations. Filtering at the `FROM` level is fastest because it reduces the dataset early.
- **Memory Usage**: All operations happen in-memory. `Position` objects and `Inventory` aggregations are optimized, but very large result sets can consume significant RAM. BQL does not use disk-based temporary storage.
## Best Practices
Follow these tips to write clean, effective, and maintainable queries.
**Query Organization** — Format your queries for readability, especially complex ones. Use line breaks and indentation to separate clauses.
```sql
-- A clean, readable query for all 2024 expenses
SELECT date, account, position
FROM year = 2024
WHERE account ~ "Expenses"
ORDER BY date DESC;
```
**Debugging** — If a query isn't working as expected, use `EXPLAIN` to see how Beancount parses it. To test a filter, use `SELECT DISTINCT` to see what unique values it matches.
```sql
-- See the query plan
EXPLAIN SELECT date, account, position;
-- Test which accounts match a regular expression
SELECT DISTINCT account
WHERE account ~ "^Assets:.*";
```
**Balance Assertions** — You can use BQL to double-check the `balance` assertions in your ledger. This query should return the exact amount specified in your last balance check for that account.
```sql
-- Verify the final balance of your checking account
SELECT account, sum(position)
FROM close ON 2025-01-01  -- Use the date from your balance directive
WHERE account = "Assets:Checking";
```
---
*Tags: query language · SQL · data analysis · financial queries · bean-query*  
*Last updated: Jan 13, 2026*
