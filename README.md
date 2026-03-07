# Omarchy Flat OneDark Theme

`flat-onedark` is a token-driven Omarchy theme with a stock-safe Waybar model and an optional theme-owned `qbar` overlay.

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
./scripts/apply-theme.sh --with-qbar
./scripts/apply-theme.sh --without-qbar
```

Enable or disable the optional qbar overlay directly:

```bash
./scripts/enable-qbar-safe.sh
./scripts/disable-qbar-safe.sh
```

## Operating Model

- `theme.tokens.sh` is the only source of truth for palette and shared design tokens.
- `waybar.css` is the theme-owned Waybar color layer.
- The repaired stock snapshot in `~/.config/waybar/themes/omarchy-default/` stays qbar-free.
- Live Waybar files are plain files rebuilt from that repaired snapshot.
- The optional qbar overlay is theme-owned wiring applied on top of the live Waybar files.
- `qbar` owns its runtime, settings, cache, and Waybar assets.
- `qbar setup` is not the supported way to integrate qbar with this theme.
- This repository must not write into `~/.local/share/omarchy`.

## Documentation

Theme docs:

- [docs/README.md](docs/README.md)
- [docs/qbar-integration.md](docs/qbar-integration.md)
- [docs/build-and-apply.md](docs/build-and-apply.md)
- [docs/troubleshooting.md](docs/troubleshooting.md)

External qbar references used by this setup:

- [qbar README](/home/othavio/Work/qbar/README.md)
- [qbar commands](/home/othavio/Work/qbar/docs/commands.md)
- [qbar runtime](/home/othavio/Work/qbar/docs/runtime.md)
- [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md)

## Included Assets

This repo ships generated theme outputs such as `waybar.css`, `walker.css`, `gtk.css`, `hyprland.conf`, `starship.toml`, `qbar.css`, `steam.css`, `vencord.theme.css`, `neovim.lua`, `cava_theme`, `lazygit.yml`, and static assets such as `backgrounds/`, `preview.png`, `icons.theme`, and `vscode.json`.

## Credits

- Flat structure/source project: https://github.com/OldJobobo/omarchy-flat-dracula-theme
- One Dark Pro palette/source project: https://github.com/sc0ttman/omarchy-one-dark-pro-theme
