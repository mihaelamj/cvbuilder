# Roadmap

The product direction for `cvbuilder`: the Markdown-first goal, the non-goals, and the delivered phases.

## Overview

This roadmap defines the product direction for `cvbuilder`. It is intentionally
Markdown-first and Linux-safe. The package owns CV data, validation, and
deterministic Markdown generation. Other tools may consume that Markdown.

Catalog diagrams are color-coded; the legend below defines each class and is the
first diagram to read.

![Color legend for every catalog diagram](legend)

The delivery epics, in order. Shipped epics are gray; the current documentation
epic is in progress:

![Roadmap epics in delivery order](roadmap)

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

Landed on `main`:

- `CVDocument` schema for file-driven CV generation, with deterministic Markdown
  and normalized JSON from the `cvbuilder` CLI, and a `--check` mode.
- Linux-only `CVBuilderTileDown` adapter; default Ignite participation removed.
- Linux, macOS, style, namespacing, SwiftFormat, and SwiftLint gates on every PR.
- Community standards, issue and PR templates, support policy, and changelog.
- A realistic demo CV fixture exercising multi-role history, omitted older jobs,
  and explicit relevance-selected jobs.
- Release epics #47, #57, and #67 complete, including the `v0.9.0` publication
  proof. Research-conformance epic #76 (#74, #75) complete. Authoring and
  publishing epic #80 (#81-#84) complete: CLI authoring, front-matter profiles,
  JSON Resume interop, and localization. Source-code audit epic #132 (#108-#131)
  complete: deterministic identity and dates, escaping and empty-field guards,
  JSON Resume fidelity, validator parity, and packaging/CI gates.
  Standards-catch-up epic #98 (DocC catalog, Mermaid pipeline, doc-comment
  coverage, brutal-5 labels, R16-R19 enforcement) and research-enrichment epic
  #86 (#87-#94, R16-R19 plus qualifications) complete.

## Ordered Roadmap Issues

Every phase is shipped. The table is the canonical issue order.

| Phase | Issue | Deliverable |
|---:|---|---|
| 1 | #26 | Merge the Linux Markdown foundation. |
| 2 | #29 | Stabilize the `CVDocument` data contract. |
| 3 | #30 | Build technical CV rendering modes. |
| 4 | #31 | Document and harden the TileDown Markdown contract. |
| 5 | #32 | Add roadmap quality gates and release hygiene. |
| 6 | #40 | Expand realistic fixture coverage. |
| 7 | #19 | Add evidence-backed renderer fixture proofs. |
| 8 | #20 | Document the JSON workflow and research-backed boundaries. |
| 9 | #48 | Add user-facing CLI help output. |
| 10 | #49 | Add a machine-readable `CVDocument` JSON Schema. |
| 11 | #50 | Add schema drift checks for examples and fixtures. |
| 12 | #51 | Prepare first-release checklist and release notes. |
| 13 | #58 | Add tag-triggered release CI gates. |
| 14 | #61 | Align the package platform contract with supported platforms. |
| 15 | #60 | Add a clean SwiftPM consumer smoke test. |
| 16 | #59 | Prepare the changelog and release notes draft. |
| 17 | #68 | Reconcile release version docs with existing tag history. |
| 18 | #69 | Add release version consistency guard. |
| 19 | #70 | Prepare release publication proof for the reconciled version. |
| 20 | #74 | Make the public legacy CV render path R12/R15 conformant. |
| 21 | #75 | Add a research-conformance matrix mapping R01 to R15. |
| 22 | #81 | Add CLI authoring validation, scaffolding, schema printing, and stream IO. |
| 23 | #82 | Add static-site-generator front-matter profiles. |
| 24 | #83 | Add JSON Resume import and export interop. |
| 25 | #84 | Add deterministic rendered-output localization. |
| 26 | #132 | Resolve the first-principles source-code audit findings (#108-#131). |

## Phase Detail

Each phase below records its objective, the tracking issue, and its status. All
phases are merged to `main` with green Linux and macOS CI.

### Phase 1: Merge the Linux Markdown Foundation (#26)

Make the Markdown-only, Linux-safe package shape the base for all future work.
`Package.swift` exposes `CVBuilderTileDown` only on Linux; no PDF renderer and no
default Ignite dependency exist. Shipped.

### Phase 2: Stabilize the CV Data Contract (#29)

Make `CVDocument` the durable source of truth: every public field documented with
its Markdown behavior, fixtures for realistic variants, and schema tests for
missing, empty, and invalid nested data. A user can write one JSON file without
reading source. Shipped. See <doc:CVDocumentContract>.

### Phase 3: Build Technical CV Templates (#30)

Turn research findings into explicit rendering modes (experienced,
early-career, public-evidence-heavy), each with a named policy, a fixture, and
expected Markdown. Every template rule is either evidence-backed or marked a
pragmatic convention. Shipped. See <doc:RenderingModes>.

### Phase 4: Improve TileDown Automation (#31)

Make TileDown consumption predictable: document the Markdown contract, add a
TileDown fixture directory, and test adapter output against canonical Markdown.
Linux users import `CVBuilderTileDown` without Apple frameworks. Shipped. See
<doc:TileDownMarkdownContract>.

### Phase 5: Quality Gates and Release Hygiene (#32)

Keep Linux, macOS, style, namespacing, SwiftFormat, and SwiftLint on every PR;
add fixture-freshness checks; document local verification. Every PR names the
roadmap phase it advances. Shipped.

### Phase 6: Realistic Fixture Coverage (#40)

Expand `Examples/democv/cv.json` to multiple work entries and nested projects
with enough older work for omission and explicit-selection tests. Generated
fixtures are reproducible from source JSON. Shipped.

### Phase 7: Evidence Fixture Proofs (#19)

Add resource-backed early-career, hostile-Markdown, and minimal JSON fixtures,
and test privacy-safe decoding plus the evidence-backed renderer behaviors on
macOS and Linux. Shipped.

### Phase 8: Document the JSON Workflow and Research Boundaries (#20)

Document the JSON-to-Markdown workflow and what the renderer deliberately does
not generate, linking back to the proof matrix. Shipped. See <doc:JSONWorkflow>.

### Phase 9: Add CLI Help Output (#48)

Add `cvbuilder --help` and `-h` with options and examples; help exits
successfully without `--data` or `--out`. Shipped.

### Phase 10: Add a CVDocument JSON Schema (#49)

Add a checked-in JSON Schema reflecting the contract, with documented authoring
usage kept within the Markdown-only boundary. Shipped.

### Phase 11: Add Schema Drift Checks (#50)

Add a drift check (and CI run) so malformed or disconnected schema changes fail
verification. Shipped.

### Phase 12: Prepare First Release Checklist (#51)

Document first-release steps, required local and GitHub checks, and Markdown-only
boundaries. Shipped. See <doc:ReleaseChecklist>.

### Phase 13: Add Tag-Triggered Release CI Gates (#58)

Run Style, Swift macOS, and Swift Linux on `v*` tag pushes while leaving PR and
`main` triggers unchanged. Shipped.

### Phase 14: Align Package Platform Contract (#61)

Align `Package.swift` with documented platforms so metadata no longer implies
unsupported iOS support; no Apple UI or PDF dependency introduced. Shipped.

### Phase 15: Add Clean SwiftPM Consumer Smoke Test (#60)

Prove external consumption: a temporary package imports `CVBuilder` (and
`CVBuilderTileDown` on Linux), staying Markdown and JSON only. Shipped.

### Phase 16: Prepare Release Notes Draft (#59)

Move changelog content into a dated section, keep a fresh `Unreleased`, and draft
release notes that name the gates and avoid unsupported PDF/HTML/scoring claims.
Shipped. See <doc:ReleaseNotes>.

### Phase 17: Reconcile Release Version History (#68)

Reconcile release docs to `v0.9.0` while preserving the historical `0.1.0`
through `0.8.0` tag boundary without rewriting history. Shipped.

### Phase 18: Add Release Version Consistency Guard (#69)

Add a local and CI guard so stale mixed release versions fail, and a documented
next release cannot be lower than the historical tag boundary. Shipped.

### Phase 19: Prepare Release Publication Proof (#70)

Create the reconciled tag after green `main` checks, publish the GitHub Release,
and record tag-triggered workflow proof. Shipped. See <doc:ReleaseNotes>.

### Phase 20: Make Legacy CV Render Path Research-Conformant (#74)

Route `CVBuilderTileDown.Renderer().render(cv:)` and `MarkdownCVRenderer
.render(cv:)` through `Rendering.MarkdownDocumentRenderer`, deprecate the legacy
`CVRendering` renderers without deleting the compatibility APIs, and remove
`CV.convertTMarkdownAndSave`. Public `render(cv:)` escapes text, emits no
attribution footer, and is deterministic. Shipped. See <doc:CVDocumentContract>.

### Phase 21: Add Research-Conformance Matrix (#75)

Make every surviving research rule R01 through R15 traceable to code locations
and enforcing tests, with a completeness test that fails on missing or stale
references and no rendering changes. Shipped. See <doc:ConformanceMatrix>.

### Phase 22: Add CLI Authoring Experience (#81)

Add `--validate`, `--print-schema`, `--init <path>` with overwrite protection,
and stdin/stdout streaming, while keeping rendering behavior unchanged. Shipped.
See <doc:JSONWorkflow>.

### Phase 23: Add Static-Site Front-Matter Profiles (#82)

Add Toucan, Hugo, and Jekyll front-matter profiles with per-profile fixtures and
documented key mapping; default front matter unchanged; no HTML or templating
introduced. Shipped. See <doc:FrontMatterProfiles>.

### Phase 24: Add JSON Resume Interop (#83)

Add a typed JSON Resume model with documented mapping, lossy fields, and import,
export, and round-trip fixtures, introducing no ATS, scoring, or fit claims.
Shipped. See <doc:JSONResumeInterop>.

### Phase 25: Add Deterministic Localization (#84)

Add selectable label sets through rendering options and deterministic per-locale
date formatting, with at least one non-English locale fixture-backed end to end.
Default English output stays byte-for-byte stable; no layout changes or new
renderer backend. Shipped. See <doc:Localization>.

### Phase 26: Resolve the Source-Code Audit Findings (#132)

Fix the 24 findings (#108-#131) of the first-principles, four-round source-code
audit, at the root cause rather than per symptom: deterministic value identity
and serialization (optional `id`, content-based `Tech`/`Company` identity),
date-model validation and optional period bounds, JSON Resume round-trip
fidelity (absent dates, seniority, same-name employer URLs), empty/whitespace
guards before structural Markdown, validator/decoder parity, front-matter
coercion, section assembly, and the packaging/platform/CI gates. Each fix landed
with regression tests. Shipped.

Research remains input to renderer policy, not a marketing claim. Evidence
priority and the surviving rule set are documented in <doc:ResearchOverview> and
<doc:ProofMatrix>. The current conclusion: there is no magic universal best CV
template; structured, factual, job-relevant evidence matters most; single
source-order Markdown is safer than layout-driven semantics; demographic,
personality, and score-like signals should not be generated.

## Definition of Done

A roadmap item is done only when:

- implementation is merged to `main`
- Linux CI is green
- macOS CI is green
- tests cover the behavior
- a catalog article or README describes the user-facing contract
- linked GitHub issues are updated or closed

An open PR is progress, not done.
