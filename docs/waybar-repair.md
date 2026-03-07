# Waybar Repair

## Why Repair Exists

Waybar was the surface most affected by local drift.

The historical failure mode was:

- Waybar looked broken
- switching theme or resetting to default did not fix it
- the local Omarchy source tree still carried dirty `config/waybar/*`

The repair flow exists to rebuild a clean stock-safe baseline without writing into `~/.local/share/omarchy`.

## Repair Model

`./scripts/repair-waybar.sh` rebuilds:

- `~/.config/waybar/themes/omarchy-default/config.jsonc`
- `~/.config/waybar/themes/omarchy-default/style.css`

from Omarchy git `HEAD`, then rewrites:

- `~/.config/waybar/config.jsonc`
- `~/.config/waybar/style.css`

as plain files from that repaired stock snapshot.

The repaired snapshot remains qbar-free.

## Script Behavior

`./scripts/repair-waybar.sh`:

1. verifies that `~/.local/share/omarchy` is a git repo
2. warns if local Omarchy Waybar sources are dirty
3. rebuilds `~/.config/waybar/themes/omarchy-default/`
4. rewrites live Waybar files from that snapshot
5. optionally restarts Waybar

Flags:

- `--dry-run`
- `--no-restart`

## Relationship to `apply-theme.sh`

`./scripts/apply-theme.sh` always runs `./scripts/repair-waybar.sh --no-restart` before `omarchy-theme-set`.

That keeps theme apply deterministic even when the local Omarchy working tree is dirty.

If the persisted qbar overlay state is enabled, `apply-theme.sh` re-applies the optional overlay after the theme apply step.

## Relationship to qbar

Repair restores the stock-safe bar. It does not uninstall qbar and it does not purge qbar-owned assets.

Repair intentionally does not:

- add qbar modules
- import `qbar.css`
- write qbar assets
- change `~/.config/qbar/*`
- change `~/.cache/qbar/*`

If you run repair while qbar was enabled, the live bar returns to stock-safe until you:

- run `./scripts/enable-qbar-safe.sh`, or
- run `./scripts/apply-theme.sh --with-qbar`, or
- run `./scripts/apply-theme.sh` with an enabled overlay state file already present

See [qbar-integration.md](./qbar-integration.md) for the supported overlay flow and [qbar README](/home/othavio/Work/qbar/README.md) for qbar-owned runtime details.

## Relationship to `theme-manager` and `omarchy-refresh-waybar`

For this repo, neither is the canonical repair path.

Why:

- they can copy from local Omarchy state that may already be dirty
- this repo needs a repair path that reads committed Omarchy truth instead

If either command reintroduces a bad bar, run:

```bash
./scripts/repair-waybar.sh
```

## Maintenance Rule

If Waybar regresses, check this order before changing theme tokens or CSS:

1. does the repaired stock snapshot exist
2. are live Waybar files regular plain files
3. is the overlay state file enabled
4. were qbar assets or exports removed
5. did a reset path overwrite the repaired snapshot
