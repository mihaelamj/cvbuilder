#!/usr/bin/env bash
# Self-tests for repository quality gate scripts.

set -eu

VALID_BODY='## What

Adds a quality gate.

## Roadmap

Advances #32 under epic #28.

## Checklist

- [x] Checked.
'

MISSING_ROADMAP_BODY='## What

Adds a quality gate.
'

PLACEHOLDER_BODY='## Roadmap

<!-- Name the roadmap issue or phase this advances, e.g. Advances #32 under epic #28. -->

## Checklist
'

PR_BODY="$VALID_BODY" bash scripts/check-pr-roadmap.sh

if PR_BODY="$MISSING_ROADMAP_BODY" bash scripts/check-pr-roadmap.sh 2>/dev/null; then
  echo "quality-gates: missing Roadmap section was accepted" >&2
  exit 1
fi

if PR_BODY="$PLACEHOLDER_BODY" bash scripts/check-pr-roadmap.sh 2>/dev/null; then
  echo "quality-gates: placeholder Roadmap section was accepted" >&2
  exit 1
fi

ROOT=$(pwd)
PLATFORM_TMP=$(mktemp -d)
trap 'rm -rf "$PLATFORM_TMP"' EXIT

cat > "$PLATFORM_TMP/Package.swift" <<'SWIFT'
let packagePlatforms: [SupportedPlatform] = [
    .macOS(.v13),
]
SWIFT

(cd "$PLATFORM_TMP" && bash "$ROOT/scripts/check-platform-contract.sh")

cat > "$PLATFORM_TMP/Package.swift" <<'SWIFT'
let packagePlatforms: [SupportedPlatform] = [
    .macOS(.v13),
    .iOS(.v16),
]
SWIFT

if (cd "$PLATFORM_TMP" && bash "$ROOT/scripts/check-platform-contract.sh" 2>/dev/null); then
  echo "quality-gates: unsupported iOS platform declaration was accepted" >&2
  exit 1
fi

cat > "$PLATFORM_TMP/Package.swift" <<'SWIFT'
let packagePlatforms: [SupportedPlatform] = [
]
SWIFT

if (cd "$PLATFORM_TMP" && bash "$ROOT/scripts/check-platform-contract.sh" 2>/dev/null); then
  echo "quality-gates: missing macOS platform declaration was accepted" >&2
  exit 1
fi

RELEASE_ROOT="$PLATFORM_TMP/release"
mkdir -p "$RELEASE_ROOT/docs/release-notes"

cat > "$RELEASE_ROOT/CHANGELOG.md" <<'MARKDOWN'
# Changelog

## [Unreleased]

## [0.9.0] - 2026-06-02
MARKDOWN

cat > "$RELEASE_ROOT/README.md" <<'MARKDOWN'
[docs/release-notes/v0.9.0.md](docs/release-notes/v0.9.0.md)
MARKDOWN

cat > "$RELEASE_ROOT/docs/roadmap.md" <<'MARKDOWN'
The release is v0.9.0.
MARKDOWN

cat > "$RELEASE_ROOT/docs/release-checklist.md" <<'MARKDOWN'
Confirm `docs/release-notes/v0.9.0.md`.
Historical tags end at the historical `0.8.0` boundary.
git tag -a v0.9.0 -m "CVBuilder v0.9.0"
git push origin v0.9.0
MARKDOWN

cat > "$RELEASE_ROOT/docs/release-notes/v0.9.0.md" <<'MARKDOWN'
# CVBuilder v0.9.0 Release Notes

CVBuilder `v0.9.0` ships Markdown.
MARKDOWN

RELEASE_CHECK_ROOT="$RELEASE_ROOT" bash "$ROOT/scripts/check-release-version.sh"

RELEASE_STALE_ROOT="$PLATFORM_TMP/release-stale"
cp -R "$RELEASE_ROOT" "$RELEASE_STALE_ROOT"
printf '%s\n' 'stale v0.1.0 reference' >> "$RELEASE_STALE_ROOT/README.md"

if RELEASE_CHECK_ROOT="$RELEASE_STALE_ROOT" bash "$ROOT/scripts/check-release-version.sh" 2>/dev/null; then
  echo "quality-gates: stale release version was accepted" >&2
  exit 1
fi

RELEASE_LOW_ROOT="$PLATFORM_TMP/release-low"
cp -R "$RELEASE_ROOT" "$RELEASE_LOW_ROOT"

cat > "$RELEASE_LOW_ROOT/CHANGELOG.md" <<'MARKDOWN'
# Changelog

## [Unreleased]

## [0.8.0] - 2026-06-02
MARKDOWN

if RELEASE_CHECK_ROOT="$RELEASE_LOW_ROOT" bash "$ROOT/scripts/check-release-version.sh" 2>/dev/null; then
  echo "quality-gates: release version at historical boundary was accepted" >&2
  exit 1
fi
