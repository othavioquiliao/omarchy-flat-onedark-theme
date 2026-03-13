# Troubleshooting

## Quick Diagnosis Table

| Symptom | Likely owner | Check | Fix |
| --- | --- | --- | --- |
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

## CSS Parser Failure In Waybar

Likely cause:

- invalid CSS in the live style
- a manual edit in `~/.config/waybar/style.css`

Check:

```bash
waybar --log-level trace
sed -n '1,220p' ~/.config/waybar/style.css
```

Fix:

```bash
./scripts/repair-waybar.sh
./scripts/apply-theme.sh
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
