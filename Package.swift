// swift-tools-version: 6.1

import PackageDescription

let packagePlatforms: [SupportedPlatform] = [
    .macOS(.v13),
]

#if os(Linux)
    let tileDownProducts: [Product] = [
        .library(
            name: "CVBuilderTileDown",
            targets: ["CVBuilderTileDown"],
        ),
    ]
    let tileDownTargets: [Target] = [
        .target(
            name: "CVBuilderTileDown",
            dependencies: ["CVBuilder"],
        ),
    ]
    let tileDownTestDependencies: [Target.Dependency] = [
        "CVBuilderTileDown",
    ]
#else
    let tileDownProducts: [Product] = []
    let tileDownTargets: [Target] = []
    let tileDownTestDependencies: [Target.Dependency] = []
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
        dependencies: [],
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
