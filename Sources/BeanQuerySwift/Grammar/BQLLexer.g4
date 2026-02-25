lexer grammar BQLLexer;

options {
  caseInsensitive = true;
}

SELECT: 'SELECT';
DISTINCT: 'DISTINCT';
FROM: 'FROM';
WHERE: 'WHERE';
GROUP: 'GROUP';
BY: 'BY';
HAVING: 'HAVING';
ORDER: 'ORDER';
LIMIT: 'LIMIT';
AS: 'AS';
AND: 'AND';
OR: 'OR';
NOT: 'NOT';
IN: 'IN';
IS: 'IS';
NULL: 'NULL';
TRUE: 'TRUE';
FALSE: 'FALSE';
BETWEEN: 'BETWEEN';
BALANCES: 'BALANCES';
JOURNAL: 'JOURNAL';
PRINT: 'PRINT';
PIVOT: 'PIVOT';
AT: 'AT';
OPEN: 'OPEN';
CLOSE: 'CLOSE';
ON: 'ON';
CLEAR: 'CLEAR';
ANY: 'ANY';
ALL: 'ALL';
ASC: 'ASC';
DESC: 'DESC';

POSITIONAL_PLACEHOLDER: '%s';
NAMED_PLACEHOLDER_START: '%(';
NAMED_PLACEHOLDER_END: ')s';

NOT_MATCH: '!~';
MATCHES: '?~';
NEQ: '!=';
LTE: '<=';
GTE: '>=';

HASH_TABLE: '#' [a-z_] [a-z0-9_]*;
HASH_EMPTY: '#';

EQ: '=';
LT: '<';
GT: '>';
MATCH: '~';

PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
PERCENT: '%';
DOT: '.';
COMMA: ',';
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';

DATE_LITERAL: DIGIT DIGIT DIGIT DIGIT '-' DIGIT DIGIT '-' DIGIT DIGIT;
DECIMAL: DIGIT+ '.' DIGIT* | DIGIT* '.' DIGIT+;
INTEGER: DIGIT+;

DOUBLE_QUOTED_TEXT: '"' ( '""' | ~["\r\n] )* '"';
SINGLE_QUOTED_STRING: '\'' ( '\'\'' | ~['\r\n] )* '\'';

IDENTIFIER: [a-z_] [a-z0-9_]*;

BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: (';' | '--') ~[\r\n]* -> skip;
WS: [ \t\r\n\f]+ -> skip;

fragment DIGIT: [0-9];
