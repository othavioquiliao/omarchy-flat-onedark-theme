# OneDark Theme Design (Centralized Colors + Solid Windows)

## Date
2026-03-05

## Goals
- Fix invalid CSS usage in GTK CSS files.
- Centralize theme colors so all theme artifacts pull from one source.
- Remove transparency/opacity effects and keep solid window backgrounds.
- Add explicit comments where window opacity is controlled.

## Constraints
- Preserve One Dark visual identity.
- Keep Omarchy-compatible file layout.
- Avoid manual color drift across files.

## Selected Approach
Use a single token source and a generation script to output all theme files.

### Why this approach
- Guarantees one source of truth for colors and opacity.
- Prevents invalid GTK CSS variable usage (`var(--...)`) by generating valid `@define-color` usage.
- Keeps future edits predictable: update one file, rebuild all outputs.

## Architecture
- `theme.tokens.sh`: canonical palette and opacity values.
- `scripts/build-theme.sh`: generates theme outputs from tokens.
- Generated outputs include CSS and terminal/shell configs.

## Components
- GTK CSS targets: `gtk.css`, `waybar.css`, `waybar-theme/style.css`, `walker.css`, `swayosd.css`.
- Other theme targets: `colors.toml`, `alacritty.toml`, `kitty.conf`, `ghostty.conf`, `colors.fish`, `fzf.fish`, `steam.css`, `btop.theme`, `cava_theme`.
- Hyprland opacities: set to fully opaque and annotate opacity lines.

## Solid Window Policy
- No transparent window backgrounds in Waybar/Walker main windows.
- No blur/backdrop filters in launcher.
- Ghostty `background-opacity = 1.0`.
- Hyprland opacity rules forced to `1.0` for active/inactive.

## Validation Plan
- Check no GTK CSS files use `var(--...)`.
- Check no transparency/backdrop filters remain in core UI files.
- Confirm generated files include `AUTO-GENERATED` header.

## User Approval
User approved architecture, components/flow, and validation sections before implementation.
