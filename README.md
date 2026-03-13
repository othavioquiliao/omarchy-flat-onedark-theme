# Omarchy Flat OneDark Theme

`flat-onedark` is a token-driven Omarchy theme with a stock-safe Waybar model.

## Supported Flows

Rebuild generated theme artifacts:

```bash
./scripts/build-theme.sh
```

Repair the local stock-safe Waybar base:

```bash
./scripts/repair-waybar.sh
```

Apply the theme end to end:

```bash
./scripts/apply-theme.sh
```

## Operating Model

- `theme.tokens.sh` is the only source of truth for palette and shared design tokens.
- `waybar.css` is the theme-owned Waybar color layer.
- The repaired stock snapshot in `~/.config/waybar/themes/omarchy-default/` is the base for live Waybar files.
- Live Waybar files are plain files rebuilt from that repaired snapshot.
- This repository must not write into `~/.local/share/omarchy`.

## Documentation

Theme docs:

- [docs/README.md](docs/README.md)
- [docs/build-and-apply.md](docs/build-and-apply.md)
- [docs/troubleshooting.md](docs/troubleshooting.md)

## Included Assets

This repo ships generated theme outputs such as `waybar.css`, `walker.css`, `gtk.css`, `hyprland.conf`, `starship.toml`, `steam.css`, `vencord.theme.css`, `neovim.lua`, `cava_theme`, `lazygit.yml`, and static assets such as `backgrounds/`, `preview.png`, `icons.theme`, and `vscode.json`.

## Credits

- Flat structure/source project: https://github.com/OldJobobo/omarchy-flat-dracula-theme
- One Dark Pro palette/source project: https://github.com/sc0ttman/omarchy-one-dark-pro-theme
