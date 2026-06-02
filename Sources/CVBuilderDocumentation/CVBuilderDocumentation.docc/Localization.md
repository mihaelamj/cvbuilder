# Localization

How `RenderingOptions.locale` renders non-English section labels and dates while keeping output byte-for-byte deterministic.

## Overview

CVBuilder can render a `CVDocument` with non-English section labels, field
labels, and month names while keeping output byte-for-byte deterministic. The
candidate's own data (name, summary, descriptions) is never translated; only the
strings the renderer itself emits are localized.

Localization applies to the canonical `Rendering.MarkdownDocumentRenderer`
driven by `RenderingOptions.locale`. The deprecated `CVRendering` renderers
(`StringCVRenderer`, `ConsoleCVRenderer`) are English-only and ignore the
locale.

## Selecting a Locale

Set `rendering.locale` in the document, or `RenderingOptions(locale:)` in code:

```json
{
  "cv": { "...": "..." },
  "rendering": { "locale": "de" }
}
```

```swift
let options = RenderingOptions(locale: .german)
```

Supported locales:

| `locale` | Language | Default |
| --- | --- | --- |
| `en` | English | yes |
| `de` | German | no |

When `locale` is omitted it defaults to `en`, and English output is identical to
every prior release (byte-for-byte stable).

## What Gets Localized

- Section headings: Contact, Experience, Education, Public Evidence, Skills,
  Links, Projects.
- Contact and entry field labels: Email, Phone, Location, Website, Role, Kind,
  Date, Period, Summary, Technologies, Technical focus, Technical tags.
- Skill-category labels and public-evidence kind labels.
- Month abbreviations and the ongoing-role token (English `Present`, German
  `Heute`).
- The degree-to-field connector in education entries.

Brand names (`LinkedIn`, `GitHub`) and widely-used loanwords (`App`,
`Frameworks`, `Tags`, `Website`) are kept as-is by convention.

## Determinism

Localization never consults the host `Locale` or `Calendar`. Each locale maps to
a fixed `RenderingLabels` set with an explicit month-name array, so the same
document and locale always produce identical Markdown on any machine. Dates keep
the `Mon YYYY` layout and the `Start - End` range form; only the month names and
the ongoing-role token differ between locales. Out-of-range months fall back to
an ISO `YYYY-MM` form independent of the locale.

Each locale has a checked-in fixture and golden Markdown under
`Tests/CVBuilderTests/Fixtures/Localization/`, asserted byte-for-byte, and the
locale enum is kept in lockstep with the JSON Schema by a drift test.

## Adding a Locale

1. Add a case to `RenderingLocale` with its BCP-47 code as the raw value.
2. Return a complete `RenderingLabels` set from `RenderingLocale.labels`.
3. Add the raw value to the `locale` enum in `Schemas/cvdocument.schema.json`
   **and** to the embedded copy in
   `Sources/CVBuilderCLI/CVBuilderCLI.SchemaDocument.swift`; the two must stay
   byte-identical, which the `--print-schema` parity test enforces.
4. Add a fixture plus golden Markdown and a rendering test.
