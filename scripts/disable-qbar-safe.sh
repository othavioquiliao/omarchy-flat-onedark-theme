#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

QBAR_STATE_FILE="${HOME}/.config/waybar/.flat-onedark-qbar-overlay.json"
QBAR_WAYBAR_DIR="${HOME}/.config/waybar/qbar"
QBAR_TERMINAL_SCRIPT="${HOME}/.config/waybar/scripts/qbar-open-terminal"

NO_RESTART=0
PURGE_ASSETS=0

usage() {
  cat <<'EOF'
Usage: ./scripts/disable-qbar-safe.sh [options]

Options:
  --no-restart   Restore stock-safe Waybar without restarting Waybar.
  --purge-assets Remove qbar-owned Waybar assets after disabling.
  -h, --help     Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-restart)
      NO_RESTART=1
      shift
      ;;
    --purge-assets)
      PURGE_ASSETS=1
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

if (( NO_RESTART )); then
  "${ROOT_DIR}/scripts/repair-waybar.sh" --no-restart
else
  "${ROOT_DIR}/scripts/repair-waybar.sh"
fi

rm -f "${QBAR_STATE_FILE}"

if (( PURGE_ASSETS )); then
  rm -rf "${QBAR_WAYBAR_DIR}"
  rm -f "${QBAR_TERMINAL_SCRIPT}"
fi

printf 'qbar overlay disabled\n'
