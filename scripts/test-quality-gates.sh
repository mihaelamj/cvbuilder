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
