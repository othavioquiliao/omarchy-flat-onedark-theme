# Omarchy Flat OneDark Theme

Flat visual style based on `omarchy-flat-dracula-theme`, recolored with the One Dark Pro palette.

![Omarchy Flat OneDark Theme preview](preview.png)

## What's included
- Flat Dracula structure kept for Omarchy compatibility (terminal + Waybar + app themes)
- One Dark Pro color system across theme configs
- One Dark Pro starship prompt preset
- `waybar-theme/` kept (Flat 1:1 style, One Dark colors)
- Single source of truth for colors/opacities in `theme.tokens.sh`

## Theme Editing (One Place Only)

Edit only:

```bash
theme.tokens.sh
```

Then regenerate every theme file:

```bash
./scripts/build-theme.sh
```

This rewrites CSS, terminal, fish, hyprland and related theme files from the same palette.

## Solid Windows (No Transparency)

- Global window opacity is controlled in `hyprland.conf`.
- Generated rules keep all window opacity values at `1.0`.
- Ghostty also uses `background-opacity = 1.0`.

## Installation

```bash
omarchy-theme-install https://github.com/<seu-user>/omarchy-flat-onedark-theme
```

Starship is optional. To use this theme prompt:

```bash
mv ~/.config/starship.toml ~/.config/starship.toml.bak
cp ~/.config/omarchy/current/theme/starship.toml ~/.config/starship.toml
```

## Backgrounds
This theme ships with the One Dark backgrounds:
- `bg1.png`
- `bg2.png`
- `bg3.png`
- `bg4.png`
- `bg5.png`
- `bg6.png`
- `bg7.jpg`
- `bg8.jpg`

## Credits
- Flat structure/source project: https://github.com/OldJobobo/omarchy-flat-dracula-theme
- One Dark Pro palette/source project: https://github.com/sc0ttman/omarchy-one-dark-pro-theme
