# Rendering Modes

Status date: 2026-06-01

`RenderingMode` selects the section-order policy for generated technical CV
Markdown. It does not score candidates, infer traits, add demographic metadata,
or optimize for a specific parser. The source of truth remains `CVDocument`.

The evidence basis is tracked in
[docs/research/cvbuilder-proof-matrix.md](research/cvbuilder-proof-matrix.md).
Rules marked evidence-backed or evidence-informed in this document must trace to
that matrix. Rules marked pragmatic renderer convention are product choices used
to keep Markdown deterministic and easy to consume.

## Mode Policies

| JSON value | Policy name | Section order | Use when |
|---|---|---|---|
| `experiencedTechnical` | Experienced technical CV | Contact, Experience, Public Evidence, Skills, Education, Links | Substantial work history should lead the factual record. |
| `earlyCareerTechnical` | Early-career technical CV | Contact, Education, Public Evidence, Experience, Skills, Links | Education and public work need earlier visibility. |
| `publicEvidenceHeavyTechnical` | Public-evidence-heavy technical CV | Contact, Public Evidence, Experience, Skills, Education, Links | The candidate's public technical artifacts are the clearest evidence to inspect first. |

## Evidence-Backed Behavior

| Rule | Evidence status | Concrete output behavior |
|---|---|---|
| Use one source-order reading path. | Evidence-backed for parser structure. | The renderer emits one linear Markdown document with `#`, `##`, `###`, and `####` headings. It does not use columns or layout-only ordering. |
| Lead experienced technical CVs with experience. | Evidence-informed from recruiter and computer-science resume studies. | `experiencedTechnical` renders `## Experience` before `## Education`. |
| Move education earlier for early-career candidates. | Evidence-informed from early-career screening evidence. | `earlyCareerTechnical` renders `## Education` before `## Experience`. |
| Attach technologies and technical focus to concrete work. | Evidence-backed by technical-hiring and developer-profile studies. | Project entries render `Technologies`, `Technical focus`, and `Technical tags` near the project. Public evidence renders the same fields near the artifact. |
| Summarize public technical evidence. | Evidence-backed by technical-hiring and public-developer-trace studies. | Public evidence entries render a linked title, kind, role, date or period, summary, technologies, focus, tags, and highlights. |
| Do not score public traces. | Evidence-backed caution from public-developer-data validity studies. | Public evidence is rendered as factual context only. No score, rank, or inferred seniority is emitted. |
| Avoid trait, fit, score, and demographic signals. | Evidence-backed for bias and personality-inference risk. | The renderer does not emit skill bars, fit scores, personality labels, culture-fit labels, photos, birthdate, nationality, marital status, or inferred demographic metadata. |
| Keep core facts out of tables and images. | Evidence-backed for parser structure, with a test escape hatch. | The canonical renderer emits headings and labelled lines, not tables, columns, images, or icon-only labels for core facts. |
| Do not target a specific screening system. | Evidence-informed caution. | Output is factual, low-noise Markdown with stable labels rather than keyword stuffing or vendor-specific hints. |

## Pragmatic Renderer Conventions

These rules are not claimed as proven hiring effects:

| Convention | Concrete output behavior |
|---|---|
| Header first. | The candidate name, title, and summary render before all `##` sections. |
| Contact first. | Every mode starts with `## Contact` when contact fields are present. |
| Links last. | Profile and download links render in `## Links` at the end so they do not interrupt core evidence. |
| Skills near the end. | `## Skills` stays compact and grouped by category. This is a readability convention, not a proven ranking signal. |
| Projects nested under roles by default. | `nestProjectsUnderRoles` defaults to `true` so work evidence stays near the role where it happened. |
| Empty optional sections omitted by default. | `omitEmptySections` defaults to `true` so absent data does not create misleading headings. |
| Public-evidence-heavy ordering is explicit. | `publicEvidenceHeavyTechnical` promotes `## Public Evidence` after contact, but does not imply public work is required or scored. |

## Fixture Coverage

The renderer has checked-in expected Markdown fixtures for every policy:

- `Tests/CVBuilderTests/Fixtures/RenderingModes/experiencedTechnical.md`
- `Tests/CVBuilderTests/Fixtures/RenderingModes/earlyCareerTechnical.md`
- `Tests/CVBuilderTests/Fixtures/RenderingModes/publicEvidenceHeavyTechnical.md`

The tests compare generated output from `Examples/democv/cv.json` to these
fixtures. The same test pass also checks heading levels, links, evidence
summaries, skill placement, and the absence of duplicated seniority text.
