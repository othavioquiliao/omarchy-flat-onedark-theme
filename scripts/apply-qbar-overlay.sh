#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

QBAR_STATE_FILE="${HOME}/.config/waybar/.flat-onedark-qbar-overlay.json"
WAYBAR_DIR="${HOME}/.config/waybar"
WAYBAR_CONFIG_FILE="${WAYBAR_DIR}/config.jsonc"
WAYBAR_STYLE_FILE="${WAYBAR_DIR}/style.css"
QBAR_WAYBAR_DIR="${WAYBAR_DIR}/qbar"
QBAR_SCRIPTS_DIR="${WAYBAR_DIR}/scripts"
QBAR_ICONS_DIR="${QBAR_WAYBAR_DIR}/icons"
QBAR_TERMINAL_SCRIPT="${QBAR_SCRIPTS_DIR}/qbar-open-terminal"
QBAR_BIN_PATH="${QBAR_BIN_PATH:-}"
QBAR_IMPORT='@import "../omarchy/current/theme/qbar.css";'
QBAR_STYLE_START='/* flat-onedark-qbar-overlay:start */'
QBAR_STYLE_END='/* flat-onedark-qbar-overlay:end */'
CURRENT_THEME_QBAR_CSS="${QBAR_THEME_CSS_PATH:-$HOME/.config/omarchy/current/theme/qbar.css}"

REPAIR_FIRST=0
NO_RESTART=0

usage() {
  cat <<'EOF'
Usage: ./scripts/apply-qbar-overlay.sh [options]

Options:
  --repair      Rebuild the live Waybar base before applying qbar.
  --no-restart  Apply the overlay without restarting Waybar.
  -h, --help    Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repair)
      REPAIR_FIRST=1
      shift
      ;;
    --no-restart)
      NO_RESTART=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

log() {
  printf '%s\n' "$*"
}

require_qbar() {
  if ! command -v qbar >/dev/null 2>&1; then
    printf 'qbar command not found in PATH.\n' >&2
    exit 1
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    printf 'python3 command not found in PATH.\n' >&2
    exit 1
  fi

  if [[ -z "${QBAR_BIN_PATH}" ]]; then
    QBAR_BIN_PATH="$(command -v qbar)"
  fi

  if [[ ! -f "${CURRENT_THEME_QBAR_CSS}" ]]; then
    printf 'Current theme qbar.css not found: %s\nRun ./scripts/apply-theme.sh first.\n' "${CURRENT_THEME_QBAR_CSS}" >&2
    exit 1
  fi
}

repair_live_waybar() {
  "${ROOT_DIR}/scripts/repair-waybar.sh" --no-restart
}

write_overlay_state() {
  mkdir -p "$(dirname "${QBAR_STATE_FILE}")"
  cat > "${QBAR_STATE_FILE}" <<'EOF'
{
  "version": 1,
  "enabled": true
}
EOF
}

apply_overlay_files() {
  local modules_json css_json

  qbar assets install --waybar-dir "${QBAR_WAYBAR_DIR}" --scripts-dir "${QBAR_SCRIPTS_DIR}" >/dev/null
  modules_json="$(qbar export waybar-modules --qbar-bin "${QBAR_BIN_PATH}" --terminal-script "${QBAR_TERMINAL_SCRIPT}")"
  css_json="$(qbar export waybar-css --icons-dir "${QBAR_ICONS_DIR}")"

  QBAR_MODULES_JSON="${modules_json}" \
  QBAR_CSS_JSON="${css_json}" \
  QBAR_IMPORT="${QBAR_IMPORT}" \
  QBAR_STYLE_START="${QBAR_STYLE_START}" \
  QBAR_STYLE_END="${QBAR_STYLE_END}" \
  QBAR_CONFIG_FILE="${WAYBAR_CONFIG_FILE}" \
  QBAR_STYLE_FILE="${WAYBAR_STYLE_FILE}" \
  python3 <<'PY'
import json
import os
import sys
from pathlib import Path

config_path = Path(os.environ["QBAR_CONFIG_FILE"])
style_path = Path(os.environ["QBAR_STYLE_FILE"])
modules_payload = json.loads(os.environ["QBAR_MODULES_JSON"])
modules = modules_payload["modules"]
module_ids = [f"custom/qbar-{provider}" for provider in modules_payload["providers"]]
css_fragment = json.loads(os.environ["QBAR_CSS_JSON"])["css"].rstrip()
import_line = os.environ["QBAR_IMPORT"]
marker_start = os.environ["QBAR_STYLE_START"]
marker_end = os.environ["QBAR_STYLE_END"]

with config_path.open("r", encoding="utf-8") as handle:
    config = json.load(handle)

modules_right = [
    module for module in config.get("modules-right", [])
    if not module.startswith("custom/qbar-")
]

try:
    insert_at = modules_right.index("battery")
except ValueError:
    insert_at = len(modules_right)
    print(
        "Warning: battery anchor missing in modules-right; appending qbar modules at the end.",
        file=sys.stderr,
    )

for offset, module_id in enumerate(module_ids):
    modules_right.insert(insert_at + offset, module_id)

config["modules-right"] = modules_right

for key in list(config.keys()):
    if key.startswith("custom/qbar-"):
        config.pop(key, None)

for module_id in module_ids:
    config[module_id] = modules[module_id]

config_path.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")

style = style_path.read_text(encoding="utf-8")
style = style.replace(import_line + "\n", "")
style = style.replace("\n" + import_line, "")

if marker_start in style and marker_end in style:
    start = style.index(marker_start)
    end = style.index(marker_end) + len(marker_end)
    style = (style[:start] + style[end:]).strip()

lines = style.splitlines()
if import_line not in lines:
    if lines and lines[0].startswith('@import "../omarchy/current/theme/waybar.css";'):
        lines.insert(1, import_line)
    else:
        lines.insert(0, import_line)

style = "\n".join(lines).strip() + "\n\n"
style += marker_start + "\n"
style += css_fragment + "\n"
style += marker_end + "\n"
style_path.write_text(style, encoding="utf-8")
PY
}

require_qbar

if (( REPAIR_FIRST )); then
  log "Repairing live Waybar before applying qbar overlay"
  repair_live_waybar
fi

log "Applying qbar overlay to live Waybar files"
apply_overlay_files
write_overlay_state

if (( !NO_RESTART )) && command -v omarchy-restart-waybar >/dev/null 2>&1; then
  log "Restarting Waybar"
  omarchy-restart-waybar
fi

log "qbar overlay applied"
