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

Profile rendering applies deterministic coercion that is specific to each
profile's declared key contract, not global:

- Boolean keys are `draft` (Toucan, Hugo) and `published` (Jekyll). A profile
  folds only the boolean key it declares, so it never mistypes a key another
  profile owns (Hugo has no `published`; Jekyll has no `draft`).
- A boolean value is recognized case-insensitively from the common
  static-site-generator spellings: `true`/`false`, `yes`/`no`, `1`/`0`, and
  `on`/`off`. Any other value renders as a quoted string rather than guessing a
  boolean.
- Array keys are `tags` (Toucan, Hugo, Jekyll) and `categories` (Hugo, Jekyll).
  A declared array key splits the source value on commas, trims whitespace, and
  always renders as a sequence (an empty or separator-only value renders as an
  empty array, never a string).
- Other values render as quoted strings.
- Unknown keys are preserved and sorted after the profile's preferred keys.

The generic profile coerces nothing: every value renders as a quoted string and
every key is sorted alphabetically. A value such as `draft` or `tags` is
therefore a typed boolean or array under an SSG profile but a quoted string
under generic, by design.

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
