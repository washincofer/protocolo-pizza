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

python3 - <<'PY'
from pathlib import Path

path = Path("godot/build/web/index.html")
html = path.read_text(encoding="utf-8")
inject = r'''<script>
window.addEventListener('keydown', function (event) {
  if (event.key === 'F1' || event.key === 'F2' || event.key === 'F3') {
    event.preventDefault();
  }
}, {capture: true});
</script>
'''
if inject not in html:
    html = html.replace('</head>', inject + '</head>')
path.write_text(html, encoding='utf-8')
PY

echo "Render build concluído: godot/build/web/index.html"
