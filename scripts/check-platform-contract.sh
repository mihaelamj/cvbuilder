#!/usr/bin/env bash
# Platform contract gate: package metadata must match documented support.

set -u

FAIL=0

if ! grep -q "\\.macOS" Package.swift; then
  echo "platform-contract: Package.swift must declare macOS support." >&2
  FAIL=1
fi

if grep -qE "\\.iOS\\s*\\(" Package.swift; then
  echo "platform-contract: Package.swift must not declare iOS until iOS support is tested and documented." >&2
  FAIL=1
fi

exit "$FAIL"
