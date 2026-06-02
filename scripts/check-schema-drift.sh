#!/usr/bin/env bash
# Verifies checked-in CVDocument examples and fixtures still match the JSON Schema.

set -u

swift test --filter CVDocumentSchemaDrift
