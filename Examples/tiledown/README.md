# TileDown Example

This directory stores Markdown examples for TileDown-style publishing workflows.

- `democv.md` is generated from `Examples/democv/cv.json`.
- The output is Markdown only.
- The source of truth remains the JSON fixture.

Regenerate the example from the repository root:

```sh
swift run cvbuilder --data Examples/democv/cv.json --out Examples/tiledown/democv.md
```

Check that the example is fresh:

```sh
swift run cvbuilder --data Examples/democv/cv.json --out Examples/tiledown/democv.md --check
```

The contract is documented in the
[TileDown Markdown Contract](../../Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/TileDownMarkdownContract.md)
catalog article.
