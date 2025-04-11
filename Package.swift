// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
            targets: ["CVBuilder"]),
    ],
    targets: [
        .target(
            name: "CVBuilder"),
        .testTarget(
            name: "CVBuilderTests",
            dependencies: ["CVBuilder"]
        ),
    ]
)
