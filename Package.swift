// swift-tools-version: 6.1

import PackageDescription

let packagePlatforms: [SupportedPlatform] = [
    .macOS(.v13),
]

/// The TileDown adapter is pure Swift over `CVBuilder`, so the target and its
/// contract test compile and run on every platform; adapter regressions are
/// caught on the macOS dev platform, not only on Linux CI. Only the public
/// product stays Linux-only.
let tileDownTargets: [Target] = [
    .target(
        name: "CVBuilderTileDown",
        dependencies: ["CVBuilder"],
    ),
]
let tileDownTestDependencies: [Target.Dependency] = [
    "CVBuilderTileDown",
]

#if os(Linux)
    let tileDownProducts: [Product] = [
        .library(
            name: "CVBuilderTileDown",
            targets: ["CVBuilderTileDown"],
        ),
    ]
#else
    let tileDownProducts: [Product] = []
#endif

let packageProducts: [Product] = [
    .library(
        name: "CVBuilder",
        targets: ["CVBuilder"],
    ),
    .executable(
        name: "cvbuilder",
        targets: ["CVBuilderTool"],
    ),
] + tileDownProducts

let packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
]

let packageTargets: [Target] = [
    .target(
        name: "CVBuilder",
        dependencies: [],
    ),
    .target(
        name: "CVBuilderDocumentation",
        dependencies: ["CVBuilder"],
    ),
    .target(
        name: "CVBuilderCLI",
        dependencies: ["CVBuilder"],
    ),
    .executableTarget(
        name: "CVBuilderTool",
        dependencies: ["CVBuilderCLI"],
    ),
    .testTarget(
        name: "CVBuilderTests",
        dependencies: [
            "CVBuilder",
        ] + tileDownTestDependencies,
        resources: [
            .process("Fixtures"),
        ],
    ),
    .testTarget(
        name: "CVBuilderCLITests",
        dependencies: ["CVBuilder", "CVBuilderCLI"],
    ),
] + tileDownTargets

let package = Package(
    name: "CVBuilder",
    platforms: packagePlatforms,
    products: packageProducts,
    dependencies: packageDependencies,
    targets: packageTargets,
)
