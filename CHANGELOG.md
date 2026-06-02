# Changelog

All notable changes to CVBuilder are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-06-03

First stable release. The public API is declared stable after the
first-principles source-code audit (#132) and the research-enrichment work
(#86, #98). See the release notes for the breaking-change summary since 0.9.0.

### Added

- `Project.accomplishments`: structured results-oriented accomplishment
  statements (action plus outcome), rendered verbatim after the project
  descriptions, with `Project.Builder` affordances
  (`withAccomplishments`/`addAccomplishment`). The renderer never inflates them
  or fabricates metrics (research rule R18).
- `RenderingOptions.useDurationPeriods`: an opt-in mode that renders a period as
  a whole-year duration (`3 yrs`) instead of a date range, derived only from the
  typed start and end. Inter-role gaps are still never computed (research rule
  R17).
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
- `Period.start` and `Period.end` are now optional (`SimpleDate?`), so an absent
  date is first-class instead of fabricated. The JSON Schema no longer requires
  `start`/`end` on a period, and the renderer shows the present bound (or
  `Present` for an ongoing role) without inventing a range.
- `Tech` value identity is now its `name` and `category`, and `Company` value
  identity is now its `name`, so deduplication and grouping key on the semantic
  fields rather than a per-instance identifier.

### Fixed

- Explicit `selectedExperienceIDs` is now authoritative over `recentCompanyCount`:
  when a selection is set, all selected work entries render in the curated order
  and the recency cap no longer silently truncates them. The cap still applies
  when no explicit selection is given (#115).
- Removed the unused, divergent `Period.formattedDateRange` (a `M/YYYY` layout
  inconsistent with the canonical `Mon YYYY` output) and documented
  `WorkExperience.formattedDateRange` as the intentionally English-only path for
  the deprecated `CVRendering` renderers (which have no locale). The canonical
  `Rendering.MarkdownDocumentRenderer` remains the localized source of truth
  (#118).
- The `CVBuilderDocumentation` target now depends on `CVBuilder` so DocC symbol
  links resolve, and macOS CI builds the catalog and fails on any DocC warning,
  so a broken reference no longer ships undetected (#127).
- The `CVBuilderTileDown` target and its contract test now compile and run on
  every platform (only the public product stays Linux-only), so adapter
  regressions are caught on the macOS dev platform; macOS CI builds the target
  (#128).
- Verification gates: `check-namespacing.sh` now counts a second file-scope type
  declared with any access / `final` / `open` / `actor` / `struct` combination
  (not only `final class`), and `check-platform-contract.sh` matches a real
  `.iOS(` declaration rather than the `.iOS` substring in a comment (#129).
- `--from json-resume --validate` now validates the converted `CVDocument`
  against the embedded schema (parity with the `cv-document` path) and rejects an
  empty or nameless resume instead of reporting it valid; a malformed file is
  reported as invalid JSON Resume, naming the format actually parsed (#113, #116).
- CLI validator fidelity: integer bounds are compared in integer space so the
  validator's view of a value beyond `Double` precision matches the decoder; a
  known boolean flag given a value (`--check=true`) reports "does not take a
  value" instead of "unknown option"; and an `anyOf(type, null)` field no longer
  reports the null branch's failure for a non-null value (#116).
- The standalone `## Projects` block is now a first-class, policy-ordered section
  instead of being welded onto the end of the Experience block, and it is drawn
  from the full experience so projects are not lost when the Experience section
  is filtered to empty by `recentCompanyCount`/`selectedExperienceIDs` (#122).
- Empty or whitespace fields no longer produce degenerate Markdown: a link with
  an empty label falls back to its destination as the visible text (never
  `[](url)`), a public-evidence item with an empty title and url falls back to
  its kind heading (never a bare `### `), and the education line emits only the
  present side of degree/field (never a dangling ` in ` connector) (#130).
- A project with the unset placeholder role no longer renders a
  `Role: Junior Unknown` line, and company-URL lookup tolerates trailing
  whitespace in the key so a heading still links (#125).
- `CV.createFromProjects` now sorts current companies ahead of finished ones, so
  an ongoing role rendered as "... - Present" appears at the top of the
  experience list instead of below older completed roles. The legacy
  `StringCVRenderer` ordering was aligned to match (#123).
- `CV.createFromProjects` now aggregates the projects' technical focuses into a
  deduplicated company-level `TechnicalFocus` and forwards each project's
  `technicalFocus` into its `ProjectExperience`, so the model preserves the
  focus data it was given (#124).
- Front-matter boolean and array coercion is now per-profile rather than global:
  Toucan and Hugo fold `draft`, Jekyll folds `published`, and a profile no longer
  mistypes a key it does not declare. Booleans accept the common static-site
  spellings (`true`/`false`, `yes`/`no`, `1`/`0`, `on`/`off`, case-insensitive);
  an unrecognized value renders as a quoted string instead of a wrong-typed one.
  The generic profile coerces nothing, documented and fixture-locked (#121).
- JSON Resume import no longer applies one employer's URL to another when two
  `work` entries share a `name`: a conflicting company URL is dropped for that
  name instead of corrupting the surviving entry, and same-name entries that
  share a URL keep it. Profile reordering and duplicate-profile drop are now
  documented as normalizing cases in the interop article (#117).
- JSON Resume seniority inference matches the leading position word
  case-insensitively, and export reconstructs the position without a fabricated
  `Mid` prefix or trailing space. A position with no recognized seniority word,
  a single-word position, and an absent or empty position now round-trip
  cleanly (#111).
- JSON Resume import no longer fabricates sentinel dates for absent optional
  dates. A `work`/`education`/`projects` entry missing `startDate` and/or
  `endDate` round-trips with those fields still absent, instead of emitting a
  fabricated `0001-01` or copying one bound onto the other (#110).
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
