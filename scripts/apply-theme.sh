#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=../theme.tokens.sh
source "${ROOT_DIR}/theme.tokens.sh"

DRY_RUN=0
TIMESTAMP="$(date +%s)"

usage() {
  cat <<'EOF'
Usage: ./scripts/apply-theme.sh [--dry-run]

Options:
  --dry-run    Print the actions without changing ~/.config or applying the theme.
  -h, --help   Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

log() {
  printf '%s\n' "$*"
}

run() {
  if (( DRY_RUN )); then
    printf 'DRY-RUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

backup_file() {
  local path="$1"
  local backup_path

  [[ -e "${path}" ]] || return 0

  backup_path="${path}.bak.${TIMESTAMP}"
  log "Backing up ${path} -> ${backup_path}"
  run mkdir -p "$(dirname "${backup_path}")"
  run cp -a "${path}" "${backup_path}"
}

sync_file() {
  local source_path="$1"
  local target_path="$2"

  backup_file "${target_path}"
  run mkdir -p "$(dirname "${target_path}")"
  run cp -a "${source_path}" "${target_path}"
}

sync_theme_dir() {
  local target_dir="$HOME/.config/omarchy/themes/${THEME_SLUG}"
  local backup_dir="${target_dir}.bak.${TIMESTAMP}"

  if [[ -d "${target_dir}" ]]; then
    log "Backing up ${target_dir} -> ${backup_dir}"
    run mkdir -p "$(dirname "${backup_dir}")"
    run cp -a "${target_dir}" "${backup_dir}"
  fi

  run mkdir -p "${target_dir}"
  if (( DRY_RUN )); then
    printf 'DRY-RUN: rsync -a --delete --exclude %q %q %q\n' ".git/" "${ROOT_DIR}/" "${target_dir}/"
  else
    rsync -a --delete --exclude ".git/" "${ROOT_DIR}/" "${target_dir}/"
  fi
}

waybar_config_source="${ROOT_DIR}/waybar-theme/config.jsonc"
waybar_style_source="${ROOT_DIR}/waybar-theme/style.css"

log "Rebuilding theme artifacts"
"${ROOT_DIR}/scripts/build-theme.sh"

log "Syncing repository to ~/.config/omarchy/themes/${THEME_SLUG}"
sync_theme_dir

log "Syncing user-facing configs"
sync_file "${waybar_config_source}" "$HOME/.config/waybar/config.jsonc"
sync_file "${waybar_style_source}" "$HOME/.config/waybar/style.css"
sync_file "${ROOT_DIR}/starship.toml" "$HOME/.config/starship.toml"

if (( DRY_RUN )); then
  log "Dry-run complete"
  exit 0
fi

log "Applying theme via omarchy-theme-set ${THEME_SLUG}"
omarchy-theme-set "${THEME_SLUG}"

if command -v omarchy-restart-walker >/dev/null 2>&1; then
  log "Restarting Walker to pick up the new launcher theme"
  omarchy-restart-walker
fi

log "Theme applied"
