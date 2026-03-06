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
  "waybar-theme/config.jsonc"
  "waybar-theme/style.css"
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

if [[ "${shadow_count}" -ne 0 ]]; then
  printf '\nAudit failed: remove unintended shadowing files or declare them repo-owned.\n' >&2
  exit 2
fi

printf '\nAudit passed.\n'
