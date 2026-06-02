# Maintaining the Docs

The contract that keeps this catalog in sync with the code: what to update when you change X, and what a reviewer must verify.

## Overview

This documentation catalog is the single source of truth for project-level
CVBuilder documentation. Every pull request that changes code MUST include the
matching catalog update in the same pull request. No exceptions.

A reviewer MUST block approval when code drifts from docs. If the "Update" column
is empty for a code change, either the article does not cover it yet (add it) or
the change is genuinely not doc-relevant (rare; the pull request description
records the judgment call).

## If You Change X, Update Y

| Change | Update | Reviewer check |
|---|---|---|
| Add or remove a SPM target or product in `Package.swift` | Landing page `## Configure and Run` and `## Topics`; <doc:Roadmap> ordered issue table | New product appears with its purpose; no removed product is still referenced. |
| Rename a public type or module (for example `CVDocument`, `Rendering.MarkdownDocumentRenderer`) | Every article naming the old symbol, plus any double-backtick symbol references to it | `grep -rn OldName` over the catalog returns no stale hits; the article filename matches any renamed symbol. |
| Add or change a `cvbuilder` CLI flag or command | <doc:JSONWorkflow>; landing page CLI listings; <doc:JSONResumeInterop> if it is a `--from`/`--format` value | The new flag has a worked example and the help text matches. |
| Add a top-level `CVDocument` key or change a default | <doc:CVDocumentContract> top-level or rendering-options table; `Schemas/cvdocument.schema.json` | The contract table row matches the schema; the default is stated. |
| Add a `PublicEvidenceKind`, `RenderingMode`, or other public enum case | <doc:CVDocumentContract> (kinds), <doc:RenderingModes> (modes); the JSON Schema enum | The new case appears in the relevant table with a one-line behavior note. |
| Add a locale to `RenderingLocale` | <doc:Localization> supported-locales table | The new BCP-47 code appears with its language and default flag; the schema parity note still holds. |
| Add a front-matter profile | <doc:FrontMatterProfiles> profiles and value-rules tables; <doc:JSONWorkflow> supported values | The profile row lists format, delimiters, and key order. |
| Change escaping, ordering, or any determinism behavior | <doc:CVDocumentContract> migration rules; <doc:ConformanceMatrix> (R12) | The determinism guarantee still reads true; the mapped test name is current. |
| Add, revise, or retire a research rule | <doc:ProofMatrix> first, then for an enforced rule (R01-R15) <doc:ConformanceMatrix> and the Swift rule mapping, then <doc:SourceMatrix> if a source changed | Each enforced rule R01-R15 still maps to at least one code location and one named test; R16-R19 stay evidence-only until they are wired in. |
| Change a release gate or the CI workflow | <doc:ReleaseChecklist> local and GitHub gate lists; <doc:ReleaseNotes> if a release ships | The gate list matches the workflow; no removed gate is still named. |
| Cut a release tag | <doc:ReleaseNotes> (new version section); <doc:ReleaseChecklist> proof; <doc:Roadmap> | The version is consistent across notes, checklist, README, and roadmap. |
| Add or change a diagram | The `.mmd` source under `Resources/diagrams/`; regenerate the `.png`; the article that embeds it; the legend if a new color class is introduced | The `.png` is regenerated from the committed `.mmd`; every color used appears in the legend; the diagram is `flowchart TD` (vertical). |
| Add a new article | Landing page `## Topics` (exactly one group) | The article is curated once; it starts with `# Title` and an abstract. |
| Add or change a `public` declaration | The `///` doc comment on the declaration, in the same commit | New public symbols carry a `///` paragraph (or a justified skip in the pull request). |

## Diagram Pipeline

Diagrams are color-coded, vertical (`flowchart TD`), and governed by a single
legend that is the first diagram every article shows.

- The `.mmd` file under
  `Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/Resources/diagrams/`
  is the single source of truth. The committed `.png` is a generated artifact,
  because DocC does not render Mermaid.
- Regenerate every PNG with `bash Scripts/render-diagrams.sh` (it shells out to
  `npx -y @mermaid-js/mermaid-cli`). Commit both the `.mmd` and the `.png`.
- The color classes are defined once in `legend.mmd` and reused by every other
  diagram. Add a class there before using a new color. Use only vertical
  (`flowchart TD`) layouts.

## Building and Previewing

Build the catalog and treat any DocC warning as a blocker (the only tolerated
warnings are the generic SPM "dependency is not used" notices):

```sh
swift package generate-documentation --target CVBuilderDocumentation
```

Preview with live reload on a free port (the default 8080 collides with common
dev servers):

```sh
swift package --disable-sandbox preview-documentation \
    --target CVBuilderDocumentation --port 8765
```

## Renames, Moves, and Deletions

When an article is renamed, moved, or deleted, inbound `<doc:>` references break
silently at build time. The pull request that renames is responsible for fixing
every inbound reference in the same commit.

- Grep the catalog for the old basename before renaming:
  `grep -rn 'doc:OldName' CVBuilderDocumentation.docc/`.
- Update every hit in the same pull request. No stub articles and no redirect
  shims; DocC does not support redirects.
- When deleting an article, remove it from the landing page `## Topics` section
  in the same commit.
