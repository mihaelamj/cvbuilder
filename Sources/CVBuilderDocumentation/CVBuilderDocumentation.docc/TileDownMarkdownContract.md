# TileDown Markdown Contract

The Linux-facing `CVBuilderTileDown` adapter: guarantees, front matter behavior, and fixture workflow.

## Overview

`CVBuilderTileDown` is the Linux-facing adapter for TileDown publishing
workflows. The adapter is deliberately small: it turns `CVDocument` data into a
Markdown string and stops there.

## Product Boundary

`CVBuilderTileDown` is available only when the Swift package is built on Linux.
It depends on `CVBuilder` and no other package product. It does not import
TileDown, Ignite, PDF libraries, Apple UI frameworks, or static-site generators.

The adapter exists so a Linux workflow can do this:

1. Load or construct a `CVDocument`.
2. Render deterministic Markdown with `CVBuilderTileDown.Renderer`.
3. Hand the returned Markdown string to TileDown or another Markdown consumer.

TileDown receives Markdown only. File writing, site generation, HTML rendering,
and PDF rendering are outside this package.

## Renderer Guarantees

| API | Output | Guarantee |
|---|---|---|
| `CVBuilderTileDown.Renderer().render(document)` | `String` | Delegates to `Rendering.MarkdownDocumentRenderer` and preserves canonical Markdown behavior. |
| `CVBuilderTileDown.Renderer().render(cv:)` | `String` | Wraps the `CV` in a default `CVDocument` and delegates to `Rendering.MarkdownDocumentRenderer`, preserving canonical escaping and no-footer output. |

The `CVDocument` overload is the publishing contract. It preserves front matter,
profile links, download links, public evidence, and rendering options. The
legacy `CV` overload is compatibility only; it does not add front matter,
document links, public evidence, or custom rendering options, but it still uses
the canonical renderer's escaping and deterministic Markdown behavior.

## Front Matter

Front matter comes from `CVDocument.frontMatter` and is serialized according to
`CVDocument.rendering.frontMatterProfile`.

- Missing front matter emits no front matter block.
- The generic profile keeps the legacy YAML-style string behavior.
- Toucan, Hugo, and Jekyll profiles use the canonical Markdown renderer's
  profile-specific delimiters, key ordering, and value coercion.
- The TileDown adapter does not add, remove, or rename front matter keys.
- The TileDown adapter does not override the selected front matter profile.
- TileDown-specific conventions should be represented as ordinary `frontMatter`
  keys in the source `CVDocument`.

The adapter does not parse or validate TileDown configuration. That boundary is
intentional: `cvbuilder` owns CV data and Markdown generation, while TileDown or
the surrounding workflow owns publishing configuration.

See <doc:FrontMatterProfiles> for delimiters, key ordering, and value coercion.

## Markdown Shape

The adapter emits the same Markdown as `Rendering.MarkdownDocumentRenderer`:

- Front matter when present, serialized according to
  `RenderingOptions.frontMatterProfile`.
- One `#` document heading for the candidate name.
- `##` sections for contact, experience, public evidence, skills, education,
  and links according to `RenderingOptions.mode`.
- `###` work, education, and public evidence entries.
- `####` project entries when projects are nested under roles.
- Labelled text lines for dates, roles, technologies, focus areas, and tags.

The canonical renderer keeps core CV facts out of tables, columns, images, and
layout-only structures. That makes the output easier to inspect, test, and pass
to downstream Markdown tooling.

## Determinism

For the same `CVDocument`, the adapter output must be byte-for-byte identical to
the canonical Markdown renderer output. Tests compare:

- `CVBuilderTileDown.Renderer().render(document)`
- `Rendering.MarkdownDocumentRenderer().render(document)`
- `Examples/tiledown/democv.md`

The checked-in example is generated from `Examples/democv/cv.json`.

## Fixture Workflow

Regenerate the TileDown example from the repository root:

```sh
swift run cvbuilder --data Examples/democv/cv.json --out Examples/tiledown/democv.md
```

Verify it is fresh:

```sh
swift run cvbuilder --data Examples/democv/cv.json --out Examples/tiledown/democv.md --check
```

On Linux, verify the adapter target:

```sh
swift build --target CVBuilderTileDown
swift test
```

## Non-goals

`CVBuilderTileDown` does not:

- render PDF
- render HTML
- run TileDown
- write files
- create a static site
- import Apple frameworks
- add default Ignite participation
- score resumes or infer candidate traits
