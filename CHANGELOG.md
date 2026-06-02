# Changelog

All notable changes to CVBuilder are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-06-02

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
- Resource-backed JSON fixtures for early-career, hostile Markdown, minimal, and
  senior technical CV rendering proof cases.
- JSON-to-Markdown workflow documentation covering CLI generation, `--check`,
  static-site integration, rendering modes, public evidence, and non-goals.
- User-facing `cvbuilder --help` and `-h` usage output for the file-driven CLI.
- Machine-readable `CVDocument` JSON Schema for editor-oriented authoring.
- Schema drift checks to keep checked-in examples and fixtures aligned with the
  `CVDocument` JSON Schema.
- First usable release checklist covering local gates, GitHub checks, changelog
  prep, tag steps, release-note expectations, and product boundaries.
- Platform contract guard that keeps unsupported iOS metadata out of the first
  release until iOS support is tested and documented.
- Clean SwiftPM consumer smoke test for proving public package consumption on
  macOS and Linux before release.

### Changed

- Removed default Ignite participation from the package graph.
- Removed unsupported iOS platform metadata from `Package.swift`; the first
  release claims macOS and Linux only.
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
