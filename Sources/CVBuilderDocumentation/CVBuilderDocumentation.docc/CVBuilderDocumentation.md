# ``CVBuilderDocumentation``

@Metadata {
    @DisplayName("CVBuilder")
}

Deterministic, Markdown-first technical CV generation in pure Swift.

## Overview

CVBuilder turns a typed `CVDocument` into byte-for-byte deterministic Markdown.
The `CVDocument` JSON file is the source of truth; Markdown and normalized JSON
are generated artifacts. The core package builds on macOS and Linux, and a
Linux-only `CVBuilderTileDown` adapter hands the same Markdown to TileDown
publishing workflows.

The renderer is intentionally conservative. It emits one linear document with
predictable `#`, `##`, `###`, and `####` headings and labelled text lines. It
does not render PDF or HTML, does not generate a static site, and does not emit
scores, skill bars, personality labels, culture-fit labels, photos, or
demographic metadata. Those boundaries are not arbitrary: they trace to the
peer-reviewed evidence collected in <doc:ResearchOverview>.

Every diagram in this catalog is color-coded. The legend below defines each
class once; read it first, then every other diagram is self-explanatory.

![Color legend for every catalog diagram](legend)

The end-to-end pipeline, from a typed source of truth to the generated artifacts
and the downstream consumers that read them:

![Authoring-to-output pipeline](pipeline)

## Configure and Run

Clone the repository and build the package:

```sh
git clone https://github.com/mihaelamj/cvbuilder.git
cd cvbuilder
swift build
```

Render Markdown from a `CVDocument` JSON file:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
```

Build this documentation catalog locally:

```sh
swift package generate-documentation --target CVBuilderDocumentation
```

Preview it in the browser with live reload on a free port:

```sh
swift package --disable-sandbox preview-documentation \
    --target CVBuilderDocumentation --port 8765
```

## Author a CV in JSON

A minimal `CVDocument` needs only a `cv` object; optional arrays and IDs may be
omitted and are synthesized on decode.

```json
{
  "frontMatter": { "slug": "demo-cv", "title": "Demo CV" },
  "cv": {
    "name": "Demo Candidate",
    "title": "Senior Swift Engineer",
    "summary": "Builds typed Swift tooling for document workflows.",
    "contactInfo": {
      "email": "demo.candidate@example.com",
      "location": "Example City"
    },
    "skills": [
      { "name": "Swift", "category": "language" },
      { "name": "Linux", "category": "platform" }
    ]
  }
}
```

The full field contract is in <doc:CVDocumentContract>, and the file-driven CLI
workflow, including `--check`, validation, and scaffolding, is in
<doc:JSONWorkflow>.

## Render from Swift

The document renderer is a small public API:

```swift
import CVBuilder

let document = CVDocument(
    frontMatter: ["slug": "demo-cv", "title": "Demo CV"],
    cv: resume
)
let markdown = Rendering.MarkdownDocumentRenderer().render(document)
```

On Linux, the same Markdown is available through the TileDown adapter:

```swift
import CVBuilderTileDown

let markdown = CVBuilderTileDown.Renderer().render(document)
```

The adapter returns Markdown only. Its full contract is in
<doc:TileDownMarkdownContract>.

## Choose a Rendering Mode

`RenderingMode` selects the section order without scoring or inferring anything.
The three modes differ only in where each section appears:

```json
{ "rendering": { "mode": "earlyCareerTechnical" } }
```

The policies, evidence basis, and fixture coverage are in <doc:RenderingModes>.
Front-matter dialects for static-site generators are in
<doc:FrontMatterProfiles>, and locale-selectable labels in <doc:Localization>.

## Topics

### Essentials

- <doc:JSONWorkflow>
- <doc:CVDocumentContract>
- <doc:RenderingModes>

### Output and Localization

- <doc:FrontMatterProfiles>
- <doc:Localization>

### Integration

- <doc:TileDownMarkdownContract>
- <doc:JSONResumeInterop>

### Research and Evidence

- <doc:ResearchOverview>
- <doc:DeepReviewProtocol>
- <doc:SourceMatrix>
- <doc:ProofGradeAudit>
- <doc:ProofMatrix>
- <doc:ConformanceMatrix>
- <doc:EvidenceSummary>

### Project and Release

- <doc:Roadmap>
- <doc:ReleaseChecklist>
- <doc:ReleaseNotes>
- <doc:MaintainingTheDocs>
