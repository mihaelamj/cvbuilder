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
    .library(
        name: "CVBuilderIgnite",
        targets: ["CVBuilderIgnite"]
    ),
    .executable(
        name: "cvbuilder",
        targets: ["CVBuilderTool"]
    )
] + tileDownProducts

let packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/twostraws/Ignite.git", branch: "main")
]

let packageTargets: [Target] = [
    .target(
        name: "CVBuilder",
        dependencies: []
    ),
    .target(
        name: "CVBuilderIgnite",
        dependencies: [
            "CVBuilder",
            .product(name: "Ignite", package: "Ignite")
        ]
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
            "CVBuilder",
            "CVBuilderIgnite"
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
