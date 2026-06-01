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
- `CVDocument` contract documentation and a complete `Examples/democv/cv.json`
  fixture.
- Public-evidence-heavy rendering mode and checked-in Markdown fixtures for all
  technical CV rendering modes.
- Explicit `selectedExperienceIDs` rendering option for keeping relevant work
  entries before recency limits are applied.
- TileDown Markdown contract documentation and a generated
  `Examples/tiledown/democv.md` example.
- Generated fixture freshness check for the checked-in TileDown Markdown example.
- Pull request roadmap gate that requires each PR to name the issue or phase it
  advances.

### Changed

- Removed default Ignite participation from the package graph.
- Kept PDF rendering, ATS scoring, resume optimizer claims, and HTML rendering
  outside the core package.
- Made `RenderingOptions.omitEmptySections` control whether empty optional
  Markdown section headings are emitted.
- Documented rendering-mode policies with evidence-backed rules separated from
  pragmatic renderer conventions.
- Expanded the demo CV fixture into a multi-role technical CV with nested
  projects, public evidence, and omitted older jobs covered by tests.
- Preserved explicit selected work-entry order for relevance-focused CV
  variants.
