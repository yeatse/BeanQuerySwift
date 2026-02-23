// Generated from /Users/yeatse/Developer/Repo/BeanQuerySwift/Sources/BeanQuerySwift/Grammar/BQLParser.g4 by ANTLR 4.13.2
@preconcurrency import Antlr4

internal class BQLParser: Parser {

	internal static let _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = BQLParser._ATN.getNumberOfDecisions()
          for i in 0..<length {
            decisionToDFA.append(DFA(BQLParser._ATN.getDecisionState(i)!, i))
           }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	internal
	enum Tokens: Int {
		case EOF = -1, SELECT = 1, DISTINCT = 2, FROM = 3, WHERE = 4, GROUP = 5, 
                 BY = 6, HAVING = 7, ORDER = 8, LIMIT = 9, AS = 10, AND = 11, 
                 OR = 12, NOT = 13, IN = 14, IS = 15, NULL = 16, TRUE = 17, 
                 FALSE = 18, BETWEEN = 19, BALANCES = 20, JOURNAL = 21, 
                 PRINT = 22, PIVOT = 23, AT = 24, OPEN = 25, CLOSE = 26, 
                 ON = 27, CLEAR = 28, ANY = 29, ALL = 30, ASC = 31, DESC = 32, 
                 POSITIONAL_PLACEHOLDER = 33, NAMED_PLACEHOLDER_START = 34, 
                 NAMED_PLACEHOLDER_END = 35, NOT_MATCH = 36, MATCHES = 37, 
                 NEQ = 38, LTE = 39, GTE = 40, HASH_TABLE = 41, HASH_EMPTY = 42, 
                 EQ = 43, LT = 44, GT = 45, MATCH = 46, PLUS = 47, MINUS = 48, 
                 STAR = 49, SLASH = 50, PERCENT = 51, DOT = 52, COMMA = 53, 
                 LPAREN = 54, RPAREN = 55, LBRACK = 56, RBRACK = 57, DATE_LITERAL = 58, 
                 DECIMAL = 59, INTEGER = 60, DOUBLE_QUOTED_TEXT = 61, SINGLE_QUOTED_STRING = 62, 
                 IDENTIFIER = 63, BLOCK_COMMENT = 64, LINE_COMMENT = 65, 
                 WS = 66
	}

	internal
	static let RULE_bql = 0, RULE_statement = 1, RULE_selectStmt = 2, RULE_distinctClause = 3, 
            RULE_targets = 4, RULE_asterisk = 5, RULE_target = 6, RULE_fromClause = 7, 
            RULE_subselect = 8, RULE_tableRef = 9, RULE_tableName = 10, 
            RULE_fromExpr = 11, RULE_clearClause = 12, RULE_whereClause = 13, 
            RULE_groupByClause = 14, RULE_groupItem = 15, RULE_orderByClause = 16, 
            RULE_orderItem = 17, RULE_ordering = 18, RULE_limitClause = 19, 
            RULE_pivotByClause = 20, RULE_pivotByItem = 21, RULE_balancesStmt = 22, 
            RULE_balancesFromClause = 23, RULE_journalStmt = 24, RULE_journalFromClause = 25, 
            RULE_printStmt = 26, RULE_printFromClause = 27, RULE_expression = 28, 
            RULE_disjunction = 29, RULE_conjunction = 30, RULE_inversion = 31, 
            RULE_comparison = 32, RULE_comparisonSuffix = 33, RULE_anyAllOp = 34, 
            RULE_sumExpr = 35, RULE_termExpr = 36, RULE_factorExpr = 37, 
            RULE_unaryExpr = 38, RULE_primaryExpr = 39, RULE_atomExpr = 40, 
            RULE_placeholder = 41, RULE_functionCall = 42, RULE_expressionList = 43, 
            RULE_columnRef = 44, RULE_constant = 45, RULE_literal = 46, 
            RULE_listLiteral = 47, RULE_identifier = 48, RULE_stringLiteral = 49, 
            RULE_booleanLiteral = 50, RULE_nullLiteral = 51, RULE_integerLiteral = 52, 
            RULE_decimalLiteral = 53, RULE_dateLiteral = 54

	internal
	static let ruleNames: [String] = [
		"bql", "statement", "selectStmt", "distinctClause", "targets", "asterisk", 
		"target", "fromClause", "subselect", "tableRef", "tableName", "fromExpr", 
		"clearClause", "whereClause", "groupByClause", "groupItem", "orderByClause", 
		"orderItem", "ordering", "limitClause", "pivotByClause", "pivotByItem", 
		"balancesStmt", "balancesFromClause", "journalStmt", "journalFromClause", 
		"printStmt", "printFromClause", "expression", "disjunction", "conjunction", 
		"inversion", "comparison", "comparisonSuffix", "anyAllOp", "sumExpr", 
		"termExpr", "factorExpr", "unaryExpr", "primaryExpr", "atomExpr", "placeholder", 
		"functionCall", "expressionList", "columnRef", "constant", "literal", 
		"listLiteral", "identifier", "stringLiteral", "booleanLiteral", "nullLiteral", 
		"integerLiteral", "decimalLiteral", "dateLiteral"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'SELECT'", "'DISTINCT'", "'FROM'", "'WHERE'", "'GROUP'", "'BY'", 
		"'HAVING'", "'ORDER'", "'LIMIT'", "'AS'", "'AND'", "'OR'", "'NOT'", "'IN'", 
		"'IS'", "'NULL'", "'TRUE'", "'FALSE'", "'BETWEEN'", "'BALANCES'", "'JOURNAL'", 
		"'PRINT'", "'PIVOT'", "'AT'", "'OPEN'", "'CLOSE'", "'ON'", "'CLEAR'", 
		"'ANY'", "'ALL'", "'ASC'", "'DESC'", "'%s'", "'%('", "')s'", "'!~'", "'?~'", 
		"'!='", "'<='", "'>='", nil, "'#'", "'='", "'<'", "'>'", "'~'", "'+'", 
		"'-'", "'*'", "'/'", "'%'", "'.'", "','", "'('", "')'", "'['", "']'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, "SELECT", "DISTINCT", "FROM", "WHERE", "GROUP", "BY", "HAVING", "ORDER", 
		"LIMIT", "AS", "AND", "OR", "NOT", "IN", "IS", "NULL", "TRUE", "FALSE", 
		"BETWEEN", "BALANCES", "JOURNAL", "PRINT", "PIVOT", "AT", "OPEN", "CLOSE", 
		"ON", "CLEAR", "ANY", "ALL", "ASC", "DESC", "POSITIONAL_PLACEHOLDER", 
		"NAMED_PLACEHOLDER_START", "NAMED_PLACEHOLDER_END", "NOT_MATCH", "MATCHES", 
		"NEQ", "LTE", "GTE", "HASH_TABLE", "HASH_EMPTY", "EQ", "LT", "GT", "MATCH", 
		"PLUS", "MINUS", "STAR", "SLASH", "PERCENT", "DOT", "COMMA", "LPAREN", 
		"RPAREN", "LBRACK", "RBRACK", "DATE_LITERAL", "DECIMAL", "INTEGER", "DOUBLE_QUOTED_TEXT", 
		"SINGLE_QUOTED_STRING", "IDENTIFIER", "BLOCK_COMMENT", "LINE_COMMENT", 
		"WS"
	]
	internal
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

	override internal
	func getGrammarFileName() -> String { return "BQLParser.g4" }

	override internal
	func getRuleNames() -> [String] { return BQLParser.ruleNames }

	override internal
	func getSerializedATN() -> [Int] { return BQLParser._serializedATN }

	override internal
	func getATN() -> ATN { return BQLParser._ATN }


	override internal
	func getVocabulary() -> Vocabulary {
	    return BQLParser.VOCABULARY
	}

	override internal
	init(_ input:TokenStream) throws {
	    RuntimeMetaData.checkVersion("4.13.2", RuntimeMetaData.VERSION)
		try super.init(input)
		_interp = ParserATNSimulator(self,BQLParser._ATN,BQLParser._decisionToDFA, BQLParser._sharedContextCache)
	}


	internal class BqlContext: ParserRuleContext {
			internal
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			internal
			func EOF() -> TerminalNode? {
				return getToken(BQLParser.Tokens.EOF.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_bql
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitBql(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitBql(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func bql() throws -> BqlContext {
		var _localctx: BqlContext
		_localctx = BqlContext(_ctx, getState())
		try enterRule(_localctx, 0, BQLParser.RULE_bql)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(110)
		 	try statement()
		 	setState(111)
		 	try match(BQLParser.Tokens.EOF.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class StatementContext: ParserRuleContext {
			internal
			func selectStmt() -> SelectStmtContext? {
				return getRuleContext(SelectStmtContext.self, 0)
			}
			internal
			func balancesStmt() -> BalancesStmtContext? {
				return getRuleContext(BalancesStmtContext.self, 0)
			}
			internal
			func journalStmt() -> JournalStmtContext? {
				return getRuleContext(JournalStmtContext.self, 0)
			}
			internal
			func printStmt() -> PrintStmtContext? {
				return getRuleContext(PrintStmtContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_statement
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitStatement(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func statement() throws -> StatementContext {
		var _localctx: StatementContext
		_localctx = StatementContext(_ctx, getState())
		try enterRule(_localctx, 2, BQLParser.RULE_statement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(117)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .SELECT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(113)
		 		try selectStmt()

		 		break

		 	case .BALANCES:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(114)
		 		try balancesStmt()

		 		break

		 	case .JOURNAL:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(115)
		 		try journalStmt()

		 		break

		 	case .PRINT:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(116)
		 		try printStmt()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class SelectStmtContext: ParserRuleContext {
			internal
			func SELECT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.SELECT.rawValue, 0)
			}
			internal
			func targets() -> TargetsContext? {
				return getRuleContext(TargetsContext.self, 0)
			}
			internal
			func distinctClause() -> DistinctClauseContext? {
				return getRuleContext(DistinctClauseContext.self, 0)
			}
			internal
			func fromClause() -> FromClauseContext? {
				return getRuleContext(FromClauseContext.self, 0)
			}
			internal
			func whereClause() -> WhereClauseContext? {
				return getRuleContext(WhereClauseContext.self, 0)
			}
			internal
			func groupByClause() -> GroupByClauseContext? {
				return getRuleContext(GroupByClauseContext.self, 0)
			}
			internal
			func orderByClause() -> OrderByClauseContext? {
				return getRuleContext(OrderByClauseContext.self, 0)
			}
			internal
			func pivotByClause() -> PivotByClauseContext? {
				return getRuleContext(PivotByClauseContext.self, 0)
			}
			internal
			func limitClause() -> LimitClauseContext? {
				return getRuleContext(LimitClauseContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_selectStmt
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitSelectStmt(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitSelectStmt(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func selectStmt() throws -> SelectStmtContext {
		var _localctx: SelectStmtContext
		_localctx = SelectStmtContext(_ctx, getState())
		try enterRule(_localctx, 4, BQLParser.RULE_selectStmt)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(119)
		 	try match(BQLParser.Tokens.SELECT.rawValue)
		 	setState(121)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.DISTINCT.rawValue) {
		 		setState(120)
		 		try distinctClause()

		 	}

		 	setState(123)
		 	try targets()
		 	setState(125)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,2,_ctx)) {
		 	case 1:
		 		setState(124)
		 		try fromClause()

		 		break
		 	default: break
		 	}
		 	setState(128)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,3,_ctx)) {
		 	case 1:
		 		setState(127)
		 		try whereClause()

		 		break
		 	default: break
		 	}
		 	setState(131)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,4,_ctx)) {
		 	case 1:
		 		setState(130)
		 		try groupByClause()

		 		break
		 	default: break
		 	}
		 	setState(134)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,5,_ctx)) {
		 	case 1:
		 		setState(133)
		 		try orderByClause()

		 		break
		 	default: break
		 	}
		 	setState(137)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,6,_ctx)) {
		 	case 1:
		 		setState(136)
		 		try pivotByClause()

		 		break
		 	default: break
		 	}
		 	setState(140)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,7,_ctx)) {
		 	case 1:
		 		setState(139)
		 		try limitClause()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class DistinctClauseContext: ParserRuleContext {
			internal
			func DISTINCT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DISTINCT.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_distinctClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitDistinctClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitDistinctClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func distinctClause() throws -> DistinctClauseContext {
		var _localctx: DistinctClauseContext
		_localctx = DistinctClauseContext(_ctx, getState())
		try enterRule(_localctx, 6, BQLParser.RULE_distinctClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(142)
		 	try match(BQLParser.Tokens.DISTINCT.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class TargetsContext: ParserRuleContext {
			internal
			func target() -> [TargetContext] {
				return getRuleContexts(TargetContext.self)
			}
			internal
			func target(_ i: Int) -> TargetContext? {
				return getRuleContext(TargetContext.self, i)
			}
			internal
			func COMMA() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.COMMA.rawValue)
			}
			internal
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.COMMA.rawValue, i)
			}
			internal
			func asterisk() -> AsteriskContext? {
				return getRuleContext(AsteriskContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_targets
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitTargets(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitTargets(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func targets() throws -> TargetsContext {
		var _localctx: TargetsContext
		_localctx = TargetsContext(_ctx, getState())
		try enterRule(_localctx, 8, BQLParser.RULE_targets)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(153)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .SELECT:fallthrough
		 	case .NOT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .POSITIONAL_PLACEHOLDER:fallthrough
		 	case .NAMED_PLACEHOLDER_START:fallthrough
		 	case .PLUS:fallthrough
		 	case .MINUS:fallthrough
		 	case .LPAREN:fallthrough
		 	case .DATE_LITERAL:fallthrough
		 	case .DECIMAL:fallthrough
		 	case .INTEGER:fallthrough
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(144)
		 		try target()
		 		setState(149)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,8,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(145)
		 				try match(BQLParser.Tokens.COMMA.rawValue)
		 				setState(146)
		 				try target()

		 		 
		 			}
		 			setState(151)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,8,_ctx)
		 		}

		 		break

		 	case .STAR:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(152)
		 		try asterisk()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class AsteriskContext: ParserRuleContext {
			internal
			func STAR() -> TerminalNode? {
				return getToken(BQLParser.Tokens.STAR.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_asterisk
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitAsterisk(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitAsterisk(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func asterisk() throws -> AsteriskContext {
		var _localctx: AsteriskContext
		_localctx = AsteriskContext(_ctx, getState())
		try enterRule(_localctx, 10, BQLParser.RULE_asterisk)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(155)
		 	try match(BQLParser.Tokens.STAR.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class TargetContext: ParserRuleContext {
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			internal
			func AS() -> TerminalNode? {
				return getToken(BQLParser.Tokens.AS.rawValue, 0)
			}
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_target
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitTarget(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitTarget(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func target() throws -> TargetContext {
		var _localctx: TargetContext
		_localctx = TargetContext(_ctx, getState())
		try enterRule(_localctx, 12, BQLParser.RULE_target)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(157)
		 	try expression()
		 	setState(160)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,10,_ctx)) {
		 	case 1:
		 		setState(158)
		 		try match(BQLParser.Tokens.AS.rawValue)
		 		setState(159)
		 		try identifier()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class FromClauseContext: ParserRuleContext {
			internal
			func FROM() -> TerminalNode? {
				return getToken(BQLParser.Tokens.FROM.rawValue, 0)
			}
			internal
			func tableRef() -> TableRefContext? {
				return getRuleContext(TableRefContext.self, 0)
			}
			internal
			func subselect() -> SubselectContext? {
				return getRuleContext(SubselectContext.self, 0)
			}
			internal
			func fromExpr() -> FromExprContext? {
				return getRuleContext(FromExprContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_fromClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitFromClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitFromClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func fromClause() throws -> FromClauseContext {
		var _localctx: FromClauseContext
		_localctx = FromClauseContext(_ctx, getState())
		try enterRule(_localctx, 14, BQLParser.RULE_fromClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(162)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(166)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,11, _ctx)) {
		 	case 1:
		 		setState(163)
		 		try tableRef()

		 		break
		 	case 2:
		 		setState(164)
		 		try subselect()

		 		break
		 	case 3:
		 		setState(165)
		 		try fromExpr()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class SubselectContext: ParserRuleContext {
			internal
			func LPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LPAREN.rawValue, 0)
			}
			internal
			func selectStmt() -> SelectStmtContext? {
				return getRuleContext(SelectStmtContext.self, 0)
			}
			internal
			func RPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.RPAREN.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_subselect
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitSubselect(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitSubselect(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func subselect() throws -> SubselectContext {
		var _localctx: SubselectContext
		_localctx = SubselectContext(_ctx, getState())
		try enterRule(_localctx, 16, BQLParser.RULE_subselect)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(168)
		 	try match(BQLParser.Tokens.LPAREN.rawValue)
		 	setState(169)
		 	try selectStmt()
		 	setState(170)
		 	try match(BQLParser.Tokens.RPAREN.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class TableRefContext: ParserRuleContext {
			internal
			func tableName() -> TableNameContext? {
				return getRuleContext(TableNameContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_tableRef
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitTableRef(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitTableRef(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func tableRef() throws -> TableRefContext {
		var _localctx: TableRefContext
		_localctx = TableRefContext(_ctx, getState())
		try enterRule(_localctx, 18, BQLParser.RULE_tableRef)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(172)
		 	try tableName()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class TableNameContext: ParserRuleContext {
			internal
			func HASH_TABLE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.HASH_TABLE.rawValue, 0)
			}
			internal
			func HASH_EMPTY() -> TerminalNode? {
				return getToken(BQLParser.Tokens.HASH_EMPTY.rawValue, 0)
			}
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_tableName
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitTableName(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitTableName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func tableName() throws -> TableNameContext {
		var _localctx: TableNameContext
		_localctx = TableNameContext(_ctx, getState())
		try enterRule(_localctx, 20, BQLParser.RULE_tableName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(177)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .HASH_TABLE:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(174)
		 		try match(BQLParser.Tokens.HASH_TABLE.rawValue)

		 		break

		 	case .HASH_EMPTY:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(175)
		 		try match(BQLParser.Tokens.HASH_EMPTY.rawValue)

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(176)
		 		try identifier()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class FromExprContext: ParserRuleContext {
			internal
			func OPEN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.OPEN.rawValue, 0)
			}
			internal
			func ON() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.ON.rawValue)
			}
			internal
			func ON(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.ON.rawValue, i)
			}
			internal
			func dateLiteral() -> [DateLiteralContext] {
				return getRuleContexts(DateLiteralContext.self)
			}
			internal
			func dateLiteral(_ i: Int) -> DateLiteralContext? {
				return getRuleContext(DateLiteralContext.self, i)
			}
			internal
			func CLOSE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.CLOSE.rawValue, 0)
			}
			internal
			func clearClause() -> ClearClauseContext? {
				return getRuleContext(ClearClauseContext.self, 0)
			}
			internal
			func CLEAR() -> TerminalNode? {
				return getToken(BQLParser.Tokens.CLEAR.rawValue, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_fromExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitFromExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitFromExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func fromExpr() throws -> FromExprContext {
		var _localctx: FromExprContext
		_localctx = FromExprContext(_ctx, getState())
		try enterRule(_localctx, 22, BQLParser.RULE_fromExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(217)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .OPEN:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(179)
		 		try match(BQLParser.Tokens.OPEN.rawValue)
		 		setState(180)
		 		try match(BQLParser.Tokens.ON.rawValue)
		 		setState(181)
		 		try dateLiteral()
		 		setState(187)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,14,_ctx)) {
		 		case 1:
		 			setState(182)
		 			try match(BQLParser.Tokens.CLOSE.rawValue)
		 			setState(185)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,13,_ctx)) {
		 			case 1:
		 				setState(183)
		 				try match(BQLParser.Tokens.ON.rawValue)
		 				setState(184)
		 				try dateLiteral()

		 				break
		 			default: break
		 			}

		 			break
		 		default: break
		 		}
		 		setState(190)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,15,_ctx)) {
		 		case 1:
		 			setState(189)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break

		 	case .CLOSE:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(192)
		 		try match(BQLParser.Tokens.CLOSE.rawValue)
		 		setState(195)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,16,_ctx)) {
		 		case 1:
		 			setState(193)
		 			try match(BQLParser.Tokens.ON.rawValue)
		 			setState(194)
		 			try dateLiteral()

		 			break
		 		default: break
		 		}
		 		setState(198)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,17,_ctx)) {
		 		case 1:
		 			setState(197)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break

		 	case .CLEAR:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(200)
		 		try match(BQLParser.Tokens.CLEAR.rawValue)

		 		break
		 	case .SELECT:fallthrough
		 	case .NOT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .POSITIONAL_PLACEHOLDER:fallthrough
		 	case .NAMED_PLACEHOLDER_START:fallthrough
		 	case .PLUS:fallthrough
		 	case .MINUS:fallthrough
		 	case .LPAREN:fallthrough
		 	case .DATE_LITERAL:fallthrough
		 	case .DECIMAL:fallthrough
		 	case .INTEGER:fallthrough
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(201)
		 		try expression()
		 		setState(205)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,18,_ctx)) {
		 		case 1:
		 			setState(202)
		 			try match(BQLParser.Tokens.OPEN.rawValue)
		 			setState(203)
		 			try match(BQLParser.Tokens.ON.rawValue)
		 			setState(204)
		 			try dateLiteral()

		 			break
		 		default: break
		 		}
		 		setState(212)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,20,_ctx)) {
		 		case 1:
		 			setState(207)
		 			try match(BQLParser.Tokens.CLOSE.rawValue)
		 			setState(210)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,19,_ctx)) {
		 			case 1:
		 				setState(208)
		 				try match(BQLParser.Tokens.ON.rawValue)
		 				setState(209)
		 				try dateLiteral()

		 				break
		 			default: break
		 			}

		 			break
		 		default: break
		 		}
		 		setState(215)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,21,_ctx)) {
		 		case 1:
		 			setState(214)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ClearClauseContext: ParserRuleContext {
			internal
			func CLEAR() -> TerminalNode? {
				return getToken(BQLParser.Tokens.CLEAR.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_clearClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitClearClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitClearClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func clearClause() throws -> ClearClauseContext {
		var _localctx: ClearClauseContext
		_localctx = ClearClauseContext(_ctx, getState())
		try enterRule(_localctx, 24, BQLParser.RULE_clearClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(219)
		 	try match(BQLParser.Tokens.CLEAR.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class WhereClauseContext: ParserRuleContext {
			internal
			func WHERE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.WHERE.rawValue, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_whereClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitWhereClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitWhereClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func whereClause() throws -> WhereClauseContext {
		var _localctx: WhereClauseContext
		_localctx = WhereClauseContext(_ctx, getState())
		try enterRule(_localctx, 26, BQLParser.RULE_whereClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(221)
		 	try match(BQLParser.Tokens.WHERE.rawValue)
		 	setState(222)
		 	try expression()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class GroupByClauseContext: ParserRuleContext {
			internal
			func GROUP() -> TerminalNode? {
				return getToken(BQLParser.Tokens.GROUP.rawValue, 0)
			}
			internal
			func BY() -> TerminalNode? {
				return getToken(BQLParser.Tokens.BY.rawValue, 0)
			}
			internal
			func groupItem() -> [GroupItemContext] {
				return getRuleContexts(GroupItemContext.self)
			}
			internal
			func groupItem(_ i: Int) -> GroupItemContext? {
				return getRuleContext(GroupItemContext.self, i)
			}
			internal
			func COMMA() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.COMMA.rawValue)
			}
			internal
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.COMMA.rawValue, i)
			}
			internal
			func HAVING() -> TerminalNode? {
				return getToken(BQLParser.Tokens.HAVING.rawValue, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_groupByClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitGroupByClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitGroupByClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func groupByClause() throws -> GroupByClauseContext {
		var _localctx: GroupByClauseContext
		_localctx = GroupByClauseContext(_ctx, getState())
		try enterRule(_localctx, 28, BQLParser.RULE_groupByClause)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(224)
		 	try match(BQLParser.Tokens.GROUP.rawValue)
		 	setState(225)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(226)
		 	try groupItem()
		 	setState(231)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,23,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(227)
		 			try match(BQLParser.Tokens.COMMA.rawValue)
		 			setState(228)
		 			try groupItem()

		 	 
		 		}
		 		setState(233)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,23,_ctx)
		 	}
		 	setState(236)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,24,_ctx)) {
		 	case 1:
		 		setState(234)
		 		try match(BQLParser.Tokens.HAVING.rawValue)
		 		setState(235)
		 		try expression()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class GroupItemContext: ParserRuleContext {
			internal
			func integerLiteral() -> IntegerLiteralContext? {
				return getRuleContext(IntegerLiteralContext.self, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_groupItem
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitGroupItem(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitGroupItem(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func groupItem() throws -> GroupItemContext {
		var _localctx: GroupItemContext
		_localctx = GroupItemContext(_ctx, getState())
		try enterRule(_localctx, 30, BQLParser.RULE_groupItem)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(240)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,25, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(238)
		 		try integerLiteral()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(239)
		 		try expression()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class OrderByClauseContext: ParserRuleContext {
			internal
			func ORDER() -> TerminalNode? {
				return getToken(BQLParser.Tokens.ORDER.rawValue, 0)
			}
			internal
			func BY() -> TerminalNode? {
				return getToken(BQLParser.Tokens.BY.rawValue, 0)
			}
			internal
			func orderItem() -> [OrderItemContext] {
				return getRuleContexts(OrderItemContext.self)
			}
			internal
			func orderItem(_ i: Int) -> OrderItemContext? {
				return getRuleContext(OrderItemContext.self, i)
			}
			internal
			func COMMA() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.COMMA.rawValue)
			}
			internal
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.COMMA.rawValue, i)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_orderByClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitOrderByClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitOrderByClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func orderByClause() throws -> OrderByClauseContext {
		var _localctx: OrderByClauseContext
		_localctx = OrderByClauseContext(_ctx, getState())
		try enterRule(_localctx, 32, BQLParser.RULE_orderByClause)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(242)
		 	try match(BQLParser.Tokens.ORDER.rawValue)
		 	setState(243)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(244)
		 	try orderItem()
		 	setState(249)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,26,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(245)
		 			try match(BQLParser.Tokens.COMMA.rawValue)
		 			setState(246)
		 			try orderItem()

		 	 
		 		}
		 		setState(251)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,26,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class OrderItemContext: ParserRuleContext {
			internal
			func integerLiteral() -> IntegerLiteralContext? {
				return getRuleContext(IntegerLiteralContext.self, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			internal
			func ordering() -> OrderingContext? {
				return getRuleContext(OrderingContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_orderItem
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitOrderItem(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitOrderItem(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func orderItem() throws -> OrderItemContext {
		var _localctx: OrderItemContext
		_localctx = OrderItemContext(_ctx, getState())
		try enterRule(_localctx, 34, BQLParser.RULE_orderItem)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(254)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,27, _ctx)) {
		 	case 1:
		 		setState(252)
		 		try integerLiteral()

		 		break
		 	case 2:
		 		setState(253)
		 		try expression()

		 		break
		 	default: break
		 	}
		 	setState(257)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,28,_ctx)) {
		 	case 1:
		 		setState(256)
		 		try ordering()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class OrderingContext: ParserRuleContext {
			internal
			func DESC() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DESC.rawValue, 0)
			}
			internal
			func ASC() -> TerminalNode? {
				return getToken(BQLParser.Tokens.ASC.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_ordering
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitOrdering(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitOrdering(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func ordering() throws -> OrderingContext {
		var _localctx: OrderingContext
		_localctx = OrderingContext(_ctx, getState())
		try enterRule(_localctx, 36, BQLParser.RULE_ordering)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(259)
		 	_la = try _input.LA(1)
		 	if (!(_la == BQLParser.Tokens.ASC.rawValue || _la == BQLParser.Tokens.DESC.rawValue)) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class LimitClauseContext: ParserRuleContext {
			internal
			func LIMIT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LIMIT.rawValue, 0)
			}
			internal
			func integerLiteral() -> IntegerLiteralContext? {
				return getRuleContext(IntegerLiteralContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_limitClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitLimitClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitLimitClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func limitClause() throws -> LimitClauseContext {
		var _localctx: LimitClauseContext
		_localctx = LimitClauseContext(_ctx, getState())
		try enterRule(_localctx, 38, BQLParser.RULE_limitClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(261)
		 	try match(BQLParser.Tokens.LIMIT.rawValue)
		 	setState(262)
		 	try integerLiteral()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class PivotByClauseContext: ParserRuleContext {
			internal
			func PIVOT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.PIVOT.rawValue, 0)
			}
			internal
			func BY() -> TerminalNode? {
				return getToken(BQLParser.Tokens.BY.rawValue, 0)
			}
			internal
			func pivotByItem() -> [PivotByItemContext] {
				return getRuleContexts(PivotByItemContext.self)
			}
			internal
			func pivotByItem(_ i: Int) -> PivotByItemContext? {
				return getRuleContext(PivotByItemContext.self, i)
			}
			internal
			func COMMA() -> TerminalNode? {
				return getToken(BQLParser.Tokens.COMMA.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_pivotByClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitPivotByClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitPivotByClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func pivotByClause() throws -> PivotByClauseContext {
		var _localctx: PivotByClauseContext
		_localctx = PivotByClauseContext(_ctx, getState())
		try enterRule(_localctx, 40, BQLParser.RULE_pivotByClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(264)
		 	try match(BQLParser.Tokens.PIVOT.rawValue)
		 	setState(265)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(266)
		 	try pivotByItem()
		 	setState(267)
		 	try match(BQLParser.Tokens.COMMA.rawValue)
		 	setState(268)
		 	try pivotByItem()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class PivotByItemContext: ParserRuleContext {
			internal
			func integerLiteral() -> IntegerLiteralContext? {
				return getRuleContext(IntegerLiteralContext.self, 0)
			}
			internal
			func columnRef() -> ColumnRefContext? {
				return getRuleContext(ColumnRefContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_pivotByItem
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitPivotByItem(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitPivotByItem(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func pivotByItem() throws -> PivotByItemContext {
		var _localctx: PivotByItemContext
		_localctx = PivotByItemContext(_ctx, getState())
		try enterRule(_localctx, 42, BQLParser.RULE_pivotByItem)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(272)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .INTEGER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(270)
		 		try integerLiteral()

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(271)
		 		try columnRef()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class BalancesStmtContext: ParserRuleContext {
			internal
			func BALANCES() -> TerminalNode? {
				return getToken(BQLParser.Tokens.BALANCES.rawValue, 0)
			}
			internal
			func AT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.AT.rawValue, 0)
			}
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			internal
			func balancesFromClause() -> BalancesFromClauseContext? {
				return getRuleContext(BalancesFromClauseContext.self, 0)
			}
			internal
			func whereClause() -> WhereClauseContext? {
				return getRuleContext(WhereClauseContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_balancesStmt
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitBalancesStmt(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitBalancesStmt(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func balancesStmt() throws -> BalancesStmtContext {
		var _localctx: BalancesStmtContext
		_localctx = BalancesStmtContext(_ctx, getState())
		try enterRule(_localctx, 44, BQLParser.RULE_balancesStmt)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(274)
		 	try match(BQLParser.Tokens.BALANCES.rawValue)
		 	setState(277)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.AT.rawValue) {
		 		setState(275)
		 		try match(BQLParser.Tokens.AT.rawValue)
		 		setState(276)
		 		try identifier()

		 	}

		 	setState(280)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(279)
		 		try balancesFromClause()

		 	}

		 	setState(283)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.WHERE.rawValue) {
		 		setState(282)
		 		try whereClause()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class BalancesFromClauseContext: ParserRuleContext {
			internal
			func FROM() -> TerminalNode? {
				return getToken(BQLParser.Tokens.FROM.rawValue, 0)
			}
			internal
			func fromExpr() -> FromExprContext? {
				return getRuleContext(FromExprContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_balancesFromClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitBalancesFromClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitBalancesFromClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func balancesFromClause() throws -> BalancesFromClauseContext {
		var _localctx: BalancesFromClauseContext
		_localctx = BalancesFromClauseContext(_ctx, getState())
		try enterRule(_localctx, 46, BQLParser.RULE_balancesFromClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(285)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(286)
		 	try fromExpr()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class JournalStmtContext: ParserRuleContext {
			internal
			func JOURNAL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.JOURNAL.rawValue, 0)
			}
			internal
			func stringLiteral() -> StringLiteralContext? {
				return getRuleContext(StringLiteralContext.self, 0)
			}
			internal
			func AT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.AT.rawValue, 0)
			}
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			internal
			func journalFromClause() -> JournalFromClauseContext? {
				return getRuleContext(JournalFromClauseContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_journalStmt
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitJournalStmt(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitJournalStmt(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func journalStmt() throws -> JournalStmtContext {
		var _localctx: JournalStmtContext
		_localctx = JournalStmtContext(_ctx, getState())
		try enterRule(_localctx, 48, BQLParser.RULE_journalStmt)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(288)
		 	try match(BQLParser.Tokens.JOURNAL.rawValue)
		 	setState(290)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.DOUBLE_QUOTED_TEXT.rawValue || _la == BQLParser.Tokens.SINGLE_QUOTED_STRING.rawValue) {
		 		setState(289)
		 		try stringLiteral()

		 	}

		 	setState(294)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.AT.rawValue) {
		 		setState(292)
		 		try match(BQLParser.Tokens.AT.rawValue)
		 		setState(293)
		 		try identifier()

		 	}

		 	setState(297)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(296)
		 		try journalFromClause()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class JournalFromClauseContext: ParserRuleContext {
			internal
			func FROM() -> TerminalNode? {
				return getToken(BQLParser.Tokens.FROM.rawValue, 0)
			}
			internal
			func fromExpr() -> FromExprContext? {
				return getRuleContext(FromExprContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_journalFromClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitJournalFromClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitJournalFromClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func journalFromClause() throws -> JournalFromClauseContext {
		var _localctx: JournalFromClauseContext
		_localctx = JournalFromClauseContext(_ctx, getState())
		try enterRule(_localctx, 50, BQLParser.RULE_journalFromClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(299)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(300)
		 	try fromExpr()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class PrintStmtContext: ParserRuleContext {
			internal
			func PRINT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.PRINT.rawValue, 0)
			}
			internal
			func printFromClause() -> PrintFromClauseContext? {
				return getRuleContext(PrintFromClauseContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_printStmt
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitPrintStmt(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitPrintStmt(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func printStmt() throws -> PrintStmtContext {
		var _localctx: PrintStmtContext
		_localctx = PrintStmtContext(_ctx, getState())
		try enterRule(_localctx, 52, BQLParser.RULE_printStmt)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(302)
		 	try match(BQLParser.Tokens.PRINT.rawValue)
		 	setState(304)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(303)
		 		try printFromClause()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class PrintFromClauseContext: ParserRuleContext {
			internal
			func FROM() -> TerminalNode? {
				return getToken(BQLParser.Tokens.FROM.rawValue, 0)
			}
			internal
			func fromExpr() -> FromExprContext? {
				return getRuleContext(FromExprContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_printFromClause
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitPrintFromClause(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitPrintFromClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func printFromClause() throws -> PrintFromClauseContext {
		var _localctx: PrintFromClauseContext
		_localctx = PrintFromClauseContext(_ctx, getState())
		try enterRule(_localctx, 54, BQLParser.RULE_printFromClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(306)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(307)
		 	try fromExpr()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ExpressionContext: ParserRuleContext {
			internal
			func disjunction() -> DisjunctionContext? {
				return getRuleContext(DisjunctionContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_expression
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitExpression(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func expression() throws -> ExpressionContext {
		var _localctx: ExpressionContext
		_localctx = ExpressionContext(_ctx, getState())
		try enterRule(_localctx, 56, BQLParser.RULE_expression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(309)
		 	try disjunction()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class DisjunctionContext: ParserRuleContext {
			internal
			func conjunction() -> [ConjunctionContext] {
				return getRuleContexts(ConjunctionContext.self)
			}
			internal
			func conjunction(_ i: Int) -> ConjunctionContext? {
				return getRuleContext(ConjunctionContext.self, i)
			}
			internal
			func OR() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.OR.rawValue)
			}
			internal
			func OR(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.OR.rawValue, i)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_disjunction
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitDisjunction(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitDisjunction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func disjunction() throws -> DisjunctionContext {
		var _localctx: DisjunctionContext
		_localctx = DisjunctionContext(_ctx, getState())
		try enterRule(_localctx, 58, BQLParser.RULE_disjunction)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(311)
		 	try conjunction()
		 	setState(316)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,37,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(312)
		 			try match(BQLParser.Tokens.OR.rawValue)
		 			setState(313)
		 			try conjunction()

		 	 
		 		}
		 		setState(318)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,37,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ConjunctionContext: ParserRuleContext {
			internal
			func inversion() -> [InversionContext] {
				return getRuleContexts(InversionContext.self)
			}
			internal
			func inversion(_ i: Int) -> InversionContext? {
				return getRuleContext(InversionContext.self, i)
			}
			internal
			func AND() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.AND.rawValue)
			}
			internal
			func AND(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.AND.rawValue, i)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_conjunction
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitConjunction(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitConjunction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func conjunction() throws -> ConjunctionContext {
		var _localctx: ConjunctionContext
		_localctx = ConjunctionContext(_ctx, getState())
		try enterRule(_localctx, 60, BQLParser.RULE_conjunction)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(319)
		 	try inversion()
		 	setState(324)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,38,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(320)
		 			try match(BQLParser.Tokens.AND.rawValue)
		 			setState(321)
		 			try inversion()

		 	 
		 		}
		 		setState(326)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,38,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class InversionContext: ParserRuleContext {
			internal
			func NOT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NOT.rawValue, 0)
			}
			internal
			func inversion() -> InversionContext? {
				return getRuleContext(InversionContext.self, 0)
			}
			internal
			func comparison() -> ComparisonContext? {
				return getRuleContext(ComparisonContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_inversion
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitInversion(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitInversion(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func inversion() throws -> InversionContext {
		var _localctx: InversionContext
		_localctx = InversionContext(_ctx, getState())
		try enterRule(_localctx, 62, BQLParser.RULE_inversion)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(330)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .NOT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(327)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(328)
		 		try inversion()

		 		break
		 	case .SELECT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .POSITIONAL_PLACEHOLDER:fallthrough
		 	case .NAMED_PLACEHOLDER_START:fallthrough
		 	case .PLUS:fallthrough
		 	case .MINUS:fallthrough
		 	case .LPAREN:fallthrough
		 	case .DATE_LITERAL:fallthrough
		 	case .DECIMAL:fallthrough
		 	case .INTEGER:fallthrough
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(329)
		 		try comparison()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ComparisonContext: ParserRuleContext {
			internal
			func sumExpr() -> SumExprContext? {
				return getRuleContext(SumExprContext.self, 0)
			}
			internal
			func comparisonSuffix() -> ComparisonSuffixContext? {
				return getRuleContext(ComparisonSuffixContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_comparison
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitComparison(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitComparison(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func comparison() throws -> ComparisonContext {
		var _localctx: ComparisonContext
		_localctx = ComparisonContext(_ctx, getState())
		try enterRule(_localctx, 64, BQLParser.RULE_comparison)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(332)
		 	try sumExpr(0)
		 	setState(334)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,40,_ctx)) {
		 	case 1:
		 		setState(333)
		 		try comparisonSuffix()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ComparisonSuffixContext: ParserRuleContext {
			internal
			func LT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LT.rawValue, 0)
			}
			internal
			func sumExpr() -> [SumExprContext] {
				return getRuleContexts(SumExprContext.self)
			}
			internal
			func sumExpr(_ i: Int) -> SumExprContext? {
				return getRuleContext(SumExprContext.self, i)
			}
			internal
			func LTE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LTE.rawValue, 0)
			}
			internal
			func GT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.GT.rawValue, 0)
			}
			internal
			func GTE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.GTE.rawValue, 0)
			}
			internal
			func EQ() -> TerminalNode? {
				return getToken(BQLParser.Tokens.EQ.rawValue, 0)
			}
			internal
			func NEQ() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NEQ.rawValue, 0)
			}
			internal
			func IN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.IN.rawValue, 0)
			}
			internal
			func NOT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NOT.rawValue, 0)
			}
			internal
			func MATCH() -> TerminalNode? {
				return getToken(BQLParser.Tokens.MATCH.rawValue, 0)
			}
			internal
			func NOT_MATCH() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NOT_MATCH.rawValue, 0)
			}
			internal
			func MATCHES() -> TerminalNode? {
				return getToken(BQLParser.Tokens.MATCHES.rawValue, 0)
			}
			internal
			func IS() -> TerminalNode? {
				return getToken(BQLParser.Tokens.IS.rawValue, 0)
			}
			internal
			func NULL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NULL.rawValue, 0)
			}
			internal
			func BETWEEN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.BETWEEN.rawValue, 0)
			}
			internal
			func AND() -> TerminalNode? {
				return getToken(BQLParser.Tokens.AND.rawValue, 0)
			}
			internal
			func anyAllOp() -> AnyAllOpContext? {
				return getRuleContext(AnyAllOpContext.self, 0)
			}
			internal
			func ANY() -> TerminalNode? {
				return getToken(BQLParser.Tokens.ANY.rawValue, 0)
			}
			internal
			func LPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LPAREN.rawValue, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			internal
			func RPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.RPAREN.rawValue, 0)
			}
			internal
			func ALL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.ALL.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_comparisonSuffix
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitComparisonSuffix(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitComparisonSuffix(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func comparisonSuffix() throws -> ComparisonSuffixContext {
		var _localctx: ComparisonSuffixContext
		_localctx = ComparisonSuffixContext(_ctx, getState())
		try enterRule(_localctx, 66, BQLParser.RULE_comparisonSuffix)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(381)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,41, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(336)
		 		try match(BQLParser.Tokens.LT.rawValue)
		 		setState(337)
		 		try sumExpr(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(338)
		 		try match(BQLParser.Tokens.LTE.rawValue)
		 		setState(339)
		 		try sumExpr(0)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(340)
		 		try match(BQLParser.Tokens.GT.rawValue)
		 		setState(341)
		 		try sumExpr(0)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(342)
		 		try match(BQLParser.Tokens.GTE.rawValue)
		 		setState(343)
		 		try sumExpr(0)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(344)
		 		try match(BQLParser.Tokens.EQ.rawValue)
		 		setState(345)
		 		try sumExpr(0)

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(346)
		 		try match(BQLParser.Tokens.NEQ.rawValue)
		 		setState(347)
		 		try sumExpr(0)

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(348)
		 		try match(BQLParser.Tokens.IN.rawValue)
		 		setState(349)
		 		try sumExpr(0)

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(350)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(351)
		 		try match(BQLParser.Tokens.IN.rawValue)
		 		setState(352)
		 		try sumExpr(0)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(353)
		 		try match(BQLParser.Tokens.MATCH.rawValue)
		 		setState(354)
		 		try sumExpr(0)

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(355)
		 		try match(BQLParser.Tokens.NOT_MATCH.rawValue)
		 		setState(356)
		 		try sumExpr(0)

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(357)
		 		try match(BQLParser.Tokens.MATCHES.rawValue)
		 		setState(358)
		 		try sumExpr(0)

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(359)
		 		try match(BQLParser.Tokens.IS.rawValue)
		 		setState(360)
		 		try match(BQLParser.Tokens.NULL.rawValue)

		 		break
		 	case 13:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(361)
		 		try match(BQLParser.Tokens.IS.rawValue)
		 		setState(362)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(363)
		 		try match(BQLParser.Tokens.NULL.rawValue)

		 		break
		 	case 14:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(364)
		 		try match(BQLParser.Tokens.BETWEEN.rawValue)
		 		setState(365)
		 		try sumExpr(0)
		 		setState(366)
		 		try match(BQLParser.Tokens.AND.rawValue)
		 		setState(367)
		 		try sumExpr(0)

		 		break
		 	case 15:
		 		try enterOuterAlt(_localctx, 15)
		 		setState(369)
		 		try anyAllOp()
		 		setState(370)
		 		try match(BQLParser.Tokens.ANY.rawValue)
		 		setState(371)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(372)
		 		try expression()
		 		setState(373)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	case 16:
		 		try enterOuterAlt(_localctx, 16)
		 		setState(375)
		 		try anyAllOp()
		 		setState(376)
		 		try match(BQLParser.Tokens.ALL.rawValue)
		 		setState(377)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(378)
		 		try expression()
		 		setState(379)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class AnyAllOpContext: ParserRuleContext {
			internal
			func LT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LT.rawValue, 0)
			}
			internal
			func LTE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LTE.rawValue, 0)
			}
			internal
			func GT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.GT.rawValue, 0)
			}
			internal
			func GTE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.GTE.rawValue, 0)
			}
			internal
			func EQ() -> TerminalNode? {
				return getToken(BQLParser.Tokens.EQ.rawValue, 0)
			}
			internal
			func NEQ() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NEQ.rawValue, 0)
			}
			internal
			func MATCH() -> TerminalNode? {
				return getToken(BQLParser.Tokens.MATCH.rawValue, 0)
			}
			internal
			func NOT_MATCH() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NOT_MATCH.rawValue, 0)
			}
			internal
			func MATCHES() -> TerminalNode? {
				return getToken(BQLParser.Tokens.MATCHES.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_anyAllOp
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitAnyAllOp(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitAnyAllOp(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func anyAllOp() throws -> AnyAllOpContext {
		var _localctx: AnyAllOpContext
		_localctx = AnyAllOpContext(_ctx, getState())
		try enterRule(_localctx, 68, BQLParser.RULE_anyAllOp)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(383)
		 	_la = try _input.LA(1)
		 	if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 134071699111936) != 0))) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	internal class SumExprContext: ParserRuleContext {
			internal
			func termExpr() -> TermExprContext? {
				return getRuleContext(TermExprContext.self, 0)
			}
			internal
			func sumExpr() -> SumExprContext? {
				return getRuleContext(SumExprContext.self, 0)
			}
			internal
			func PLUS() -> TerminalNode? {
				return getToken(BQLParser.Tokens.PLUS.rawValue, 0)
			}
			internal
			func MINUS() -> TerminalNode? {
				return getToken(BQLParser.Tokens.MINUS.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_sumExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitSumExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitSumExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 internal final  func sumExpr( ) throws -> SumExprContext   {
		return try sumExpr(0)
	}
	@discardableResult
	private func sumExpr(_ _p: Int) throws -> SumExprContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: SumExprContext
		_localctx = SumExprContext(_ctx, _parentState)
		var _prevctx: SumExprContext = _localctx
		let _startState: Int = 70
		try enterRecursionRule(_localctx, 70, BQLParser.RULE_sumExpr, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(386)
			try termExpr(0)

			_ctx!.stop = try _input.LT(-1)
			setState(396)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,43,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(394)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,42, _ctx)) {
					case 1:
						_localctx = SumExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_sumExpr)
						setState(388)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(389)
						try match(BQLParser.Tokens.PLUS.rawValue)
						setState(390)
						try termExpr(0)

						break
					case 2:
						_localctx = SumExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_sumExpr)
						setState(391)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(392)
						try match(BQLParser.Tokens.MINUS.rawValue)
						setState(393)
						try termExpr(0)

						break
					default: break
					}
			 
				}
				setState(398)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,43,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}


	internal class TermExprContext: ParserRuleContext {
			internal
			func factorExpr() -> FactorExprContext? {
				return getRuleContext(FactorExprContext.self, 0)
			}
			internal
			func termExpr() -> TermExprContext? {
				return getRuleContext(TermExprContext.self, 0)
			}
			internal
			func STAR() -> TerminalNode? {
				return getToken(BQLParser.Tokens.STAR.rawValue, 0)
			}
			internal
			func SLASH() -> TerminalNode? {
				return getToken(BQLParser.Tokens.SLASH.rawValue, 0)
			}
			internal
			func PERCENT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.PERCENT.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_termExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitTermExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitTermExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 internal final  func termExpr( ) throws -> TermExprContext   {
		return try termExpr(0)
	}
	@discardableResult
	private func termExpr(_ _p: Int) throws -> TermExprContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: TermExprContext
		_localctx = TermExprContext(_ctx, _parentState)
		var _prevctx: TermExprContext = _localctx
		let _startState: Int = 72
		try enterRecursionRule(_localctx, 72, BQLParser.RULE_termExpr, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(400)
			try factorExpr()

			_ctx!.stop = try _input.LT(-1)
			setState(413)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,45,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(411)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,44, _ctx)) {
					case 1:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(402)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(403)
						try match(BQLParser.Tokens.STAR.rawValue)
						setState(404)
						try factorExpr()

						break
					case 2:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(405)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(406)
						try match(BQLParser.Tokens.SLASH.rawValue)
						setState(407)
						try factorExpr()

						break
					case 3:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(408)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(409)
						try match(BQLParser.Tokens.PERCENT.rawValue)
						setState(410)
						try factorExpr()

						break
					default: break
					}
			 
				}
				setState(415)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,45,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	internal class FactorExprContext: ParserRuleContext {
			internal
			func unaryExpr() -> UnaryExprContext? {
				return getRuleContext(UnaryExprContext.self, 0)
			}
			internal
			func LPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LPAREN.rawValue, 0)
			}
			internal
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			internal
			func RPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.RPAREN.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_factorExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitFactorExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitFactorExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func factorExpr() throws -> FactorExprContext {
		var _localctx: FactorExprContext
		_localctx = FactorExprContext(_ctx, getState())
		try enterRule(_localctx, 74, BQLParser.RULE_factorExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(421)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,46, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(416)
		 		try unaryExpr()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(417)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(418)
		 		try expression()
		 		setState(419)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class UnaryExprContext: ParserRuleContext {
			internal
			func PLUS() -> TerminalNode? {
				return getToken(BQLParser.Tokens.PLUS.rawValue, 0)
			}
			internal
			func atomExpr() -> AtomExprContext? {
				return getRuleContext(AtomExprContext.self, 0)
			}
			internal
			func MINUS() -> TerminalNode? {
				return getToken(BQLParser.Tokens.MINUS.rawValue, 0)
			}
			internal
			func factorExpr() -> FactorExprContext? {
				return getRuleContext(FactorExprContext.self, 0)
			}
			internal
			func primaryExpr() -> PrimaryExprContext? {
				return getRuleContext(PrimaryExprContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_unaryExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitUnaryExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitUnaryExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func unaryExpr() throws -> UnaryExprContext {
		var _localctx: UnaryExprContext
		_localctx = UnaryExprContext(_ctx, getState())
		try enterRule(_localctx, 76, BQLParser.RULE_unaryExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(428)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .PLUS:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(423)
		 		try match(BQLParser.Tokens.PLUS.rawValue)
		 		setState(424)
		 		try atomExpr()

		 		break

		 	case .MINUS:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(425)
		 		try match(BQLParser.Tokens.MINUS.rawValue)
		 		setState(426)
		 		try factorExpr()

		 		break
		 	case .SELECT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .POSITIONAL_PLACEHOLDER:fallthrough
		 	case .NAMED_PLACEHOLDER_START:fallthrough
		 	case .LPAREN:fallthrough
		 	case .DATE_LITERAL:fallthrough
		 	case .DECIMAL:fallthrough
		 	case .INTEGER:fallthrough
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(427)
		 		try primaryExpr(0)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	internal class PrimaryExprContext: ParserRuleContext {
			internal
			func atomExpr() -> AtomExprContext? {
				return getRuleContext(AtomExprContext.self, 0)
			}
			internal
			func primaryExpr() -> PrimaryExprContext? {
				return getRuleContext(PrimaryExprContext.self, 0)
			}
			internal
			func DOT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DOT.rawValue, 0)
			}
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			internal
			func LBRACK() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LBRACK.rawValue, 0)
			}
			internal
			func stringLiteral() -> StringLiteralContext? {
				return getRuleContext(StringLiteralContext.self, 0)
			}
			internal
			func RBRACK() -> TerminalNode? {
				return getToken(BQLParser.Tokens.RBRACK.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_primaryExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitPrimaryExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitPrimaryExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 internal final  func primaryExpr( ) throws -> PrimaryExprContext   {
		return try primaryExpr(0)
	}
	@discardableResult
	private func primaryExpr(_ _p: Int) throws -> PrimaryExprContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: PrimaryExprContext
		_localctx = PrimaryExprContext(_ctx, _parentState)
		var _prevctx: PrimaryExprContext = _localctx
		let _startState: Int = 78
		try enterRecursionRule(_localctx, 78, BQLParser.RULE_primaryExpr, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(431)
			try atomExpr()

			_ctx!.stop = try _input.LT(-1)
			setState(443)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,49,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(441)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,48, _ctx)) {
					case 1:
						_localctx = PrimaryExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_primaryExpr)
						setState(433)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(434)
						try match(BQLParser.Tokens.DOT.rawValue)
						setState(435)
						try identifier()

						break
					case 2:
						_localctx = PrimaryExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_primaryExpr)
						setState(436)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(437)
						try match(BQLParser.Tokens.LBRACK.rawValue)
						setState(438)
						try stringLiteral()
						setState(439)
						try match(BQLParser.Tokens.RBRACK.rawValue)

						break
					default: break
					}
			 
				}
				setState(445)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,49,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	internal class AtomExprContext: ParserRuleContext {
			internal
			func selectStmt() -> SelectStmtContext? {
				return getRuleContext(SelectStmtContext.self, 0)
			}
			internal
			func functionCall() -> FunctionCallContext? {
				return getRuleContext(FunctionCallContext.self, 0)
			}
			internal
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
			internal
			func columnRef() -> ColumnRefContext? {
				return getRuleContext(ColumnRefContext.self, 0)
			}
			internal
			func placeholder() -> PlaceholderContext? {
				return getRuleContext(PlaceholderContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_atomExpr
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitAtomExpr(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitAtomExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func atomExpr() throws -> AtomExprContext {
		var _localctx: AtomExprContext
		_localctx = AtomExprContext(_ctx, getState())
		try enterRule(_localctx, 80, BQLParser.RULE_atomExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(451)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,50, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(446)
		 		try selectStmt()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(447)
		 		try functionCall()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(448)
		 		try constant()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(449)
		 		try columnRef()

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(450)
		 		try placeholder()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class PlaceholderContext: ParserRuleContext {
			internal
			func POSITIONAL_PLACEHOLDER() -> TerminalNode? {
				return getToken(BQLParser.Tokens.POSITIONAL_PLACEHOLDER.rawValue, 0)
			}
			internal
			func NAMED_PLACEHOLDER_START() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NAMED_PLACEHOLDER_START.rawValue, 0)
			}
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			internal
			func NAMED_PLACEHOLDER_END() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NAMED_PLACEHOLDER_END.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_placeholder
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitPlaceholder(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitPlaceholder(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func placeholder() throws -> PlaceholderContext {
		var _localctx: PlaceholderContext
		_localctx = PlaceholderContext(_ctx, getState())
		try enterRule(_localctx, 82, BQLParser.RULE_placeholder)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(458)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .POSITIONAL_PLACEHOLDER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(453)
		 		try match(BQLParser.Tokens.POSITIONAL_PLACEHOLDER.rawValue)

		 		break

		 	case .NAMED_PLACEHOLDER_START:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(454)
		 		try match(BQLParser.Tokens.NAMED_PLACEHOLDER_START.rawValue)
		 		setState(455)
		 		try identifier()
		 		setState(456)
		 		try match(BQLParser.Tokens.NAMED_PLACEHOLDER_END.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class FunctionCallContext: ParserRuleContext {
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			internal
			func LPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LPAREN.rawValue, 0)
			}
			internal
			func asterisk() -> AsteriskContext? {
				return getRuleContext(AsteriskContext.self, 0)
			}
			internal
			func RPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.RPAREN.rawValue, 0)
			}
			internal
			func expressionList() -> ExpressionListContext? {
				return getRuleContext(ExpressionListContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_functionCall
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitFunctionCall(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitFunctionCall(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func functionCall() throws -> FunctionCallContext {
		var _localctx: FunctionCallContext
		_localctx = FunctionCallContext(_ctx, getState())
		try enterRule(_localctx, 84, BQLParser.RULE_functionCall)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(472)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,53, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(460)
		 		try identifier()
		 		setState(461)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(462)
		 		try asterisk()
		 		setState(463)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(465)
		 		try identifier()
		 		setState(466)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(468)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -269793739406893054) != 0)) {
		 			setState(467)
		 			try expressionList()

		 		}

		 		setState(470)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ExpressionListContext: ParserRuleContext {
			internal
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			internal
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			internal
			func COMMA() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.COMMA.rawValue)
			}
			internal
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.COMMA.rawValue, i)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_expressionList
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitExpressionList(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitExpressionList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func expressionList() throws -> ExpressionListContext {
		var _localctx: ExpressionListContext
		_localctx = ExpressionListContext(_ctx, getState())
		try enterRule(_localctx, 86, BQLParser.RULE_expressionList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(474)
		 	try expression()
		 	setState(479)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (_la == BQLParser.Tokens.COMMA.rawValue) {
		 		setState(475)
		 		try match(BQLParser.Tokens.COMMA.rawValue)
		 		setState(476)
		 		try expression()


		 		setState(481)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ColumnRefContext: ParserRuleContext {
			internal
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_columnRef
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitColumnRef(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitColumnRef(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func columnRef() throws -> ColumnRefContext {
		var _localctx: ColumnRefContext
		_localctx = ColumnRefContext(_ctx, getState())
		try enterRule(_localctx, 88, BQLParser.RULE_columnRef)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(482)
		 	try identifier()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ConstantContext: ParserRuleContext {
			internal
			func literal() -> LiteralContext? {
				return getRuleContext(LiteralContext.self, 0)
			}
			internal
			func listLiteral() -> ListLiteralContext? {
				return getRuleContext(ListLiteralContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_constant
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitConstant(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitConstant(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func constant() throws -> ConstantContext {
		var _localctx: ConstantContext
		_localctx = ConstantContext(_ctx, getState())
		try enterRule(_localctx, 90, BQLParser.RULE_constant)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(486)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .DATE_LITERAL:fallthrough
		 	case .DECIMAL:fallthrough
		 	case .INTEGER:fallthrough
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(484)
		 		try literal()

		 		break

		 	case .LPAREN:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(485)
		 		try listLiteral()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class LiteralContext: ParserRuleContext {
			internal
			func dateLiteral() -> DateLiteralContext? {
				return getRuleContext(DateLiteralContext.self, 0)
			}
			internal
			func decimalLiteral() -> DecimalLiteralContext? {
				return getRuleContext(DecimalLiteralContext.self, 0)
			}
			internal
			func integerLiteral() -> IntegerLiteralContext? {
				return getRuleContext(IntegerLiteralContext.self, 0)
			}
			internal
			func stringLiteral() -> StringLiteralContext? {
				return getRuleContext(StringLiteralContext.self, 0)
			}
			internal
			func nullLiteral() -> NullLiteralContext? {
				return getRuleContext(NullLiteralContext.self, 0)
			}
			internal
			func booleanLiteral() -> BooleanLiteralContext? {
				return getRuleContext(BooleanLiteralContext.self, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_literal
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func literal() throws -> LiteralContext {
		var _localctx: LiteralContext
		_localctx = LiteralContext(_ctx, getState())
		try enterRule(_localctx, 92, BQLParser.RULE_literal)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(494)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .DATE_LITERAL:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(488)
		 		try dateLiteral()

		 		break

		 	case .DECIMAL:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(489)
		 		try decimalLiteral()

		 		break

		 	case .INTEGER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(490)
		 		try integerLiteral()

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(491)
		 		try stringLiteral()

		 		break

		 	case .NULL:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(492)
		 		try nullLiteral()

		 		break
		 	case .TRUE:fallthrough
		 	case .FALSE:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(493)
		 		try booleanLiteral()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class ListLiteralContext: ParserRuleContext {
			internal
			func LPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.LPAREN.rawValue, 0)
			}
			internal
			func literal() -> [LiteralContext] {
				return getRuleContexts(LiteralContext.self)
			}
			internal
			func literal(_ i: Int) -> LiteralContext? {
				return getRuleContext(LiteralContext.self, i)
			}
			internal
			func COMMA() -> [TerminalNode] {
				return getTokens(BQLParser.Tokens.COMMA.rawValue)
			}
			internal
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(BQLParser.Tokens.COMMA.rawValue, i)
			}
			internal
			func RPAREN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.RPAREN.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_listLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitListLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitListLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func listLiteral() throws -> ListLiteralContext {
		var _localctx: ListLiteralContext
		_localctx = ListLiteralContext(_ctx, getState())
		try enterRule(_localctx, 94, BQLParser.RULE_listLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(496)
		 	try match(BQLParser.Tokens.LPAREN.rawValue)
		 	setState(497)
		 	try literal()
		 	setState(498)
		 	try match(BQLParser.Tokens.COMMA.rawValue)
		 	setState(510)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 8935141660703522816) != 0)) {
		 		setState(499)
		 		try literal()
		 		setState(504)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,57,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(500)
		 				try match(BQLParser.Tokens.COMMA.rawValue)
		 				setState(501)
		 				try literal()

		 		 
		 			}
		 			setState(506)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,57,_ctx)
		 		}
		 		setState(508)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (_la == BQLParser.Tokens.COMMA.rawValue) {
		 			setState(507)
		 			try match(BQLParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(512)
		 	try match(BQLParser.Tokens.RPAREN.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class IdentifierContext: ParserRuleContext {
			internal
			func IDENTIFIER() -> TerminalNode? {
				return getToken(BQLParser.Tokens.IDENTIFIER.rawValue, 0)
			}
			internal
			func DOUBLE_QUOTED_TEXT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DOUBLE_QUOTED_TEXT.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_identifier
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitIdentifier(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitIdentifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func identifier() throws -> IdentifierContext {
		var _localctx: IdentifierContext
		_localctx = IdentifierContext(_ctx, getState())
		try enterRule(_localctx, 96, BQLParser.RULE_identifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(514)
		 	_la = try _input.LA(1)
		 	if (!(_la == BQLParser.Tokens.DOUBLE_QUOTED_TEXT.rawValue || _la == BQLParser.Tokens.IDENTIFIER.rawValue)) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class StringLiteralContext: ParserRuleContext {
			internal
			func DOUBLE_QUOTED_TEXT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DOUBLE_QUOTED_TEXT.rawValue, 0)
			}
			internal
			func SINGLE_QUOTED_STRING() -> TerminalNode? {
				return getToken(BQLParser.Tokens.SINGLE_QUOTED_STRING.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_stringLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitStringLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitStringLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func stringLiteral() throws -> StringLiteralContext {
		var _localctx: StringLiteralContext
		_localctx = StringLiteralContext(_ctx, getState())
		try enterRule(_localctx, 98, BQLParser.RULE_stringLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(516)
		 	_la = try _input.LA(1)
		 	if (!(_la == BQLParser.Tokens.DOUBLE_QUOTED_TEXT.rawValue || _la == BQLParser.Tokens.SINGLE_QUOTED_STRING.rawValue)) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class BooleanLiteralContext: ParserRuleContext {
			internal
			func TRUE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.TRUE.rawValue, 0)
			}
			internal
			func FALSE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.FALSE.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_booleanLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitBooleanLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitBooleanLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func booleanLiteral() throws -> BooleanLiteralContext {
		var _localctx: BooleanLiteralContext
		_localctx = BooleanLiteralContext(_ctx, getState())
		try enterRule(_localctx, 100, BQLParser.RULE_booleanLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(518)
		 	_la = try _input.LA(1)
		 	if (!(_la == BQLParser.Tokens.TRUE.rawValue || _la == BQLParser.Tokens.FALSE.rawValue)) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class NullLiteralContext: ParserRuleContext {
			internal
			func NULL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.NULL.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_nullLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitNullLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitNullLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func nullLiteral() throws -> NullLiteralContext {
		var _localctx: NullLiteralContext
		_localctx = NullLiteralContext(_ctx, getState())
		try enterRule(_localctx, 102, BQLParser.RULE_nullLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(520)
		 	try match(BQLParser.Tokens.NULL.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class IntegerLiteralContext: ParserRuleContext {
			internal
			func INTEGER() -> TerminalNode? {
				return getToken(BQLParser.Tokens.INTEGER.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_integerLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitIntegerLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitIntegerLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func integerLiteral() throws -> IntegerLiteralContext {
		var _localctx: IntegerLiteralContext
		_localctx = IntegerLiteralContext(_ctx, getState())
		try enterRule(_localctx, 104, BQLParser.RULE_integerLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(522)
		 	try match(BQLParser.Tokens.INTEGER.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class DecimalLiteralContext: ParserRuleContext {
			internal
			func DECIMAL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DECIMAL.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_decimalLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitDecimalLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitDecimalLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func decimalLiteral() throws -> DecimalLiteralContext {
		var _localctx: DecimalLiteralContext
		_localctx = DecimalLiteralContext(_ctx, getState())
		try enterRule(_localctx, 106, BQLParser.RULE_decimalLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(524)
		 	try match(BQLParser.Tokens.DECIMAL.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	internal class DateLiteralContext: ParserRuleContext {
			internal
			func DATE_LITERAL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.DATE_LITERAL.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_dateLiteral
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitDateLiteral(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitDateLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func dateLiteral() throws -> DateLiteralContext {
		var _localctx: DateLiteralContext
		_localctx = DateLiteralContext(_ctx, getState())
		try enterRule(_localctx, 108, BQLParser.RULE_dateLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(526)
		 	try match(BQLParser.Tokens.DATE_LITERAL.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	override internal
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  35:
			return try sumExpr_sempred(_localctx?.castdown(SumExprContext.self), predIndex)
		case  36:
			return try termExpr_sempred(_localctx?.castdown(TermExprContext.self), predIndex)
		case  39:
			return try primaryExpr_sempred(_localctx?.castdown(PrimaryExprContext.self), predIndex)
	    default: return true
		}
	}
	private func sumExpr_sempred(_ _localctx: SumExprContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 3)
		    case 1:return precpred(_ctx, 2)
		    default: return true
		}
	}
	private func termExpr_sempred(_ _localctx: TermExprContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 2:return precpred(_ctx, 4)
		    case 3:return precpred(_ctx, 3)
		    case 4:return precpred(_ctx, 2)
		    default: return true
		}
	}
	private func primaryExpr_sempred(_ _localctx: PrimaryExprContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 5:return precpred(_ctx, 3)
		    case 6:return precpred(_ctx, 2)
		    default: return true
		}
	}

	static let _serializedATN:[Int] = [
		4,1,66,529,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,
		7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,14,7,14,
		2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,2,20,7,20,2,21,7,21,
		2,22,7,22,2,23,7,23,2,24,7,24,2,25,7,25,2,26,7,26,2,27,7,27,2,28,7,28,
		2,29,7,29,2,30,7,30,2,31,7,31,2,32,7,32,2,33,7,33,2,34,7,34,2,35,7,35,
		2,36,7,36,2,37,7,37,2,38,7,38,2,39,7,39,2,40,7,40,2,41,7,41,2,42,7,42,
		2,43,7,43,2,44,7,44,2,45,7,45,2,46,7,46,2,47,7,47,2,48,7,48,2,49,7,49,
		2,50,7,50,2,51,7,51,2,52,7,52,2,53,7,53,2,54,7,54,1,0,1,0,1,0,1,1,1,1,
		1,1,1,1,3,1,118,8,1,1,2,1,2,3,2,122,8,2,1,2,1,2,3,2,126,8,2,1,2,3,2,129,
		8,2,1,2,3,2,132,8,2,1,2,3,2,135,8,2,1,2,3,2,138,8,2,1,2,3,2,141,8,2,1,
		3,1,3,1,4,1,4,1,4,5,4,148,8,4,10,4,12,4,151,9,4,1,4,3,4,154,8,4,1,5,1,
		5,1,6,1,6,1,6,3,6,161,8,6,1,7,1,7,1,7,1,7,3,7,167,8,7,1,8,1,8,1,8,1,8,
		1,9,1,9,1,10,1,10,1,10,3,10,178,8,10,1,11,1,11,1,11,1,11,1,11,1,11,3,11,
		186,8,11,3,11,188,8,11,1,11,3,11,191,8,11,1,11,1,11,1,11,3,11,196,8,11,
		1,11,3,11,199,8,11,1,11,1,11,1,11,1,11,1,11,3,11,206,8,11,1,11,1,11,1,
		11,3,11,211,8,11,3,11,213,8,11,1,11,3,11,216,8,11,3,11,218,8,11,1,12,1,
		12,1,13,1,13,1,13,1,14,1,14,1,14,1,14,1,14,5,14,230,8,14,10,14,12,14,233,
		9,14,1,14,1,14,3,14,237,8,14,1,15,1,15,3,15,241,8,15,1,16,1,16,1,16,1,
		16,1,16,5,16,248,8,16,10,16,12,16,251,9,16,1,17,1,17,3,17,255,8,17,1,17,
		3,17,258,8,17,1,18,1,18,1,19,1,19,1,19,1,20,1,20,1,20,1,20,1,20,1,20,1,
		21,1,21,3,21,273,8,21,1,22,1,22,1,22,3,22,278,8,22,1,22,3,22,281,8,22,
		1,22,3,22,284,8,22,1,23,1,23,1,23,1,24,1,24,3,24,291,8,24,1,24,1,24,3,
		24,295,8,24,1,24,3,24,298,8,24,1,25,1,25,1,25,1,26,1,26,3,26,305,8,26,
		1,27,1,27,1,27,1,28,1,28,1,29,1,29,1,29,5,29,315,8,29,10,29,12,29,318,
		9,29,1,30,1,30,1,30,5,30,323,8,30,10,30,12,30,326,9,30,1,31,1,31,1,31,
		3,31,331,8,31,1,32,1,32,3,32,335,8,32,1,33,1,33,1,33,1,33,1,33,1,33,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,3,33,382,8,33,1,34,
		1,34,1,35,1,35,1,35,1,35,1,35,1,35,1,35,1,35,1,35,5,35,395,8,35,10,35,
		12,35,398,9,35,1,36,1,36,1,36,1,36,1,36,1,36,1,36,1,36,1,36,1,36,1,36,
		1,36,5,36,412,8,36,10,36,12,36,415,9,36,1,37,1,37,1,37,1,37,1,37,3,37,
		422,8,37,1,38,1,38,1,38,1,38,1,38,3,38,429,8,38,1,39,1,39,1,39,1,39,1,
		39,1,39,1,39,1,39,1,39,1,39,1,39,5,39,442,8,39,10,39,12,39,445,9,39,1,
		40,1,40,1,40,1,40,1,40,3,40,452,8,40,1,41,1,41,1,41,1,41,1,41,3,41,459,
		8,41,1,42,1,42,1,42,1,42,1,42,1,42,1,42,1,42,3,42,469,8,42,1,42,1,42,3,
		42,473,8,42,1,43,1,43,1,43,5,43,478,8,43,10,43,12,43,481,9,43,1,44,1,44,
		1,45,1,45,3,45,487,8,45,1,46,1,46,1,46,1,46,1,46,1,46,3,46,495,8,46,1,
		47,1,47,1,47,1,47,1,47,1,47,5,47,503,8,47,10,47,12,47,506,9,47,1,47,3,
		47,509,8,47,3,47,511,8,47,1,47,1,47,1,48,1,48,1,49,1,49,1,50,1,50,1,51,
		1,51,1,52,1,52,1,53,1,53,1,54,1,54,1,54,0,3,70,72,78,55,0,2,4,6,8,10,12,
		14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,
		62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,
		108,0,5,1,0,31,32,2,0,36,40,43,46,2,0,61,61,63,63,1,0,61,62,1,0,17,18,
		562,0,110,1,0,0,0,2,117,1,0,0,0,4,119,1,0,0,0,6,142,1,0,0,0,8,153,1,0,
		0,0,10,155,1,0,0,0,12,157,1,0,0,0,14,162,1,0,0,0,16,168,1,0,0,0,18,172,
		1,0,0,0,20,177,1,0,0,0,22,217,1,0,0,0,24,219,1,0,0,0,26,221,1,0,0,0,28,
		224,1,0,0,0,30,240,1,0,0,0,32,242,1,0,0,0,34,254,1,0,0,0,36,259,1,0,0,
		0,38,261,1,0,0,0,40,264,1,0,0,0,42,272,1,0,0,0,44,274,1,0,0,0,46,285,1,
		0,0,0,48,288,1,0,0,0,50,299,1,0,0,0,52,302,1,0,0,0,54,306,1,0,0,0,56,309,
		1,0,0,0,58,311,1,0,0,0,60,319,1,0,0,0,62,330,1,0,0,0,64,332,1,0,0,0,66,
		381,1,0,0,0,68,383,1,0,0,0,70,385,1,0,0,0,72,399,1,0,0,0,74,421,1,0,0,
		0,76,428,1,0,0,0,78,430,1,0,0,0,80,451,1,0,0,0,82,458,1,0,0,0,84,472,1,
		0,0,0,86,474,1,0,0,0,88,482,1,0,0,0,90,486,1,0,0,0,92,494,1,0,0,0,94,496,
		1,0,0,0,96,514,1,0,0,0,98,516,1,0,0,0,100,518,1,0,0,0,102,520,1,0,0,0,
		104,522,1,0,0,0,106,524,1,0,0,0,108,526,1,0,0,0,110,111,3,2,1,0,111,112,
		5,0,0,1,112,1,1,0,0,0,113,118,3,4,2,0,114,118,3,44,22,0,115,118,3,48,24,
		0,116,118,3,52,26,0,117,113,1,0,0,0,117,114,1,0,0,0,117,115,1,0,0,0,117,
		116,1,0,0,0,118,3,1,0,0,0,119,121,5,1,0,0,120,122,3,6,3,0,121,120,1,0,
		0,0,121,122,1,0,0,0,122,123,1,0,0,0,123,125,3,8,4,0,124,126,3,14,7,0,125,
		124,1,0,0,0,125,126,1,0,0,0,126,128,1,0,0,0,127,129,3,26,13,0,128,127,
		1,0,0,0,128,129,1,0,0,0,129,131,1,0,0,0,130,132,3,28,14,0,131,130,1,0,
		0,0,131,132,1,0,0,0,132,134,1,0,0,0,133,135,3,32,16,0,134,133,1,0,0,0,
		134,135,1,0,0,0,135,137,1,0,0,0,136,138,3,40,20,0,137,136,1,0,0,0,137,
		138,1,0,0,0,138,140,1,0,0,0,139,141,3,38,19,0,140,139,1,0,0,0,140,141,
		1,0,0,0,141,5,1,0,0,0,142,143,5,2,0,0,143,7,1,0,0,0,144,149,3,12,6,0,145,
		146,5,53,0,0,146,148,3,12,6,0,147,145,1,0,0,0,148,151,1,0,0,0,149,147,
		1,0,0,0,149,150,1,0,0,0,150,154,1,0,0,0,151,149,1,0,0,0,152,154,3,10,5,
		0,153,144,1,0,0,0,153,152,1,0,0,0,154,9,1,0,0,0,155,156,5,49,0,0,156,11,
		1,0,0,0,157,160,3,56,28,0,158,159,5,10,0,0,159,161,3,96,48,0,160,158,1,
		0,0,0,160,161,1,0,0,0,161,13,1,0,0,0,162,166,5,3,0,0,163,167,3,18,9,0,
		164,167,3,16,8,0,165,167,3,22,11,0,166,163,1,0,0,0,166,164,1,0,0,0,166,
		165,1,0,0,0,167,15,1,0,0,0,168,169,5,54,0,0,169,170,3,4,2,0,170,171,5,
		55,0,0,171,17,1,0,0,0,172,173,3,20,10,0,173,19,1,0,0,0,174,178,5,41,0,
		0,175,178,5,42,0,0,176,178,3,96,48,0,177,174,1,0,0,0,177,175,1,0,0,0,177,
		176,1,0,0,0,178,21,1,0,0,0,179,180,5,25,0,0,180,181,5,27,0,0,181,187,3,
		108,54,0,182,185,5,26,0,0,183,184,5,27,0,0,184,186,3,108,54,0,185,183,
		1,0,0,0,185,186,1,0,0,0,186,188,1,0,0,0,187,182,1,0,0,0,187,188,1,0,0,
		0,188,190,1,0,0,0,189,191,3,24,12,0,190,189,1,0,0,0,190,191,1,0,0,0,191,
		218,1,0,0,0,192,195,5,26,0,0,193,194,5,27,0,0,194,196,3,108,54,0,195,193,
		1,0,0,0,195,196,1,0,0,0,196,198,1,0,0,0,197,199,3,24,12,0,198,197,1,0,
		0,0,198,199,1,0,0,0,199,218,1,0,0,0,200,218,5,28,0,0,201,205,3,56,28,0,
		202,203,5,25,0,0,203,204,5,27,0,0,204,206,3,108,54,0,205,202,1,0,0,0,205,
		206,1,0,0,0,206,212,1,0,0,0,207,210,5,26,0,0,208,209,5,27,0,0,209,211,
		3,108,54,0,210,208,1,0,0,0,210,211,1,0,0,0,211,213,1,0,0,0,212,207,1,0,
		0,0,212,213,1,0,0,0,213,215,1,0,0,0,214,216,3,24,12,0,215,214,1,0,0,0,
		215,216,1,0,0,0,216,218,1,0,0,0,217,179,1,0,0,0,217,192,1,0,0,0,217,200,
		1,0,0,0,217,201,1,0,0,0,218,23,1,0,0,0,219,220,5,28,0,0,220,25,1,0,0,0,
		221,222,5,4,0,0,222,223,3,56,28,0,223,27,1,0,0,0,224,225,5,5,0,0,225,226,
		5,6,0,0,226,231,3,30,15,0,227,228,5,53,0,0,228,230,3,30,15,0,229,227,1,
		0,0,0,230,233,1,0,0,0,231,229,1,0,0,0,231,232,1,0,0,0,232,236,1,0,0,0,
		233,231,1,0,0,0,234,235,5,7,0,0,235,237,3,56,28,0,236,234,1,0,0,0,236,
		237,1,0,0,0,237,29,1,0,0,0,238,241,3,104,52,0,239,241,3,56,28,0,240,238,
		1,0,0,0,240,239,1,0,0,0,241,31,1,0,0,0,242,243,5,8,0,0,243,244,5,6,0,0,
		244,249,3,34,17,0,245,246,5,53,0,0,246,248,3,34,17,0,247,245,1,0,0,0,248,
		251,1,0,0,0,249,247,1,0,0,0,249,250,1,0,0,0,250,33,1,0,0,0,251,249,1,0,
		0,0,252,255,3,104,52,0,253,255,3,56,28,0,254,252,1,0,0,0,254,253,1,0,0,
		0,255,257,1,0,0,0,256,258,3,36,18,0,257,256,1,0,0,0,257,258,1,0,0,0,258,
		35,1,0,0,0,259,260,7,0,0,0,260,37,1,0,0,0,261,262,5,9,0,0,262,263,3,104,
		52,0,263,39,1,0,0,0,264,265,5,23,0,0,265,266,5,6,0,0,266,267,3,42,21,0,
		267,268,5,53,0,0,268,269,3,42,21,0,269,41,1,0,0,0,270,273,3,104,52,0,271,
		273,3,88,44,0,272,270,1,0,0,0,272,271,1,0,0,0,273,43,1,0,0,0,274,277,5,
		20,0,0,275,276,5,24,0,0,276,278,3,96,48,0,277,275,1,0,0,0,277,278,1,0,
		0,0,278,280,1,0,0,0,279,281,3,46,23,0,280,279,1,0,0,0,280,281,1,0,0,0,
		281,283,1,0,0,0,282,284,3,26,13,0,283,282,1,0,0,0,283,284,1,0,0,0,284,
		45,1,0,0,0,285,286,5,3,0,0,286,287,3,22,11,0,287,47,1,0,0,0,288,290,5,
		21,0,0,289,291,3,98,49,0,290,289,1,0,0,0,290,291,1,0,0,0,291,294,1,0,0,
		0,292,293,5,24,0,0,293,295,3,96,48,0,294,292,1,0,0,0,294,295,1,0,0,0,295,
		297,1,0,0,0,296,298,3,50,25,0,297,296,1,0,0,0,297,298,1,0,0,0,298,49,1,
		0,0,0,299,300,5,3,0,0,300,301,3,22,11,0,301,51,1,0,0,0,302,304,5,22,0,
		0,303,305,3,54,27,0,304,303,1,0,0,0,304,305,1,0,0,0,305,53,1,0,0,0,306,
		307,5,3,0,0,307,308,3,22,11,0,308,55,1,0,0,0,309,310,3,58,29,0,310,57,
		1,0,0,0,311,316,3,60,30,0,312,313,5,12,0,0,313,315,3,60,30,0,314,312,1,
		0,0,0,315,318,1,0,0,0,316,314,1,0,0,0,316,317,1,0,0,0,317,59,1,0,0,0,318,
		316,1,0,0,0,319,324,3,62,31,0,320,321,5,11,0,0,321,323,3,62,31,0,322,320,
		1,0,0,0,323,326,1,0,0,0,324,322,1,0,0,0,324,325,1,0,0,0,325,61,1,0,0,0,
		326,324,1,0,0,0,327,328,5,13,0,0,328,331,3,62,31,0,329,331,3,64,32,0,330,
		327,1,0,0,0,330,329,1,0,0,0,331,63,1,0,0,0,332,334,3,70,35,0,333,335,3,
		66,33,0,334,333,1,0,0,0,334,335,1,0,0,0,335,65,1,0,0,0,336,337,5,44,0,
		0,337,382,3,70,35,0,338,339,5,39,0,0,339,382,3,70,35,0,340,341,5,45,0,
		0,341,382,3,70,35,0,342,343,5,40,0,0,343,382,3,70,35,0,344,345,5,43,0,
		0,345,382,3,70,35,0,346,347,5,38,0,0,347,382,3,70,35,0,348,349,5,14,0,
		0,349,382,3,70,35,0,350,351,5,13,0,0,351,352,5,14,0,0,352,382,3,70,35,
		0,353,354,5,46,0,0,354,382,3,70,35,0,355,356,5,36,0,0,356,382,3,70,35,
		0,357,358,5,37,0,0,358,382,3,70,35,0,359,360,5,15,0,0,360,382,5,16,0,0,
		361,362,5,15,0,0,362,363,5,13,0,0,363,382,5,16,0,0,364,365,5,19,0,0,365,
		366,3,70,35,0,366,367,5,11,0,0,367,368,3,70,35,0,368,382,1,0,0,0,369,370,
		3,68,34,0,370,371,5,29,0,0,371,372,5,54,0,0,372,373,3,56,28,0,373,374,
		5,55,0,0,374,382,1,0,0,0,375,376,3,68,34,0,376,377,5,30,0,0,377,378,5,
		54,0,0,378,379,3,56,28,0,379,380,5,55,0,0,380,382,1,0,0,0,381,336,1,0,
		0,0,381,338,1,0,0,0,381,340,1,0,0,0,381,342,1,0,0,0,381,344,1,0,0,0,381,
		346,1,0,0,0,381,348,1,0,0,0,381,350,1,0,0,0,381,353,1,0,0,0,381,355,1,
		0,0,0,381,357,1,0,0,0,381,359,1,0,0,0,381,361,1,0,0,0,381,364,1,0,0,0,
		381,369,1,0,0,0,381,375,1,0,0,0,382,67,1,0,0,0,383,384,7,1,0,0,384,69,
		1,0,0,0,385,386,6,35,-1,0,386,387,3,72,36,0,387,396,1,0,0,0,388,389,10,
		3,0,0,389,390,5,47,0,0,390,395,3,72,36,0,391,392,10,2,0,0,392,393,5,48,
		0,0,393,395,3,72,36,0,394,388,1,0,0,0,394,391,1,0,0,0,395,398,1,0,0,0,
		396,394,1,0,0,0,396,397,1,0,0,0,397,71,1,0,0,0,398,396,1,0,0,0,399,400,
		6,36,-1,0,400,401,3,74,37,0,401,413,1,0,0,0,402,403,10,4,0,0,403,404,5,
		49,0,0,404,412,3,74,37,0,405,406,10,3,0,0,406,407,5,50,0,0,407,412,3,74,
		37,0,408,409,10,2,0,0,409,410,5,51,0,0,410,412,3,74,37,0,411,402,1,0,0,
		0,411,405,1,0,0,0,411,408,1,0,0,0,412,415,1,0,0,0,413,411,1,0,0,0,413,
		414,1,0,0,0,414,73,1,0,0,0,415,413,1,0,0,0,416,422,3,76,38,0,417,418,5,
		54,0,0,418,419,3,56,28,0,419,420,5,55,0,0,420,422,1,0,0,0,421,416,1,0,
		0,0,421,417,1,0,0,0,422,75,1,0,0,0,423,424,5,47,0,0,424,429,3,80,40,0,
		425,426,5,48,0,0,426,429,3,74,37,0,427,429,3,78,39,0,428,423,1,0,0,0,428,
		425,1,0,0,0,428,427,1,0,0,0,429,77,1,0,0,0,430,431,6,39,-1,0,431,432,3,
		80,40,0,432,443,1,0,0,0,433,434,10,3,0,0,434,435,5,52,0,0,435,442,3,96,
		48,0,436,437,10,2,0,0,437,438,5,56,0,0,438,439,3,98,49,0,439,440,5,57,
		0,0,440,442,1,0,0,0,441,433,1,0,0,0,441,436,1,0,0,0,442,445,1,0,0,0,443,
		441,1,0,0,0,443,444,1,0,0,0,444,79,1,0,0,0,445,443,1,0,0,0,446,452,3,4,
		2,0,447,452,3,84,42,0,448,452,3,90,45,0,449,452,3,88,44,0,450,452,3,82,
		41,0,451,446,1,0,0,0,451,447,1,0,0,0,451,448,1,0,0,0,451,449,1,0,0,0,451,
		450,1,0,0,0,452,81,1,0,0,0,453,459,5,33,0,0,454,455,5,34,0,0,455,456,3,
		96,48,0,456,457,5,35,0,0,457,459,1,0,0,0,458,453,1,0,0,0,458,454,1,0,0,
		0,459,83,1,0,0,0,460,461,3,96,48,0,461,462,5,54,0,0,462,463,3,10,5,0,463,
		464,5,55,0,0,464,473,1,0,0,0,465,466,3,96,48,0,466,468,5,54,0,0,467,469,
		3,86,43,0,468,467,1,0,0,0,468,469,1,0,0,0,469,470,1,0,0,0,470,471,5,55,
		0,0,471,473,1,0,0,0,472,460,1,0,0,0,472,465,1,0,0,0,473,85,1,0,0,0,474,
		479,3,56,28,0,475,476,5,53,0,0,476,478,3,56,28,0,477,475,1,0,0,0,478,481,
		1,0,0,0,479,477,1,0,0,0,479,480,1,0,0,0,480,87,1,0,0,0,481,479,1,0,0,0,
		482,483,3,96,48,0,483,89,1,0,0,0,484,487,3,92,46,0,485,487,3,94,47,0,486,
		484,1,0,0,0,486,485,1,0,0,0,487,91,1,0,0,0,488,495,3,108,54,0,489,495,
		3,106,53,0,490,495,3,104,52,0,491,495,3,98,49,0,492,495,3,102,51,0,493,
		495,3,100,50,0,494,488,1,0,0,0,494,489,1,0,0,0,494,490,1,0,0,0,494,491,
		1,0,0,0,494,492,1,0,0,0,494,493,1,0,0,0,495,93,1,0,0,0,496,497,5,54,0,
		0,497,498,3,92,46,0,498,510,5,53,0,0,499,504,3,92,46,0,500,501,5,53,0,
		0,501,503,3,92,46,0,502,500,1,0,0,0,503,506,1,0,0,0,504,502,1,0,0,0,504,
		505,1,0,0,0,505,508,1,0,0,0,506,504,1,0,0,0,507,509,5,53,0,0,508,507,1,
		0,0,0,508,509,1,0,0,0,509,511,1,0,0,0,510,499,1,0,0,0,510,511,1,0,0,0,
		511,512,1,0,0,0,512,513,5,55,0,0,513,95,1,0,0,0,514,515,7,2,0,0,515,97,
		1,0,0,0,516,517,7,3,0,0,517,99,1,0,0,0,518,519,7,4,0,0,519,101,1,0,0,0,
		520,521,5,16,0,0,521,103,1,0,0,0,522,523,5,60,0,0,523,105,1,0,0,0,524,
		525,5,59,0,0,525,107,1,0,0,0,526,527,5,58,0,0,527,109,1,0,0,0,60,117,121,
		125,128,131,134,137,140,149,153,160,166,177,185,187,190,195,198,205,210,
		212,215,217,231,236,240,249,254,257,272,277,280,283,290,294,297,304,316,
		324,330,334,381,394,396,411,413,421,428,441,443,451,458,468,472,479,486,
		494,504,508,510
	]

	internal
	static let _ATN = try! ATNDeserializer().deserialize(_serializedATN)
}