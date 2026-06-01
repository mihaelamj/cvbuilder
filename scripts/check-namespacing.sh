#!/usr/bin/env bash
# Namespacing gate: one non-private top-level type per Swift source file.
# Split additional public/package/internal helper types into their own files, or
# mark implementation details private/fileprivate.

set -u

SRC="Sources"
if [ ! -d "$SRC" ]; then
  echo "namespacing: no $SRC directory, skipping."
  exit 0
fi

FAIL=0
while IFS= read -r f; do
  count=$(grep -cE "^(public |package |internal )?(actor|struct|enum|protocol|class|final class) [A-Z]" "$f")
  if [ "$count" -gt 1 ]; then
    echo "namespacing: $count file-scope types in $f (one per file)" >&2
    FAIL=1
  fi
done < <(find "$SRC" -name "*.swift")

if [ "$FAIL" -ne 0 ]; then
  echo "namespacing: gate failed. See CONTRIBUTING.md." >&2
fi
exit "$FAIL"
