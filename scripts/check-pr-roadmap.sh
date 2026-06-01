#!/usr/bin/env bash
# Verifies that a pull request body names the roadmap issue or phase it advances.

set -u

read_body() {
  if [ -n "${PR_BODY_FILE:-}" ]; then
    cat "$PR_BODY_FILE"
    return
  fi

  printf "%s" "${PR_BODY:-}"
}

BODY="$(read_body)"

fail() {
  echo "roadmap: $1" >&2
  exit 1
}

if ! printf "%s\n" "$BODY" | grep -Eq "^##[[:space:]]+Roadmap[[:space:]]*$"; then
  fail "PR body must include a '## Roadmap' section."
fi

ROADMAP_SECTION="$(
  printf "%s\n" "$BODY" |
    awk '
      /^##[[:space:]]+Roadmap[[:space:]]*$/ { in_section = 1; next }
      /^##[[:space:]]+/ && in_section { exit }
      in_section { print }
    '
)"

CLEAN_ROADMAP_SECTION="$(
  printf "%s\n" "$ROADMAP_SECTION" |
    awk '
      /^[[:space:]]*<!--/ { in_comment = 1 }
      !in_comment { print }
      /-->[[:space:]]*$/ { in_comment = 0 }
    '
)"

if ! printf "%s\n" "$CLEAN_ROADMAP_SECTION" | grep -Eq "#[0-9]+|[Pp]hase[[:space:]]+[0-9]+"; then
  fail "Roadmap section must name an issue number or phase number."
fi
