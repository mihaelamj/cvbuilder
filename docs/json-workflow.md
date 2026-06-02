# JSON To Markdown Workflow

Status date: 2026-06-02

This document describes the supported file-driven CVBuilder workflow:

1. Write one `CVDocument` JSON file.
2. Generate deterministic Markdown with the `cvbuilder` CLI.
3. Commit both the source JSON and the generated Markdown when the site or
   publishing workflow expects checked-in output.
4. Use `--check` in CI to prove the Markdown is current.

`CVDocument` remains the source of truth. Markdown and normalized JSON are
generated artifacts.

## Boundary

CVBuilder owns structured CV data and Markdown generation. It is intentionally
static-site-generator agnostic.

CVBuilder does not:

- generate or render PDF
- render HTML
- create or publish a static site
- run TileDown
- infer candidate fit
- score candidates, skills, public evidence, or roles
- generate ATS or LLM gaming hints
- render photos, demographic metadata, personality labels, culture-fit labels,
  skill bars, tables, columns, or icon-only semantic labels in the canonical
  Markdown renderer

If another tool needs PDF, HTML, or a complete static site, that tool should
consume `CVDocument` data or the generated Markdown. It should not become a
default dependency of the core CVBuilder package.

`links.downloads` may point at externally generated assets, including PDFs.
CVBuilder can preserve and render those links as Markdown, but it does not
create the target assets.

## Authoring File

Start with a handwritten JSON file. Omit optional arrays and IDs when they do
not add value. The decoder synthesizes IDs for model types when JSON omits
them, and the CLI can write normalized JSON if you need to inspect the fully
expanded document.

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

The full field contract is in
[cvdocument-contract.md](cvdocument-contract.md). A complete senior technical
fixture is in [Examples/democv/cv.json](../Examples/democv/cv.json).

For editor completion or validation, use the checked-in JSON Schema at
[Schemas/cvdocument.schema.json](../Schemas/cvdocument.schema.json). The schema
describes the public `CVDocument` contract only; it does not add rendering
targets or scoring behavior.

To verify that the checked-in examples and fixtures still match the schema, run:

```sh
bash scripts/check-schema-drift.sh
```

## Generate Markdown

Generate Markdown from the JSON file:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
```

The command creates parent directories for `--out` when needed and writes one
Markdown file. Markdown output includes a trailing newline.

To compose in shell pipelines, read from stdin with `--data -` and write to
stdout with `--out -`:

```sh
cat cv.json | swift run cvbuilder --data - --out -
```

## Validate Input

Validate a `CVDocument` without writing generated output:

```sh
swift run cvbuilder --data cv.json --validate
```

Validation checks the input against the public JSON Schema, then decodes it as
`CVDocument`. Schema failures report JSON paths such as
`$.cv.experience[0].period.start.month`; decode failures use the same
coding-path diagnostics as rendering, such as `cv.contactInfo.email`.

## Print The JSON Schema

Print the canonical schema to stdout:

```sh
swift run cvbuilder -- --print-schema
```

The command emits the same bytes as
[Schemas/cvdocument.schema.json](../Schemas/cvdocument.schema.json), so editors
and CI can retrieve the schema through the CLI.

## Scaffold A Starter Document

Create the minimal starter document shown in this guide:

```sh
swift run cvbuilder -- --init cv.json
```

`--init` refuses to overwrite an existing file. Pass `--force` only when you
intend to replace it:

```sh
swift run cvbuilder -- --init cv.json --force
```

## Check Generated Output

Use `--check` to fail when checked-in Markdown is stale:

```sh
swift run cvbuilder --data cv.json --out cv/index.md --check
```

`--check` does not write files. It renders the expected output in memory, reads
the file at `--out`, and exits non-zero when the bytes differ or when the file
is missing.

A typical repository workflow is:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
git diff -- cv/index.md
swift run cvbuilder --data cv.json --out cv/index.md --check
```

The same pattern is used by
[scripts/check-generated-fixtures.sh](../scripts/check-generated-fixtures.sh)
for the checked-in demo output.

## Write Normalized JSON

Use normalized JSON when you want to inspect synthesized IDs, sorted keys, and
decoder defaults:

```sh
swift run cvbuilder --data cv.json --out cv.normalized.json --format json
```

The normalized JSON is deterministic. Treat it as a generated artifact unless
your project deliberately chooses it as the checked-in authoring format.

## Front Matter Passthrough

`frontMatter` is a string dictionary. The Markdown renderer emits it before the
body as YAML-style front matter:

```json
{
  "frontMatter": {
    "layout": "cv",
    "slug": "demo-cv",
    "title": "Demo CV"
  }
}
```

CVBuilder sorts front matter keys before rendering and escapes scalar values as
single-line strings. It does not validate static-site-generator-specific keys.
That is deliberate: Hugo, Jekyll, TileDown, custom site builders, and checked-in
Markdown workflows can each consume their own keys without CVBuilder knowing
their full site model.

## Static Site Integration

A static site can keep the source JSON beside the generated Markdown:

```text
content/
  cv/
    cv.json
    index.md
```

Generate the Markdown:

```sh
swift run cvbuilder --data content/cv/cv.json --out content/cv/index.md
```

Then let the site generator consume `content/cv/index.md`. CVBuilder does not
run the site generator, choose a theme, inject layouts, or publish the site.

For TileDown-oriented workflows, see
[tiledown-markdown-contract.md](tiledown-markdown-contract.md). The TileDown
adapter is Markdown-only and Linux-only.

## Rendering Modes

Set `rendering.mode` when the default section order is not the right technical
CV shape:

```json
{
  "rendering": {
    "mode": "earlyCareerTechnical"
  }
}
```

Supported modes:

- `experiencedTechnical`: contact, experience, public evidence, skills,
  education, links.
- `earlyCareerTechnical`: contact, education, public evidence, experience,
  skills, links.
- `publicEvidenceHeavyTechnical`: contact, public evidence, experience, skills,
  education, links.

Mode policies and evidence mapping are documented in
[rendering-modes.md](rendering-modes.md).

## Public Technical Evidence

Use `publicEvidence` for public artifacts that help a reader inspect technical
work with context:

```json
{
  "publicEvidence": [
    {
      "title": "Contract Tooling Package",
      "kind": "package",
      "role": "Maintainer",
      "summary": "Maintains a Swift package that generates typed clients from checked-in OpenAPI contracts.",
      "url": "https://example.com/contract-tooling",
      "technologies": ["Swift", "OpenAPI"],
      "date": "2026"
    }
  ]
}
```

Public evidence is factual context. The renderer does not assign points,
rankings, inferred seniority, or fit labels to public artifacts.

## Research Boundary

The implementation rules come from the research documents in
[docs/research](research/README.md). The primary implementation map is
[cvbuilder-proof-matrix.md](research/cvbuilder-proof-matrix.md).

The research supports a narrow product claim:

- structured CV data is the source of truth
- Markdown should be deterministic and source ordered
- technical evidence should attach to concrete work
- public evidence should include a summary and link
- demographic, personality, culture-fit, score-like, and ATS-gaming signals
  should not be generated

The research does not prove a universal best CV template. CVBuilder exposes
rendering modes so different technical CV contexts can choose explicit section
ordering without pretending that ordering is a candidate-quality score.
