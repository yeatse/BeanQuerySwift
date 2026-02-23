public enum BeanQuerySwift {
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
