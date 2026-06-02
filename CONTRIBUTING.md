# Contributing to CVBuilder

CVBuilder is a Pure Swift project. Core models, renderers, CLI, Linux adapter,
and tests must be Swift.

By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

```sh
bash scripts/check-style.sh
bash scripts/check-namespacing.sh
bash scripts/check-platform-contract.sh
bash scripts/check-release-version.sh
bash scripts/test-quality-gates.sh
bash scripts/check-generated-fixtures.sh
bash scripts/check-consumer-smoke.sh
swiftformat . --config .swiftformat --lint
swiftlint --config .swiftlint.yml --strict
swift build --target CVBuilder
swift build --target CVBuilderCLI
swift build --product cvbuilder
swift test
```

Run the CLI:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
```

On Linux, also verify the TileDown adapter:

```sh
swift build --target CVBuilderTileDown
```

## Constraints

- The core must build on macOS and Linux.
- `CVBuilderTileDown` is Linux-only and emits Markdown only.
- No PDF renderer in the core package.
- No ATS scoring, resume optimizer claims, personality labels, demographic
  labels, or inferred fit labels.
- No default Ignite or other HTML renderer dependency.
- No runtime shell-out to another renderer during rendering.
- Tests use Swift Testing.

## Issue Labels

The tracker uses exactly five labels (Apple system palette): `bug` (#FF3B30),
`enhancement` (#007AFF), `epic` (#AF52DE), `priority: high` (#FF3B30), and
`good first issue` (#34C759). The issue forms apply the kind (`bug` or
`enhancement`) at filing time. Do not add a sixth label unless it carries at
least three current issues and adds a genuinely orthogonal axis; record that
justification in the PR. Express finer topics (documentation, research, and so
on) in the issue title and body, not as labels.

## Commits

Commit messages follow Conventional Commits: `<type>(<scope>): summary`.
Examples: `feat(renderer): add evidence section`, `test(cli): cover check mode`.

Do not include AI attribution and do not use em dashes in commit messages or
committed files.

## Pull Requests

- Keep one focused change per PR.
- Add tests for behavior changes.
- Run `bash scripts/check-style.sh`, `bash scripts/check-namespacing.sh`,
  `bash scripts/check-platform-contract.sh`,
  `bash scripts/check-release-version.sh`,
  `bash scripts/test-quality-gates.sh`,
  `bash scripts/check-consumer-smoke.sh`,
  `bash scripts/check-generated-fixtures.sh`,
  `swiftformat . --config .swiftformat --lint`,
  `swiftlint --config .swiftlint.yml --strict`,
  `swift build --target CVBuilder`, `swift build --target CVBuilderCLI`,
  `swift build --product cvbuilder`, and `swift test`.
- Keep Linux CI green, especially when changing package products or TileDown
  behavior.
- Include a `## Roadmap` section that names the issue or phase the PR advances.
- Update README or docs when the user-facing contract changes.

## License

By contributing, you agree that your contributions are licensed under the
project's [MIT License](LICENSE).
