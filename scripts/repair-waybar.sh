#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OMARCHY_SOURCE_DIR="${OMARCHY_PATH:-$HOME/.local/share/omarchy}"

DRY_RUN=0
NO_RESTART=0

usage() {
  cat <<'EOF'
Usage: ./scripts/repair-waybar.sh [options]

Options:
  --dry-run     Print the actions without changing ~/.config.
  --no-restart  Rebuild the local Waybar base without restarting Waybar.
  -h, --help    Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
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

ensure_omarchy_repo() {
  if ! git -C "${OMARCHY_SOURCE_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf 'Omarchy source is not a git repository: %s\n' "${OMARCHY_SOURCE_DIR}" >&2
    exit 1
  fi
}

warn_dirty_waybar_source() {
  if ! git -C "${OMARCHY_SOURCE_DIR}" diff --quiet -- config/waybar/config.jsonc config/waybar/style.css || \
     ! git -C "${OMARCHY_SOURCE_DIR}" diff --cached --quiet -- config/waybar/config.jsonc config/waybar/style.css; then
    log "Warning: Omarchy Waybar source is dirty. Repair uses git HEAD and ignores working tree changes in config/waybar."
  fi
}

write_omarchy_head_file() {
  local source_path="$1"
  local target_path="$2"

  if (( DRY_RUN )); then
    printf 'DRY-RUN: git -C %q show %q > %q\n' \
      "${OMARCHY_SOURCE_DIR}" "HEAD:${source_path}" "${target_path}"
    return 0
  fi

  git -C "${OMARCHY_SOURCE_DIR}" show "HEAD:${source_path}" > "${target_path}"
}

repair_waybar_base() {
  local local_waybar_dir="$HOME/.config/waybar"
  local local_waybar_theme_dir="${local_waybar_dir}/themes/omarchy-default"

  log "Repairing local Waybar base from Omarchy git HEAD"

  run mkdir -p "${local_waybar_dir}/themes"
  if [[ -e "${local_waybar_theme_dir}" ]] && [[ ! -d "${local_waybar_theme_dir}" || -L "${local_waybar_theme_dir}" ]]; then
    run rm -rf "${local_waybar_theme_dir}"
  fi
  run mkdir -p "${local_waybar_theme_dir}"

  write_omarchy_head_file "config/waybar/config.jsonc" "${local_waybar_theme_dir}/config.jsonc"
  write_omarchy_head_file "config/waybar/style.css" "${local_waybar_theme_dir}/style.css"

  run ln -sfn "${local_waybar_theme_dir}/config.jsonc" "${local_waybar_dir}/config.jsonc"
  run ln -sfn "${local_waybar_theme_dir}/style.css" "${local_waybar_dir}/style.css"
}

ensure_omarchy_repo
warn_dirty_waybar_source
repair_waybar_base

if (( !NO_RESTART )) && command -v omarchy-restart-waybar >/dev/null 2>&1; then
  log "Restarting Waybar"
  run omarchy-restart-waybar
fi

log "Waybar repair complete"
