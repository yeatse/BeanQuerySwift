// Generated from /Users/yeatse/Developer/Repo/BeanQuerySwift/Sources/BeanQuerySwift/Grammar/BQLParser.g4 by ANTLR 4.13.2
import Antlr4

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link BQLParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
internal class BQLParserVisitor<T>: ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link BQLParser#bql}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitBql(_ ctx: BQLParser.BqlContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#statement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitStatement(_ ctx: BQLParser.StatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#selectStmt}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitSelectStmt(_ ctx: BQLParser.SelectStmtContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#distinctClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitDistinctClause(_ ctx: BQLParser.DistinctClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#targets}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitTargets(_ ctx: BQLParser.TargetsContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#asterisk}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitAsterisk(_ ctx: BQLParser.AsteriskContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#target}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitTarget(_ ctx: BQLParser.TargetContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#fromClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitFromClause(_ ctx: BQLParser.FromClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#subselect}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitSubselect(_ ctx: BQLParser.SubselectContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#tableRef}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitTableRef(_ ctx: BQLParser.TableRefContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#tableName}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitTableName(_ ctx: BQLParser.TableNameContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#fromExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitFromExpr(_ ctx: BQLParser.FromExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#clearClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitClearClause(_ ctx: BQLParser.ClearClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#whereClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitWhereClause(_ ctx: BQLParser.WhereClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#groupByClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitGroupByClause(_ ctx: BQLParser.GroupByClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#groupItem}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitGroupItem(_ ctx: BQLParser.GroupItemContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#orderByClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitOrderByClause(_ ctx: BQLParser.OrderByClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#orderItem}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitOrderItem(_ ctx: BQLParser.OrderItemContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#ordering}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitOrdering(_ ctx: BQLParser.OrderingContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#limitClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitLimitClause(_ ctx: BQLParser.LimitClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#pivotByClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitPivotByClause(_ ctx: BQLParser.PivotByClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#pivotByItem}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitPivotByItem(_ ctx: BQLParser.PivotByItemContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#balancesStmt}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitBalancesStmt(_ ctx: BQLParser.BalancesStmtContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#balancesFromClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitBalancesFromClause(_ ctx: BQLParser.BalancesFromClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#journalStmt}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitJournalStmt(_ ctx: BQLParser.JournalStmtContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#journalFromClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitJournalFromClause(_ ctx: BQLParser.JournalFromClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#printStmt}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitPrintStmt(_ ctx: BQLParser.PrintStmtContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#printFromClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitPrintFromClause(_ ctx: BQLParser.PrintFromClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitExpression(_ ctx: BQLParser.ExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#disjunction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitDisjunction(_ ctx: BQLParser.DisjunctionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#conjunction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitConjunction(_ ctx: BQLParser.ConjunctionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#inversion}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitInversion(_ ctx: BQLParser.InversionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#comparison}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitComparison(_ ctx: BQLParser.ComparisonContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#comparisonSuffix}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitComparisonSuffix(_ ctx: BQLParser.ComparisonSuffixContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#anyAllOp}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitAnyAllOp(_ ctx: BQLParser.AnyAllOpContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#sumExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitSumExpr(_ ctx: BQLParser.SumExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#termExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitTermExpr(_ ctx: BQLParser.TermExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#factorExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitFactorExpr(_ ctx: BQLParser.FactorExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#unaryExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitUnaryExpr(_ ctx: BQLParser.UnaryExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#primaryExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitPrimaryExpr(_ ctx: BQLParser.PrimaryExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#atomExpr}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitAtomExpr(_ ctx: BQLParser.AtomExprContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#placeholder}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitPlaceholder(_ ctx: BQLParser.PlaceholderContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#functionCall}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitFunctionCall(_ ctx: BQLParser.FunctionCallContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#expressionList}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitExpressionList(_ ctx: BQLParser.ExpressionListContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#columnRef}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitColumnRef(_ ctx: BQLParser.ColumnRefContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#contextualKeyword}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitContextualKeyword(_ ctx: BQLParser.ContextualKeywordContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#constant}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitConstant(_ ctx: BQLParser.ConstantContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitLiteral(_ ctx: BQLParser.LiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#listLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitListLiteral(_ ctx: BQLParser.ListLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#identifier}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitIdentifier(_ ctx: BQLParser.IdentifierContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#stringLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitStringLiteral(_ ctx: BQLParser.StringLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#booleanLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitBooleanLiteral(_ ctx: BQLParser.BooleanLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#nullLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitNullLiteral(_ ctx: BQLParser.NullLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#integerLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitIntegerLiteral(_ ctx: BQLParser.IntegerLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#decimalLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitDecimalLiteral(_ ctx: BQLParser.DecimalLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link BQLParser#dateLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	internal func visitDateLiteral(_ ctx: BQLParser.DateLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

}