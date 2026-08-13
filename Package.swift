// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BeanQuerySwift",
    platforms: [.iOS(.v18), .macOS(.v15), .watchOS(.v11), .visionOS(.v2), .tvOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BeanQuerySwift",
            targets: ["BeanQuerySwift"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/yeatse/BeancountSwift", from: "1.1.4"),
        .package(url: "https://github.com/antlr/antlr4", from: "4.13.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BeanQuerySwift",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4"),
                .product(name: "BeancountSwift", package: "BeancountSwift"),
            ],
            exclude: [
                "Grammar",
            ],
        ),
        .testTarget(
            name: "BeanQuerySwiftTests",
            dependencies: ["BeanQuerySwift"]
        ),
    ]
)
