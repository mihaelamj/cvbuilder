// swift-tools-version: 6.1

import PackageDescription

let packagePlatforms: [SupportedPlatform] = [
    .macOS(.v13),
    .iOS(.v16)
]

#if os(Linux)
    let tileDownProducts: [Product] = [
        .library(
            name: "CVBuilderTileDown",
            targets: ["CVBuilderTileDown"]
        )
    ]
    let tileDownTargets: [Target] = [
        .target(
            name: "CVBuilderTileDown",
            dependencies: ["CVBuilder"]
        )
    ]
    let tileDownTestDependencies: [Target.Dependency] = [
        "CVBuilderTileDown"
    ]
#else
    let tileDownProducts: [Product] = []
    let tileDownTargets: [Target] = []
    let tileDownTestDependencies: [Target.Dependency] = []
#endif

let packageProducts: [Product] = [
    .library(
        name: "CVBuilder",
        targets: ["CVBuilder"]
    ),
    .executable(
        name: "cvbuilder",
        targets: ["CVBuilderTool"]
    )
] + tileDownProducts

let packageDependencies: [Package.Dependency] = []

let packageTargets: [Target] = [
    .target(
        name: "CVBuilder",
        dependencies: []
    ),
    .target(
        name: "CVBuilderCLI",
        dependencies: ["CVBuilder"]
    ),
    .executableTarget(
        name: "CVBuilderTool",
        dependencies: ["CVBuilderCLI"]
    ),
    .testTarget(
        name: "CVBuilderTests",
        dependencies: [
            "CVBuilder"
        ] + tileDownTestDependencies
    ),
    .testTarget(
        name: "CVBuilderCLITests",
        dependencies: ["CVBuilder", "CVBuilderCLI"]
    )
] + tileDownTargets

let package = Package(
    name: "CVBuilder",
    platforms: packagePlatforms,
    products: packageProducts,
    dependencies: packageDependencies,
    targets: packageTargets
)
