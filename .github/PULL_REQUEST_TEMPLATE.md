<!-- One focused change per PR. If the diff spans two unrelated concerns, split it. -->

## What

<!-- What does this change do? -->

## Why

<!-- Why is it needed? Link the issue it closes, e.g. Closes #123. -->

## How to verify

<!-- Commands or steps a reviewer can run. -->

```sh
bash scripts/check-style.sh
bash scripts/check-namespacing.sh
swiftformat . --config .swiftformat --lint
swiftlint --config .swiftlint.yml --strict
swift build --target CVBuilder
swift build --target CVBuilderCLI
swift build --product cvbuilder
swift test
```

## Checklist

- [ ] Style and namespacing checks pass.
- [ ] SwiftFormat and SwiftLint pass.
- [ ] Build and tests pass.
- [ ] Linux behavior is verified when package products or TileDown behavior change.
- [ ] README or docs updated for user-facing contract changes.
- [ ] CHANGELOG.md updated under Unreleased, or this change is docs/tests/config only.
- [ ] No AI attribution and no em dashes in commits, comments, or this description.
