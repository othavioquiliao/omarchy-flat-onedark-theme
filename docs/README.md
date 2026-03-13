# Documentation Index

This directory is the canonical context set for the `flat-onedark` theme.

Use it as the source of truth for:

- repository maintenance
- live Omarchy debugging
- Waybar repair and rollback

## Read Order

1. [architecture.md](./architecture.md)
2. [file-ownership.md](./file-ownership.md)
3. [build-and-apply.md](./build-and-apply.md)
4. [runtime-surfaces.md](./runtime-surfaces.md)
5. [waybar-repair.md](./waybar-repair.md)
6. [troubleshooting.md](./troubleshooting.md)

## Document Map

- `architecture.md`
  - system model and stock-safe Waybar base
- `file-ownership.md`
  - who writes each runtime surface and who must not
- `build-and-apply.md`
  - public scripts and flags
- `runtime-surfaces.md`
  - repo-to-runtime path map
- `waybar-repair.md`
  - why repair exists and how to use it
- `troubleshooting.md`
  - operational diagnosis for repair and runtime failures

## Fast Facts

- `theme.tokens.sh` is the only source of truth for palette and shared design tokens.
- `./scripts/build-theme.sh` regenerates repo-owned outputs.
- `./scripts/repair-waybar.sh` rebuilds the repaired stock snapshot and rewrites live Waybar files as plain files.
- `./scripts/apply-theme.sh` is the full apply path.

## Legacy Documents

- `docs/plans/` contains historical planning documents, not current operational truth.
