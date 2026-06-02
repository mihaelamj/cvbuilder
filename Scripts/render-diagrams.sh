#!/usr/bin/env bash
# Regenerate every catalog diagram PNG from its committed .mmd source.
#
# DocC does not render Mermaid, so the committed PNG is the artifact the catalog
# embeds. The .mmd file is the single source of truth; the PNG is generated.
# Run this whenever a .mmd changes, then commit both files.
#
# Requires Node (for npx). The first run downloads the mermaid-cli Chromium.
set -euo pipefail

DIAGRAM_DIR="Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/Resources/diagrams"
CONFIG="$DIAGRAM_DIR/mermaid.config.json"
SCALE=3

if [ ! -d "$DIAGRAM_DIR" ]; then
    echo "Diagram directory not found: $DIAGRAM_DIR" >&2
    exit 1
fi

shopt -s nullglob
sources=("$DIAGRAM_DIR"/*.mmd)
if [ ${#sources[@]} -eq 0 ]; then
    echo "No .mmd sources in $DIAGRAM_DIR" >&2
    exit 1
fi

for src in "${sources[@]}"; do
    out="${src%.mmd}.png"
    echo "Rendering $src -> $out"
    npx -y @mermaid-js/mermaid-cli \
        --input "$src" \
        --output "$out" \
        --configFile "$CONFIG" \
        --backgroundColor white \
        --scale "$SCALE"
done

echo "Rendered ${#sources[@]} diagram(s)."
