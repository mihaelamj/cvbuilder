# CVBuilder Roadmap

Status date: 2026-06-01

This roadmap defines the product direction for `cvbuilder`. It is intentionally
Markdown-first and Linux-safe. The package owns CV data, validation, and
deterministic Markdown generation. Other tools may consume that Markdown.

## Goal

Build `cvbuilder` as the canonical Swift library and CLI for creating technical
CV Markdown from structured data.

The long-term product should let a user keep one typed CV source of truth and
generate predictable Markdown for:

- personal sites
- TileDown publishing workflows
- checked-in CV pages
- recruiter-facing technical CV variants

## Non-goals

These are outside `cvbuilder`:

- PDF rendering
- ATS scoring
- resume-optimizer claims
- skill bars, personality labels, fit scores, or culture-fit labels
- static-site generation
- default dependencies on HTML renderers such as Ignite

If PDF output returns later, it belongs in a separate renderer or tool that
consumes Markdown or structured `CVDocument` data. It does not belong in the
core package.

## Current State

### Landed on `main`

- `CVDocument` schema exists for file-driven CV generation.
- `cvbuilder` CLI can render Markdown from JSON.
- `cvbuilder` CLI can emit normalized JSON.
- `--check` mode can verify checked-in output.
- Research documents live in `docs/research`.

### In PR

- PR #27 adds the Linux-only `CVBuilderTileDown` adapter.
- PR #27 removes default Ignite build participation.
- PR #27 keeps TileDown scoped to Markdown only.
- PR #27 has green Linux and macOS CI on the current head.

Relevant links:

- Issue #28: product roadmap epic with ordered child issues.
- Issue #3: file-driven CVBuilder implementation target.
- Issue #5: closed evidence research epic.
- Issue #26: Linux TileDown Markdown adapter.
- PR #27: Linux TileDown Markdown adapter implementation.

Ordered roadmap issues:

1. #26 - merge the Linux Markdown foundation.
2. #29 - stabilize the `CVDocument` data contract.
3. #30 - build technical CV rendering modes.
4. #31 - document and harden the TileDown Markdown contract.
5. #32 - add roadmap quality gates and release hygiene.

## Roadmap

### Phase 1: Merge the Linux Markdown Foundation

Objective: make the current Markdown-only, Linux-safe package shape the base for
all future work.

Deliverables:

- merge PR #27
- close issue #26 after merge
- keep GitHub Linux CI mandatory
- keep the CI guard that rejects `CVBuilderIgnite` in the Linux package graph
- keep `.claude/` and local generated artifacts out of commits

Acceptance:

- `swift test` passes on macOS
- Linux CI passes
- Claw Linux build and test pass when Linux-specific behavior changes
- `Package.swift` exposes `CVBuilderTileDown` only on Linux
- no PDF renderer exists in `Sources`
- no default Ignite dependency exists

### Phase 2: Stabilize the CV Data Contract

Objective: make `CVDocument` the durable source of truth for generated CVs.

Deliverables:

- document every public `CVDocument` field with expected Markdown behavior
- add fixture JSON files for realistic technical CV variants
- add schema tests for missing, empty, and invalid nested data
- add migration notes for future schema changes
- decide whether legacy `CV` rendering remains a compatibility path or becomes
  a thin adapter over `CVDocument`

Acceptance:

- a user can write one JSON file without reading source code
- generated Markdown is deterministic from that JSON
- invalid input fails with actionable CLI errors
- fixture tests prove all supported schema branches

### Phase 3: Build Technical CV Templates

Objective: turn the research findings into explicit rendering modes instead of
ad hoc Markdown tweaks.

Initial modes:

- experienced technical CV
- early-career technical CV
- public-evidence-heavy technical CV

Deliverables:

- template policy docs that map evidence rules to renderer behavior
- fixture Markdown snapshots for each mode
- tests for section order, heading levels, links, evidence summaries, and skill
  placement
- no hidden scoring or personality inference

Acceptance:

- each mode has a named rendering policy
- each mode has a fixture and expected Markdown output
- every template rule is either evidence-backed or marked as a pragmatic
  renderer convention

### Phase 4: Improve TileDown Automation

Objective: make TileDown consumption boring and predictable.

Deliverables:

- document the TileDown-compatible Markdown contract
- add a TileDown fixture directory with generated Markdown examples
- add tests that compare `CVBuilderTileDown.Renderer` output to canonical
  Markdown output
- clarify whether TileDown needs front matter conventions beyond current
  `CVDocument.frontMatter`

Acceptance:

- Linux users can import `CVBuilderTileDown` without Apple frameworks
- TileDown receives Markdown only
- output remains byte-for-byte deterministic
- TileDown integration does not pull in PDF, Ignite, or static-site generator
  dependencies

### Phase 5: Quality Gates and Release Hygiene

Objective: make regressions hard to ship.

Deliverables:

- keep Linux and macOS CI on every PR
- add a fixture freshness command if snapshots become checked in
- document local verification commands in README
- add issue-body links from roadmap phases to GitHub issues as they are filed
- add release notes when the first usable version is tagged

Acceptance:

- every PR says which roadmap phase it advances
- every production behavior change has tests
- every generated artifact can be reproduced from source data
- roadmap state is updated when a phase starts, lands, or changes scope

## Research Rules

Research remains input to renderer policy, not a marketing claim.

Evidence priority:

1. Peer-reviewed scientific articles.
2. Meta-analyses, systematic reviews, and well-cited academic surveys.
3. Technical papers only when stronger evidence is missing.
4. Vendor docs and recruiter advice only for examples or implementation risks.

Current research conclusion:

- there is no magic universal best CV template
- structured, factual, job-relevant evidence matters most
- single source-order Markdown is safer than layout-driven semantics
- technologies should attach to concrete work where possible
- public technical evidence should be summarized with context
- demographic, personality, and score-like signals should not be generated

## Definition of Done

A roadmap item is done only when:

- implementation is merged to `main`
- Linux CI is green
- macOS CI is green
- tests cover the behavior
- README or docs describe the user-facing contract
- linked GitHub issues are updated or closed

An open PR is progress, not done.
