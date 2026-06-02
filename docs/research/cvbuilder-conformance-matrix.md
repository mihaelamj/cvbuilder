# CVBuilder Research Conformance Matrix

Status date: 2026-06-02

Related issues: #75, #76, #11, #3

This document makes the surviving research rules from
`cvbuilder-proof-matrix.md` traceable to implementation files and enforcing
tests. The matrix is not a new research claim. It is a regression contract:
each surviving rule R01 through R15 must have at least one implementation
location and at least one named test.

`ResearchConformanceMatrixTests` checks this document against the Swift-side
rule mapping. The test fails when a rule is missing, a code path no longer
exists, or a referenced test name is stale.

## Matrix

| Rule ID | Short rule text | Code locations | Enforcing tests |
|---|---|---|---|
| R01 | Structured `CVDocument` data is canonical; Markdown is generated. | `Sources/CVBuilder/Document/CVDocument.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift` | `document preserves front matter, links, evidence, and technical focus`<br>`runner renders Markdown from CVDocument JSON`<br>`runner re-emits normalized JSON` |
| R02 | Technical CV output uses one source-order reading path. | `Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Policy.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `experienced mode renders the proof-backed document shape`<br>`rendering modes match checked-in Markdown fixtures` |
| R03 | Experienced technical mode leads with experience. | `Sources/CVBuilder/Document/RenderingMode.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Policy.swift` | `experienced and early-career modes use different ordering`<br>`democv fixture proves senior technical rendering behavior` |
| R04 | Early-career technical mode can place education and projects earlier. | `Sources/CVBuilder/Document/RenderingMode.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Policy.swift` | `early career fixture promotes education before experience`<br>`experienced and early-career modes use different ordering` |
| R05 | Projects and products nest under the job where the work happened. | `Sources/CVBuilder/Document/RenderingOptions.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `experienced mode renders the proof-backed document shape`<br>`democv fixture proves senior technical rendering behavior`<br>`positive rendering limits constrain work entries and project descriptions` |
| R06 | Technologies attach to concrete roles, projects, or evidence. | `Sources/CVBuilder/WorkExperience.swift`<br>`Sources/CVBuilder/Project.swift`<br>`Sources/CVBuilder/ProjectExperience.swift`<br>`Sources/CVBuilder/Document/PublicEvidence.swift`<br>`Sources/CVBuilder/Document/TechnicalFocus.swift` | `document preserves front matter, links, evidence, and technical focus`<br>`public evidence carries context beyond a link`<br>`experienced mode renders the proof-backed document shape` |
| R07 | Public technical evidence includes summary context, not only a link. | `Sources/CVBuilder/Document/PublicEvidence.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `public evidence carries context beyond a link`<br>`experienced mode renders the proof-backed document shape` |
| R08 | Public developer traces are optional and never scored. | `Sources/CVBuilder/Document/PublicEvidence.swift`<br>`Sources/CVBuilder/Document/RenderingOptions.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift` | `renderer omits visual scoring demographic and table artifacts`<br>`rendering options express ordering without scores` |
| R09 | Do not render skill bars, fit scores, personality labels, or culture-fit labels. | `Sources/CVBuilder/Document/RenderingOptions.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift` | `renderer omits visual scoring demographic and table artifacts`<br>`rendering options express ordering without scores` |
| R10 | Avoid photos, icon-only semantic labels, and demographic metadata by default. | `Sources/CVBuilder/Document/CVDocument.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift` | `renderer omits visual scoring demographic and table artifacts`<br>`required document fixtures decode, render, and remain privacy safe` |
| R11 | Avoid tables, columns, and images for core facts unless parser tests prove safety. | `Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `renderer omits visual scoring demographic and table artifacts`<br>`renderer keeps TileDown integration Markdown only`<br>`hostile text is escaped as data, not Markdown structure` |
| R12 | Markdown escaping and deterministic rendering are required. | `Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Escaping.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `rendering is byte-for-byte deterministic`<br>`hostile text is escaped as data, not Markdown structure`<br>`unsafe link destinations are encoded consistently`<br>`front matter keys and scalar values are quoted and single-line` |
| R13 | Global skills stay compact and grouped near the end by default. | `Sources/CVBuilder/Document/RenderingOptions.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `checked-in JSON Schema covers document sections and authoring defaults`<br>`rendering modes match checked-in Markdown fixtures`<br>`non-compact skills are escaped as an engineering invariant` |
| R14 | Technical focus tags attach to actual work instead of becoming keyword stuffing. | `Sources/CVBuilder/WorkExperience.swift`<br>`Sources/CVBuilder/ProjectExperience.swift`<br>`Sources/CVBuilder/Document/TechnicalFocus.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift` | `document preserves front matter, links, evidence, and technical focus`<br>`democv fixture proves senior technical rendering behavior`<br>`early career fixture promotes education before experience` |
| R15 | Do not optimize for a specific ATS or LLM; emit factual, low-noise, auditable Markdown. | `Sources/CVBuilder/Document/RenderingOptions.swift`<br>`Sources/CVBuilder/Rendering/MarkdownCVRenderer.swift`<br>`Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift` | `renderer omits visual scoring demographic and table artifacts`<br>`legacy CV-only Markdown renderer remains available`<br>`renderer keeps TileDown integration Markdown only` |

## Maintenance

When a renderer policy changes, update this matrix in the same PR as the code
or test change. A rule may map to more than one test, but it may not map to
zero tests. If the project intentionally weakens or retires a research rule,
change `cvbuilder-proof-matrix.md` first, then update this matrix and the test
mapping in the same PR.
