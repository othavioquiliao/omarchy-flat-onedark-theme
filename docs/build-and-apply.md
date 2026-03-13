# Build and Apply

## Public Commands

This theme exposes these operator-facing commands:

- `./scripts/build-theme.sh`
- `./scripts/audit-theme.sh`
- `./scripts/repair-waybar.sh`
- `./scripts/apply-theme.sh`

## `scripts/build-theme.sh`

Use this after changing `theme.tokens.sh` or generator logic.

It regenerates repo-owned outputs such as:

- `colors.toml`
- `waybar.css`
- `walker.css`
- `gtk.css`
- `hyprland.conf`
- `starship.toml`

It does not apply the theme, restart services, or repair Waybar.

## `scripts/audit-theme.sh`

Use this after ownership or structural changes.

It checks:

- template-shadowing drift
- forbidden legacy Waybar layout files
- repair/apply script wiring
- that this repo does not mutate `~/.local/share/omarchy`

## `scripts/repair-waybar.sh`

Use this when the live bar needs to return to a stock-safe baseline.

It:

1. reads Omarchy git `HEAD`
2. rebuilds `~/.config/waybar/themes/omarchy-default/`
3. rewrites live `config.jsonc` and `style.css` as plain files from that repaired snapshot
4. optionally restarts Waybar

Flags:

- `--dry-run`
- `--no-restart`

It does not apply the theme.

## `scripts/apply-theme.sh`

Use this for the full theme apply path.

Sequence:

1. rebuild generated artifacts
2. sync the repo into `~/.config/omarchy/themes/flat-onedark`
3. sync `starship.toml`
4. repair the Waybar base through `./scripts/repair-waybar.sh --no-restart`
5. run `omarchy-theme-set flat-onedark`
6. restart Waybar and Walker

Flags:

- `--dry-run`
- `--with-backups`
- `--clean-backups`

## Typical Workflows

Design iteration:

```bash
./scripts/build-theme.sh
./scripts/audit-theme.sh
```

Repair the live bar only:

```bash
./scripts/repair-waybar.sh
```

Apply the theme:

```bash
./scripts/apply-theme.sh
```
