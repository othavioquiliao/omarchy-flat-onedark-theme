#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

NO_RESTART=0

usage() {
  cat <<'EOF'
Usage: ./scripts/enable-qbar-safe.sh [options]

Options:
  --no-restart  Apply the overlay without restarting Waybar.
  -h, --help    Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
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

if (( NO_RESTART )); then
  exec "${ROOT_DIR}/scripts/apply-qbar-overlay.sh" --repair --no-restart
fi

exec "${ROOT_DIR}/scripts/apply-qbar-overlay.sh" --repair
