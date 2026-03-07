# Runtime Surfaces

## Purpose

This document maps repo files and external inputs to their runtime locations, owners, and apply paths.

Use it to decide whether a problem belongs to:

- repo-generated theme output
- Omarchy template output
- repaired Waybar runtime state
- theme-owned qbar overlay wiring
- qbar-owned runtime or assets

## Core Surface Matrix

| Surface | Source | Runtime path | Owner | Apply path | Notes |
| --- | --- | --- | --- | --- | --- |
| Waybar color layer | `waybar.css` | `~/.config/omarchy/current/theme/waybar.css` | this repo | `omarchy-theme-set` / `omarchy-restart-waybar` | Colors only |
| qbar visual contract | `qbar.css` | `~/.config/omarchy/current/theme/qbar.css` | this repo | imported only when overlay is enabled | Not part of stock-safe default |
| Repaired stock config | Omarchy git `HEAD:config/waybar/config.jsonc` | `~/.config/waybar/themes/omarchy-default/config.jsonc` | repair flow | `./scripts/repair-waybar.sh` | qbar-free snapshot |
| Repaired stock style | Omarchy git `HEAD:config/waybar/style.css` | `~/.config/waybar/themes/omarchy-default/style.css` | repair flow | `./scripts/repair-waybar.sh` | qbar-free snapshot |
| Live Waybar config | repaired stock snapshot plus optional overlay composition | `~/.config/waybar/config.jsonc` | repair flow by default, theme overlay when enabled | `./scripts/repair-waybar.sh`, `./scripts/enable-qbar-safe.sh`, `./scripts/apply-theme.sh --with-qbar` | Plain file |
| Live Waybar style | repaired stock snapshot plus optional overlay composition | `~/.config/waybar/style.css` | repair flow by default, theme overlay when enabled | `./scripts/repair-waybar.sh`, `./scripts/enable-qbar-safe.sh`, `./scripts/apply-theme.sh --with-qbar` | Plain file |
| qbar overlay state | theme runtime state | `~/.config/waybar/.flat-onedark-qbar-overlay.json` | this theme | `enable-qbar-safe.sh`, `disable-qbar-safe.sh`, `apply-theme.sh` | Persists opt-in overlay state |
| qbar Waybar assets | `qbar assets install` | `~/.config/waybar/qbar/*` | qbar | qbar CLI | Consumed by theme-owned overlay only |
| qbar terminal helper | `qbar assets install` | `~/.config/waybar/scripts/qbar-open-terminal` | qbar | qbar CLI | Consumed by exported modules |
| qbar settings | qbar runtime | `~/.config/qbar/settings.json` | qbar | qbar CLI / qbar TUI | Provider selection and order |
| qbar cache | qbar runtime | `~/.cache/qbar/*` | qbar | qbar runtime | Not stored under Waybar anymore |
| Walker CSS | `walker.css` | `~/.config/omarchy/current/theme/walker.css` | this repo | `omarchy-theme-set` / `omarchy-restart-walker` | Launcher layer |
| Hyprland theme | `hyprland.conf` | `~/.config/omarchy/current/theme/hyprland.conf` | this repo | `omarchy-theme-set` / `hyprctl reload` | Visual config |
| GTK layer | `gtk.css` | `~/.config/omarchy/current/theme/gtk.css` | this repo | `omarchy-theme-set` | App restart may still be needed |
| Starship | `starship.toml` | `~/.config/starship.toml` | this repo | `./scripts/apply-theme.sh` | Synced directly |

## Template-Driven Surfaces

These runtime files come from Omarchy templates driven by `colors.toml`:

| Surface | Runtime path |
| --- | --- |
| Alacritty | `~/.config/omarchy/current/theme/alacritty.toml` |
| Kitty | `~/.config/omarchy/current/theme/kitty.conf` |
| Ghostty | `~/.config/omarchy/current/theme/ghostty.conf` |
| Hyprlock | `~/.config/omarchy/current/theme/hyprlock.conf` |
| SwayOSD | `~/.config/omarchy/current/theme/swayosd.css` |
| Mako | `~/.config/omarchy/current/theme/mako.ini` |
| btop | `~/.config/omarchy/current/theme/btop.theme` |
| Browser policy color | `~/.config/omarchy/current/theme/chromium.theme` |
| Obsidian | `~/.config/omarchy/current/theme/obsidian.css` |
| Keyboard RGB | `~/.config/omarchy/current/theme/keyboard.rgb` |

## qbar Contract Inputs

The overlay helper consumes qbar through these public interfaces:

- `qbar assets install --waybar-dir <path> --scripts-dir <path>`
- `qbar export waybar-modules --qbar-bin <path> --terminal-script <path>`
- `qbar export waybar-css --icons-dir <path>`

Theme-side references:

- [build-and-apply.md](./build-and-apply.md)
- [qbar-integration.md](./qbar-integration.md)

qbar-side references:

- [qbar README](/home/othavio/Work/qbar/README.md)
- [qbar commands](/home/othavio/Work/qbar/docs/commands.md)
- [qbar runtime](/home/othavio/Work/qbar/docs/runtime.md)
- [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md)

## Waybar-Launched Tools

Some issues that look like Waybar problems are actually issues in tools launched from Waybar.

| Waybar action | Actual surface |
| --- | --- |
| `wifi` | `impala` in the terminal |
| `bluetooth` | `bluetui` in the terminal |
| `audio` | `wiremix` in the terminal |
| `cpu` / process view | `btop` in the terminal |
| `power` | Walker / Omarchy menu |

## Operational Summary

If a surface is broken, classify it first:

1. repo-generated theme output
2. Omarchy template output
3. repaired stock snapshot
4. live Waybar overlay wiring
5. qbar-owned runtime or assets
6. TUI launched from Waybar
