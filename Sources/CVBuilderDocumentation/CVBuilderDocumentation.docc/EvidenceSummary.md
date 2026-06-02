# Evidence Summary

First-pass research conclusions and the implementation rules they produced for CVBuilder's schema and renderer.

## Overview

This article summarizes the research-backed constraints for CVBuilder's
technical-CV schema and Markdown renderer. Related issues: #5, #6, #7, #8, #9,
#10, #11. Implementation target: #3.

CVBuilder should generate a publishable Markdown CV from structured data. It
should not perform PDF rendering and should not depend on a specific
static-site generator.

## First-Pass Findings

The first evidence pass reviewed scientific sources on resume screening,
structured application forms, recruiter attention, demographic cues, software
engineering hiring evidence, developer public traces, and resume parsing.

The strongest findings were:

- Resumes are weak and bias-prone partly because they are unstructured.
- Structured forms and typed fields are more defensible than freeform resume
  artifacts.
- Recruiters use resume information to form screening judgments, so relevant
  facts must be easy to locate.
- Technical resumes benefit from explicit experience, education, technologies,
  projects, and public technical evidence.
- Recruiters and automated systems can infer or amplify demographic and
  personality cues, so the renderer should avoid adding unnecessary cues.
- Resume parsing and information extraction literature favors predictable
  sections, explicit labels, and one reading order.

## Implementation Rules

### Canonical Model

- `CVDocument` or equivalent structured JSON is canonical.
- Markdown is a deterministic render target.
- Omitted arrays should decode as empty values.
- Hand-authored JSON should not require UUIDs; synthesize IDs on decode when
  omitted.
- `frontMatter: [String: String]` should be a generator-agnostic passthrough.
- Rendering must be deterministic so `--check` can compare exact output.

### Schema Coverage

The document model should represent:

- name, headline/title, summary, contact
- experience with organization, optional URL, location, title, dates, summary,
  highlights, technologies, nested projects/products
- education with institution, optional URL, degree, field, dates, details
- public technical evidence: open source, talks/speaking,
  publications/writing, app listings/products, package docs, project URLs
- grouped skills
- rendering options for experienced versus early-career ordering

### Default Technical CV Order

For experienced technical candidates:

1. `# Name`
2. optional `## Headline`
3. contact line
4. concise summary
5. `## Experience`
6. `## Education`
7. public technical evidence sections, only when present
8. `## Skills`
9. custom sections last

Early-career mode may move education, internships, and standalone projects
before experience.

### Experience Rendering

- Render roles as `### [Organization](url) (Start - End), Title`.
- Keep location as a simple text line.
- Keep accomplishments concise.
- Nest products/projects as `#### Project/Product Name` under the relevant job.
- Render technologies near the role/project where they were used.
- Do not rely on global skills as the only technology location.

### Technical Content Rules

- Prefer concrete evidence over trait claims.
- Show what was built, operated, improved, tested, migrated, secured,
  automated, or maintained.
- Support architecture, reliability, testing, performance, security,
  automation, developer tooling, mentoring, communication, and product/user
  impact.
- Summarize GitHub/open-source/public technical evidence in the CV; do not rely
  on reviewers clicking through.

Avoid:

- keyword stuffing
- visual skill bars
- fit scores
- personality labels
- culture-fit labels
- inferred seniority scores
- photos or icons as semantic data
- age, birthdate, nationality, marital status, or decorative demographic
  metadata

### Markdown and Parser Rules

- Emit plain CommonMark-compatible Markdown.
- Use one source-order reading path.
- Use predictable heading levels: `#`, `##`, `###`, `####`.
- Use explicit text labels for semantic information.
- Escape generated Markdown text and link destinations.
- Omit empty optional sections.
- Avoid tables for core facts until parser/rendering tests prove they are safe.
- Avoid semantic data in images, icons, hidden metadata, or renderer-specific
  layout directives.
- Do not target or game a specific ATS or LLM. Emit factual, low-noise,
  auditable Markdown.

## Deep Review Refinements

The deeper review in issue #10 did not reverse the first pass. It refined it:

- Public technical evidence needs structure, not just links.
- Public developer traces should not be scored.
- Technical role/focus tags should attach to concrete work.
- Demographic-cue minimization should be explicit.
- Single reading order is a hard renderer rule.
- Early-career mode should be supported.
- The renderer must remain transparent and non-scoring.

Suggested public evidence shape:

```jsonc
{
  "title": "Cupertino",
  "kind": "openSource",
  "role": "Maintainer",
  "summary": "Swift desktop automation toolkit with MCP integrations.",
  "url": "https://github.com/example/cupertino",
  "technologies": ["Swift", "MCP"],
  "date": "2026",
  "highlights": [
    "Maintained package structure",
    "Documented integration surface"
  ]
}
```

Suggested technical area field:

```jsonc
"technicalAreas": ["mobile", "architecture", "testing", "developer tooling"]
```

These tags must render near the relevant role/project, not as a detached
keyword dump.

## Test Requirements

Implementation should test:

- `CVDocument` round-trips
- UUIDs are optional on decode
- omitted arrays decode as empty
- renderer output has stable section ordering
- empty sections are omitted
- Markdown escaping covers headings, list markers, emphasis, links, tables,
  pipes, and URL destinations
- CLI renders Markdown from JSON
- `--check` exits non-zero when output differs
- public evidence renders with title, kind/role, summary, link, and technologies
- public evidence is omitted cleanly when empty
- technologies and technical areas render near the relevant role/project
- early-career ordering differs intentionally from experienced ordering
- no tables/columns/images are used for core facts
- repeated renders are byte-for-byte deterministic
- the renderer never emits prohibited scoring/personality/demographic fields
- Linux CI runs schema, renderer, and CLI tests
