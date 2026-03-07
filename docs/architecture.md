# Architecture

## Purpose

This repository defines the `flat-onedark` Omarchy theme.

It is responsible for:

- a stable One Dark design system
- generated theme artifacts from one token file
- a deterministic Waybar repair workflow
- an optional theme-owned qbar overlay on top of the repaired Waybar base

It is not responsible for:

- owning Omarchy itself
- writing into `~/.local/share/omarchy`
- delegating live Waybar wiring to qbar

## Design Principles

### Single source of truth

`theme.tokens.sh` owns palette and shared semantic tokens. Generated files are outputs, not independent design sources.

### Hybrid ownership

The repo mixes:

- repo-owned generated files where structure matters
- Omarchy template-driven files where palette is enough
- local repaired runtime state for Waybar

### Stock-safe by default

The default Waybar contract is a repaired stock snapshot plus plain live files rebuilt from that snapshot. The repaired snapshot stays qbar-free.

### Optional qbar overlay

qbar is supported as an opt-in overlay. This repo owns the Waybar wiring for that overlay. qbar owns its executable, settings, cache, provider runtime, and Waybar assets.

## System Model

### Authoring layer

Maintainers edit:

- `theme.tokens.sh`
- `README.md`
- `docs/*`
- `scripts/*`
- selected static assets such as `icons.theme`, `vscode.json`, `preview.png`, and `backgrounds/*`

### Generated repo layer

`./scripts/build-theme.sh` regenerates:

- `colors.toml`
- `colors.fish`
- `fzf.fish`
- `waybar.css`
- `walker.css`
- `gtk.css`
- `hyprland.conf`
- `starship.toml`
- `qbar.css`
- `steam.css`
- `vencord.theme.css`
- `neovim.lua`
- `cava_theme`
- `lazygit.yml`

These files are versioned outputs. Do not treat them as hand-edited sources.

### Omarchy template layer

Omarchy turns `colors.toml` into runtime files such as:

- `alacritty.toml`
- `kitty.conf`
- `ghostty.conf`
- `hyprlock.conf`
- `mako.ini`
- `swayosd.css`
- `btop.theme`
- `chromium.theme`
- `obsidian.css`
- `keyboard.rgb`

Those files are template-driven unless this theme intentionally takes ownership away from Omarchy.

### Local runtime layer

Active theme files live under:

- `~/.config/omarchy/current/theme`

Waybar runtime state lives under:

- `~/.config/waybar/themes/omarchy-default/`
- `~/.config/waybar/config.jsonc`
- `~/.config/waybar/style.css`

The repaired stock snapshot is local runtime state. It is not part of the Omarchy source tree.

## Waybar Model

Waybar is the special case in this theme because the local Omarchy source tree can be dirty for `config/waybar/*`.

The supported model is:

1. rebuild a repaired stock snapshot from Omarchy git `HEAD`
2. rewrite live Waybar files as plain files from that snapshot
3. keep the snapshot qbar-free
4. optionally compose the qbar overlay only into the live Waybar files

That split keeps the default bar repairable and the qbar overlay reversible.

## qbar Model

`qbar.css` is part of the current supported integration contract, but it is only imported when the optional overlay is enabled.

This theme owns:

- overlay enable and disable
- overlay persistence state
- live Waybar composition

qbar owns:

- the `qbar` executable
- `~/.config/qbar/*`
- `~/.cache/qbar/*`
- `~/.config/waybar/qbar/*`
- `~/.config/waybar/scripts/qbar-open-terminal`

See [qbar-integration.md](./qbar-integration.md) for the operational contract and external qbar references such as [qbar README](/home/othavio/Work/qbar/README.md) and [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md).

## Repository Layout

| Path | Role |
| --- | --- |
| `README.md` | Short operator-facing entrypoint |
| `docs/` | Canonical operational documentation |
| `theme.tokens.sh` | Authoritative design tokens |
| `scripts/` | Build, audit, repair, apply, and overlay entrypoints |
| `waybar.css` | Theme-owned Waybar color layer |
| `qbar.css` | Theme-owned visual contract for the optional qbar overlay |
| `walker.css` | Generated Walker styling |
| `gtk.css` | Generated GTK layer |
| `hyprland.conf` | Generated Hyprland visual config |
| `colors.toml` | Omarchy template input |
| `starship.toml` | Generated prompt config |
| `backgrounds/`, `preview.png`, `icons.theme`, `vscode.json` | Static theme assets |

## Documentation Rule

Operational truth belongs in `docs/`.

Historical planning belongs in `docs/plans/`.
