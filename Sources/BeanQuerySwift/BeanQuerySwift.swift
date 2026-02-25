/// Namespace helpers for constructing BeanQuerySwift public APIs.
public enum BeanQuerySwift {
    /// Creates a `BeanQueryEngine` with the given compiler defaults.
    ///
    /// - Parameters:
    ///   - defaultTableName: Default `FROM` table used when omitted in a query.
    ///   - supportImplicitGroupBy: Whether non-aggregate targets should be auto-added to `GROUP BY`.
    /// - Returns: A configured `BeanQueryEngine` instance.
    public static func makeEngine(
        defaultTableName: String = "postings",
        supportImplicitGroupBy: Bool = true
    ) -> BeanQueryEngine {
        BeanQueryEngine(
            defaultTableName: defaultTableName,
            supportImplicitGroupBy: supportImplicitGroupBy
        )
    }
}
