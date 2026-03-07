# qbar Integration

## Purpose

This document defines the current supported qbar workflow for `flat-onedark`.

The supported model is:

- stock-safe Waybar by default
- optional qbar overlay when explicitly enabled
- theme-owned wiring
- qbar-owned runtime

## Current Supported Workflow

Use qbar with this theme through these commands only:

```bash
./scripts/enable-qbar-safe.sh
./scripts/disable-qbar-safe.sh
./scripts/apply-theme.sh --with-qbar
./scripts/apply-theme.sh --without-qbar
```

What happens on enable:

1. repair the live Waybar files
2. install qbar Waybar assets through qbar
3. read qbar module exports
4. read qbar CSS exports
5. compose the overlay into the live Waybar files only
6. persist `~/.config/waybar/.flat-onedark-qbar-overlay.json`
7. restart Waybar unless `--no-restart` is used

What happens on disable:

1. repair the live Waybar files back to stock-safe
2. clear the overlay state file
3. optionally remove qbar-owned Waybar assets

## Ownership Split

### Theme-owned wiring

This repo owns:

- overlay enable and disable
- overlay persistence state
- insertion of `custom/qbar-*` modules into the live Waybar config
- import of `qbar.css` into the live Waybar style
- keeping the repaired stock snapshot qbar-free

### qbar-owned runtime

qbar owns:

- the `qbar` executable
- `~/.config/qbar/*`
- `~/.cache/qbar/*`
- `~/.config/waybar/qbar/*`
- `~/.config/waybar/scripts/qbar-open-terminal`
- provider auth, status refresh, and exported module contract

## Supported and Unsupported Paths

Supported:

- `./scripts/enable-qbar-safe.sh`
- `./scripts/disable-qbar-safe.sh`
- `./scripts/apply-theme.sh --with-qbar`
- `./scripts/apply-theme.sh --without-qbar`

Supported with caution:

- `./scripts/apply-theme.sh` with an already-enabled overlay state file, because apply will preserve that state

Not supported as the primary integration path for this theme:

- using `qbar setup` as the live-bar integrator for this theme
- using qbar-side or manual Waybar edits as if qbar owned the live Waybar config
- adding qbar modules to the repaired stock snapshot

`qbar setup` may still be useful as a safe wrapper for qbar-owned assets and install paths, but it is not the supported live-bar integrator for this theme.

## Why This Split Exists

The repaired stock snapshot needs to stay deterministic. If live Waybar wiring happens outside the theme scripts, repeated manual edits or external tooling can drift the live files away from the stock-safe model.

The supported split avoids that by keeping:

- a stable repaired stock snapshot
- a reversible live overlay
- a clear owner for runtime data

## State and Recovery

The persisted overlay state lives at:

- `~/.config/waybar/.flat-onedark-qbar-overlay.json`

That state lets `./scripts/apply-theme.sh` re-apply the overlay after a normal theme apply.

If the overlay breaks:

1. return the live bar to stock-safe with `./scripts/disable-qbar-safe.sh` or `./scripts/repair-waybar.sh`
2. confirm qbar assets and exports still work
3. enable the overlay again through the theme scripts

## External qbar References

This theme consumes qbar's public contract. qbar-side details live in:

- [qbar README](/home/othavio/Work/qbar/README.md)
- [qbar commands](/home/othavio/Work/qbar/docs/commands.md)
- [qbar runtime](/home/othavio/Work/qbar/docs/runtime.md)
- [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md)

Theme-side companion docs:

- [build-and-apply.md](./build-and-apply.md)
- [file-ownership.md](./file-ownership.md)
- [runtime-surfaces.md](./runtime-surfaces.md)
- [troubleshooting.md](./troubleshooting.md)
