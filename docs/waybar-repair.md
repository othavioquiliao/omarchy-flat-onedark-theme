# Waybar Repair

## Why This Document Exists

Waybar is the surface that caused the most confusion in this project.

The visible symptom was simple:

- Waybar looked broken
- switching theme or style in `theme-manager` did not fix it
- even “default Omarchy” still looked wrong

The real cause was not the active theme alone. It was the Waybar default source being dirty in the local Omarchy working tree.

## Historical Failure Mode

### What users expected

- `theme-manager` default should restore a sane stock Waybar
- `omarchy-refresh-waybar` should reset Waybar to Omarchy defaults

### What actually happened

- `~/.config/waybar/themes/omarchy-default` pointed into `~/.local/share/omarchy/config/waybar`
- that Omarchy source path was locally modified
- any flow that copied from that path reproduced the bad state

So the “default” itself was already wrong.

## Why The Theme Does Not Fix This by Editing Omarchy Source

Editing `~/.local/share/omarchy` is the wrong fix because:

- it is Omarchy source managed by git
- updates can overwrite it
- it makes upstream drift worse
- the Omarchy skill contract for this machine treats it as read-only for customization work

The theme therefore solves the problem from the user config side only.

## Current Repair Model

### Repair target

The repair target is a local stock copy:

- `~/.config/waybar/themes/omarchy-default/config.jsonc`
- `~/.config/waybar/themes/omarchy-default/style.css`

### Repair source

The source is:

- `git HEAD:config/waybar/config.jsonc`
- `git HEAD:config/waybar/style.css`

inside the local Omarchy repo.

This is important:

- the repair uses committed Omarchy truth
- it ignores dirty working tree changes in `~/.local/share/omarchy/config/waybar`

### Live pointers

The live files are then repointed to the repaired local copy:

- `~/.config/waybar/config.jsonc`
- `~/.config/waybar/style.css`

## `scripts/repair-waybar.sh`

### Intent

Provide a single-purpose, repeatable Waybar recovery command that does not require a full theme apply.

### Behavior

The script:

1. checks that the Omarchy source is a git repo
2. warns if Omarchy Waybar source files are dirty
3. rebuilds `~/.config/waybar/themes/omarchy-default`
4. repoints the live Waybar symlinks
5. restarts Waybar unless `--no-restart` is used

### Flags

- `--dry-run`
- `--no-restart`

## Relationship to `scripts/apply-theme.sh`

`apply-theme.sh` delegates to `repair-waybar.sh --no-restart`.

That means:

- full theme application always repairs Waybar first
- the repair logic only needs to exist in one place

## Relationship to `theme-manager`

`theme-manager` is still useful for inspection and normal theme changes.

But for this repository:

- `theme-manager` is not the canonical fix for the historical Waybar corruption issue
- if the repaired local base is replaced by a contaminated reset, run `./scripts/repair-waybar.sh`

## Relationship to `omarchy-refresh-waybar`

Do not use `omarchy-refresh-waybar` as the primary recovery path for this repository.

Reason:

- it refreshes from the Omarchy config source path
- that source path is the very place that was dirty on this machine

If someone runs it manually and Waybar regresses:

- rerun `./scripts/repair-waybar.sh`
- or rerun `./scripts/apply-theme.sh`

## Relationship to qbar

qbar is a separate concern.

This repair model intentionally does not:

- inject qbar modules
- restore qbar icons in the default bar
- patch qbar-specific layout back into the repaired stock base

If qbar is desired, use `qbar setup` and accept that qbar owns that integration.

## Known Limitations

### Dirty Omarchy source still exists

The repair model bypasses the dirty source. It does not clean the source tree itself.

That is a deliberate tradeoff:

- safe for user customization
- no mutation of Omarchy source
- still leaves `git status` dirty in `~/.local/share/omarchy`

### Re-running a contaminated upstream reset can overwrite the local repaired base

If that happens, the repair is cheap and deterministic. Use the repair script again.

## Maintenance Rule

If Waybar regresses, do not immediately change theme CSS or tokens.

Check first:

1. where `~/.config/waybar/config.jsonc` resolves
2. where `~/.config/waybar/style.css` resolves
3. whether the local repaired stock base still exists
4. whether qbar was reintroduced outside this repo

Only after that should you change theme behavior.
