# Build and Apply

## Public Commands

This theme exposes these operator-facing commands:

- `./scripts/build-theme.sh`
- `./scripts/audit-theme.sh`
- `./scripts/repair-waybar.sh`
- `./scripts/apply-theme.sh`
- `./scripts/enable-qbar-safe.sh`
- `./scripts/disable-qbar-safe.sh`

It also exposes one internal helper:

- `./scripts/apply-qbar-overlay.sh`

## `scripts/build-theme.sh`

Use this after changing `theme.tokens.sh` or generator logic.

It regenerates repo-owned outputs such as:

- `colors.toml`
- `waybar.css`
- `qbar.css`
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

It does not apply the theme and does not enable qbar.

## `scripts/apply-theme.sh`

Use this for the full theme apply path.

Sequence:

1. rebuild generated artifacts
2. sync the repo into `~/.config/omarchy/themes/flat-onedark`
3. sync `starship.toml`
4. repair the Waybar base through `./scripts/repair-waybar.sh --no-restart`
5. run `omarchy-theme-set flat-onedark`
6. optionally re-apply the qbar overlay
7. restart Waybar and Walker

Flags:

- `--dry-run`
- `--with-backups`
- `--clean-backups`
- `--with-qbar`
- `--without-qbar`

Use `--with-qbar` when you want theme apply to force the optional overlay on. Use `--without-qbar` when you want apply to clear the persisted overlay state and leave the bar stock-safe.

If the overlay state file already exists and is enabled, `apply-theme.sh` re-applies the overlay automatically after `omarchy-theme-set`.

## `scripts/enable-qbar-safe.sh`

Use this when the theme is already installed and you want to turn the qbar overlay on without a full theme apply.

It:

1. repairs the live Waybar base
2. delegates to the internal overlay helper
3. leaves the repaired stock snapshot unchanged

Flags:

- `--no-restart`

## `scripts/disable-qbar-safe.sh`

Use this when you want to restore the stock-safe bar without removing qbar itself.

It:

1. repairs the live Waybar base
2. removes `~/.config/waybar/.flat-onedark-qbar-overlay.json`
3. optionally removes qbar-owned Waybar assets

Flags:

- `--no-restart`
- `--purge-assets`

`--purge-assets` removes:

- `~/.config/waybar/qbar`
- `~/.config/waybar/scripts/qbar-open-terminal`

## `scripts/apply-qbar-overlay.sh`

This is an internal helper, not the preferred user entrypoint.

It composes the optional qbar overlay on top of the already-repaired live Waybar files by:

1. optionally running repair first with `--repair`
2. calling `qbar assets install`
3. reading `qbar export waybar-modules`
4. reading `qbar export waybar-css`
5. rewriting only the live `config.jsonc` and `style.css`
6. writing `~/.config/waybar/.flat-onedark-qbar-overlay.json`

Flags:

- `--repair`
- `--no-restart`

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

Apply the theme and ensure qbar is on:

```bash
./scripts/apply-theme.sh --with-qbar
```

Toggle qbar without a full apply:

```bash
./scripts/enable-qbar-safe.sh
./scripts/disable-qbar-safe.sh
```

## qbar References

This theme consumes qbar's external contract. For qbar-side command and runtime details, see:

- [qbar README](/home/othavio/Work/qbar/README.md)
- [qbar commands](/home/othavio/Work/qbar/docs/commands.md)
- [qbar runtime](/home/othavio/Work/qbar/docs/runtime.md)
- [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md)
