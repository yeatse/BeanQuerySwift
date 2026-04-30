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
            RULE_columnRef = 44, RULE_contextualKeyword = 45, RULE_constant = 46, 
            RULE_literal = 47, RULE_listLiteral = 48, RULE_identifier = 49, 
            RULE_stringLiteral = 50, RULE_booleanLiteral = 51, RULE_nullLiteral = 52, 
            RULE_integerLiteral = 53, RULE_decimalLiteral = 54, RULE_dateLiteral = 55

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
		"functionCall", "expressionList", "columnRef", "contextualKeyword", "constant", 
		"literal", "listLiteral", "identifier", "stringLiteral", "booleanLiteral", 
		"nullLiteral", "integerLiteral", "decimalLiteral", "dateLiteral"
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
		 	setState(112)
		 	try statement()
		 	setState(113)
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
		 	setState(119)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .SELECT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(115)
		 		try selectStmt()

		 		break

		 	case .BALANCES:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(116)
		 		try balancesStmt()

		 		break

		 	case .JOURNAL:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(117)
		 		try journalStmt()

		 		break

		 	case .PRINT:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(118)
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
		 	setState(121)
		 	try match(BQLParser.Tokens.SELECT.rawValue)
		 	setState(123)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.DISTINCT.rawValue) {
		 		setState(122)
		 		try distinctClause()

		 	}

		 	setState(125)
		 	try targets()
		 	setState(127)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,2,_ctx)) {
		 	case 1:
		 		setState(126)
		 		try fromClause()

		 		break
		 	default: break
		 	}
		 	setState(130)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,3,_ctx)) {
		 	case 1:
		 		setState(129)
		 		try whereClause()

		 		break
		 	default: break
		 	}
		 	setState(133)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,4,_ctx)) {
		 	case 1:
		 		setState(132)
		 		try groupByClause()

		 		break
		 	default: break
		 	}
		 	setState(136)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,5,_ctx)) {
		 	case 1:
		 		setState(135)
		 		try orderByClause()

		 		break
		 	default: break
		 	}
		 	setState(139)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,6,_ctx)) {
		 	case 1:
		 		setState(138)
		 		try pivotByClause()

		 		break
		 	default: break
		 	}
		 	setState(142)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,7,_ctx)) {
		 	case 1:
		 		setState(141)
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
		 	setState(144)
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
		 	setState(155)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .SELECT:fallthrough
		 	case .NOT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .OPEN:fallthrough
		 	case .CLOSE:fallthrough
		 	case .CLEAR:fallthrough
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
		 		setState(146)
		 		try target()
		 		setState(151)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,8,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(147)
		 				try match(BQLParser.Tokens.COMMA.rawValue)
		 				setState(148)
		 				try target()

		 		 
		 			}
		 			setState(153)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,8,_ctx)
		 		}

		 		break

		 	case .STAR:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(154)
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
		 	setState(157)
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
		 	setState(159)
		 	try expression()
		 	setState(162)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,10,_ctx)) {
		 	case 1:
		 		setState(160)
		 		try match(BQLParser.Tokens.AS.rawValue)
		 		setState(161)
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
		 	setState(164)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(168)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,11, _ctx)) {
		 	case 1:
		 		setState(165)
		 		try tableRef()

		 		break
		 	case 2:
		 		setState(166)
		 		try subselect()

		 		break
		 	case 3:
		 		setState(167)
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
		 	setState(170)
		 	try match(BQLParser.Tokens.LPAREN.rawValue)
		 	setState(171)
		 	try selectStmt()
		 	setState(172)
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
		 	setState(174)
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
			internal
			func BALANCES() -> TerminalNode? {
				return getToken(BQLParser.Tokens.BALANCES.rawValue, 0)
			}
			internal
			func JOURNAL() -> TerminalNode? {
				return getToken(BQLParser.Tokens.JOURNAL.rawValue, 0)
			}
			internal
			func PRINT() -> TerminalNode? {
				return getToken(BQLParser.Tokens.PRINT.rawValue, 0)
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
		 	setState(182)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .HASH_TABLE:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(176)
		 		try match(BQLParser.Tokens.HASH_TABLE.rawValue)

		 		break

		 	case .HASH_EMPTY:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(177)
		 		try match(BQLParser.Tokens.HASH_EMPTY.rawValue)

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(178)
		 		try identifier()

		 		break

		 	case .BALANCES:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(179)
		 		try match(BQLParser.Tokens.BALANCES.rawValue)

		 		break

		 	case .JOURNAL:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(180)
		 		try match(BQLParser.Tokens.JOURNAL.rawValue)

		 		break

		 	case .PRINT:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(181)
		 		try match(BQLParser.Tokens.PRINT.rawValue)

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
		 	setState(222)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,22, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(184)
		 		try match(BQLParser.Tokens.OPEN.rawValue)
		 		setState(185)
		 		try match(BQLParser.Tokens.ON.rawValue)
		 		setState(186)
		 		try dateLiteral()
		 		setState(192)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,14,_ctx)) {
		 		case 1:
		 			setState(187)
		 			try match(BQLParser.Tokens.CLOSE.rawValue)
		 			setState(190)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,13,_ctx)) {
		 			case 1:
		 				setState(188)
		 				try match(BQLParser.Tokens.ON.rawValue)
		 				setState(189)
		 				try dateLiteral()

		 				break
		 			default: break
		 			}

		 			break
		 		default: break
		 		}
		 		setState(195)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,15,_ctx)) {
		 		case 1:
		 			setState(194)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(197)
		 		try match(BQLParser.Tokens.CLOSE.rawValue)
		 		setState(200)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,16,_ctx)) {
		 		case 1:
		 			setState(198)
		 			try match(BQLParser.Tokens.ON.rawValue)
		 			setState(199)
		 			try dateLiteral()

		 			break
		 		default: break
		 		}
		 		setState(203)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,17,_ctx)) {
		 		case 1:
		 			setState(202)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(205)
		 		try match(BQLParser.Tokens.CLEAR.rawValue)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(206)
		 		try expression()
		 		setState(210)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,18,_ctx)) {
		 		case 1:
		 			setState(207)
		 			try match(BQLParser.Tokens.OPEN.rawValue)
		 			setState(208)
		 			try match(BQLParser.Tokens.ON.rawValue)
		 			setState(209)
		 			try dateLiteral()

		 			break
		 		default: break
		 		}
		 		setState(217)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,20,_ctx)) {
		 		case 1:
		 			setState(212)
		 			try match(BQLParser.Tokens.CLOSE.rawValue)
		 			setState(215)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,19,_ctx)) {
		 			case 1:
		 				setState(213)
		 				try match(BQLParser.Tokens.ON.rawValue)
		 				setState(214)
		 				try dateLiteral()

		 				break
		 			default: break
		 			}

		 			break
		 		default: break
		 		}
		 		setState(220)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,21,_ctx)) {
		 		case 1:
		 			setState(219)
		 			try clearClause()

		 			break
		 		default: break
		 		}

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
		 	setState(224)
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
		 	setState(226)
		 	try match(BQLParser.Tokens.WHERE.rawValue)
		 	setState(227)
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
		 	setState(229)
		 	try match(BQLParser.Tokens.GROUP.rawValue)
		 	setState(230)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(231)
		 	try groupItem()
		 	setState(236)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,23,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(232)
		 			try match(BQLParser.Tokens.COMMA.rawValue)
		 			setState(233)
		 			try groupItem()

		 	 
		 		}
		 		setState(238)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,23,_ctx)
		 	}
		 	setState(241)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,24,_ctx)) {
		 	case 1:
		 		setState(239)
		 		try match(BQLParser.Tokens.HAVING.rawValue)
		 		setState(240)
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
		 	setState(245)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,25, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(243)
		 		try integerLiteral()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(244)
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
		 	setState(247)
		 	try match(BQLParser.Tokens.ORDER.rawValue)
		 	setState(248)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(249)
		 	try orderItem()
		 	setState(254)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,26,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(250)
		 			try match(BQLParser.Tokens.COMMA.rawValue)
		 			setState(251)
		 			try orderItem()

		 	 
		 		}
		 		setState(256)
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
		 	setState(259)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,27, _ctx)) {
		 	case 1:
		 		setState(257)
		 		try integerLiteral()

		 		break
		 	case 2:
		 		setState(258)
		 		try expression()

		 		break
		 	default: break
		 	}
		 	setState(262)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,28,_ctx)) {
		 	case 1:
		 		setState(261)
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
		 	setState(264)
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
		 	setState(266)
		 	try match(BQLParser.Tokens.LIMIT.rawValue)
		 	setState(267)
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
		 	setState(269)
		 	try match(BQLParser.Tokens.PIVOT.rawValue)
		 	setState(270)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(271)
		 	try pivotByItem()
		 	setState(272)
		 	try match(BQLParser.Tokens.COMMA.rawValue)
		 	setState(273)
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
		 	setState(277)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .INTEGER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(275)
		 		try integerLiteral()

		 		break
		 	case .OPEN:fallthrough
		 	case .CLOSE:fallthrough
		 	case .CLEAR:fallthrough
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(276)
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
		 	setState(279)
		 	try match(BQLParser.Tokens.BALANCES.rawValue)
		 	setState(282)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.AT.rawValue) {
		 		setState(280)
		 		try match(BQLParser.Tokens.AT.rawValue)
		 		setState(281)
		 		try identifier()

		 	}

		 	setState(285)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(284)
		 		try balancesFromClause()

		 	}

		 	setState(288)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.WHERE.rawValue) {
		 		setState(287)
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
		 	setState(290)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(291)
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
		 	setState(293)
		 	try match(BQLParser.Tokens.JOURNAL.rawValue)
		 	setState(295)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.DOUBLE_QUOTED_TEXT.rawValue || _la == BQLParser.Tokens.SINGLE_QUOTED_STRING.rawValue) {
		 		setState(294)
		 		try stringLiteral()

		 	}

		 	setState(299)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.AT.rawValue) {
		 		setState(297)
		 		try match(BQLParser.Tokens.AT.rawValue)
		 		setState(298)
		 		try identifier()

		 	}

		 	setState(302)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(301)
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
		 	setState(304)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(305)
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
		 	setState(307)
		 	try match(BQLParser.Tokens.PRINT.rawValue)
		 	setState(309)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(308)
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
		 	setState(311)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(312)
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
		 	setState(314)
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
		 	setState(316)
		 	try conjunction()
		 	setState(321)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,37,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(317)
		 			try match(BQLParser.Tokens.OR.rawValue)
		 			setState(318)
		 			try conjunction()

		 	 
		 		}
		 		setState(323)
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
		 	setState(324)
		 	try inversion()
		 	setState(329)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,38,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(325)
		 			try match(BQLParser.Tokens.AND.rawValue)
		 			setState(326)
		 			try inversion()

		 	 
		 		}
		 		setState(331)
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
		 	setState(335)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .NOT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(332)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(333)
		 		try inversion()

		 		break
		 	case .SELECT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .OPEN:fallthrough
		 	case .CLOSE:fallthrough
		 	case .CLEAR:fallthrough
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
		 		setState(334)
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
		 	setState(337)
		 	try sumExpr(0)
		 	setState(339)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,40,_ctx)) {
		 	case 1:
		 		setState(338)
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
		 	setState(386)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,41, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(341)
		 		try match(BQLParser.Tokens.LT.rawValue)
		 		setState(342)
		 		try sumExpr(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(343)
		 		try match(BQLParser.Tokens.LTE.rawValue)
		 		setState(344)
		 		try sumExpr(0)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(345)
		 		try match(BQLParser.Tokens.GT.rawValue)
		 		setState(346)
		 		try sumExpr(0)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(347)
		 		try match(BQLParser.Tokens.GTE.rawValue)
		 		setState(348)
		 		try sumExpr(0)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(349)
		 		try match(BQLParser.Tokens.EQ.rawValue)
		 		setState(350)
		 		try sumExpr(0)

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(351)
		 		try match(BQLParser.Tokens.NEQ.rawValue)
		 		setState(352)
		 		try sumExpr(0)

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(353)
		 		try match(BQLParser.Tokens.IN.rawValue)
		 		setState(354)
		 		try sumExpr(0)

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(355)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(356)
		 		try match(BQLParser.Tokens.IN.rawValue)
		 		setState(357)
		 		try sumExpr(0)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(358)
		 		try match(BQLParser.Tokens.MATCH.rawValue)
		 		setState(359)
		 		try sumExpr(0)

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(360)
		 		try match(BQLParser.Tokens.NOT_MATCH.rawValue)
		 		setState(361)
		 		try sumExpr(0)

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(362)
		 		try match(BQLParser.Tokens.MATCHES.rawValue)
		 		setState(363)
		 		try sumExpr(0)

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(364)
		 		try match(BQLParser.Tokens.IS.rawValue)
		 		setState(365)
		 		try match(BQLParser.Tokens.NULL.rawValue)

		 		break
		 	case 13:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(366)
		 		try match(BQLParser.Tokens.IS.rawValue)
		 		setState(367)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(368)
		 		try match(BQLParser.Tokens.NULL.rawValue)

		 		break
		 	case 14:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(369)
		 		try match(BQLParser.Tokens.BETWEEN.rawValue)
		 		setState(370)
		 		try sumExpr(0)
		 		setState(371)
		 		try match(BQLParser.Tokens.AND.rawValue)
		 		setState(372)
		 		try sumExpr(0)

		 		break
		 	case 15:
		 		try enterOuterAlt(_localctx, 15)
		 		setState(374)
		 		try anyAllOp()
		 		setState(375)
		 		try match(BQLParser.Tokens.ANY.rawValue)
		 		setState(376)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(377)
		 		try expression()
		 		setState(378)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	case 16:
		 		try enterOuterAlt(_localctx, 16)
		 		setState(380)
		 		try anyAllOp()
		 		setState(381)
		 		try match(BQLParser.Tokens.ALL.rawValue)
		 		setState(382)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(383)
		 		try expression()
		 		setState(384)
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
		 	setState(388)
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
			setState(391)
			try termExpr(0)

			_ctx!.stop = try _input.LT(-1)
			setState(401)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,43,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(399)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,42, _ctx)) {
					case 1:
						_localctx = SumExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_sumExpr)
						setState(393)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(394)
						try match(BQLParser.Tokens.PLUS.rawValue)
						setState(395)
						try termExpr(0)

						break
					case 2:
						_localctx = SumExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_sumExpr)
						setState(396)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(397)
						try match(BQLParser.Tokens.MINUS.rawValue)
						setState(398)
						try termExpr(0)

						break
					default: break
					}
			 
				}
				setState(403)
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
			setState(405)
			try factorExpr()

			_ctx!.stop = try _input.LT(-1)
			setState(418)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,45,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(416)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,44, _ctx)) {
					case 1:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(407)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(408)
						try match(BQLParser.Tokens.STAR.rawValue)
						setState(409)
						try factorExpr()

						break
					case 2:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(410)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(411)
						try match(BQLParser.Tokens.SLASH.rawValue)
						setState(412)
						try factorExpr()

						break
					case 3:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(413)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(414)
						try match(BQLParser.Tokens.PERCENT.rawValue)
						setState(415)
						try factorExpr()

						break
					default: break
					}
			 
				}
				setState(420)
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
		 	setState(426)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,46, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(421)
		 		try unaryExpr()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(422)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(423)
		 		try expression()
		 		setState(424)
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
		 	setState(433)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .PLUS:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(428)
		 		try match(BQLParser.Tokens.PLUS.rawValue)
		 		setState(429)
		 		try atomExpr()

		 		break

		 	case .MINUS:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(430)
		 		try match(BQLParser.Tokens.MINUS.rawValue)
		 		setState(431)
		 		try factorExpr()

		 		break
		 	case .SELECT:fallthrough
		 	case .NULL:fallthrough
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .OPEN:fallthrough
		 	case .CLOSE:fallthrough
		 	case .CLEAR:fallthrough
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
		 		setState(432)
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
			func contextualKeyword() -> ContextualKeywordContext? {
				return getRuleContext(ContextualKeywordContext.self, 0)
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
			setState(436)
			try atomExpr()

			_ctx!.stop = try _input.LT(-1)
			setState(451)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,50,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(449)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,49, _ctx)) {
					case 1:
						_localctx = PrimaryExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_primaryExpr)
						setState(438)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(439)
						try match(BQLParser.Tokens.DOT.rawValue)
						setState(442)
						try _errHandler.sync(self)
						switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
						case .DOUBLE_QUOTED_TEXT:fallthrough
						case .IDENTIFIER:
							setState(440)
							try identifier()

							break
						case .OPEN:fallthrough
						case .CLOSE:fallthrough
						case .CLEAR:
							setState(441)
							try contextualKeyword()

							break
						default:
							throw ANTLRException.recognition(e: NoViableAltException(self))
						}

						break
					case 2:
						_localctx = PrimaryExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_primaryExpr)
						setState(444)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(445)
						try match(BQLParser.Tokens.LBRACK.rawValue)
						setState(446)
						try stringLiteral()
						setState(447)
						try match(BQLParser.Tokens.RBRACK.rawValue)

						break
					default: break
					}
			 
				}
				setState(453)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,50,_ctx)
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
		 	setState(459)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,51, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(454)
		 		try selectStmt()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(455)
		 		try functionCall()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(456)
		 		try constant()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(457)
		 		try columnRef()

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(458)
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
		 	setState(466)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .POSITIONAL_PLACEHOLDER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(461)
		 		try match(BQLParser.Tokens.POSITIONAL_PLACEHOLDER.rawValue)

		 		break

		 	case .NAMED_PLACEHOLDER_START:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(462)
		 		try match(BQLParser.Tokens.NAMED_PLACEHOLDER_START.rawValue)
		 		setState(463)
		 		try identifier()
		 		setState(464)
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
		 	setState(480)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,54, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(468)
		 		try identifier()
		 		setState(469)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(470)
		 		try asterisk()
		 		setState(471)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(473)
		 		try identifier()
		 		setState(474)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(476)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -269793739037794302) != 0)) {
		 			setState(475)
		 			try expressionList()

		 		}

		 		setState(478)
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
		 	setState(482)
		 	try expression()
		 	setState(487)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (_la == BQLParser.Tokens.COMMA.rawValue) {
		 		setState(483)
		 		try match(BQLParser.Tokens.COMMA.rawValue)
		 		setState(484)
		 		try expression()


		 		setState(489)
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
			internal
			func contextualKeyword() -> ContextualKeywordContext? {
				return getRuleContext(ContextualKeywordContext.self, 0)
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
		 	setState(492)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(490)
		 		try identifier()

		 		break
		 	case .OPEN:fallthrough
		 	case .CLOSE:fallthrough
		 	case .CLEAR:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(491)
		 		try contextualKeyword()

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

	internal class ContextualKeywordContext: ParserRuleContext {
			internal
			func OPEN() -> TerminalNode? {
				return getToken(BQLParser.Tokens.OPEN.rawValue, 0)
			}
			internal
			func CLOSE() -> TerminalNode? {
				return getToken(BQLParser.Tokens.CLOSE.rawValue, 0)
			}
			internal
			func CLEAR() -> TerminalNode? {
				return getToken(BQLParser.Tokens.CLEAR.rawValue, 0)
			}
		override internal
		func getRuleIndex() -> Int {
			return BQLParser.RULE_contextualKeyword
		}
		override internal
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? BQLParserVisitor {
			    return visitor.visitContextualKeyword(self)
			}
			else if let visitor = visitor as? BQLParserBaseVisitor {
			    return visitor.visitContextualKeyword(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 internal func contextualKeyword() throws -> ContextualKeywordContext {
		var _localctx: ContextualKeywordContext
		_localctx = ContextualKeywordContext(_ctx, getState())
		try enterRule(_localctx, 90, BQLParser.RULE_contextualKeyword)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(494)
		 	_la = try _input.LA(1)
		 	if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 369098752) != 0))) {
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
		try enterRule(_localctx, 92, BQLParser.RULE_constant)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(498)
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
		 		setState(496)
		 		try literal()

		 		break

		 	case .LPAREN:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(497)
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
		try enterRule(_localctx, 94, BQLParser.RULE_literal)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(506)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .DATE_LITERAL:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(500)
		 		try dateLiteral()

		 		break

		 	case .DECIMAL:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(501)
		 		try decimalLiteral()

		 		break

		 	case .INTEGER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(502)
		 		try integerLiteral()

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(503)
		 		try stringLiteral()

		 		break

		 	case .NULL:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(504)
		 		try nullLiteral()

		 		break
		 	case .TRUE:fallthrough
		 	case .FALSE:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(505)
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
		try enterRule(_localctx, 96, BQLParser.RULE_listLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(508)
		 	try match(BQLParser.Tokens.LPAREN.rawValue)
		 	setState(509)
		 	try literal()
		 	setState(510)
		 	try match(BQLParser.Tokens.COMMA.rawValue)
		 	setState(522)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 8935141660703522816) != 0)) {
		 		setState(511)
		 		try literal()
		 		setState(516)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,59,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(512)
		 				try match(BQLParser.Tokens.COMMA.rawValue)
		 				setState(513)
		 				try literal()

		 		 
		 			}
		 			setState(518)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,59,_ctx)
		 		}
		 		setState(520)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (_la == BQLParser.Tokens.COMMA.rawValue) {
		 			setState(519)
		 			try match(BQLParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(524)
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
		try enterRule(_localctx, 98, BQLParser.RULE_identifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(526)
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
		try enterRule(_localctx, 100, BQLParser.RULE_stringLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(528)
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
		try enterRule(_localctx, 102, BQLParser.RULE_booleanLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(530)
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
		try enterRule(_localctx, 104, BQLParser.RULE_nullLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(532)
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
		try enterRule(_localctx, 106, BQLParser.RULE_integerLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(534)
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
		try enterRule(_localctx, 108, BQLParser.RULE_decimalLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(536)
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
		try enterRule(_localctx, 110, BQLParser.RULE_dateLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(538)
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
		4,1,66,541,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,
		7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,14,7,14,
		2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,2,20,7,20,2,21,7,21,
		2,22,7,22,2,23,7,23,2,24,7,24,2,25,7,25,2,26,7,26,2,27,7,27,2,28,7,28,
		2,29,7,29,2,30,7,30,2,31,7,31,2,32,7,32,2,33,7,33,2,34,7,34,2,35,7,35,
		2,36,7,36,2,37,7,37,2,38,7,38,2,39,7,39,2,40,7,40,2,41,7,41,2,42,7,42,
		2,43,7,43,2,44,7,44,2,45,7,45,2,46,7,46,2,47,7,47,2,48,7,48,2,49,7,49,
		2,50,7,50,2,51,7,51,2,52,7,52,2,53,7,53,2,54,7,54,2,55,7,55,1,0,1,0,1,
		0,1,1,1,1,1,1,1,1,3,1,120,8,1,1,2,1,2,3,2,124,8,2,1,2,1,2,3,2,128,8,2,
		1,2,3,2,131,8,2,1,2,3,2,134,8,2,1,2,3,2,137,8,2,1,2,3,2,140,8,2,1,2,3,
		2,143,8,2,1,3,1,3,1,4,1,4,1,4,5,4,150,8,4,10,4,12,4,153,9,4,1,4,3,4,156,
		8,4,1,5,1,5,1,6,1,6,1,6,3,6,163,8,6,1,7,1,7,1,7,1,7,3,7,169,8,7,1,8,1,
		8,1,8,1,8,1,9,1,9,1,10,1,10,1,10,1,10,1,10,1,10,3,10,183,8,10,1,11,1,11,
		1,11,1,11,1,11,1,11,3,11,191,8,11,3,11,193,8,11,1,11,3,11,196,8,11,1,11,
		1,11,1,11,3,11,201,8,11,1,11,3,11,204,8,11,1,11,1,11,1,11,1,11,1,11,3,
		11,211,8,11,1,11,1,11,1,11,3,11,216,8,11,3,11,218,8,11,1,11,3,11,221,8,
		11,3,11,223,8,11,1,12,1,12,1,13,1,13,1,13,1,14,1,14,1,14,1,14,1,14,5,14,
		235,8,14,10,14,12,14,238,9,14,1,14,1,14,3,14,242,8,14,1,15,1,15,3,15,246,
		8,15,1,16,1,16,1,16,1,16,1,16,5,16,253,8,16,10,16,12,16,256,9,16,1,17,
		1,17,3,17,260,8,17,1,17,3,17,263,8,17,1,18,1,18,1,19,1,19,1,19,1,20,1,
		20,1,20,1,20,1,20,1,20,1,21,1,21,3,21,278,8,21,1,22,1,22,1,22,3,22,283,
		8,22,1,22,3,22,286,8,22,1,22,3,22,289,8,22,1,23,1,23,1,23,1,24,1,24,3,
		24,296,8,24,1,24,1,24,3,24,300,8,24,1,24,3,24,303,8,24,1,25,1,25,1,25,
		1,26,1,26,3,26,310,8,26,1,27,1,27,1,27,1,28,1,28,1,29,1,29,1,29,5,29,320,
		8,29,10,29,12,29,323,9,29,1,30,1,30,1,30,5,30,328,8,30,10,30,12,30,331,
		9,30,1,31,1,31,1,31,3,31,336,8,31,1,32,1,32,3,32,340,8,32,1,33,1,33,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,
		33,3,33,387,8,33,1,34,1,34,1,35,1,35,1,35,1,35,1,35,1,35,1,35,1,35,1,35,
		5,35,400,8,35,10,35,12,35,403,9,35,1,36,1,36,1,36,1,36,1,36,1,36,1,36,
		1,36,1,36,1,36,1,36,1,36,5,36,417,8,36,10,36,12,36,420,9,36,1,37,1,37,
		1,37,1,37,1,37,3,37,427,8,37,1,38,1,38,1,38,1,38,1,38,3,38,434,8,38,1,
		39,1,39,1,39,1,39,1,39,1,39,1,39,3,39,443,8,39,1,39,1,39,1,39,1,39,1,39,
		5,39,450,8,39,10,39,12,39,453,9,39,1,40,1,40,1,40,1,40,1,40,3,40,460,8,
		40,1,41,1,41,1,41,1,41,1,41,3,41,467,8,41,1,42,1,42,1,42,1,42,1,42,1,42,
		1,42,1,42,3,42,477,8,42,1,42,1,42,3,42,481,8,42,1,43,1,43,1,43,5,43,486,
		8,43,10,43,12,43,489,9,43,1,44,1,44,3,44,493,8,44,1,45,1,45,1,46,1,46,
		3,46,499,8,46,1,47,1,47,1,47,1,47,1,47,1,47,3,47,507,8,47,1,48,1,48,1,
		48,1,48,1,48,1,48,5,48,515,8,48,10,48,12,48,518,9,48,1,48,3,48,521,8,48,
		3,48,523,8,48,1,48,1,48,1,49,1,49,1,50,1,50,1,51,1,51,1,52,1,52,1,53,1,
		53,1,54,1,54,1,55,1,55,1,55,0,3,70,72,78,56,0,2,4,6,8,10,12,14,16,18,20,
		22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,
		70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,0,
		6,1,0,31,32,2,0,36,40,43,46,2,0,25,26,28,28,2,0,61,61,63,63,1,0,61,62,
		1,0,17,18,578,0,112,1,0,0,0,2,119,1,0,0,0,4,121,1,0,0,0,6,144,1,0,0,0,
		8,155,1,0,0,0,10,157,1,0,0,0,12,159,1,0,0,0,14,164,1,0,0,0,16,170,1,0,
		0,0,18,174,1,0,0,0,20,182,1,0,0,0,22,222,1,0,0,0,24,224,1,0,0,0,26,226,
		1,0,0,0,28,229,1,0,0,0,30,245,1,0,0,0,32,247,1,0,0,0,34,259,1,0,0,0,36,
		264,1,0,0,0,38,266,1,0,0,0,40,269,1,0,0,0,42,277,1,0,0,0,44,279,1,0,0,
		0,46,290,1,0,0,0,48,293,1,0,0,0,50,304,1,0,0,0,52,307,1,0,0,0,54,311,1,
		0,0,0,56,314,1,0,0,0,58,316,1,0,0,0,60,324,1,0,0,0,62,335,1,0,0,0,64,337,
		1,0,0,0,66,386,1,0,0,0,68,388,1,0,0,0,70,390,1,0,0,0,72,404,1,0,0,0,74,
		426,1,0,0,0,76,433,1,0,0,0,78,435,1,0,0,0,80,459,1,0,0,0,82,466,1,0,0,
		0,84,480,1,0,0,0,86,482,1,0,0,0,88,492,1,0,0,0,90,494,1,0,0,0,92,498,1,
		0,0,0,94,506,1,0,0,0,96,508,1,0,0,0,98,526,1,0,0,0,100,528,1,0,0,0,102,
		530,1,0,0,0,104,532,1,0,0,0,106,534,1,0,0,0,108,536,1,0,0,0,110,538,1,
		0,0,0,112,113,3,2,1,0,113,114,5,0,0,1,114,1,1,0,0,0,115,120,3,4,2,0,116,
		120,3,44,22,0,117,120,3,48,24,0,118,120,3,52,26,0,119,115,1,0,0,0,119,
		116,1,0,0,0,119,117,1,0,0,0,119,118,1,0,0,0,120,3,1,0,0,0,121,123,5,1,
		0,0,122,124,3,6,3,0,123,122,1,0,0,0,123,124,1,0,0,0,124,125,1,0,0,0,125,
		127,3,8,4,0,126,128,3,14,7,0,127,126,1,0,0,0,127,128,1,0,0,0,128,130,1,
		0,0,0,129,131,3,26,13,0,130,129,1,0,0,0,130,131,1,0,0,0,131,133,1,0,0,
		0,132,134,3,28,14,0,133,132,1,0,0,0,133,134,1,0,0,0,134,136,1,0,0,0,135,
		137,3,32,16,0,136,135,1,0,0,0,136,137,1,0,0,0,137,139,1,0,0,0,138,140,
		3,40,20,0,139,138,1,0,0,0,139,140,1,0,0,0,140,142,1,0,0,0,141,143,3,38,
		19,0,142,141,1,0,0,0,142,143,1,0,0,0,143,5,1,0,0,0,144,145,5,2,0,0,145,
		7,1,0,0,0,146,151,3,12,6,0,147,148,5,53,0,0,148,150,3,12,6,0,149,147,1,
		0,0,0,150,153,1,0,0,0,151,149,1,0,0,0,151,152,1,0,0,0,152,156,1,0,0,0,
		153,151,1,0,0,0,154,156,3,10,5,0,155,146,1,0,0,0,155,154,1,0,0,0,156,9,
		1,0,0,0,157,158,5,49,0,0,158,11,1,0,0,0,159,162,3,56,28,0,160,161,5,10,
		0,0,161,163,3,98,49,0,162,160,1,0,0,0,162,163,1,0,0,0,163,13,1,0,0,0,164,
		168,5,3,0,0,165,169,3,18,9,0,166,169,3,16,8,0,167,169,3,22,11,0,168,165,
		1,0,0,0,168,166,1,0,0,0,168,167,1,0,0,0,169,15,1,0,0,0,170,171,5,54,0,
		0,171,172,3,4,2,0,172,173,5,55,0,0,173,17,1,0,0,0,174,175,3,20,10,0,175,
		19,1,0,0,0,176,183,5,41,0,0,177,183,5,42,0,0,178,183,3,98,49,0,179,183,
		5,20,0,0,180,183,5,21,0,0,181,183,5,22,0,0,182,176,1,0,0,0,182,177,1,0,
		0,0,182,178,1,0,0,0,182,179,1,0,0,0,182,180,1,0,0,0,182,181,1,0,0,0,183,
		21,1,0,0,0,184,185,5,25,0,0,185,186,5,27,0,0,186,192,3,110,55,0,187,190,
		5,26,0,0,188,189,5,27,0,0,189,191,3,110,55,0,190,188,1,0,0,0,190,191,1,
		0,0,0,191,193,1,0,0,0,192,187,1,0,0,0,192,193,1,0,0,0,193,195,1,0,0,0,
		194,196,3,24,12,0,195,194,1,0,0,0,195,196,1,0,0,0,196,223,1,0,0,0,197,
		200,5,26,0,0,198,199,5,27,0,0,199,201,3,110,55,0,200,198,1,0,0,0,200,201,
		1,0,0,0,201,203,1,0,0,0,202,204,3,24,12,0,203,202,1,0,0,0,203,204,1,0,
		0,0,204,223,1,0,0,0,205,223,5,28,0,0,206,210,3,56,28,0,207,208,5,25,0,
		0,208,209,5,27,0,0,209,211,3,110,55,0,210,207,1,0,0,0,210,211,1,0,0,0,
		211,217,1,0,0,0,212,215,5,26,0,0,213,214,5,27,0,0,214,216,3,110,55,0,215,
		213,1,0,0,0,215,216,1,0,0,0,216,218,1,0,0,0,217,212,1,0,0,0,217,218,1,
		0,0,0,218,220,1,0,0,0,219,221,3,24,12,0,220,219,1,0,0,0,220,221,1,0,0,
		0,221,223,1,0,0,0,222,184,1,0,0,0,222,197,1,0,0,0,222,205,1,0,0,0,222,
		206,1,0,0,0,223,23,1,0,0,0,224,225,5,28,0,0,225,25,1,0,0,0,226,227,5,4,
		0,0,227,228,3,56,28,0,228,27,1,0,0,0,229,230,5,5,0,0,230,231,5,6,0,0,231,
		236,3,30,15,0,232,233,5,53,0,0,233,235,3,30,15,0,234,232,1,0,0,0,235,238,
		1,0,0,0,236,234,1,0,0,0,236,237,1,0,0,0,237,241,1,0,0,0,238,236,1,0,0,
		0,239,240,5,7,0,0,240,242,3,56,28,0,241,239,1,0,0,0,241,242,1,0,0,0,242,
		29,1,0,0,0,243,246,3,106,53,0,244,246,3,56,28,0,245,243,1,0,0,0,245,244,
		1,0,0,0,246,31,1,0,0,0,247,248,5,8,0,0,248,249,5,6,0,0,249,254,3,34,17,
		0,250,251,5,53,0,0,251,253,3,34,17,0,252,250,1,0,0,0,253,256,1,0,0,0,254,
		252,1,0,0,0,254,255,1,0,0,0,255,33,1,0,0,0,256,254,1,0,0,0,257,260,3,106,
		53,0,258,260,3,56,28,0,259,257,1,0,0,0,259,258,1,0,0,0,260,262,1,0,0,0,
		261,263,3,36,18,0,262,261,1,0,0,0,262,263,1,0,0,0,263,35,1,0,0,0,264,265,
		7,0,0,0,265,37,1,0,0,0,266,267,5,9,0,0,267,268,3,106,53,0,268,39,1,0,0,
		0,269,270,5,23,0,0,270,271,5,6,0,0,271,272,3,42,21,0,272,273,5,53,0,0,
		273,274,3,42,21,0,274,41,1,0,0,0,275,278,3,106,53,0,276,278,3,88,44,0,
		277,275,1,0,0,0,277,276,1,0,0,0,278,43,1,0,0,0,279,282,5,20,0,0,280,281,
		5,24,0,0,281,283,3,98,49,0,282,280,1,0,0,0,282,283,1,0,0,0,283,285,1,0,
		0,0,284,286,3,46,23,0,285,284,1,0,0,0,285,286,1,0,0,0,286,288,1,0,0,0,
		287,289,3,26,13,0,288,287,1,0,0,0,288,289,1,0,0,0,289,45,1,0,0,0,290,291,
		5,3,0,0,291,292,3,22,11,0,292,47,1,0,0,0,293,295,5,21,0,0,294,296,3,100,
		50,0,295,294,1,0,0,0,295,296,1,0,0,0,296,299,1,0,0,0,297,298,5,24,0,0,
		298,300,3,98,49,0,299,297,1,0,0,0,299,300,1,0,0,0,300,302,1,0,0,0,301,
		303,3,50,25,0,302,301,1,0,0,0,302,303,1,0,0,0,303,49,1,0,0,0,304,305,5,
		3,0,0,305,306,3,22,11,0,306,51,1,0,0,0,307,309,5,22,0,0,308,310,3,54,27,
		0,309,308,1,0,0,0,309,310,1,0,0,0,310,53,1,0,0,0,311,312,5,3,0,0,312,313,
		3,22,11,0,313,55,1,0,0,0,314,315,3,58,29,0,315,57,1,0,0,0,316,321,3,60,
		30,0,317,318,5,12,0,0,318,320,3,60,30,0,319,317,1,0,0,0,320,323,1,0,0,
		0,321,319,1,0,0,0,321,322,1,0,0,0,322,59,1,0,0,0,323,321,1,0,0,0,324,329,
		3,62,31,0,325,326,5,11,0,0,326,328,3,62,31,0,327,325,1,0,0,0,328,331,1,
		0,0,0,329,327,1,0,0,0,329,330,1,0,0,0,330,61,1,0,0,0,331,329,1,0,0,0,332,
		333,5,13,0,0,333,336,3,62,31,0,334,336,3,64,32,0,335,332,1,0,0,0,335,334,
		1,0,0,0,336,63,1,0,0,0,337,339,3,70,35,0,338,340,3,66,33,0,339,338,1,0,
		0,0,339,340,1,0,0,0,340,65,1,0,0,0,341,342,5,44,0,0,342,387,3,70,35,0,
		343,344,5,39,0,0,344,387,3,70,35,0,345,346,5,45,0,0,346,387,3,70,35,0,
		347,348,5,40,0,0,348,387,3,70,35,0,349,350,5,43,0,0,350,387,3,70,35,0,
		351,352,5,38,0,0,352,387,3,70,35,0,353,354,5,14,0,0,354,387,3,70,35,0,
		355,356,5,13,0,0,356,357,5,14,0,0,357,387,3,70,35,0,358,359,5,46,0,0,359,
		387,3,70,35,0,360,361,5,36,0,0,361,387,3,70,35,0,362,363,5,37,0,0,363,
		387,3,70,35,0,364,365,5,15,0,0,365,387,5,16,0,0,366,367,5,15,0,0,367,368,
		5,13,0,0,368,387,5,16,0,0,369,370,5,19,0,0,370,371,3,70,35,0,371,372,5,
		11,0,0,372,373,3,70,35,0,373,387,1,0,0,0,374,375,3,68,34,0,375,376,5,29,
		0,0,376,377,5,54,0,0,377,378,3,56,28,0,378,379,5,55,0,0,379,387,1,0,0,
		0,380,381,3,68,34,0,381,382,5,30,0,0,382,383,5,54,0,0,383,384,3,56,28,
		0,384,385,5,55,0,0,385,387,1,0,0,0,386,341,1,0,0,0,386,343,1,0,0,0,386,
		345,1,0,0,0,386,347,1,0,0,0,386,349,1,0,0,0,386,351,1,0,0,0,386,353,1,
		0,0,0,386,355,1,0,0,0,386,358,1,0,0,0,386,360,1,0,0,0,386,362,1,0,0,0,
		386,364,1,0,0,0,386,366,1,0,0,0,386,369,1,0,0,0,386,374,1,0,0,0,386,380,
		1,0,0,0,387,67,1,0,0,0,388,389,7,1,0,0,389,69,1,0,0,0,390,391,6,35,-1,
		0,391,392,3,72,36,0,392,401,1,0,0,0,393,394,10,3,0,0,394,395,5,47,0,0,
		395,400,3,72,36,0,396,397,10,2,0,0,397,398,5,48,0,0,398,400,3,72,36,0,
		399,393,1,0,0,0,399,396,1,0,0,0,400,403,1,0,0,0,401,399,1,0,0,0,401,402,
		1,0,0,0,402,71,1,0,0,0,403,401,1,0,0,0,404,405,6,36,-1,0,405,406,3,74,
		37,0,406,418,1,0,0,0,407,408,10,4,0,0,408,409,5,49,0,0,409,417,3,74,37,
		0,410,411,10,3,0,0,411,412,5,50,0,0,412,417,3,74,37,0,413,414,10,2,0,0,
		414,415,5,51,0,0,415,417,3,74,37,0,416,407,1,0,0,0,416,410,1,0,0,0,416,
		413,1,0,0,0,417,420,1,0,0,0,418,416,1,0,0,0,418,419,1,0,0,0,419,73,1,0,
		0,0,420,418,1,0,0,0,421,427,3,76,38,0,422,423,5,54,0,0,423,424,3,56,28,
		0,424,425,5,55,0,0,425,427,1,0,0,0,426,421,1,0,0,0,426,422,1,0,0,0,427,
		75,1,0,0,0,428,429,5,47,0,0,429,434,3,80,40,0,430,431,5,48,0,0,431,434,
		3,74,37,0,432,434,3,78,39,0,433,428,1,0,0,0,433,430,1,0,0,0,433,432,1,
		0,0,0,434,77,1,0,0,0,435,436,6,39,-1,0,436,437,3,80,40,0,437,451,1,0,0,
		0,438,439,10,3,0,0,439,442,5,52,0,0,440,443,3,98,49,0,441,443,3,90,45,
		0,442,440,1,0,0,0,442,441,1,0,0,0,443,450,1,0,0,0,444,445,10,2,0,0,445,
		446,5,56,0,0,446,447,3,100,50,0,447,448,5,57,0,0,448,450,1,0,0,0,449,438,
		1,0,0,0,449,444,1,0,0,0,450,453,1,0,0,0,451,449,1,0,0,0,451,452,1,0,0,
		0,452,79,1,0,0,0,453,451,1,0,0,0,454,460,3,4,2,0,455,460,3,84,42,0,456,
		460,3,92,46,0,457,460,3,88,44,0,458,460,3,82,41,0,459,454,1,0,0,0,459,
		455,1,0,0,0,459,456,1,0,0,0,459,457,1,0,0,0,459,458,1,0,0,0,460,81,1,0,
		0,0,461,467,5,33,0,0,462,463,5,34,0,0,463,464,3,98,49,0,464,465,5,35,0,
		0,465,467,1,0,0,0,466,461,1,0,0,0,466,462,1,0,0,0,467,83,1,0,0,0,468,469,
		3,98,49,0,469,470,5,54,0,0,470,471,3,10,5,0,471,472,5,55,0,0,472,481,1,
		0,0,0,473,474,3,98,49,0,474,476,5,54,0,0,475,477,3,86,43,0,476,475,1,0,
		0,0,476,477,1,0,0,0,477,478,1,0,0,0,478,479,5,55,0,0,479,481,1,0,0,0,480,
		468,1,0,0,0,480,473,1,0,0,0,481,85,1,0,0,0,482,487,3,56,28,0,483,484,5,
		53,0,0,484,486,3,56,28,0,485,483,1,0,0,0,486,489,1,0,0,0,487,485,1,0,0,
		0,487,488,1,0,0,0,488,87,1,0,0,0,489,487,1,0,0,0,490,493,3,98,49,0,491,
		493,3,90,45,0,492,490,1,0,0,0,492,491,1,0,0,0,493,89,1,0,0,0,494,495,7,
		2,0,0,495,91,1,0,0,0,496,499,3,94,47,0,497,499,3,96,48,0,498,496,1,0,0,
		0,498,497,1,0,0,0,499,93,1,0,0,0,500,507,3,110,55,0,501,507,3,108,54,0,
		502,507,3,106,53,0,503,507,3,100,50,0,504,507,3,104,52,0,505,507,3,102,
		51,0,506,500,1,0,0,0,506,501,1,0,0,0,506,502,1,0,0,0,506,503,1,0,0,0,506,
		504,1,0,0,0,506,505,1,0,0,0,507,95,1,0,0,0,508,509,5,54,0,0,509,510,3,
		94,47,0,510,522,5,53,0,0,511,516,3,94,47,0,512,513,5,53,0,0,513,515,3,
		94,47,0,514,512,1,0,0,0,515,518,1,0,0,0,516,514,1,0,0,0,516,517,1,0,0,
		0,517,520,1,0,0,0,518,516,1,0,0,0,519,521,5,53,0,0,520,519,1,0,0,0,520,
		521,1,0,0,0,521,523,1,0,0,0,522,511,1,0,0,0,522,523,1,0,0,0,523,524,1,
		0,0,0,524,525,5,55,0,0,525,97,1,0,0,0,526,527,7,3,0,0,527,99,1,0,0,0,528,
		529,7,4,0,0,529,101,1,0,0,0,530,531,7,5,0,0,531,103,1,0,0,0,532,533,5,
		16,0,0,533,105,1,0,0,0,534,535,5,60,0,0,535,107,1,0,0,0,536,537,5,59,0,
		0,537,109,1,0,0,0,538,539,5,58,0,0,539,111,1,0,0,0,62,119,123,127,130,
		133,136,139,142,151,155,162,168,182,190,192,195,200,203,210,215,217,220,
		222,236,241,245,254,259,262,277,282,285,288,295,299,302,309,321,329,335,
		339,386,399,401,416,418,426,433,442,449,451,459,466,476,480,487,492,498,
		506,516,520,522
	]

	internal
	static let _ATN = try! ATNDeserializer().deserialize(_serializedATN)
}