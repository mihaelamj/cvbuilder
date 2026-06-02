# Release Checklist

The Markdown-first release gates, tag process, and the boundaries a CVBuilder release must preserve.

## Overview

This checklist prepares a Markdown-first CVBuilder release tag. It does not
expand the product boundary. CVBuilder remains a pure Swift, Markdown-first
library and command-line tool.

Historical tags `0.1.0` through `0.9.0` remain in the repository. The first
stable release uses a `v1.0.0` tag so it is newer than the historical
`0.8.0` boundary and matches the `v*` tag-triggered workflows.

## Release Boundary

The Markdown-first release includes:

- `CVDocument` as the canonical JSON data contract.
- deterministic Markdown generation from `CVDocument`.
- normalized JSON output from the `cvbuilder` CLI.
- `--check` mode for stale generated Markdown or JSON.
- `CVBuilderTileDown` as a Linux-safe Markdown adapter.
- checked-in example data and generated Markdown fixtures.
- JSON Schema authoring metadata for `CVDocument`.
- schema drift checks for examples and fixtures.

The Markdown-first release does not include:

- PDF generation or rendering.
- HTML rendering.
- static-site generation or publishing.
- default Ignite participation.
- ATS scoring, resume optimizer claims, or parser gaming hints.
- photos, demographic metadata, personality labels, culture-fit labels, fit
  scores, skill bars, tables, or column layout in the canonical renderer.

## Local Release Gates

Run these from the repository root before creating a tag:

```sh
bash scripts/check-style.sh
bash scripts/check-namespacing.sh
bash scripts/check-platform-contract.sh
bash scripts/check-release-version.sh
bash scripts/test-quality-gates.sh
bash scripts/check-schema-drift.sh
bash scripts/check-generated-fixtures.sh
bash scripts/check-consumer-smoke.sh
swiftformat . --config .swiftformat --lint
swiftlint --config .swiftlint.yml --strict
swift build
swift build --target CVBuilder
swift build --target CVBuilderCLI
swift build --product cvbuilder
swift test
```

The release is not ready if any command fails or produces uncommitted fixture
changes.

The release-version guard checks that the top dated changelog section, release
notes file, release checklist commands, README, and roadmap agree on the
reconciled release tag. It also rejects a documented release version that is not
newer than the historical `0.8.0` boundary.

On Linux, also run:

```sh
swift build --target CVBuilderTileDown
```

`CVBuilderTileDown` is a Linux target hook and is proved by the Swift (Linux)
GitHub workflow for release tags.

## GitHub Release Gates

The release commit on `main` must have these checks green:

- Style and namespacing
- Swift (macOS)
- Swift (Linux)

The macOS and Linux workflows run the Swift test suite, the schema drift check,
generated fixture freshness checks, and clean SwiftPM consumer smoke checks.
Linux also proves the package graph keeps `CVBuilderTileDown`, proves
`CVBuilderTileDown` can be imported by a clean consumer package, and does not
reintroduce default `CVBuilderIgnite` participation. The release-gate workflows
run on pull requests, pushes to `main`, manual dispatch, and `v*` tag pushes.

## Changelog Prep

Before tagging:

1. Move the `CHANGELOG.md` `Unreleased` content into a dated version section.
2. Keep a fresh empty `Unreleased` section above the release section.
3. Confirm the release notes mention the Markdown-only boundary and do not imply
   PDF, HTML, static-site generation, scoring, or optimizer behavior.
4. Confirm the public release notes do not contain draft status text,
   publication instructions, or maintainer-only process language.
5. Confirm the changelog names the CLI, JSON Schema, schema drift checks,
   generated fixture freshness, consumer smoke checks, and Linux CI support.
6. Confirm the release notes match the final release commit.

For the first stable release, the expected tag is `v1.0.0` unless the
maintainer chooses a different SemVer version.

## Tag and Publish

After the release commit is on `main` and GitHub checks are green:

```sh
git fetch origin main
git switch main
git pull --ff-only origin main
git tag -a v1.0.0 -m "CVBuilder v1.0.0"
git push origin v1.0.0
```

Then create a GitHub Release for the tag. Release notes should include:

- install or build command: `swift build`
- CLI examples for Markdown, normalized JSON, and `--check`
- schema authoring entry point: `Schemas/cvdocument.schema.json`
- release gates that passed: style, macOS Swift, Linux Swift, schema drift, and
  generated fixture freshness
- boundary note: Markdown and JSON only, no PDF, HTML, scoring, or static-site
  generation in core CVBuilder

## Post-Release Check

After publishing:

1. Confirm the tag points at the intended `main` commit.
2. Confirm the GitHub Release links to the generated source archive.
3. Confirm `README.md` and the catalog still describe the released behavior.
4. Open a follow-up issue for any release note correction instead of rewriting
   history.

## Published Release Proof

The predecessor `0.9.0` release was published on 2026-06-02. The first stable
`v1.0.0` release was published on 2026-06-03. The GitHub Release and the
tag-triggered Style, Swift macOS, and Swift Linux workflow runs are linked from
<doc:ReleaseNotes>.
