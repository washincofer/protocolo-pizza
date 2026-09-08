#!/usr/bin/env bash
set -euo pipefail

GODOT_VERSION="4.3"
GODOT_TAG="${GODOT_VERSION}-stable"
GODOT_DIR="/tmp/godot-${GODOT_TAG}"
GODOT_BIN="${GODOT_DIR}/godot"
TEMPLATE_DIR="${HOME}/.local/share/godot/export_templates/${GODOT_VERSION}.stable"

mkdir -p "${GODOT_DIR}" "${TEMPLATE_DIR}" godot/build/web

curl -L --fail --retry 3 \
  "https://github.com/godotengine/godot/releases/download/${GODOT_TAG}/Godot_v${GODOT_TAG}_linux.x86_64.zip" \
  -o "${GODOT_DIR}/godot.zip"

unzip -q "${GODOT_DIR}/godot.zip" -d "${GODOT_DIR}"
mv "${GODOT_DIR}/Godot_v${GODOT_TAG}_linux.x86_64" "${GODOT_BIN}"
chmod +x "${GODOT_BIN}"

curl -L --fail --retry 3 \
  "https://github.com/godotengine/godot/releases/download/${GODOT_TAG}/Godot_v${GODOT_TAG}_export_templates.tpz" \
  -o "${GODOT_DIR}/templates.tpz"

unzip -q "${GODOT_DIR}/templates.tpz" -d "${GODOT_DIR}/templates-unpacked"
cp -R "${GODOT_DIR}/templates-unpacked/templates/." "${TEMPLATE_DIR}/"

"${GODOT_BIN}" --headless --path godot --import
"${GODOT_BIN}" --headless --path godot --export-release "Web" build/web/index.html

test -f godot/build/web/index.html

echo "Render build concluído: godot/build/web/index.html"
