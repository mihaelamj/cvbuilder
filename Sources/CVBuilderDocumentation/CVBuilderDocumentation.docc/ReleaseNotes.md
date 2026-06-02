# Release Notes: v1.0.0

What ships in `v1.0.0`, the first stable release of the CVBuilder package.

## Overview

These notes describe `v1.0.0`. It follows the `0.9.0` Markdown-first release and
the hardening that came after it, and it is the point at which the public API is
declared stable. Historical tags `0.1.0` through `0.9.0` remain in the
repository.

CVBuilder `v1.0.0` is a pure Swift, evidence-based technical CV generator for
macOS and Linux: typed `CVDocument` data in, deterministic Markdown out, with no
PDF, HTML, scoring, or layout magic.

## What Ships

- `CVDocument` as the canonical JSON data contract for publishable CV data.
- Deterministic, byte-stable Markdown rendering from structured Swift or JSON
  data; the same input always re-normalizes identically and passes `--check`.
- `cvbuilder` CLI: Markdown output, normalized JSON output, `--validate`,
  `--print-schema`, `--init`, stdin/stdout streaming, and `--check`.
- JSON Resume import (`--from json-resume`) and export (`--format json-resume`)
  with a documented round-trip guarantee and lossy-field inventory.
- Static-site front-matter profiles (generic, Toucan, Hugo, Jekyll) and
  rendering modes for experienced, early-career, and public-evidence-heavy CVs.
- Locale-selectable labels and deterministic, host-independent date formatting.
- Structured `Project.accomplishments` rendered verbatim, and an opt-in
  duration-period mode.
- Linux-only `CVBuilderTileDown` adapter for TileDown-compatible Markdown.
- A JSON Schema (`Schemas/cvdocument.schema.json`) kept in lockstep with the
  decoder, and renderer policy traced to research rules R01-R19 with enforcing
  tests.

## Breaking Changes Since 0.9.0

`v1.0.0` consolidates the API-affecting changes from the source-code audit and
declares the result stable:

- Model `id` fields are now optional (`UUID?`): an omitted id stays omitted in
  normalized JSON, and an explicit JSON `null` is rejected.
- `Period.start` and `Period.end` are optional (`SimpleDate?`); decoding
  validates the month range (1-12) and rejects a reversed period.
- `Tech` value identity is `name` plus `category`, and `Company` value identity
  is `name`, so deduplication and grouping key on content rather than identity.

See `CHANGELOG.md` for the complete list.

## Build

```sh
swift build
swift build --product cvbuilder
```

Run the CLI:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
swift run cvbuilder --data cv.json --out cv.normalized.json --format json
swift run cvbuilder --data cv.json --out cv/index.md --check
```

## Release Gates

The release commit must pass: style and namespacing, the platform contract
check, the Swift macOS and Swift Linux workflows, the schema drift check, the
generated-fixture freshness check, and the clean SwiftPM consumer smoke test. On
Linux, the consumer smoke test also imports `CVBuilderTileDown` and compares its
output with canonical Markdown.

## Product Boundary

This release is Markdown and JSON only. CVBuilder core does not include PDF or
HTML rendering, static-site generation, ATS scoring or parser-gaming hints, or
photos, demographic metadata, personality labels, culture-fit labels, fit
scores, skill bars, tables, or column layout in the canonical renderer.

## Source

Use `CHANGELOG.md` for the full change list and <doc:ReleaseChecklist> for the
release process.
