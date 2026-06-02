# JSON Resume Interop

Field-level mapping, the round-trip guarantee, and the lossy fields when importing and exporting JSON Resume documents.

## Overview

CVBuilder can import and export documents in the
[jsonresume.org](https://jsonresume.org) schema while keeping `CVDocument` as the
canonical model. This article specifies the field-level mapping, the round-trip
guarantee, and the fields that are lossy in each direction.

This is pure data mapping. It introduces no scores, fit signals, rankings, or
parser-specific tricks, and adds no rendering backend. Imported documents render
through the existing `CVDocument` Markdown renderer.

## CLI

```sh
# Import a JSON Resume document and render Markdown.
cvbuilder --data resume.json --from json-resume --out cv/index.md

# Import a JSON Resume document and emit normalized CVDocument JSON.
cvbuilder --data resume.json --from json-resume --out cv.json --format json

# Export a CVDocument to a JSON Resume document.
cvbuilder --data cv.json --out resume.json --format json-resume
```

`--from` selects the input format (`cv-document`, the default, or
`json-resume`). `--format` selects the output format (`markdown`, the default,
`json`, or `json-resume`).

Programmatically, the conversions are exposed as `CVDocument(jsonResume:)` and
`JSONResume(cvDocument:)`.

## Round-Trip Guarantee

The two schemas hold different amounts of information. `CVDocument` is strictly
richer on the mapped subset: it carries role seniority, stable identifiers,
per-project structure, technical focus, rendering options, front matter, and
public-evidence kinds, none of which JSON Resume can represent. Exporting to
JSON Resume is therefore a projection onto a smaller space, and re-importing
cannot recover what the projection dropped. That loss is structural, not a
defect, and it is the reason the canonical model is not extended to absorb
JSON-Resume-shaped fields.

The guarantee is stated on the direction that *can* be lossless:

> Let `S` be the supported JSON Resume field subset (basics core, work,
> education, name-only skills, and projects). For any JSON Resume document `j`,
> importing then re-exporting yields `j` projected onto `S`, byte-for-byte after
> normalization (sorted keys, canonical `YYYY-MM` dates, empty fields omitted).
> Formally, `export(import(j)) = projection_S(j)`.

Sections and fields outside `S` are dropped on import and absent on re-export.
An absent optional `startDate` or `endDate` is preserved as absent: `Period`
carries optional bounds, so a missing date is never fabricated as a sentinel
(`0001-01`) or copied from the other bound, and it re-exports omitted.
The reverse direction (`import(export(d))`) is lossy and enumerated below.

`Tests/CVBuilderTests/Fixtures/JSONResume/roundtrip.json` is a fixed point of
this round-trip and is asserted byte-for-byte by the test suite.

## Structural Mapping

JSON Resume's two array sections map to two distinct `CVDocument` homes so the
import is injective and the round-trip stays well defined:

- `work[]` maps to `cv.experience[]`.
- `projects[]` maps to `publicEvidence[]`.

### basics

| JSON Resume | CVDocument | Notes |
| --- | --- | --- |
| `basics.name` | `cv.name` | |
| `basics.label` | `cv.title` | |
| `basics.summary` | `cv.summary` | |
| `basics.email` | `cv.contactInfo.email` | |
| `basics.phone` | `cv.contactInfo.phone` | |
| `basics.url` | `cv.contactInfo.website` | |
| `basics.location` | `cv.contactInfo.location` | Composed on import; see lossy notes. |
| `basics.profiles[]` | `cv.contactInfo.linkedIn` / `github`, else `links.profiles[]` | LinkedIn and GitHub become typed contact URLs; others become document links. |

LinkedIn and GitHub are matched case-insensitively by `network` name. Export
emits them first with the canonical names `LinkedIn` and `GitHub`, then the
remaining document links in order.

### work

| JSON Resume | CVDocument | Notes |
| --- | --- | --- |
| `work[].name` | `WorkExperience.company.name` | |
| `work[].position` | `WorkExperience.role` | Seniority inferred from a leading word and stripped from the title. |
| `work[].startDate` / `endDate` | `WorkExperience.period` | Empty `endDate` means `isCurrent`. |
| `work[].url` | `links.companyURLs[company]` | Links the company heading. |
| `work[].summary` + `highlights` | one synthesized nested project's `descriptions` | `summary` first, then `highlights`, so the renderer shows them and export splits them back. |

Seniority inference recognizes a leading `Intern`, `Junior`, `Mid`, `Senior`,
`Lead`, `Principal`, or `Chief` word, matched case-insensitively, in a
multi-word position. `Senior iOS Engineer` becomes seniority `.senior` with
title `iOS Engineer`; export rejoins them as `Senior iOS Engineer`, so the
position round-trips. A position with no recognized leading word, a single-word
position (including a lone seniority word such as `Principal`), and an absent or
empty position all default to `.mid`, and export emits the title alone, so they
round-trip without a fabricated `Mid` prefix or trailing space.

Three position cases are deliberately lossy or normalizing: a leading word
matched case-insensitively re-emits in canonical casing (`senior` becomes
`Senior`); internal runs of whitespace in the title collapse to a single space;
and an explicit leading `Mid ` is dropped on export, because it is
indistinguishable from the no-seniority default.

### education

| JSON Resume | CVDocument | Notes |
| --- | --- | --- |
| `education[].institution` | `Education.institution` | |
| `education[].studyType` | `Education.degree` | |
| `education[].area` | `Education.field` | |
| `education[].startDate` / `endDate` | `Education.period` | |

### skills

| JSON Resume | CVDocument | Notes |
| --- | --- | --- |
| `skills[].name` (no keywords) | one `Tech` | Round-trips. |
| `skills[].keywords[]` | one `Tech` per keyword | Group `name` and `level` are dropped. |

Export emits one skill per `Tech` using its name only; the `Tech` category is
not represented.

### projects

| JSON Resume | CVDocument | Notes |
| --- | --- | --- |
| `projects[].name` | `PublicEvidence.title` | |
| `projects[].description` | `PublicEvidence.summary` | |
| `projects[].highlights[]` | `PublicEvidence.highlights` | |
| `projects[].keywords[]` | `PublicEvidence.technologies` | |
| `projects[].startDate` / `endDate` | `PublicEvidence.period` | |
| `projects[].url` | `PublicEvidence.url` | |
| `projects[].roles[]` | `PublicEvidence.role` | First role only. |
| `projects[].type` | `PublicEvidence.kind` | Matched to a `PublicEvidenceKind` raw value, else `.project`. |

### dates

JSON Resume dates are ISO calendar strings (`YYYY-MM-DD`, `YYYY-MM`, or
`YYYY`). `CVDocument` stores month and year only. The day component is dropped,
a missing month defaults to January, and the canonical output form is
`YYYY-MM`. Only `YYYY-MM` inputs round-trip exactly.

### meta and unsupported sections

`volunteer`, `awards`, `certificates`, `publications`, `languages`,
`interests`, `references`, and `meta` have no `CVDocument` home. They are
ignored on import and never emitted on export.

## Lossy Fields

### Importing JSON Resume into CVDocument

These JSON Resume inputs do not round-trip byte-for-byte because they fall
outside the supported subset `S`:

- `basics.location` fields other than a single `city`. Import composes
  `city`, `region`, and `countryCode` (falling back to `address`) into one
  string; export writes the whole string back to `city`.
- `basics.profiles[].username`, which `CVDocument` does not store.
- Recognized-network casing other than `LinkedIn` and `GitHub` (for example
  `linkedin`), which export re-cases canonically.
- `skills[].level` and `skills[].keywords` group names.
- `work[].position` casing of a recognized leading seniority word (re-cased
  canonically), internal whitespace in the title (collapsed to single spaces),
  and an explicit leading `Mid ` (dropped, as it is indistinguishable from the
  no-seniority default).
- Dates in `YYYY-MM-DD` (day dropped) or `YYYY` (month defaulted to `01`).
- `projects[].entity`, which has no public-evidence home, and second and later
  `projects[].roles`.
- A `work[].url` when two or more entries share the same employer `name`: the
  company-URL map is keyed by name, so the last entry's URL wins.
- All sections outside `S` (`volunteer`, `awards`, `meta`, and so on). `meta` is
  modelled but dropped by the `CVDocument` conversion in both directions.

### Exporting CVDocument into JSON Resume

This direction is structurally lossy. The following `CVDocument` data has no
JSON Resume representation and is dropped on export:

- All `id` values (`UUID`s are regenerated on a later import).
- Role seniority beyond what the position string encodes. In particular, a
  `.mid` role whose `title` begins with a recognized seniority word (for example
  `Role(seniority: .mid, title: "Senior Engineer")`) exports as the bare title,
  so a later import infers that leading word as the seniority. `.mid` is the
  no-seniority default and is indistinguishable from an authored `.mid`.
- Per-project structure within a role: a role's nested projects are flattened
  into a single `summary` plus `highlights`, losing project boundaries, names,
  and per-project technologies, URLs, and dates.
- `TechnicalFocus` (areas and tags) everywhere it appears.
- `Tech.category`.
- `RenderingOptions` and `frontMatter`.
- `links.downloads` and `links.companyURLs` for companies absent from work.
- `PublicEvidence.date` when no `period` is present.

## Research Boundary

JSON Resume interop is an engineering and interoperability feature. There is no
peer-reviewed evaluation of structured machine-readable resume formats, so the
mapping makes no claim about hiring outcomes, parser behavior, or fit. The
export is covered by a test asserting it introduces no scoring, fit, ranking,
or demographic fields, consistent with rules R08, R09, and R15 in
<doc:ConformanceMatrix>.
