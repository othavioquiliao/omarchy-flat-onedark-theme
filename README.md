# Omarchy Flat OneDark Theme

Flat OneDark theme for Omarchy with a token-driven build pipeline, a minimal theme-owned Waybar color layer, and a dedicated Waybar repair workflow that avoids mutating `~/.local/share/omarchy`.

## Quick Start

Edit the source of truth:

```bash
theme.tokens.sh
```

Regenerate generated artifacts:

```bash
./scripts/build-theme.sh
```

Audit file ownership and anti-drift rules:

```bash
./scripts/audit-theme.sh
```

Repair the local stock Waybar base:

```bash
./scripts/repair-waybar.sh
```

Apply the theme end to end:

```bash
./scripts/apply-theme.sh
```

## Core Commands

- `./scripts/build-theme.sh`
  - rewrites generated repo-owned artifacts from `theme.tokens.sh`
- `./scripts/audit-theme.sh`
  - catches template shadowing, legacy Waybar layout files, and invalid Waybar ownership
- `./scripts/repair-waybar.sh`
  - rebuilds `~/.config/waybar/themes/omarchy-default` from Omarchy git `HEAD`
- `./scripts/apply-theme.sh`
  - builds, syncs the theme into Omarchy, repairs Waybar, then applies `flat-onedark`

Useful apply flags:

```bash
./scripts/apply-theme.sh --dry-run
./scripts/apply-theme.sh --with-backups
./scripts/apply-theme.sh --clean-backups
```

## Operational Rules

- `theme.tokens.sh` is the only edit point for palette and shared design tokens.
- `waybar.css` is the only Waybar file published by this theme.
- `qbar` is opt-in and must own its own Waybar integration through `qbar setup`.
- This repo must not write into `~/.local/share/omarchy`.
- If Waybar looks wrong after a reset or theme-manager action, use `./scripts/repair-waybar.sh`.

## Documentation

Detailed project documentation lives in [docs/README.md](docs/README.md).

That documentation is the canonical context set for:

- human maintainers
- future coding agents
- debugging live Omarchy state
- understanding ownership boundaries between this repo, Omarchy, qbar, and user-local config

## Included Assets

- generated theme outputs such as `waybar.css`, `walker.css`, `gtk.css`, `hyprland.conf`, `starship.toml`, `qbar.css`, `steam.css`, `vencord.theme.css`, `neovim.lua`, `cava_theme`, `lazygit.yml`, `colors.toml`, `colors.fish`, and `fzf.fish`
- static assets such as `backgrounds/`, `preview.png`, `icons.theme`, and `vscode.json`

## Credits

- Flat structure/source project: https://github.com/OldJobobo/omarchy-flat-dracula-theme
- One Dark Pro palette/source project: https://github.com/sc0ttman/omarchy-one-dark-pro-theme
