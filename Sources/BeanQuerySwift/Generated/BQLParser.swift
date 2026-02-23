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
                 FALSE = 18, BETWEEN = 19, BALANCES = 20, AT = 21, OPEN = 22, 
                 CLOSE = 23, ON = 24, CLEAR = 25, ANY = 26, ALL = 27, ASC = 28, 
                 DESC = 29, POSITIONAL_PLACEHOLDER = 30, NAMED_PLACEHOLDER_START = 31, 
                 NAMED_PLACEHOLDER_END = 32, NOT_MATCH = 33, MATCHES = 34, 
                 NEQ = 35, LTE = 36, GTE = 37, HASH_TABLE = 38, HASH_EMPTY = 39, 
                 EQ = 40, LT = 41, GT = 42, MATCH = 43, PLUS = 44, MINUS = 45, 
                 STAR = 46, SLASH = 47, PERCENT = 48, DOT = 49, COMMA = 50, 
                 LPAREN = 51, RPAREN = 52, LBRACK = 53, RBRACK = 54, DATE_LITERAL = 55, 
                 DECIMAL = 56, INTEGER = 57, DOUBLE_QUOTED_TEXT = 58, SINGLE_QUOTED_STRING = 59, 
                 IDENTIFIER = 60, BLOCK_COMMENT = 61, LINE_COMMENT = 62, 
                 WS = 63
	}

	internal
	static let RULE_bql = 0, RULE_statement = 1, RULE_selectStmt = 2, RULE_distinctClause = 3, 
            RULE_targets = 4, RULE_asterisk = 5, RULE_target = 6, RULE_fromClause = 7, 
            RULE_subselect = 8, RULE_tableRef = 9, RULE_tableName = 10, 
            RULE_fromExpr = 11, RULE_clearClause = 12, RULE_whereClause = 13, 
            RULE_groupByClause = 14, RULE_groupItem = 15, RULE_orderByClause = 16, 
            RULE_orderItem = 17, RULE_ordering = 18, RULE_limitClause = 19, 
            RULE_balancesStmt = 20, RULE_balancesFromClause = 21, RULE_expression = 22, 
            RULE_disjunction = 23, RULE_conjunction = 24, RULE_inversion = 25, 
            RULE_comparison = 26, RULE_comparisonSuffix = 27, RULE_anyAllOp = 28, 
            RULE_sumExpr = 29, RULE_termExpr = 30, RULE_factorExpr = 31, 
            RULE_unaryExpr = 32, RULE_primaryExpr = 33, RULE_atomExpr = 34, 
            RULE_placeholder = 35, RULE_functionCall = 36, RULE_expressionList = 37, 
            RULE_columnRef = 38, RULE_constant = 39, RULE_literal = 40, 
            RULE_listLiteral = 41, RULE_identifier = 42, RULE_stringLiteral = 43, 
            RULE_booleanLiteral = 44, RULE_nullLiteral = 45, RULE_integerLiteral = 46, 
            RULE_decimalLiteral = 47, RULE_dateLiteral = 48

	internal
	static let ruleNames: [String] = [
		"bql", "statement", "selectStmt", "distinctClause", "targets", "asterisk", 
		"target", "fromClause", "subselect", "tableRef", "tableName", "fromExpr", 
		"clearClause", "whereClause", "groupByClause", "groupItem", "orderByClause", 
		"orderItem", "ordering", "limitClause", "balancesStmt", "balancesFromClause", 
		"expression", "disjunction", "conjunction", "inversion", "comparison", 
		"comparisonSuffix", "anyAllOp", "sumExpr", "termExpr", "factorExpr", "unaryExpr", 
		"primaryExpr", "atomExpr", "placeholder", "functionCall", "expressionList", 
		"columnRef", "constant", "literal", "listLiteral", "identifier", "stringLiteral", 
		"booleanLiteral", "nullLiteral", "integerLiteral", "decimalLiteral", "dateLiteral"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'SELECT'", "'DISTINCT'", "'FROM'", "'WHERE'", "'GROUP'", "'BY'", 
		"'HAVING'", "'ORDER'", "'LIMIT'", "'AS'", "'AND'", "'OR'", "'NOT'", "'IN'", 
		"'IS'", "'NULL'", "'TRUE'", "'FALSE'", "'BETWEEN'", "'BALANCES'", "'AT'", 
		"'OPEN'", "'CLOSE'", "'ON'", "'CLEAR'", "'ANY'", "'ALL'", "'ASC'", "'DESC'", 
		"'%s'", "'%('", "')s'", "'!~'", "'?~'", "'!='", "'<='", "'>='", nil, "'#'", 
		"'='", "'<'", "'>'", "'~'", "'+'", "'-'", "'*'", "'/'", "'%'", "'.'", 
		"','", "'('", "')'", "'['", "']'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, "SELECT", "DISTINCT", "FROM", "WHERE", "GROUP", "BY", "HAVING", "ORDER", 
		"LIMIT", "AS", "AND", "OR", "NOT", "IN", "IS", "NULL", "TRUE", "FALSE", 
		"BETWEEN", "BALANCES", "AT", "OPEN", "CLOSE", "ON", "CLEAR", "ANY", "ALL", 
		"ASC", "DESC", "POSITIONAL_PLACEHOLDER", "NAMED_PLACEHOLDER_START", "NAMED_PLACEHOLDER_END", 
		"NOT_MATCH", "MATCHES", "NEQ", "LTE", "GTE", "HASH_TABLE", "HASH_EMPTY", 
		"EQ", "LT", "GT", "MATCH", "PLUS", "MINUS", "STAR", "SLASH", "PERCENT", 
		"DOT", "COMMA", "LPAREN", "RPAREN", "LBRACK", "RBRACK", "DATE_LITERAL", 
		"DECIMAL", "INTEGER", "DOUBLE_QUOTED_TEXT", "SINGLE_QUOTED_STRING", "IDENTIFIER", 
		"BLOCK_COMMENT", "LINE_COMMENT", "WS"
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
		 	setState(98)
		 	try statement()
		 	setState(99)
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
		 	setState(103)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .SELECT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(101)
		 		try selectStmt()

		 		break

		 	case .BALANCES:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(102)
		 		try balancesStmt()

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
		 	setState(105)
		 	try match(BQLParser.Tokens.SELECT.rawValue)
		 	setState(107)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.DISTINCT.rawValue) {
		 		setState(106)
		 		try distinctClause()

		 	}

		 	setState(109)
		 	try targets()
		 	setState(111)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,2,_ctx)) {
		 	case 1:
		 		setState(110)
		 		try fromClause()

		 		break
		 	default: break
		 	}
		 	setState(114)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,3,_ctx)) {
		 	case 1:
		 		setState(113)
		 		try whereClause()

		 		break
		 	default: break
		 	}
		 	setState(117)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,4,_ctx)) {
		 	case 1:
		 		setState(116)
		 		try groupByClause()

		 		break
		 	default: break
		 	}
		 	setState(120)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,5,_ctx)) {
		 	case 1:
		 		setState(119)
		 		try orderByClause()

		 		break
		 	default: break
		 	}
		 	setState(123)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,6,_ctx)) {
		 	case 1:
		 		setState(122)
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
		 	setState(125)
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
		 	setState(136)
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
		 		setState(127)
		 		try target()
		 		setState(132)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,7,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(128)
		 				try match(BQLParser.Tokens.COMMA.rawValue)
		 				setState(129)
		 				try target()

		 		 
		 			}
		 			setState(134)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,7,_ctx)
		 		}

		 		break

		 	case .STAR:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(135)
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
		 	setState(138)
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
		 	setState(140)
		 	try expression()
		 	setState(143)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,9,_ctx)) {
		 	case 1:
		 		setState(141)
		 		try match(BQLParser.Tokens.AS.rawValue)
		 		setState(142)
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
		 	setState(145)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(149)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,10, _ctx)) {
		 	case 1:
		 		setState(146)
		 		try tableRef()

		 		break
		 	case 2:
		 		setState(147)
		 		try subselect()

		 		break
		 	case 3:
		 		setState(148)
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
		 	setState(151)
		 	try match(BQLParser.Tokens.LPAREN.rawValue)
		 	setState(152)
		 	try selectStmt()
		 	setState(153)
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
		 	setState(155)
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
		 	setState(160)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .HASH_TABLE:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(157)
		 		try match(BQLParser.Tokens.HASH_TABLE.rawValue)

		 		break

		 	case .HASH_EMPTY:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(158)
		 		try match(BQLParser.Tokens.HASH_EMPTY.rawValue)

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(159)
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
		 	setState(200)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .OPEN:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(162)
		 		try match(BQLParser.Tokens.OPEN.rawValue)
		 		setState(163)
		 		try match(BQLParser.Tokens.ON.rawValue)
		 		setState(164)
		 		try dateLiteral()
		 		setState(170)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,13,_ctx)) {
		 		case 1:
		 			setState(165)
		 			try match(BQLParser.Tokens.CLOSE.rawValue)
		 			setState(168)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,12,_ctx)) {
		 			case 1:
		 				setState(166)
		 				try match(BQLParser.Tokens.ON.rawValue)
		 				setState(167)
		 				try dateLiteral()

		 				break
		 			default: break
		 			}

		 			break
		 		default: break
		 		}
		 		setState(173)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,14,_ctx)) {
		 		case 1:
		 			setState(172)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break

		 	case .CLOSE:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(175)
		 		try match(BQLParser.Tokens.CLOSE.rawValue)
		 		setState(178)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,15,_ctx)) {
		 		case 1:
		 			setState(176)
		 			try match(BQLParser.Tokens.ON.rawValue)
		 			setState(177)
		 			try dateLiteral()

		 			break
		 		default: break
		 		}
		 		setState(181)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,16,_ctx)) {
		 		case 1:
		 			setState(180)
		 			try clearClause()

		 			break
		 		default: break
		 		}

		 		break

		 	case .CLEAR:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(183)
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
		 		setState(184)
		 		try expression()
		 		setState(188)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,17,_ctx)) {
		 		case 1:
		 			setState(185)
		 			try match(BQLParser.Tokens.OPEN.rawValue)
		 			setState(186)
		 			try match(BQLParser.Tokens.ON.rawValue)
		 			setState(187)
		 			try dateLiteral()

		 			break
		 		default: break
		 		}
		 		setState(195)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,19,_ctx)) {
		 		case 1:
		 			setState(190)
		 			try match(BQLParser.Tokens.CLOSE.rawValue)
		 			setState(193)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,18,_ctx)) {
		 			case 1:
		 				setState(191)
		 				try match(BQLParser.Tokens.ON.rawValue)
		 				setState(192)
		 				try dateLiteral()

		 				break
		 			default: break
		 			}

		 			break
		 		default: break
		 		}
		 		setState(198)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,20,_ctx)) {
		 		case 1:
		 			setState(197)
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
		 	setState(202)
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
		 	setState(204)
		 	try match(BQLParser.Tokens.WHERE.rawValue)
		 	setState(205)
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
		 	setState(207)
		 	try match(BQLParser.Tokens.GROUP.rawValue)
		 	setState(208)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(209)
		 	try groupItem()
		 	setState(214)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,22,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(210)
		 			try match(BQLParser.Tokens.COMMA.rawValue)
		 			setState(211)
		 			try groupItem()

		 	 
		 		}
		 		setState(216)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,22,_ctx)
		 	}
		 	setState(219)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,23,_ctx)) {
		 	case 1:
		 		setState(217)
		 		try match(BQLParser.Tokens.HAVING.rawValue)
		 		setState(218)
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
		 	setState(223)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,24, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(221)
		 		try integerLiteral()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(222)
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
		 	setState(225)
		 	try match(BQLParser.Tokens.ORDER.rawValue)
		 	setState(226)
		 	try match(BQLParser.Tokens.BY.rawValue)
		 	setState(227)
		 	try orderItem()
		 	setState(232)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,25,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(228)
		 			try match(BQLParser.Tokens.COMMA.rawValue)
		 			setState(229)
		 			try orderItem()

		 	 
		 		}
		 		setState(234)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,25,_ctx)
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
		 	setState(237)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,26, _ctx)) {
		 	case 1:
		 		setState(235)
		 		try integerLiteral()

		 		break
		 	case 2:
		 		setState(236)
		 		try expression()

		 		break
		 	default: break
		 	}
		 	setState(240)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,27,_ctx)) {
		 	case 1:
		 		setState(239)
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
		 	setState(242)
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
		 	setState(244)
		 	try match(BQLParser.Tokens.LIMIT.rawValue)
		 	setState(245)
		 	try integerLiteral()

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
		try enterRule(_localctx, 40, BQLParser.RULE_balancesStmt)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(247)
		 	try match(BQLParser.Tokens.BALANCES.rawValue)
		 	setState(250)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.AT.rawValue) {
		 		setState(248)
		 		try match(BQLParser.Tokens.AT.rawValue)
		 		setState(249)
		 		try identifier()

		 	}

		 	setState(253)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.FROM.rawValue) {
		 		setState(252)
		 		try balancesFromClause()

		 	}

		 	setState(256)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (_la == BQLParser.Tokens.WHERE.rawValue) {
		 		setState(255)
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
		try enterRule(_localctx, 42, BQLParser.RULE_balancesFromClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(258)
		 	try match(BQLParser.Tokens.FROM.rawValue)
		 	setState(259)
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
		try enterRule(_localctx, 44, BQLParser.RULE_expression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(261)
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
		try enterRule(_localctx, 46, BQLParser.RULE_disjunction)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(263)
		 	try conjunction()
		 	setState(268)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,31,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(264)
		 			try match(BQLParser.Tokens.OR.rawValue)
		 			setState(265)
		 			try conjunction()

		 	 
		 		}
		 		setState(270)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,31,_ctx)
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
		try enterRule(_localctx, 48, BQLParser.RULE_conjunction)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(271)
		 	try inversion()
		 	setState(276)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,32,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(272)
		 			try match(BQLParser.Tokens.AND.rawValue)
		 			setState(273)
		 			try inversion()

		 	 
		 		}
		 		setState(278)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,32,_ctx)
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
		try enterRule(_localctx, 50, BQLParser.RULE_inversion)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(282)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .NOT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(279)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(280)
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
		 		setState(281)
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
		try enterRule(_localctx, 52, BQLParser.RULE_comparison)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(284)
		 	try sumExpr(0)
		 	setState(286)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,34,_ctx)) {
		 	case 1:
		 		setState(285)
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
		try enterRule(_localctx, 54, BQLParser.RULE_comparisonSuffix)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(333)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,35, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(288)
		 		try match(BQLParser.Tokens.LT.rawValue)
		 		setState(289)
		 		try sumExpr(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(290)
		 		try match(BQLParser.Tokens.LTE.rawValue)
		 		setState(291)
		 		try sumExpr(0)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(292)
		 		try match(BQLParser.Tokens.GT.rawValue)
		 		setState(293)
		 		try sumExpr(0)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(294)
		 		try match(BQLParser.Tokens.GTE.rawValue)
		 		setState(295)
		 		try sumExpr(0)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(296)
		 		try match(BQLParser.Tokens.EQ.rawValue)
		 		setState(297)
		 		try sumExpr(0)

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(298)
		 		try match(BQLParser.Tokens.NEQ.rawValue)
		 		setState(299)
		 		try sumExpr(0)

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(300)
		 		try match(BQLParser.Tokens.IN.rawValue)
		 		setState(301)
		 		try sumExpr(0)

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(302)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(303)
		 		try match(BQLParser.Tokens.IN.rawValue)
		 		setState(304)
		 		try sumExpr(0)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(305)
		 		try match(BQLParser.Tokens.MATCH.rawValue)
		 		setState(306)
		 		try sumExpr(0)

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(307)
		 		try match(BQLParser.Tokens.NOT_MATCH.rawValue)
		 		setState(308)
		 		try sumExpr(0)

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(309)
		 		try match(BQLParser.Tokens.MATCHES.rawValue)
		 		setState(310)
		 		try sumExpr(0)

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(311)
		 		try match(BQLParser.Tokens.IS.rawValue)
		 		setState(312)
		 		try match(BQLParser.Tokens.NULL.rawValue)

		 		break
		 	case 13:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(313)
		 		try match(BQLParser.Tokens.IS.rawValue)
		 		setState(314)
		 		try match(BQLParser.Tokens.NOT.rawValue)
		 		setState(315)
		 		try match(BQLParser.Tokens.NULL.rawValue)

		 		break
		 	case 14:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(316)
		 		try match(BQLParser.Tokens.BETWEEN.rawValue)
		 		setState(317)
		 		try sumExpr(0)
		 		setState(318)
		 		try match(BQLParser.Tokens.AND.rawValue)
		 		setState(319)
		 		try sumExpr(0)

		 		break
		 	case 15:
		 		try enterOuterAlt(_localctx, 15)
		 		setState(321)
		 		try anyAllOp()
		 		setState(322)
		 		try match(BQLParser.Tokens.ANY.rawValue)
		 		setState(323)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(324)
		 		try expression()
		 		setState(325)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	case 16:
		 		try enterOuterAlt(_localctx, 16)
		 		setState(327)
		 		try anyAllOp()
		 		setState(328)
		 		try match(BQLParser.Tokens.ALL.rawValue)
		 		setState(329)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(330)
		 		try expression()
		 		setState(331)
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
		try enterRule(_localctx, 56, BQLParser.RULE_anyAllOp)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(335)
		 	_la = try _input.LA(1)
		 	if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 16758962388992) != 0))) {
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
		let _startState: Int = 58
		try enterRecursionRule(_localctx, 58, BQLParser.RULE_sumExpr, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(338)
			try termExpr(0)

			_ctx!.stop = try _input.LT(-1)
			setState(348)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,37,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(346)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,36, _ctx)) {
					case 1:
						_localctx = SumExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_sumExpr)
						setState(340)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(341)
						try match(BQLParser.Tokens.PLUS.rawValue)
						setState(342)
						try termExpr(0)

						break
					case 2:
						_localctx = SumExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_sumExpr)
						setState(343)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(344)
						try match(BQLParser.Tokens.MINUS.rawValue)
						setState(345)
						try termExpr(0)

						break
					default: break
					}
			 
				}
				setState(350)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,37,_ctx)
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
		let _startState: Int = 60
		try enterRecursionRule(_localctx, 60, BQLParser.RULE_termExpr, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(352)
			try factorExpr()

			_ctx!.stop = try _input.LT(-1)
			setState(365)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,39,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(363)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,38, _ctx)) {
					case 1:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(354)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(355)
						try match(BQLParser.Tokens.STAR.rawValue)
						setState(356)
						try factorExpr()

						break
					case 2:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(357)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(358)
						try match(BQLParser.Tokens.SLASH.rawValue)
						setState(359)
						try factorExpr()

						break
					case 3:
						_localctx = TermExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_termExpr)
						setState(360)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(361)
						try match(BQLParser.Tokens.PERCENT.rawValue)
						setState(362)
						try factorExpr()

						break
					default: break
					}
			 
				}
				setState(367)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,39,_ctx)
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
		try enterRule(_localctx, 62, BQLParser.RULE_factorExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(373)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,40, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(368)
		 		try unaryExpr()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(369)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(370)
		 		try expression()
		 		setState(371)
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
		try enterRule(_localctx, 64, BQLParser.RULE_unaryExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(380)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .PLUS:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(375)
		 		try match(BQLParser.Tokens.PLUS.rawValue)
		 		setState(376)
		 		try atomExpr()

		 		break

		 	case .MINUS:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(377)
		 		try match(BQLParser.Tokens.MINUS.rawValue)
		 		setState(378)
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
		 		setState(379)
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
		let _startState: Int = 66
		try enterRecursionRule(_localctx, 66, BQLParser.RULE_primaryExpr, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(383)
			try atomExpr()

			_ctx!.stop = try _input.LT(-1)
			setState(395)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,43,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(393)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,42, _ctx)) {
					case 1:
						_localctx = PrimaryExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_primaryExpr)
						setState(385)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(386)
						try match(BQLParser.Tokens.DOT.rawValue)
						setState(387)
						try identifier()

						break
					case 2:
						_localctx = PrimaryExprContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, BQLParser.RULE_primaryExpr)
						setState(388)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(389)
						try match(BQLParser.Tokens.LBRACK.rawValue)
						setState(390)
						try stringLiteral()
						setState(391)
						try match(BQLParser.Tokens.RBRACK.rawValue)

						break
					default: break
					}
			 
				}
				setState(397)
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
		try enterRule(_localctx, 68, BQLParser.RULE_atomExpr)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(403)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,44, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(398)
		 		try selectStmt()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(399)
		 		try functionCall()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(400)
		 		try constant()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(401)
		 		try columnRef()

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(402)
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
		try enterRule(_localctx, 70, BQLParser.RULE_placeholder)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(410)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .POSITIONAL_PLACEHOLDER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(405)
		 		try match(BQLParser.Tokens.POSITIONAL_PLACEHOLDER.rawValue)

		 		break

		 	case .NAMED_PLACEHOLDER_START:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(406)
		 		try match(BQLParser.Tokens.NAMED_PLACEHOLDER_START.rawValue)
		 		setState(407)
		 		try identifier()
		 		setState(408)
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
		try enterRule(_localctx, 72, BQLParser.RULE_functionCall)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(424)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,47, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(412)
		 		try identifier()
		 		setState(413)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(414)
		 		try asterisk()
		 		setState(415)
		 		try match(BQLParser.Tokens.RPAREN.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(417)
		 		try identifier()
		 		setState(418)
		 		try match(BQLParser.Tokens.LPAREN.rawValue)
		 		setState(420)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2272118791788240898) != 0)) {
		 			setState(419)
		 			try expressionList()

		 		}

		 		setState(422)
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
		try enterRule(_localctx, 74, BQLParser.RULE_expressionList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(426)
		 	try expression()
		 	setState(431)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (_la == BQLParser.Tokens.COMMA.rawValue) {
		 		setState(427)
		 		try match(BQLParser.Tokens.COMMA.rawValue)
		 		setState(428)
		 		try expression()


		 		setState(433)
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
		try enterRule(_localctx, 76, BQLParser.RULE_columnRef)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(434)
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
		try enterRule(_localctx, 78, BQLParser.RULE_constant)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(438)
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
		 		setState(436)
		 		try literal()

		 		break

		 	case .LPAREN:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(437)
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
		try enterRule(_localctx, 80, BQLParser.RULE_literal)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(446)
		 	try _errHandler.sync(self)
		 	switch (BQLParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .DATE_LITERAL:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(440)
		 		try dateLiteral()

		 		break

		 	case .DECIMAL:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(441)
		 		try decimalLiteral()

		 		break

		 	case .INTEGER:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(442)
		 		try integerLiteral()

		 		break
		 	case .DOUBLE_QUOTED_TEXT:fallthrough
		 	case .SINGLE_QUOTED_STRING:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(443)
		 		try stringLiteral()

		 		break

		 	case .NULL:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(444)
		 		try nullLiteral()

		 		break
		 	case .TRUE:fallthrough
		 	case .FALSE:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(445)
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
		try enterRule(_localctx, 82, BQLParser.RULE_listLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(448)
		 	try match(BQLParser.Tokens.LPAREN.rawValue)
		 	setState(449)
		 	try literal()
		 	setState(450)
		 	try match(BQLParser.Tokens.COMMA.rawValue)
		 	setState(462)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1116892707588341760) != 0)) {
		 		setState(451)
		 		try literal()
		 		setState(456)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,51,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(452)
		 				try match(BQLParser.Tokens.COMMA.rawValue)
		 				setState(453)
		 				try literal()

		 		 
		 			}
		 			setState(458)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,51,_ctx)
		 		}
		 		setState(460)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (_la == BQLParser.Tokens.COMMA.rawValue) {
		 			setState(459)
		 			try match(BQLParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(464)
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
		try enterRule(_localctx, 84, BQLParser.RULE_identifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(466)
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
		try enterRule(_localctx, 86, BQLParser.RULE_stringLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(468)
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
		try enterRule(_localctx, 88, BQLParser.RULE_booleanLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(470)
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
		try enterRule(_localctx, 90, BQLParser.RULE_nullLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(472)
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
		try enterRule(_localctx, 92, BQLParser.RULE_integerLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(474)
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
		try enterRule(_localctx, 94, BQLParser.RULE_decimalLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(476)
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
		try enterRule(_localctx, 96, BQLParser.RULE_dateLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(478)
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
		case  29:
			return try sumExpr_sempred(_localctx?.castdown(SumExprContext.self), predIndex)
		case  30:
			return try termExpr_sempred(_localctx?.castdown(TermExprContext.self), predIndex)
		case  33:
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
		4,1,63,481,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,
		7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,14,7,14,
		2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,2,20,7,20,2,21,7,21,
		2,22,7,22,2,23,7,23,2,24,7,24,2,25,7,25,2,26,7,26,2,27,7,27,2,28,7,28,
		2,29,7,29,2,30,7,30,2,31,7,31,2,32,7,32,2,33,7,33,2,34,7,34,2,35,7,35,
		2,36,7,36,2,37,7,37,2,38,7,38,2,39,7,39,2,40,7,40,2,41,7,41,2,42,7,42,
		2,43,7,43,2,44,7,44,2,45,7,45,2,46,7,46,2,47,7,47,2,48,7,48,1,0,1,0,1,
		0,1,1,1,1,3,1,104,8,1,1,2,1,2,3,2,108,8,2,1,2,1,2,3,2,112,8,2,1,2,3,2,
		115,8,2,1,2,3,2,118,8,2,1,2,3,2,121,8,2,1,2,3,2,124,8,2,1,3,1,3,1,4,1,
		4,1,4,5,4,131,8,4,10,4,12,4,134,9,4,1,4,3,4,137,8,4,1,5,1,5,1,6,1,6,1,
		6,3,6,144,8,6,1,7,1,7,1,7,1,7,3,7,150,8,7,1,8,1,8,1,8,1,8,1,9,1,9,1,10,
		1,10,1,10,3,10,161,8,10,1,11,1,11,1,11,1,11,1,11,1,11,3,11,169,8,11,3,
		11,171,8,11,1,11,3,11,174,8,11,1,11,1,11,1,11,3,11,179,8,11,1,11,3,11,
		182,8,11,1,11,1,11,1,11,1,11,1,11,3,11,189,8,11,1,11,1,11,1,11,3,11,194,
		8,11,3,11,196,8,11,1,11,3,11,199,8,11,3,11,201,8,11,1,12,1,12,1,13,1,13,
		1,13,1,14,1,14,1,14,1,14,1,14,5,14,213,8,14,10,14,12,14,216,9,14,1,14,
		1,14,3,14,220,8,14,1,15,1,15,3,15,224,8,15,1,16,1,16,1,16,1,16,1,16,5,
		16,231,8,16,10,16,12,16,234,9,16,1,17,1,17,3,17,238,8,17,1,17,3,17,241,
		8,17,1,18,1,18,1,19,1,19,1,19,1,20,1,20,1,20,3,20,251,8,20,1,20,3,20,254,
		8,20,1,20,3,20,257,8,20,1,21,1,21,1,21,1,22,1,22,1,23,1,23,1,23,5,23,267,
		8,23,10,23,12,23,270,9,23,1,24,1,24,1,24,5,24,275,8,24,10,24,12,24,278,
		9,24,1,25,1,25,1,25,3,25,283,8,25,1,26,1,26,3,26,287,8,26,1,27,1,27,1,
		27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,
		27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,
		27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,27,1,
		27,3,27,334,8,27,1,28,1,28,1,29,1,29,1,29,1,29,1,29,1,29,1,29,1,29,1,29,
		5,29,347,8,29,10,29,12,29,350,9,29,1,30,1,30,1,30,1,30,1,30,1,30,1,30,
		1,30,1,30,1,30,1,30,1,30,5,30,364,8,30,10,30,12,30,367,9,30,1,31,1,31,
		1,31,1,31,1,31,3,31,374,8,31,1,32,1,32,1,32,1,32,1,32,3,32,381,8,32,1,
		33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,1,33,5,33,394,8,33,10,
		33,12,33,397,9,33,1,34,1,34,1,34,1,34,1,34,3,34,404,8,34,1,35,1,35,1,35,
		1,35,1,35,3,35,411,8,35,1,36,1,36,1,36,1,36,1,36,1,36,1,36,1,36,3,36,421,
		8,36,1,36,1,36,3,36,425,8,36,1,37,1,37,1,37,5,37,430,8,37,10,37,12,37,
		433,9,37,1,38,1,38,1,39,1,39,3,39,439,8,39,1,40,1,40,1,40,1,40,1,40,1,
		40,3,40,447,8,40,1,41,1,41,1,41,1,41,1,41,1,41,5,41,455,8,41,10,41,12,
		41,458,9,41,1,41,3,41,461,8,41,3,41,463,8,41,1,41,1,41,1,42,1,42,1,43,
		1,43,1,44,1,44,1,45,1,45,1,46,1,46,1,47,1,47,1,48,1,48,1,48,0,3,58,60,
		66,49,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,
		46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,
		94,96,0,5,1,0,28,29,2,0,33,37,40,43,2,0,58,58,60,60,1,0,58,59,1,0,17,18,
		512,0,98,1,0,0,0,2,103,1,0,0,0,4,105,1,0,0,0,6,125,1,0,0,0,8,136,1,0,0,
		0,10,138,1,0,0,0,12,140,1,0,0,0,14,145,1,0,0,0,16,151,1,0,0,0,18,155,1,
		0,0,0,20,160,1,0,0,0,22,200,1,0,0,0,24,202,1,0,0,0,26,204,1,0,0,0,28,207,
		1,0,0,0,30,223,1,0,0,0,32,225,1,0,0,0,34,237,1,0,0,0,36,242,1,0,0,0,38,
		244,1,0,0,0,40,247,1,0,0,0,42,258,1,0,0,0,44,261,1,0,0,0,46,263,1,0,0,
		0,48,271,1,0,0,0,50,282,1,0,0,0,52,284,1,0,0,0,54,333,1,0,0,0,56,335,1,
		0,0,0,58,337,1,0,0,0,60,351,1,0,0,0,62,373,1,0,0,0,64,380,1,0,0,0,66,382,
		1,0,0,0,68,403,1,0,0,0,70,410,1,0,0,0,72,424,1,0,0,0,74,426,1,0,0,0,76,
		434,1,0,0,0,78,438,1,0,0,0,80,446,1,0,0,0,82,448,1,0,0,0,84,466,1,0,0,
		0,86,468,1,0,0,0,88,470,1,0,0,0,90,472,1,0,0,0,92,474,1,0,0,0,94,476,1,
		0,0,0,96,478,1,0,0,0,98,99,3,2,1,0,99,100,5,0,0,1,100,1,1,0,0,0,101,104,
		3,4,2,0,102,104,3,40,20,0,103,101,1,0,0,0,103,102,1,0,0,0,104,3,1,0,0,
		0,105,107,5,1,0,0,106,108,3,6,3,0,107,106,1,0,0,0,107,108,1,0,0,0,108,
		109,1,0,0,0,109,111,3,8,4,0,110,112,3,14,7,0,111,110,1,0,0,0,111,112,1,
		0,0,0,112,114,1,0,0,0,113,115,3,26,13,0,114,113,1,0,0,0,114,115,1,0,0,
		0,115,117,1,0,0,0,116,118,3,28,14,0,117,116,1,0,0,0,117,118,1,0,0,0,118,
		120,1,0,0,0,119,121,3,32,16,0,120,119,1,0,0,0,120,121,1,0,0,0,121,123,
		1,0,0,0,122,124,3,38,19,0,123,122,1,0,0,0,123,124,1,0,0,0,124,5,1,0,0,
		0,125,126,5,2,0,0,126,7,1,0,0,0,127,132,3,12,6,0,128,129,5,50,0,0,129,
		131,3,12,6,0,130,128,1,0,0,0,131,134,1,0,0,0,132,130,1,0,0,0,132,133,1,
		0,0,0,133,137,1,0,0,0,134,132,1,0,0,0,135,137,3,10,5,0,136,127,1,0,0,0,
		136,135,1,0,0,0,137,9,1,0,0,0,138,139,5,46,0,0,139,11,1,0,0,0,140,143,
		3,44,22,0,141,142,5,10,0,0,142,144,3,84,42,0,143,141,1,0,0,0,143,144,1,
		0,0,0,144,13,1,0,0,0,145,149,5,3,0,0,146,150,3,18,9,0,147,150,3,16,8,0,
		148,150,3,22,11,0,149,146,1,0,0,0,149,147,1,0,0,0,149,148,1,0,0,0,150,
		15,1,0,0,0,151,152,5,51,0,0,152,153,3,4,2,0,153,154,5,52,0,0,154,17,1,
		0,0,0,155,156,3,20,10,0,156,19,1,0,0,0,157,161,5,38,0,0,158,161,5,39,0,
		0,159,161,3,84,42,0,160,157,1,0,0,0,160,158,1,0,0,0,160,159,1,0,0,0,161,
		21,1,0,0,0,162,163,5,22,0,0,163,164,5,24,0,0,164,170,3,96,48,0,165,168,
		5,23,0,0,166,167,5,24,0,0,167,169,3,96,48,0,168,166,1,0,0,0,168,169,1,
		0,0,0,169,171,1,0,0,0,170,165,1,0,0,0,170,171,1,0,0,0,171,173,1,0,0,0,
		172,174,3,24,12,0,173,172,1,0,0,0,173,174,1,0,0,0,174,201,1,0,0,0,175,
		178,5,23,0,0,176,177,5,24,0,0,177,179,3,96,48,0,178,176,1,0,0,0,178,179,
		1,0,0,0,179,181,1,0,0,0,180,182,3,24,12,0,181,180,1,0,0,0,181,182,1,0,
		0,0,182,201,1,0,0,0,183,201,5,25,0,0,184,188,3,44,22,0,185,186,5,22,0,
		0,186,187,5,24,0,0,187,189,3,96,48,0,188,185,1,0,0,0,188,189,1,0,0,0,189,
		195,1,0,0,0,190,193,5,23,0,0,191,192,5,24,0,0,192,194,3,96,48,0,193,191,
		1,0,0,0,193,194,1,0,0,0,194,196,1,0,0,0,195,190,1,0,0,0,195,196,1,0,0,
		0,196,198,1,0,0,0,197,199,3,24,12,0,198,197,1,0,0,0,198,199,1,0,0,0,199,
		201,1,0,0,0,200,162,1,0,0,0,200,175,1,0,0,0,200,183,1,0,0,0,200,184,1,
		0,0,0,201,23,1,0,0,0,202,203,5,25,0,0,203,25,1,0,0,0,204,205,5,4,0,0,205,
		206,3,44,22,0,206,27,1,0,0,0,207,208,5,5,0,0,208,209,5,6,0,0,209,214,3,
		30,15,0,210,211,5,50,0,0,211,213,3,30,15,0,212,210,1,0,0,0,213,216,1,0,
		0,0,214,212,1,0,0,0,214,215,1,0,0,0,215,219,1,0,0,0,216,214,1,0,0,0,217,
		218,5,7,0,0,218,220,3,44,22,0,219,217,1,0,0,0,219,220,1,0,0,0,220,29,1,
		0,0,0,221,224,3,92,46,0,222,224,3,44,22,0,223,221,1,0,0,0,223,222,1,0,
		0,0,224,31,1,0,0,0,225,226,5,8,0,0,226,227,5,6,0,0,227,232,3,34,17,0,228,
		229,5,50,0,0,229,231,3,34,17,0,230,228,1,0,0,0,231,234,1,0,0,0,232,230,
		1,0,0,0,232,233,1,0,0,0,233,33,1,0,0,0,234,232,1,0,0,0,235,238,3,92,46,
		0,236,238,3,44,22,0,237,235,1,0,0,0,237,236,1,0,0,0,238,240,1,0,0,0,239,
		241,3,36,18,0,240,239,1,0,0,0,240,241,1,0,0,0,241,35,1,0,0,0,242,243,7,
		0,0,0,243,37,1,0,0,0,244,245,5,9,0,0,245,246,3,92,46,0,246,39,1,0,0,0,
		247,250,5,20,0,0,248,249,5,21,0,0,249,251,3,84,42,0,250,248,1,0,0,0,250,
		251,1,0,0,0,251,253,1,0,0,0,252,254,3,42,21,0,253,252,1,0,0,0,253,254,
		1,0,0,0,254,256,1,0,0,0,255,257,3,26,13,0,256,255,1,0,0,0,256,257,1,0,
		0,0,257,41,1,0,0,0,258,259,5,3,0,0,259,260,3,22,11,0,260,43,1,0,0,0,261,
		262,3,46,23,0,262,45,1,0,0,0,263,268,3,48,24,0,264,265,5,12,0,0,265,267,
		3,48,24,0,266,264,1,0,0,0,267,270,1,0,0,0,268,266,1,0,0,0,268,269,1,0,
		0,0,269,47,1,0,0,0,270,268,1,0,0,0,271,276,3,50,25,0,272,273,5,11,0,0,
		273,275,3,50,25,0,274,272,1,0,0,0,275,278,1,0,0,0,276,274,1,0,0,0,276,
		277,1,0,0,0,277,49,1,0,0,0,278,276,1,0,0,0,279,280,5,13,0,0,280,283,3,
		50,25,0,281,283,3,52,26,0,282,279,1,0,0,0,282,281,1,0,0,0,283,51,1,0,0,
		0,284,286,3,58,29,0,285,287,3,54,27,0,286,285,1,0,0,0,286,287,1,0,0,0,
		287,53,1,0,0,0,288,289,5,41,0,0,289,334,3,58,29,0,290,291,5,36,0,0,291,
		334,3,58,29,0,292,293,5,42,0,0,293,334,3,58,29,0,294,295,5,37,0,0,295,
		334,3,58,29,0,296,297,5,40,0,0,297,334,3,58,29,0,298,299,5,35,0,0,299,
		334,3,58,29,0,300,301,5,14,0,0,301,334,3,58,29,0,302,303,5,13,0,0,303,
		304,5,14,0,0,304,334,3,58,29,0,305,306,5,43,0,0,306,334,3,58,29,0,307,
		308,5,33,0,0,308,334,3,58,29,0,309,310,5,34,0,0,310,334,3,58,29,0,311,
		312,5,15,0,0,312,334,5,16,0,0,313,314,5,15,0,0,314,315,5,13,0,0,315,334,
		5,16,0,0,316,317,5,19,0,0,317,318,3,58,29,0,318,319,5,11,0,0,319,320,3,
		58,29,0,320,334,1,0,0,0,321,322,3,56,28,0,322,323,5,26,0,0,323,324,5,51,
		0,0,324,325,3,44,22,0,325,326,5,52,0,0,326,334,1,0,0,0,327,328,3,56,28,
		0,328,329,5,27,0,0,329,330,5,51,0,0,330,331,3,44,22,0,331,332,5,52,0,0,
		332,334,1,0,0,0,333,288,1,0,0,0,333,290,1,0,0,0,333,292,1,0,0,0,333,294,
		1,0,0,0,333,296,1,0,0,0,333,298,1,0,0,0,333,300,1,0,0,0,333,302,1,0,0,
		0,333,305,1,0,0,0,333,307,1,0,0,0,333,309,1,0,0,0,333,311,1,0,0,0,333,
		313,1,0,0,0,333,316,1,0,0,0,333,321,1,0,0,0,333,327,1,0,0,0,334,55,1,0,
		0,0,335,336,7,1,0,0,336,57,1,0,0,0,337,338,6,29,-1,0,338,339,3,60,30,0,
		339,348,1,0,0,0,340,341,10,3,0,0,341,342,5,44,0,0,342,347,3,60,30,0,343,
		344,10,2,0,0,344,345,5,45,0,0,345,347,3,60,30,0,346,340,1,0,0,0,346,343,
		1,0,0,0,347,350,1,0,0,0,348,346,1,0,0,0,348,349,1,0,0,0,349,59,1,0,0,0,
		350,348,1,0,0,0,351,352,6,30,-1,0,352,353,3,62,31,0,353,365,1,0,0,0,354,
		355,10,4,0,0,355,356,5,46,0,0,356,364,3,62,31,0,357,358,10,3,0,0,358,359,
		5,47,0,0,359,364,3,62,31,0,360,361,10,2,0,0,361,362,5,48,0,0,362,364,3,
		62,31,0,363,354,1,0,0,0,363,357,1,0,0,0,363,360,1,0,0,0,364,367,1,0,0,
		0,365,363,1,0,0,0,365,366,1,0,0,0,366,61,1,0,0,0,367,365,1,0,0,0,368,374,
		3,64,32,0,369,370,5,51,0,0,370,371,3,44,22,0,371,372,5,52,0,0,372,374,
		1,0,0,0,373,368,1,0,0,0,373,369,1,0,0,0,374,63,1,0,0,0,375,376,5,44,0,
		0,376,381,3,68,34,0,377,378,5,45,0,0,378,381,3,62,31,0,379,381,3,66,33,
		0,380,375,1,0,0,0,380,377,1,0,0,0,380,379,1,0,0,0,381,65,1,0,0,0,382,383,
		6,33,-1,0,383,384,3,68,34,0,384,395,1,0,0,0,385,386,10,3,0,0,386,387,5,
		49,0,0,387,394,3,84,42,0,388,389,10,2,0,0,389,390,5,53,0,0,390,391,3,86,
		43,0,391,392,5,54,0,0,392,394,1,0,0,0,393,385,1,0,0,0,393,388,1,0,0,0,
		394,397,1,0,0,0,395,393,1,0,0,0,395,396,1,0,0,0,396,67,1,0,0,0,397,395,
		1,0,0,0,398,404,3,4,2,0,399,404,3,72,36,0,400,404,3,78,39,0,401,404,3,
		76,38,0,402,404,3,70,35,0,403,398,1,0,0,0,403,399,1,0,0,0,403,400,1,0,
		0,0,403,401,1,0,0,0,403,402,1,0,0,0,404,69,1,0,0,0,405,411,5,30,0,0,406,
		407,5,31,0,0,407,408,3,84,42,0,408,409,5,32,0,0,409,411,1,0,0,0,410,405,
		1,0,0,0,410,406,1,0,0,0,411,71,1,0,0,0,412,413,3,84,42,0,413,414,5,51,
		0,0,414,415,3,10,5,0,415,416,5,52,0,0,416,425,1,0,0,0,417,418,3,84,42,
		0,418,420,5,51,0,0,419,421,3,74,37,0,420,419,1,0,0,0,420,421,1,0,0,0,421,
		422,1,0,0,0,422,423,5,52,0,0,423,425,1,0,0,0,424,412,1,0,0,0,424,417,1,
		0,0,0,425,73,1,0,0,0,426,431,3,44,22,0,427,428,5,50,0,0,428,430,3,44,22,
		0,429,427,1,0,0,0,430,433,1,0,0,0,431,429,1,0,0,0,431,432,1,0,0,0,432,
		75,1,0,0,0,433,431,1,0,0,0,434,435,3,84,42,0,435,77,1,0,0,0,436,439,3,
		80,40,0,437,439,3,82,41,0,438,436,1,0,0,0,438,437,1,0,0,0,439,79,1,0,0,
		0,440,447,3,96,48,0,441,447,3,94,47,0,442,447,3,92,46,0,443,447,3,86,43,
		0,444,447,3,90,45,0,445,447,3,88,44,0,446,440,1,0,0,0,446,441,1,0,0,0,
		446,442,1,0,0,0,446,443,1,0,0,0,446,444,1,0,0,0,446,445,1,0,0,0,447,81,
		1,0,0,0,448,449,5,51,0,0,449,450,3,80,40,0,450,462,5,50,0,0,451,456,3,
		80,40,0,452,453,5,50,0,0,453,455,3,80,40,0,454,452,1,0,0,0,455,458,1,0,
		0,0,456,454,1,0,0,0,456,457,1,0,0,0,457,460,1,0,0,0,458,456,1,0,0,0,459,
		461,5,50,0,0,460,459,1,0,0,0,460,461,1,0,0,0,461,463,1,0,0,0,462,451,1,
		0,0,0,462,463,1,0,0,0,463,464,1,0,0,0,464,465,5,52,0,0,465,83,1,0,0,0,
		466,467,7,2,0,0,467,85,1,0,0,0,468,469,7,3,0,0,469,87,1,0,0,0,470,471,
		7,4,0,0,471,89,1,0,0,0,472,473,5,16,0,0,473,91,1,0,0,0,474,475,5,57,0,
		0,475,93,1,0,0,0,476,477,5,56,0,0,477,95,1,0,0,0,478,479,5,55,0,0,479,
		97,1,0,0,0,54,103,107,111,114,117,120,123,132,136,143,149,160,168,170,
		173,178,181,188,193,195,198,200,214,219,223,232,237,240,250,253,256,268,
		276,282,286,333,346,348,363,365,373,380,393,395,403,410,420,424,431,438,
		446,456,460,462
	]

	internal
	static let _ATN = try! ATNDeserializer().deserialize(_serializedATN)
}