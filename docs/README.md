# Documentation Index

This directory is the canonical context set for the `flat-onedark` theme.

Use it as the source of truth for:

- repository maintenance
- live Omarchy debugging
- Waybar repair and rollback
- the supported qbar overlay workflow

## Read Order

1. [architecture.md](./architecture.md)
2. [file-ownership.md](./file-ownership.md)
3. [build-and-apply.md](./build-and-apply.md)
4. [runtime-surfaces.md](./runtime-surfaces.md)
5. [waybar-repair.md](./waybar-repair.md)
6. [qbar-integration.md](./qbar-integration.md)
7. [troubleshooting.md](./troubleshooting.md)

## Document Map

- `architecture.md`
  - system model, stock-safe Waybar base, and optional qbar overlay
- `file-ownership.md`
  - who writes each runtime surface and who must not
- `build-and-apply.md`
  - public scripts, flags, and the internal qbar overlay helper
- `runtime-surfaces.md`
  - repo-to-runtime path map, including qbar state and assets
- `waybar-repair.md`
  - why repair exists and how it relates to qbar overlay re-application
- `qbar-integration.md`
  - current supported qbar workflow for this theme
- `troubleshooting.md`
  - operational diagnosis for repair, overlay, and runtime failures

## Fast Facts

- `theme.tokens.sh` is the only source of truth for palette and shared design tokens.
- `./scripts/build-theme.sh` regenerates repo-owned outputs.
- `./scripts/repair-waybar.sh` rebuilds the repaired stock snapshot and rewrites live Waybar files as plain files.
- `./scripts/apply-theme.sh` is the full apply path.
- `./scripts/enable-qbar-safe.sh` and `./scripts/disable-qbar-safe.sh` are the supported qbar overlay toggles.
- `qbar` is optional and not part of the default stock-safe bar.
- `qbar setup` is not the supported integration path for this theme.

## Integrated Setup

This theme owns the live Waybar wiring for the optional qbar overlay. The qbar repo owns qbar runtime, provider state, cache, and Waybar assets.

External qbar references:

- [qbar README](/home/othavio/Work/qbar/README.md)
- [qbar commands](/home/othavio/Work/qbar/docs/commands.md)
- [qbar runtime](/home/othavio/Work/qbar/docs/runtime.md)
- [qbar Waybar contract](/home/othavio/Work/qbar/docs/waybar-contract.md)

## Legacy Documents

- [theme-color-map.md](./theme-color-map.md) is a legacy compatibility entrypoint.
- `docs/plans/` contains historical planning documents, not current operational truth.
