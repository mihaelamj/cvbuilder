# CVBuilder

[![Style and namespacing](https://github.com/mihaelamj/cvbuilder/actions/workflows/style.yml/badge.svg)](https://github.com/mihaelamj/cvbuilder/actions/workflows/style.yml)
[![Swift macOS](https://github.com/mihaelamj/cvbuilder/actions/workflows/swift-macos.yml/badge.svg)](https://github.com/mihaelamj/cvbuilder/actions/workflows/swift-macos.yml)
[![Swift Linux](https://github.com/mihaelamj/cvbuilder/actions/workflows/swift-linux.yml/badge.svg)](https://github.com/mihaelamj/cvbuilder/actions/workflows/swift-linux.yml)

Follow project updates at [@diyamantina](https://x.com/diyamantina).

CVBuilder is a Pure Swift technical CV generator. It keeps CV data in typed
Swift or JSON, renders deterministic Markdown, and provides a Linux-facing
TileDown adapter for Markdown publishing workflows.

The core package is built for macOS and Linux. `CVDocument` is the canonical
source of truth for publishable CV data, front matter, links, public evidence,
and rendering options.

## Philosophy

CVBuilder starts from the one finding the personnel-selection literature agrees
on: a resume or CV is not a validated selection instrument. It is weak,
bias-prone, and partly unstructured, and treating it as a measurement of
candidate quality is unsupported. A CV generator must therefore not *pretend* to
produce a score. That single premise rules out skill bars, fit scores,
personality and culture-fit labels, inferred seniority, and ATS gaming before
any feature is designed.

What remains is a narrower, defensible job: keep the data structured and typed,
and render a clear, factual, low-noise, deterministic Markdown artifact that
makes job-relevant evidence easy to find, for both human readers and the parsers
and assistive technology that read on their behalf. Deterministic output, a
single clean reading order, escaped data, and proof-backed public evidence all
follow from that goal.

These are not opinions. Each renderer choice traces to peer-reviewed evidence or
is explicitly labelled a pragmatic convention. The research was gathered under a
documented review protocol (68 sources), audited rule by rule (keep, revise, or
downgrade, with folklore rejected explicitly), and the surviving proof-grade
rules are wired to named tests so policy drift fails the build. The full chain,
from founding premise to enforced contract, lives in the
[Research Overview](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/ResearchOverview.md)
and its source, proof, and conformance matrices.

## What Works Today

CVBuilder currently renders inspectable Markdown from structured CV data. The
output is deterministic, byte-for-byte testable, and intentionally conservative.

The generic renderer currently covers:

- Front matter for static site generators.
- Headings, paragraphs, links, and labelled text lines.
- Contact information, education, work experience, projects, skills, public
  evidence, and profile/download links.
- Rendering modes for experienced, early-career, and public-evidence-heavy
  technical CV ordering.
- Optional explicit ordered work-entry selection for relevant older jobs before
  recency limits are applied.
- JSON input with ergonomic defaults for missing optional arrays.
- Deterministic, byte-stable normalized JSON: optional `id` fields may be
  omitted and stay omitted, so the same input re-normalizes identically and
  `--check` passes.
- Model-boundary validation: `Period.SimpleDate` months are constrained to
  1 through 12 and reversed periods are rejected when decoding, matching the
  JSON Schema; field values cannot inject Markdown headings or thematic breaks.
- Content-based value identity: skills deduplicate by name and category, and
  same-named employers merge into one experience entry.
- JSON Resume import (`--from json-resume`) and export (`--format json-resume`).
- CLI output checks for checked-in generated Markdown.
- Linux TileDown compatibility through a Markdown-only adapter.

The compatibility target is structured technical CV data to Markdown. The
demo fixture now includes multi-role work history, nested projects, public
evidence, and omitted older jobs so template behavior is visible in tests.

## Package Products

| Product | Kind | Purpose |
|---|---|---|
| `CVBuilder` | Library | Core CV data model, document model, and Markdown/plain text renderers. |
| `CVBuilderTileDown` | Library | Linux-only Markdown adapter for TileDown workflows. |
| `cvbuilder` | Executable | `CVDocument` JSON file to Markdown or normalized JSON command. |

`CVBuilderTileDown` is available only when the package is built on Linux. iOS
support is not claimed.

## Quick Start

Use the document renderer directly:

```swift
import CVBuilder

let resume = CV(
    name: "Demo Candidate",
    title: "Senior Swift Engineer",
    summary: "Builds typed Swift tooling for document workflows.",
    contactInfo: ContactInfo(
        email: "demo.candidate@example.com",
        phone: "+1 555 010 0701",
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
    frontMatter: ["slug": "demo-cv", "title": "Demo CV"],
    cv: resume
)

let markdown = Rendering.MarkdownDocumentRenderer().render(document)
```

Use the Linux-facing product:

```swift
import CVBuilderTileDown

let markdown = CVBuilderTileDown.Renderer().render(document)
```

The TileDown adapter returns Markdown only. It does not run TileDown, render
PDF, render HTML, write files, or import Apple UI frameworks. The full adapter
contract is documented in the
[TileDown Markdown Contract](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/TileDownMarkdownContract.md)
catalog article.

Run the CV CLI:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
```

Validate a CVDocument without writing output:

```sh
swift run cvbuilder --data cv.json --validate
```

Print the checked-in JSON Schema:

```sh
swift run cvbuilder -- --print-schema
```

Create a starter JSON document:

```sh
swift run cvbuilder -- --init cv.json
```

Show CLI usage:

```sh
swift run cvbuilder -- --help
```

Write normalized JSON:

```sh
swift run cvbuilder --data cv.json --out cv.normalized.json --format json
```

Import a JSON Resume document and render Markdown:

```sh
swift run cvbuilder --data resume.json --from json-resume --out cv/index.md
```

Export a `CVDocument` to JSON Resume:

```sh
swift run cvbuilder --data cv.json --format json-resume --out resume.json
```

Check a generated Markdown file:

```sh
swift run cvbuilder --data cv.json --out cv/index.md --check
```

Compose through standard input and output:

```sh
cat cv.json | swift run cvbuilder --data - --out -
```

## JSON Input

The CLI reads one `CVDocument` JSON file. Missing optional arrays default to
empty values, and optional `id` fields may be omitted (an omitted `id` stays
omitted in normalized output, so the document re-normalizes byte-for-byte). This
small document is valid input:

```json
{
  "frontMatter": {
    "slug": "demo-cv",
    "title": "Demo CV"
  },
  "cv": {
    "name": "Demo Candidate",
    "title": "Senior Swift Engineer",
    "summary": "Builds typed Swift tooling for document workflows.",
    "contactInfo": {
      "email": "demo.candidate@example.com",
      "phone": "+1 555 010 0701",
      "location": "Example City"
    },
    "skills": [
      { "name": "Swift", "category": "language" },
      { "name": "Linux", "category": "platform" }
    ]
  }
}
```

The full data contract, Markdown behavior, decoding defaults, and migration
rules are documented in the
[CVDocument Contract](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/CVDocumentContract.md)
catalog article. A complete handwritten fixture lives at
[Examples/democv/cv.json](Examples/democv/cv.json). Editor-oriented schema
metadata lives at [Schemas/cvdocument.schema.json](Schemas/cvdocument.schema.json).
The file-driven authoring flow is documented in the
[JSON Workflow](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/JSONWorkflow.md)
catalog article.

## CVBuilder roadmap

Epic [#28](https://github.com/mihaelamj/cvbuilder/issues/28) tracks the product
roadmap. Epic [#12](https://github.com/mihaelamj/cvbuilder/issues/12) tracked
the evidence-backed implementation slices that hardened the renderer and JSON
workflow. Epic [#47](https://github.com/mihaelamj/cvbuilder/issues/47) completed
release-ready authoring and CLI usability. Epic
[#57](https://github.com/mihaelamj/cvbuilder/issues/57) completed first public
release hardening and tag proof. Epic
[#67](https://github.com/mihaelamj/cvbuilder/issues/67) reconciles release
version history before publication. Epic
[#80](https://github.com/mihaelamj/cvbuilder/issues/80) completed the
authoring and publishing experience. Epic
[#132](https://github.com/mihaelamj/cvbuilder/issues/132) completed the
first-principles source-code audit hardening (#108-#131): deterministic
identity and dates, escaping and empty-field guards, JSON Resume fidelity,
validator parity, and the packaging/CI gates.

```mermaid
flowchart TD
    P1["Phase 1<br/>#26 Linux Markdown foundation<br/>Done"]
    P2["Phase 2<br/>#29 CVDocument data contract<br/>Done"]
    P3["Phase 3<br/>#30 Technical CV rendering modes<br/>Done"]
    P4["Phase 4<br/>#31 TileDown Markdown contract<br/>Done"]
    P5["Phase 5<br/>#32 Quality gates and release hygiene<br/>Done"]
    P6["Phase 6<br/>#40 Realistic fixture coverage<br/>Done"]
    P7["Phase 7<br/>#19 Evidence fixture proofs<br/>Done"]
    P8["Phase 8<br/>#20 Workflow documentation<br/>Done"]
    P9["Phase 9<br/>#48 CLI help<br/>Done"]
    P10["Phase 10<br/>#49 JSON Schema<br/>Done"]
    P11["Phase 11<br/>#50 Schema drift checks<br/>Done"]
    P12["Phase 12<br/>#51 Release checklist<br/>Done"]
    P13["Phase 13<br/>#58 Release tag CI<br/>Done"]
    P14["Phase 14<br/>#61 Platform contract<br/>Done"]
    P15["Phase 15<br/>#60 Consumer smoke<br/>Done"]
    P16["Phase 16<br/>#59 Release notes draft<br/>Done"]
    P17["Phase 17<br/>#68 Version history docs<br/>Done"]
    P18["Phase 18<br/>#69 Version guard<br/>Done"]
    P19["Phase 19<br/>#70 Publish proof<br/>Done"]
    P20["Phase 20<br/>#74 Legacy CV path<br/>Done"]
    P21["Phase 21<br/>#75 Conformance matrix<br/>Done"]
    P22["Phase 22<br/>#81 CLI authoring<br/>Done"]
    P23["Phase 23<br/>#82 Front matter profiles<br/>Done"]
    P24["Phase 24<br/>#83 JSON Resume interop<br/>Done"]
    P25["Phase 25<br/>#84 Localization<br/>Done"]
    P26["Phase 26<br/>#132 Source-code audit hardening<br/>Done"]

    P1 --> P2 --> P3 --> P4 --> P5 --> P6 --> P7 --> P8 --> P9 --> P10 --> P11 --> P12 --> P13 --> P14 --> P15 --> P16 --> P17 --> P18 --> P19 --> P20 --> P21 --> P22 --> P23 --> P24 --> P25 --> P26

    classDef done fill:#e8f5e9,stroke:#2e7d32,color:#111;
    classDef active fill:#fff3e0,stroke:#ef6c00,color:#111;
    classDef review fill:#e8f0fe,stroke:#1a73e8,color:#111;
    classDef next fill:#fff8e1,stroke:#f9a825,color:#111;
    classDef partial fill:#e0f7fa,stroke:#00838f,color:#111;
    classDef todo fill:#eef3ff,stroke:#3367d6,color:#111;
    class P1,P2,P3,P4 done;
    class P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16 done;
    class P17 done;
    class P18 done;
    class P19 done;
    class P20 done;
    class P21 done;
    class P22 done;
    class P23 done;
    class P24 done;
    class P25 done;
    class P26 done;
```

See the [Roadmap](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/Roadmap.md)
catalog article for the full roadmap.

## Validation

The test suite validates generated Markdown through fixture and behavior checks:

- Snapshot-style expectations check section ordering, headings, links, escaping,
  evidence rendering, and checked-in rendering-mode fixtures.
- Demo fixture tests cover realistic nested projects, omitted older jobs, and
  explicit selection of relevant work entries.
- Resource-backed JSON fixtures cover minimal, early-career, hostile Markdown,
  and full senior technical CV documents.
- Hostile text tests ensure generated Markdown treats source data as data, not
  structure, including setext heading underlines that would otherwise forge a
  heading.
- JSON schema tests check defaults for omitted optional arrays, rejection of
  explicit invalid nulls, and rejection of out-of-range months and reversed
  periods at the decode boundary.
- Determinism tests assert that a document which omits IDs re-normalizes to
  byte-identical JSON across runs, and value-identity tests assert skills
  deduplicate by name and category and same-named employers merge.
- CLI tests check Markdown output, normalized JSON output, JSON Resume import
  and export, relative-URL acceptance, and stale-file detection.
- Linux-only TileDown tests compare adapter output to canonical Markdown output
  and the checked-in TileDown example.

## Build and Test

```sh
swift build --target CVBuilder
swift build --target CVBuilderCLI
swift build --product cvbuilder
swift test
```

The schema drift check validates the checked-in example and fixture JSON files
against the public `CVDocument` JSON Schema:

```sh
bash scripts/check-schema-drift.sh
```

The same core package is expected to build on macOS and Linux. GitHub CI runs
style, macOS Swift, and Linux Swift workflows.

Useful local checks from the repository root:

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
```

Every pull request also needs a `## Roadmap` section naming the issue or phase
it advances. CI enforces this on pull requests.

To check a draft PR body locally:

```sh
PR_BODY_FILE=/path/to/pr-body.md bash scripts/check-pr-roadmap.sh
```

On Linux, also verify the TileDown adapter:

```sh
swift build --target CVBuilderTileDown
```

## Documentation

Project documentation is a Swift-DocC catalog under
[`Sources/CVBuilderDocumentation`](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc).
It is the single source of truth and is the canonical, fully cross-linked
reading experience. Build it locally:

```sh
swift package generate-documentation --target CVBuilderDocumentation
swift package --disable-sandbox preview-documentation \
    --target CVBuilderDocumentation --port 8765
```

Repository policy and machine-readable files:

- [CHANGELOG.md](CHANGELOG.md): notable user-facing changes.
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): the Contributor Covenant standard for
  participation.
- [CONTRIBUTING.md](CONTRIBUTING.md): contribution rules and local checks.
- [SECURITY.md](SECURITY.md): how to report a vulnerability privately and the
  supported versions.
- [SUPPORT.md](SUPPORT.md): where to file bugs, feature requests, and security issues.
- [LICENSE](LICENSE): the project license.
- [Schemas/cvdocument.schema.json](Schemas/cvdocument.schema.json):
  machine-readable JSON Schema for editor validation and completion.
- [Examples/tiledown/democv.md](Examples/tiledown/democv.md): generated
  TileDown-oriented Markdown example.

Catalog articles (each renders in DocC; source Markdown is linked here):

- [Roadmap](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/Roadmap.md):
  product roadmap and ordered issue plan.
- [CVDocument Contract](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/CVDocumentContract.md):
  JSON contract, Markdown behavior, and migration rules.
- [JSON Workflow](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/JSONWorkflow.md):
  file-driven JSON to Markdown workflow, CI checks, SSG integration, and boundaries.
- [Rendering Modes](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/RenderingModes.md):
  rendering policy names, evidence mapping, and mode fixture coverage.
- [Front Matter Profiles](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/FrontMatterProfiles.md):
  generic, Toucan, Hugo, and Jekyll front matter profiles.
- [Localization](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/Localization.md):
  locale-selectable labels and deterministic dates.
- [TileDown Markdown Contract](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/TileDownMarkdownContract.md):
  Linux adapter guarantees, front matter behavior, and fixture workflow.
- [JSON Resume Interop](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/JSONResumeInterop.md):
  import and export mapping, round-trip guarantee, and lossy fields.
- [Release Checklist](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/ReleaseChecklist.md):
  Markdown-first release gates, tag process, and boundaries.
- [Release Notes](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/ReleaseNotes.md):
  notes for the first Markdown-first release tag.
- [Research Overview](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/ResearchOverview.md):
  the evidence behind renderer policy, organized from first principles, with the
  source, proof, and conformance matrices.
- [Maintaining the Docs](Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/MaintainingTheDocs.md):
  the if-you-change-X-update-Y contract and the diagram pipeline.

## Platform Boundaries

- Portable behavior means macOS and Linux.
- `CVBuilderTileDown` is a Linux target hook, not a separate renderer backend.
- TileDown receives Markdown only.
- `scripts/check-consumer-smoke.sh` proves a clean SwiftPM package can import
  public CVBuilder products before release.
- iOS support is not implemented or tested.
- `Package.swift` must not declare iOS support until that support is tested and
  documented.
- Research source snapshots, when present, are evidence only. They are not
  package dependencies.

## Design Constraints

- Pure Swift source.
- Deterministic Markdown generation from typed data.
- No runtime shell-out to another renderer during rendering.
- No PDF renderer in the core package.
- No ATS scoring, resume optimizer claims, personality labels, demographic
  labels, or inferred fit labels.
- No layout-driven Markdown tables, columns, image rendering, or photo handling
  in the canonical document renderer.
- No default Ignite or other HTML renderer dependency.
- Linux support through Foundation and Swift Package Manager.
- Small, testable public API.

## License

See [LICENSE](LICENSE).
