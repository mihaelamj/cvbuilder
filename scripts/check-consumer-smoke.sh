#!/usr/bin/env bash
# Proves a clean external Swift package can consume CVBuilder products.

set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ROOT_SWIFT=$(printf '%s' "$ROOT" | sed 's/\\/\\\\/g; s/"/\\"/g')
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

mkdir -p "$WORKDIR/Sources/CVBuilderConsumerSmoke"

cat > "$WORKDIR/Package.swift" <<SWIFT
// swift-tools-version: 6.1

import PackageDescription

let cvbuilderPath = "$ROOT_SWIFT"

var consumerDependencies: [Target.Dependency] = [
    .product(name: "CVBuilder", package: "CVBuilder"),
]

#if os(Linux)
consumerDependencies.append(.product(name: "CVBuilderTileDown", package: "CVBuilder"))
#endif

let package = Package(
    name: "CVBuilderConsumerSmoke",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(path: cvbuilderPath),
    ],
    targets: [
        .executableTarget(
            name: "CVBuilderConsumerSmoke",
            dependencies: consumerDependencies,
        ),
    ],
)
SWIFT

cat > "$WORKDIR/Sources/CVBuilderConsumerSmoke/main.swift" <<'SWIFT'
import CVBuilder

#if os(Linux)
import CVBuilderTileDown
#endif

let resume = CV(
    name: "Consumer Smoke",
    title: "Swift Package Consumer",
    summary: "Verifies clean SwiftPM package consumption.",
    contactInfo: ContactInfo(
        email: "consumer-smoke@example.com",
        phone: "+1 555 010 0600",
        location: "Example City"
    ),
    experience: [],
    education: [],
    skills: [
        Tech(name: "Swift", category: .language),
        Tech(name: "Linux", category: .platform),
    ]
)

let document = CVDocument(
    frontMatter: ["slug": "consumer-smoke"],
    cv: resume
)

let canonicalMarkdown = Rendering.MarkdownDocumentRenderer().render(document)

guard canonicalMarkdown.contains("# Consumer Smoke") else {
    fatalError("consumer smoke failed to render the expected heading")
}

guard canonicalMarkdown.contains("Swift Package Consumer") else {
    fatalError("consumer smoke failed to render the expected title")
}

#if os(Linux)
let tileDownMarkdown = CVBuilderTileDown.Renderer().render(document)

guard tileDownMarkdown == canonicalMarkdown else {
    fatalError("consumer smoke TileDown output diverged from canonical Markdown")
}
#endif

print("consumer-smoke: ok")
SWIFT

swift run --package-path "$WORKDIR" CVBuilderConsumerSmoke
