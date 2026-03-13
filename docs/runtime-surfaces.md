# Runtime Surfaces

## Purpose

This document maps repo files and external inputs to their runtime locations, owners, and apply paths.

Use it to decide whether a problem belongs to:

- repo-generated theme output
- Omarchy template output
- repaired Waybar runtime state

## Core Surface Matrix

| Surface | Source | Runtime path | Owner | Apply path | Notes |
| --- | --- | --- | --- | --- | --- |
| Waybar color layer | `waybar.css` | `~/.config/omarchy/current/theme/waybar.css` | this repo | `omarchy-theme-set` / `omarchy-restart-waybar` | Colors only |
| Repaired stock config | Omarchy git `HEAD:config/waybar/config.jsonc` | `~/.config/waybar/themes/omarchy-default/config.jsonc` | repair flow | `./scripts/repair-waybar.sh` | Stock snapshot |
| Repaired stock style | Omarchy git `HEAD:config/waybar/style.css` | `~/.config/waybar/themes/omarchy-default/style.css` | repair flow | `./scripts/repair-waybar.sh` | Stock snapshot |
| Live Waybar config | repaired stock snapshot | `~/.config/waybar/config.jsonc` | repair flow | `./scripts/repair-waybar.sh`, `./scripts/apply-theme.sh` | Plain file |
| Live Waybar style | repaired stock snapshot | `~/.config/waybar/style.css` | repair flow | `./scripts/repair-waybar.sh`, `./scripts/apply-theme.sh` | Plain file |
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
4. live Waybar files
5. TUI launched from Waybar
