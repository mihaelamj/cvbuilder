# Changelog

All notable changes to CVBuilder are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- CLI authoring commands for `--validate`, `--print-schema`, `--init`, stdin
  input with `--data -`, and stdout output with `--out -`.
- Static-site-generator front matter profiles for generic, Toucan, Hugo, and
  Jekyll Markdown output.
- JSON Resume interop: a typed `jsonresume.org` model, `CVDocument(jsonResume:)`
  import, `JSONResume(cvDocument:)` export, the CLI `--from json-resume` input
  mode and `--format json-resume` output, round-trip fixtures, and the
  JSON Resume Interop catalog article mapping and lossy-field contract.
- Rendered-output localization: `RenderingOptions.locale` selects the language
  for section labels, field labels, and month names from a deterministic,
  host-locale-independent label set. Ships English (default, byte-for-byte
  unchanged) and German, with a checked-in German fixture and
  the Localization catalog article.
- Release-version consistency guard for changelog, release notes, release
  checklist, README, and roadmap drift.

### Changed

- Route the deprecated `MarkdownCVRenderer` and Linux
  `CVBuilderTileDown.Renderer().render(cv:)` compatibility paths through the
  canonical `CVDocument` Markdown renderer, so bare `CV` rendering now uses the
  same escaping, deterministic ordering, and no-footer output.
- Deprecated the legacy `CVRendering`, `MarkdownCVRenderer`,
  `StringCVRenderer`, and `ConsoleCVRenderer` APIs in favor of `CVDocument` and
  `Rendering.MarkdownDocumentRenderer`.
- Model `id` fields are now `UUID?` and default to omitted instead of a freshly
  synthesized `UUID()`. Omitted IDs stay omitted through decode and encode, an
  explicit JSON `null` is still rejected, and explicit IDs round-trip unchanged.
- `Tech` value identity is now its `name` and `category`, and `Company` value
  identity is now its `name`, so deduplication and grouping key on the semantic
  fields rather than a per-instance identifier.

### Fixed

- Front-matter `tags` and `categories` always render as an array under the
  static-site-generator profiles, including the empty and separator-only cases
  (an empty sequence: `[]` in TOML, `key: []` in YAML). Previously an empty or
  separator-only value fell through to a string scalar and leaked the raw
  separator, giving the key a non-uniform type; non-empty rendering is
  unchanged (#120).
- The CLI schema validator's `uri` format check now mirrors the model decoder,
  which accepts relative URLs (site-root paths, anchors, relative paths). It
  rejects only strings Foundation cannot parse into a URL, so `--validate` no
  longer falsely rejects a document the decoder accepts and the renderer
  renders (#112).
- Markdown escaping now neutralizes setext heading underlines: a field value
  that is entirely `=` (any length) or entirely `-` (any length) is escaped at
  the line start, so user data can no longer promote the preceding rendered
  line into a forged heading (#108).
- `Period.SimpleDate` now validates `month` against the schema range (`1...12`)
  when decoding, so a bare `JSONDecoder` rejects malformed months (`0`, `13`,
  `-1`) consistently with the CLI's schema validator. `Period` rejects a
  reversed period (`start` later than `end`) at decode, equal periods collapse
  to a single rendered token, and the canonical Markdown renderer and JSON
  Resume export fall back to a valid year-only token instead of emitting a
  malformed `2024-13` ISO string (#109).
- Normalized JSON is deterministic for documents that omit IDs: the same input
  now produces byte-identical output across runs, so `--check` against the
  CLI's own output passes (#119).
- Skills no longer render twice when projects share a technology: skill
  deduplication keys on `name` and `category` instead of synthesized identity
  (#114).
- `CV.createFromProjects` merges all projects at the same-named company into a
  single experience entry even when each `Company` value was constructed
  separately, instead of splitting one employer into duplicate headings (#131).

## [0.9.0] - 2026-06-02

This is the first Markdown-first public release after the historical `0.1.0`
through `0.8.0` tags. Those older tags remain in the repository history.

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
