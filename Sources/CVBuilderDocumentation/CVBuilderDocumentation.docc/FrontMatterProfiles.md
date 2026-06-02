# Front Matter Profiles

How `RenderingOptions.frontMatterProfile` serializes `CVDocument.frontMatter` for common static-site generators.

## Overview

CVBuilder keeps `CVDocument.frontMatter` as a generator-agnostic string
dictionary. `RenderingOptions.frontMatterProfile` only controls how that
dictionary is serialized before the Markdown body.

Profiles do not add HTML rendering, site generation, theme selection, or
generator execution.

## Profiles

| JSON value | Format | Delimiters | Key order |
|---|---|---|---|
| `generic` | YAML-style scalar strings | `---` | Alphabetical |
| `toucan` | YAML | `---` | `title`, `description`, `date`, `tags`, `draft`, `slug`, `layout`, then custom keys |
| `hugo` | TOML | `+++` | `title`, `description`, `date`, `draft`, `slug`, `tags`, `categories`, `type`, `layout`, then custom keys |
| `jekyll` | YAML | `---` | `layout`, `title`, `permalink`, `date`, `tags`, `categories`, `published`, `slug`, then custom keys |

## Value Rules

All source values remain strings in `CVDocument.frontMatter`.

Profile rendering applies deterministic coercion for conventional keys:

- `draft` and `published` render as booleans only when the source value is
  exactly `true` or `false`, ignoring case and surrounding whitespace.
- `tags` and `categories` render as arrays by splitting the source value on
  commas and trimming whitespace.
- Other values render as quoted strings.
- Unknown keys are preserved and sorted after the profile's preferred keys.

The generic profile preserves the pre-profile behavior: every value renders as
a quoted string and every key is sorted alphabetically.

## CLI Override

The JSON field is the source-of-truth option:

```json
{
  "rendering": {
    "frontMatterProfile": "hugo"
  }
}
```

Use the CLI flag for a one-off render without editing the source document:

```sh
swift run cvbuilder --data cv.json --out cv/index.md --front-matter-profile hugo
```

The same override applies to normalized JSON output, so a publishing pipeline can
materialize the selected rendering profile deterministically.

## Source Notes

- Toucan documents front matter as a section at the top of Markdown enclosed
  between `---` lines, with reserved keys including `id`, `type`, `slug`, and
  `views`:
  [toucansites.com](https://toucansites.com/docs/content-management/front-matter/).
- Hugo documents front matter as page metadata and supports YAML, TOML, and JSON;
  TOML examples use `+++` delimiters, and common fields include `date`, `draft`,
  `title`, `description`, `slug`, and taxonomy arrays:
  [gohugo.io](https://gohugo.io/content-management/front-matter/).
- Jekyll documents YAML front matter between triple-dashed lines, with variables
  such as `layout`, `permalink`, `published`, `date`, `categories`, and `tags`:
  [jekyllrb.com](https://jekyllrb.com/docs/front-matter/).
