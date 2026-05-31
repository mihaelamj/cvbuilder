// swift-tools-version: 6.1

import PackageDescription

// CVBuilderIgnite renders via twostraws/Ignite, a macOS-oriented HTML DSL that
// does not build on Linux. Gate it (and its Ignite dependency) to macOS so the
// core library, the cvbuilder CLI, and the tests build and run on Linux too.
#if os(macOS)
let igniteProducts: [Product] = [
    .library(name: "CVBuilderIgnite", targets: ["CVBuilderIgnite"]),
]
let igniteDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/twostraws/Ignite.git", branch: "main"),
]
let igniteTargets: [Target] = [
    .target(
        name: "CVBuilderIgnite",
        dependencies: [
            "CVBuilder",
            .product(name: "Ignite", package: "Ignite"),
        ]
    ),
]
#else
let igniteProducts: [Product] = []
let igniteDependencies: [Package.Dependency] = []
let igniteTargets: [Target] = []
#endif

let package = Package(
    name: "CVBuilder",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(name: "CVBuilder", targets: ["CVBuilder"]),
        .executable(name: "cvbuilder", targets: ["CVBuilderCLI"]),
    ] + igniteProducts,
    dependencies: igniteDependencies,
    targets: [
        // Core models and rendering — no external dependency, builds anywhere.
        .target(name: "CVBuilder"),

        // File-driven CLI: render a CV page from one JSON document. The target
        // directory is CVBuilderCLI (not "cvbuilder") so it does not collide with
        // the CVBuilder target on case-insensitive filesystems; the executable
        // product is still named `cvbuilder`.
        .executableTarget(
            name: "CVBuilderCLI",
            dependencies: ["CVBuilder"]
        ),

        .testTarget(
            name: "CVBuilderTests",
            dependencies: ["CVBuilder"]
        ),
    ] + igniteTargets
)
