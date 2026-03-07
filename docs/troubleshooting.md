# Troubleshooting

## Quick Diagnosis Table

| Symptom | Likely owner | Check | Fix |
| --- | --- | --- | --- |
| Waybar missing after enabling qbar | live Waybar overlay wiring or exported CSS | run `waybar --log-level trace` and inspect `~/.config/waybar/style.css` | `./scripts/disable-qbar-safe.sh` then retry after fixing the export |
| Overlay state enabled but qbar widgets missing | qbar assets or exports | check `~/.config/waybar/.flat-onedark-qbar-overlay.json`, `~/.config/waybar/qbar/`, and `~/.config/waybar/scripts/qbar-open-terminal` | `./scripts/enable-qbar-safe.sh` |
| `qbar` not found during enable/apply | qbar runtime install | `command -v qbar` | install/fix qbar, then rerun enable or apply |
| Exported modules are invalid | qbar contract | run the qbar export commands with the same arguments used by the theme helper | fix qbar-side contract, then re-enable |
| `apply-theme.sh` completed but qbar overlay is gone | overlay state or explicit `--without-qbar` | inspect `~/.config/waybar/.flat-onedark-qbar-overlay.json` | rerun `./scripts/enable-qbar-safe.sh` or `./scripts/apply-theme.sh --with-qbar` |
| Default Omarchy reset still looks wrong | repaired stock snapshot replaced by dirty local source | inspect `~/.config/waybar/themes/omarchy-default/` | `./scripts/repair-waybar.sh` |

## Waybar Still Looks Wrong After Apply

Check:

```bash
stat ~/.config/waybar/config.jsonc ~/.config/waybar/style.css
```

Expected:

- both are regular files
- neither is being treated as a special local override path

Fix:

```bash
./scripts/repair-waybar.sh
./scripts/apply-theme.sh
```

## CSS Parser Failure After Enabling qbar

Likely cause:

- invalid CSS in the live style
- invalid CSS exported by qbar
- a manual edit in `~/.config/waybar/style.css`

Check:

```bash
waybar --log-level trace
sed -n '1,220p' ~/.config/waybar/style.css
```

Fix:

```bash
./scripts/disable-qbar-safe.sh
./scripts/enable-qbar-safe.sh
```

If the failure comes from qbar exports, treat it as a qbar-side issue first. See [qbar README](/home/othavio/Work/qbar/README.md) and [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md).

Manual export checks:

```bash
qbar export waybar-modules \
  --qbar-bin "$(command -v qbar)" \
  --terminal-script ~/.config/waybar/scripts/qbar-open-terminal

qbar export waybar-css \
  --icons-dir ~/.config/waybar/qbar/icons
```

## Overlay State Active But Assets Are Missing

Likely cause:

- `~/.config/waybar/.flat-onedark-qbar-overlay.json` still says enabled
- qbar-owned Waybar assets were deleted or never installed

Check:

```bash
ls ~/.config/waybar/qbar
ls ~/.config/waybar/scripts/qbar-open-terminal
```

Fix:

```bash
./scripts/enable-qbar-safe.sh
```

## `qbar` Missing From `PATH`

Likely cause:

- qbar is not installed correctly
- the shell environment used by the script cannot find the qbar binary

Check:

```bash
command -v qbar
```

Fix the qbar install first, then rerun:

```bash
./scripts/enable-qbar-safe.sh
```

## Live Bar Returned To Stock-Safe After Repair

This is expected if you run `./scripts/repair-waybar.sh` directly. Repair restores the stock-safe bar and does not re-enable the overlay by itself.

To bring qbar back:

```bash
./scripts/enable-qbar-safe.sh
```

or:

```bash
./scripts/apply-theme.sh --with-qbar
```

## Terminal Widgets Look Unreadable

These usually are not Waybar CSS problems.

Common mappings:

- `wifi` -> `impala`
- `bluetooth` -> `bluetui`
- `audio` -> `wiremix`
- `cpu` / processes -> `btop`

Review terminal palette inputs first:

- `theme.tokens.sh`
- generated `colors.toml`

## Power Or Omarchy Menus Look Wrong

Those usually route through Walker, not Waybar.

Review:

- `walker.css`
- Walker-related tokens in `theme.tokens.sh`

## Omarchy Source Tree Is Dirty

Check:

```bash
git -C ~/.local/share/omarchy status --short -- config/waybar/config.jsonc config/waybar/style.css
```

This repo does not clean that tree. The supported response is to rebuild local runtime state instead:

```bash
./scripts/repair-waybar.sh
```

## When To Change Code

Only change scripts or generators after the owner is clear.

Use these docs in order:

1. [runtime-surfaces.md](./runtime-surfaces.md)
2. [file-ownership.md](./file-ownership.md)
3. [waybar-repair.md](./waybar-repair.md)
4. [qbar-integration.md](./qbar-integration.md)
