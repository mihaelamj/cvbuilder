# CVDocument Contract

Status date: 2026-06-02

`CVDocument` is the durable JSON contract for `cvbuilder`. The JSON document is
the source of truth. Markdown and normalized JSON are generated artifacts.

## Contract Goals

- A user can write one JSON file without writing Swift.
- Generated Markdown is deterministic from that JSON.
- Missing optional collections default to empty collections.
- Explicit `null` for required fields, IDs, and collections is invalid.
- Markdown rendering stays factual and conservative.
- Schema changes are additive unless a migration note and test prove otherwise.

## Top-Level Shape

| JSON key | Required | Default | Markdown behavior |
|---|---:|---|---|
| `frontMatter` | No | `{}` | Emits a YAML front matter block before the body. Keys are sorted. Values are escaped as single-line scalars. |
| `cv` | Yes | None | Supplies the document header, contact data, experience, education, and skills. |
| `links` | No | Empty link groups | `profiles` and `downloads` render in `## Links`. `companyURLs` links matching experience headings. |
| `publicEvidence` | No | `[]` | Renders `## Public Evidence` entries in source order. |
| `rendering` | No | Experienced technical defaults | Controls section order, project nesting, compaction, and empty-section behavior. |

## CV Core

The nested `cv` object contains the core resume facts:

| JSON key | Required | Default | Markdown behavior |
|---|---:|---|---|
| `id` | No | Synthesized UUID | Included only in normalized JSON. |
| `name` | Yes | None | Renders as `# Name`. |
| `title` | Yes | None | Renders below the name. |
| `summary` | Yes | None | Renders below the title. |
| `contactInfo` | Yes | None | Renders as `## Contact`. |
| `experience` | No | `[]` | Renders as `## Experience` when non-empty or when empty sections are enabled. |
| `education` | No | `[]` | Renders as `## Education` when non-empty or when empty sections are enabled. |
| `skills` | No | `[]` | Renders as `## Skills` when non-empty or when empty sections are enabled. |

All nested model IDs may be omitted by handwritten JSON. Omitted IDs are
synthesized during decoding and become visible when the CLI writes normalized
JSON.

## Links

| JSON key | Required | Default | Markdown behavior |
|---|---:|---|---|
| `profiles` | No | `[]` | Renders labelled links in `## Links`. |
| `downloads` | No | `[]` | Renders labelled links in `## Links`. |
| `companyURLs` | No | `{}` | Links matching work-experience company headings. |

Link destinations are strings, not decoded `URL` values. This preserves absolute
URLs, site-root paths, relative paths, and anchors until Markdown rendering.

## Public Evidence

Each `publicEvidence` item describes a public technical artifact.

| JSON key | Required | Default | Markdown behavior |
|---|---:|---|---|
| `id` | No | Synthesized UUID | Included only in normalized JSON. |
| `title` | Yes | None | Renders as an item heading linked to `url`. |
| `kind` | Yes | None | Renders as `Kind: ...`. |
| `role` | Yes | None | Renders as `Role: ...`. |
| `summary` | Yes | None | Renders as `Summary: ...`. |
| `url` | Yes | None | Link destination for the evidence title. |
| `technologies` | No | `[]` | Renders as `Technologies: ...` when non-empty. |
| `date` | No | `null` | Renders as `Date: ...` when non-empty. |
| `period` | No | `null` | Renders as `Period: ...` when `date` is absent. |
| `highlights` | No | `[]` | Renders each non-empty highlight in source order. |
| `technicalFocus` | No | `null` | Renders technical focus and tags when non-empty. |

Supported `kind` values are `openSource`, `talk`, `publication`, `app`,
`package`, `technicalWriting`, `project`, and `other`.

## Rendering Options

| JSON key | Required | Default | Markdown behavior |
|---|---:|---|---|
| `mode` | No | `experiencedTechnical` | Controls section order. |
| `recentCompanyCount` | No | Unlimited | Limits rendered work entries when positive. Non-positive values mean unlimited. |
| `selectedExperienceIDs` | No | `[]` | When non-empty, renders matching work-experience UUIDs in the supplied order, skips duplicates and unknown IDs, then applies `recentCompanyCount`. |
| `maxBulletsPerProject` | No | Unlimited | Limits project description paragraphs when positive. Non-positive values mean unlimited. |
| `nestProjectsUnderRoles` | No | `true` | Renders projects under each role. `false` moves projects to a standalone `## Projects` section. |
| `compactGroupedSkills` | No | `true` | Groups skills by category. `false` renders one skill per line. |
| `omitEmptySections` | No | `true` | Omits empty optional sections. `false` emits empty optional section headings. |

Supported `mode` values:

- `experiencedTechnical`: contact, experience, public evidence, skills,
  education, links.
- `earlyCareerTechnical`: contact, education, public evidence, experience,
  skills, links.
- `publicEvidenceHeavyTechnical`: contact, public evidence, experience, skills,
  education, links.

See [docs/rendering-modes.md](rendering-modes.md) for the policy names,
evidence mapping, and fixture coverage for each mode.

See [docs/json-workflow.md](json-workflow.md) for the file-driven CLI workflow,
`--check` usage, front matter passthrough, and static-site-generator boundary.

## Decoding Rules

- Missing optional collections default to empty.
- Missing optional objects default to `null` or documented defaults.
- Missing required fields fail decoding.
- Explicit `null` for required fields fails decoding.
- Explicit `null` for collections fails decoding. Omit the field or use `[]`.
- Unknown JSON keys are ignored by Swift decoding and are not emitted by
  normalized JSON.

The CLI reports decoding failures with a field path where `JSONDecoder` provides
one, for example `cv.contactInfo.email` or `cv.experience[0].company`.

## Legacy CV Rendering Decision

`CVDocument` is the canonical publishing contract. The `cvbuilder` CLI only
accepts `CVDocument` JSON.

`MarkdownCVRenderer` remains a compatibility path for Swift callers that already
hold a plain `CV`. It is not the schema contract and should not gain publishing
metadata. New publishing features belong on `CVDocument` and
`Rendering.MarkdownDocumentRenderer`.

## Migration Rules

- Add fields with defaults whenever possible.
- Add enum cases only with renderer and documentation updates in the same change.
- Do not rename or remove JSON keys without a migration note, fixture update, and
  test that proves the old failure or conversion behavior.
- Keep normalized JSON deterministic by using sorted keys in CLI output.
- Keep Markdown deterministic by preserving source order except where this
  contract explicitly states sorting, such as front matter keys.
- Update this document, `CHANGELOG.md`, and schema tests in the same change as
  any public contract change.

## Fixture

See `Examples/democv/cv.json` for a complete handwritten document with omitted
IDs, explicit work-experience IDs, links, multiple roles and projects, public
evidence, rendering options, and technical focus. The fixture intentionally
contains more work history than `recentCompanyCount` renders so tests can prove
older jobs are omitted from generated Markdown.

Additional test fixtures live under
`Tests/CVBuilderTests/Fixtures/Documents/`:

- `earlyCareerTechnical.json` proves education-first ordering and public
  evidence for early-career technical CVs.
- `hostileMarkdown.json` proves generated Markdown escapes source data instead
  of treating it as structure.
- `minimal.json` proves handwritten documents can omit optional arrays and IDs.
