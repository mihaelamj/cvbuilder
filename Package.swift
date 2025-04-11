// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "CVBuilder",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CVBuilder",
            targets: ["CVBuilder"]
        ),
        .library(
            name: "CVBuilderIgnite",
            targets: ["CVBuilderIgnite"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/twostraws/Ignite.git", branch: "main")
    ],
    targets: [
        // Core models and logic — no Ignite dependency
        .target(
            name: "CVBuilder",
            dependencies: []
        ),

        // IgniteRenderer only — depends on CVBuilder + Ignite
        .target(
            name: "CVBuilderIgnite",
            dependencies: [
                "CVBuilder",
                .product(name: "Ignite", package: "Ignite")
            ]
        ),

        // Unit tests
        .testTarget(
            name: "CVBuilderTests",
            dependencies: ["CVBuilder"]
        )
    ]
)
