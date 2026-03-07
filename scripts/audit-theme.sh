#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATE_DIR="${OMARCHY_TEMPLATE_DIR:-$HOME/.local/share/omarchy/default/themed}"

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
  printf 'Template directory not found: %s\n' "${TEMPLATE_DIR}" >&2
  exit 1
fi

repo_owned=(
  "waybar.css"
  "walker.css"
  "hyprland.conf"
  "gtk.css"
  "qbar.css"
  "vscode.json"
  "neovim.lua"
  "steam.css"
  "vencord.theme.css"
  "colors.fish"
  "fzf.fish"
  "lazygit.yml"
  "cava_theme"
  "starship.toml"
)

is_repo_owned() {
  local candidate="$1"
  local owned
  for owned in "${repo_owned[@]}"; do
    if [[ "${owned}" == "${candidate}" ]]; then
      return 0
    fi
  done
  return 1
}

shadow_count=0

printf 'Theme audit for %s\n' "${ROOT_DIR}"
printf 'Omarchy template dir: %s\n\n' "${TEMPLATE_DIR}"

printf 'Repo-owned surfaces:\n'
for owned in "${repo_owned[@]}"; do
  printf '  - %s\n' "${owned}"
done

printf '\nTemplate-shadowing surfaces:\n'
while IFS= read -r tpl; do
  name="$(basename "${tpl%.tpl}")"
  if [[ -f "${ROOT_DIR}/${name}" ]] && ! is_repo_owned "${name}"; then
    printf '  - %s shadows %s\n' "${name}" "${tpl}"
    shadow_count=$((shadow_count + 1))
  fi
done < <(find "${TEMPLATE_DIR}" -maxdepth 1 -type f -name '*.tpl' | sort)

if [[ "${shadow_count}" -eq 0 ]]; then
  printf '  none\n'
fi

printf '\nTemplate-driven surfaces expected from colors.toml:\n'
printf '  - alacritty.toml\n'
printf '  - kitty.conf\n'
printf '  - ghostty.conf\n'
printf '  - hyprlock.conf\n'
printf '  - swayosd.css\n'
printf '  - btop.theme\n'
printf '  - mako.ini\n'
printf '  - chromium.theme\n'
printf '  - obsidian.css\n'
printf '  - keyboard.rgb\n'

printf '\nWaybar ownership checks:\n'
if [[ -e "${ROOT_DIR}/waybar-theme/config.jsonc" ]] || [[ -e "${ROOT_DIR}/waybar-theme/style.css" ]]; then
  printf '  - invalid: legacy waybar-theme layout files still exist in the repo\n' >&2
  exit 3
fi
printf '  - repo does not publish legacy waybar-theme layout files\n'

if [[ ! -x "${ROOT_DIR}/scripts/repair-waybar.sh" ]]; then
  printf '  - invalid: scripts/repair-waybar.sh is missing or not executable\n' >&2
  exit 3
fi
printf '  - repair script exists and is executable\n'

if [[ ! -x "${ROOT_DIR}/scripts/apply-qbar-overlay.sh" ]] || \
   [[ ! -x "${ROOT_DIR}/scripts/enable-qbar-safe.sh" ]] || \
   [[ ! -x "${ROOT_DIR}/scripts/disable-qbar-safe.sh" ]]; then
  printf '  - invalid: qbar overlay scripts are missing or not executable\n' >&2
  exit 3
fi
printf '  - qbar overlay scripts exist and are executable\n'

if ! rg -n 'repair-waybar\.sh' "${ROOT_DIR}/scripts/apply-theme.sh" >/dev/null; then
  printf '  - invalid: scripts/apply-theme.sh no longer delegates to scripts/repair-waybar.sh\n' >&2
  exit 3
fi
printf '  - apply script delegates to repair-waybar.sh\n'

if ! rg -n 'apply-qbar-overlay\.sh' "${ROOT_DIR}/scripts/apply-theme.sh" >/dev/null; then
  printf '  - invalid: scripts/apply-theme.sh no longer knows how to re-apply the qbar overlay\n' >&2
  exit 3
fi
printf '  - apply script can re-apply the optional qbar overlay\n'

if rg -n 'ln -sfn' "${ROOT_DIR}/scripts/repair-waybar.sh" >/dev/null; then
  printf '  - invalid: repair script still recreates live Waybar symlinks\n' >&2
  exit 3
fi
printf '  - repair script writes live Waybar files as plain files\n'

if rg -n '~/.local/share/omarchy/config/waybar|omarchy-refresh-waybar' \
  "${ROOT_DIR}/scripts/apply-theme.sh" \
  "${ROOT_DIR}/scripts/repair-waybar.sh" >/dev/null; then
  printf '  - invalid: Waybar scripts still mutate or refresh the contaminated Omarchy Waybar source\n' >&2
  exit 3
fi
printf '  - Waybar scripts repair only ~/.config/waybar from Omarchy git HEAD\n'

if rg -n '~/.config/waybar/themes/omarchy-default' \
  "${ROOT_DIR}/scripts/apply-qbar-overlay.sh" \
  "${ROOT_DIR}/scripts/enable-qbar-safe.sh" \
  "${ROOT_DIR}/scripts/disable-qbar-safe.sh" >/dev/null; then
  printf '  - invalid: qbar overlay scripts must not mutate the repaired stock snapshot\n' >&2
  exit 3
fi
printf '  - qbar overlay scripts only touch live Waybar files and overlay state\n'

if [[ "${shadow_count}" -ne 0 ]]; then
  printf '\nAudit failed: remove unintended shadowing files or declare them repo-owned.\n' >&2
  exit 2
fi

printf '\nAudit passed.\n'
