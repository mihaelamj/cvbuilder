#!/usr/bin/env bash
# Verifies checked-in generated examples still match their source data.

set -u

swift run cvbuilder \
  --data Examples/democv/cv.json \
  --out Examples/tiledown/democv.md \
  --check
