parser grammar BQLParser;

options {
  tokenVocab = BQLLexer;
}

bql
  : statement EOF
  ;

statement
  : selectStmt
  | balancesStmt
  ;

selectStmt
  : SELECT distinctClause? targets fromClause? whereClause? groupByClause? orderByClause? limitClause?
  ;

distinctClause
  : DISTINCT
  ;

targets
  : target (COMMA target)*
  | asterisk
  ;

asterisk
  : STAR
  ;

target
  : expression (AS identifier)?
  ;

fromClause
  : FROM (tableRef | subselect | fromExpr)
  ;

subselect
  : LPAREN selectStmt RPAREN
  ;

tableRef
  : tableName
  ;

tableName
  : HASH_TABLE
  | HASH_EMPTY
  | identifier
  ;

fromExpr
  : OPEN ON dateLiteral (CLOSE (ON dateLiteral)?)? clearClause?
  | CLOSE (ON dateLiteral)? clearClause?
  | CLEAR
  | expression (OPEN ON dateLiteral)? (CLOSE (ON dateLiteral)?)? clearClause?
  ;

clearClause
  : CLEAR
  ;

whereClause
  : WHERE expression
  ;

groupByClause
  : GROUP BY groupItem (COMMA groupItem)* (HAVING expression)?
  ;

groupItem
  : integerLiteral
  | expression
  ;

orderByClause
  : ORDER BY orderItem (COMMA orderItem)*
  ;

orderItem
  : (integerLiteral | expression) ordering?
  ;

ordering
  : DESC
  | ASC
  ;

limitClause
  : LIMIT integerLiteral
  ;

balancesStmt
  : BALANCES (AT identifier)? balancesFromClause? whereClause?
  ;

balancesFromClause
  : FROM fromExpr
  ;

expression
  : disjunction
  ;

disjunction
  : conjunction (OR conjunction)*
  ;

conjunction
  : inversion (AND inversion)*
  ;

inversion
  : NOT inversion
  | comparison
  ;

comparison
  : sumExpr comparisonSuffix?
  ;

comparisonSuffix
  : LT sumExpr
  | LTE sumExpr
  | GT sumExpr
  | GTE sumExpr
  | EQ sumExpr
  | NEQ sumExpr
  | IN sumExpr
  | NOT IN sumExpr
  | MATCH sumExpr
  | NOT_MATCH sumExpr
  | MATCHES sumExpr
  | IS NULL
  | IS NOT NULL
  | BETWEEN sumExpr AND sumExpr
  | anyAllOp ANY LPAREN expression RPAREN
  | anyAllOp ALL LPAREN expression RPAREN
  ;

anyAllOp
  : LT
  | LTE
  | GT
  | GTE
  | EQ
  | NEQ
  | MATCH
  | NOT_MATCH
  | MATCHES
  ;

sumExpr
  : sumExpr PLUS termExpr
  | sumExpr MINUS termExpr
  | termExpr
  ;

termExpr
  : termExpr STAR factorExpr
  | termExpr SLASH factorExpr
  | termExpr PERCENT factorExpr
  | factorExpr
  ;

factorExpr
  : unaryExpr
  | LPAREN expression RPAREN
  ;

unaryExpr
  : PLUS atomExpr
  | MINUS factorExpr
  | primaryExpr
  ;

primaryExpr
  : primaryExpr DOT identifier
  | primaryExpr LBRACK stringLiteral RBRACK
  | atomExpr
  ;

atomExpr
  : selectStmt
  | functionCall
  | constant
  | columnRef
  | placeholder
  ;

placeholder
  : POSITIONAL_PLACEHOLDER
  | NAMED_PLACEHOLDER_START identifier NAMED_PLACEHOLDER_END
  ;

functionCall
  : identifier LPAREN asterisk RPAREN
  | identifier LPAREN expressionList? RPAREN
  ;

expressionList
  : expression (COMMA expression)*
  ;

columnRef
  : identifier
  ;

constant
  : literal
  | listLiteral
  ;

literal
  : dateLiteral
  | decimalLiteral
  | integerLiteral
  | stringLiteral
  | nullLiteral
  | booleanLiteral
  ;

listLiteral
  : LPAREN literal COMMA (literal (COMMA literal)* COMMA?)? RPAREN
  ;

identifier
  : IDENTIFIER
  | DOUBLE_QUOTED_TEXT
  ;

stringLiteral
  : DOUBLE_QUOTED_TEXT
  | SINGLE_QUOTED_STRING
  ;

booleanLiteral
  : TRUE
  | FALSE
  ;

nullLiteral
  : NULL
  ;

integerLiteral
  : INTEGER
  ;

decimalLiteral
  : DECIMAL
  ;

dateLiteral
  : DATE_LITERAL
  ;
