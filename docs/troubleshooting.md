# Troubleshooting

## Waybar Still Looks Wrong After Apply

### Likely cause

The live Waybar files are no longer pointing at the repaired local stock base, or qbar reintroduced custom modules/styles outside this repository.

### Check

```bash
readlink -f ~/.config/waybar/config.jsonc
readlink -f ~/.config/waybar/style.css
```

Expected:

- both should resolve into `~/.config/waybar/themes/omarchy-default/`

### Fix

```bash
./scripts/repair-waybar.sh
```

If you also want to reapply the entire theme:

```bash
./scripts/apply-theme.sh
```

## theme-manager “Default Omarchy” Still Looks Wrong

### Likely cause

The local Omarchy source tree still contains dirty Waybar defaults, and a reset copied from the wrong place again.

### Fix

```bash
./scripts/repair-waybar.sh
```

### Important

This is not necessarily a failure of the active theme. It is often a failure of the local stock base.

## qbar Came Back Unexpectedly

### Likely cause

qbar was installed or reconfigured outside this theme and owns its own Waybar integration again.

### Check

Look for qbar modules or qbar assets under `~/.config/waybar/`.

### Interpretation

- if qbar is present, the bar is no longer purely under the default contract documented by this repo
- qbar behavior must be debugged as qbar-owned state first

## wifi / bluetooth / audio / processes Look Unreadable

### Likely cause

These are not pure Waybar CSS problems.

They usually come from:

- terminal ANSI colors
- the TUI application itself

### Mapping

- `wifi` -> `impala`
- `bluetooth` -> `bluetui`
- `audio` -> `wiremix`
- `processes` -> `btop`

### Fix path

Review:

- `theme.tokens.sh`
- generated terminal palette through `colors.toml`

Do not start by changing Waybar unless the issue is clearly inside the bar itself.

## Power or Omarchy Menus Look Wrong

### Likely cause

These usually route through Walker, not Waybar.

### Fix path

Review:

- `walker.css`
- Walker-related tokens in `theme.tokens.sh`

## `omarchy-refresh-waybar` Reintroduced the Bug

### Explanation

That command refreshes from Omarchy config defaults. On this machine, those defaults were historically dirty in the local Omarchy working tree.

### Fix

```bash
./scripts/repair-waybar.sh
```

## The Omarchy Source Tree Is Dirty

### Check

```bash
git -C ~/.local/share/omarchy status --short -- config/waybar/config.jsonc config/waybar/style.css
```

### Meaning

This repository does not attempt to clean that tree.

The supported behavior is:

- read git `HEAD`
- reconstruct clean local runtime files in `~/.config`

### Do not do this from this repo

- edit `~/.local/share/omarchy` directly as part of theme customization

## Generated Files Drifted From Tokens

### Symptom

You changed `theme.tokens.sh`, but runtime behavior still reflects old values or repo files disagree with tokens.

### Fix

```bash
./scripts/build-theme.sh
./scripts/audit-theme.sh
```

Then reapply:

```bash
./scripts/apply-theme.sh
```

## Backups Are Accumulating Again

### Explanation

Backups are optional now. They are only created when `--with-backups` is used, but older iterations may have left backup files behind.

### Cleanup

```bash
./scripts/apply-theme.sh --clean-backups
```

## The Theme Applied But A Surface Did Not Change

### Diagnosis order

1. Confirm the surface is actually owned by this repo.
2. If not, confirm whether it is template-driven.
3. If not, confirm whether it is local runtime state.
4. If not, confirm whether it belongs to qbar or another external integration.

### Common examples

- Waybar layout issue: repair script / local stock base
- Terminal TUI issue: ANSI palette
- Power menu issue: Walker
- GNOME icon theme issue: `icons.theme`
- Browser color issue: generated `chromium.theme`

## When To Escalate to Code Changes

Only change code after the owner of the broken surface is clear.

If ownership is unclear, use these documents in order:

1. `runtime-surfaces.md`
2. `file-ownership.md`
3. `waybar-repair.md`
