#!/usr/bin/env bash
# Verifies release-version documentation stays internally consistent.

set -u

ROOT="${RELEASE_CHECK_ROOT:-$(pwd)}"
HISTORICAL_LATEST_VERSION="0.8.0"
FAIL=0

fail() {
  echo "release-version: $1" >&2
  FAIL=1
}

require_file() {
  if [ ! -f "$ROOT/$1" ]; then
    fail "missing required file: $1"
  fi
}

require_contains() {
  file="$1"
  pattern="$2"
  message="$3"

  if ! grep -qF "$pattern" "$ROOT/$file" 2>/dev/null; then
    fail "$message"
  fi
}

version_component() {
  version="$1"
  component_index="$2"

  printf "%s" "$version" | awk -F. -v component_index="$component_index" '{ print $component_index + 0 }'
}

version_greater_than() {
  left="$1"
  right="$2"

  i=1
  while [ "$i" -le 3 ]; do
    left_component=$(version_component "$left" "$i")
    right_component=$(version_component "$right" "$i")

    if [ "$left_component" -gt "$right_component" ]; then
      return 0
    fi
    if [ "$left_component" -lt "$right_component" ]; then
      return 1
    fi
    i=$((i + 1))
  done

  return 1
}

# Project-level documentation lives in the DocC catalog, not a freeform docs/ folder.
DOCC="Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc"
RELEASE_CHECKLIST="$DOCC/ReleaseChecklist.md"
ROADMAP="$DOCC/Roadmap.md"

require_file "CHANGELOG.md"
require_file "README.md"
require_file "$RELEASE_CHECKLIST"
require_file "$ROADMAP"

CHANGELOG_VERSION="$(
  awk '
    /^## \[[0-9]+\.[0-9]+\.[0-9]+\]/ {
      version = $2
      gsub(/^\[/, "", version)
      gsub(/\]$/, "", version)
      print version
      exit
    }
  ' "$ROOT/CHANGELOG.md"
)"

if [ -z "$CHANGELOG_VERSION" ]; then
  fail "CHANGELOG.md must have a top release section like '## [0.9.0] - YYYY-MM-DD'."
else
  RELEASE_TAG="v$CHANGELOG_VERSION"
  RELEASE_NOTES_PATH="$DOCC/ReleaseNotes.md"

  if ! version_greater_than "$CHANGELOG_VERSION" "$HISTORICAL_LATEST_VERSION"; then
    fail "top changelog version $CHANGELOG_VERSION must be newer than historical $HISTORICAL_LATEST_VERSION."
  fi

  require_file "$RELEASE_NOTES_PATH"
  require_contains "README.md" "$RELEASE_NOTES_PATH" "README.md must link $RELEASE_NOTES_PATH."
  require_contains "$ROADMAP" "$RELEASE_TAG" "Roadmap article must mention $RELEASE_TAG."
  require_contains "$RELEASE_CHECKLIST" "<doc:ReleaseNotes>" "release checklist must reference the ReleaseNotes article."
  require_contains "$RELEASE_CHECKLIST" "git tag -a $RELEASE_TAG" "release checklist must tag $RELEASE_TAG."
  require_contains "$RELEASE_CHECKLIST" "git push origin $RELEASE_TAG" "release checklist must push $RELEASE_TAG."
  require_contains "$RELEASE_CHECKLIST" "historical \`$HISTORICAL_LATEST_VERSION\` boundary" "release checklist must document the historical tag boundary."
  require_contains "$RELEASE_NOTES_PATH" "Release Notes: $RELEASE_TAG" "release notes title must use $RELEASE_TAG."
  require_contains "$RELEASE_NOTES_PATH" "CVBuilder \`$RELEASE_TAG\`" "release notes body must use $RELEASE_TAG."

  VERSION_REFERENCES="$(
    grep -RhoE 'v[0-9]+\.[0-9]+\.[0-9]+' \
      "$ROOT/README.md" \
      "$ROOT/$RELEASE_CHECKLIST" \
      "$ROOT/$RELEASE_NOTES_PATH" \
      "$ROOT/$ROADMAP" 2>/dev/null |
      sort -u
  )"

  if printf "%s\n" "$VERSION_REFERENCES" | grep -qv "^$RELEASE_TAG$"; then
    fail "release docs contain mixed v-prefixed versions: $(printf "%s" "$VERSION_REFERENCES" | tr '\n' ' ')"
  fi
fi

exit "$FAIL"
