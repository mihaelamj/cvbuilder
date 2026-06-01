# Changelog

All notable changes to CVBuilder are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Pure Swift `CVDocument` data model for publishable technical CV data.
- Deterministic Markdown renderer for `CVDocument`.
- `cvbuilder` CLI for JSON to Markdown and normalized JSON output.
- Linux-only `CVBuilderTileDown` adapter for Markdown publishing workflows.
- Style, namespacing, SwiftFormat, SwiftLint, Linux Swift, and macOS Swift CI gates.

### Changed

- Removed default Ignite participation from the package graph.
- Kept PDF rendering, ATS scoring, resume optimizer claims, and HTML rendering
  outside the core package.
