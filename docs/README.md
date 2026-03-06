# Documentation Index

This directory is the canonical context set for this theme.

Use these documents as the source of truth when:

- maintaining the repository
- debugging a live Omarchy system
- handing the theme to another developer
- handing the theme to another coding agent

## Read Order

1. [architecture.md](./architecture.md)
2. [file-ownership.md](./file-ownership.md)
3. [build-and-apply.md](./build-and-apply.md)
4. [runtime-surfaces.md](./runtime-surfaces.md)
5. [waybar-repair.md](./waybar-repair.md)
6. [troubleshooting.md](./troubleshooting.md)

## What Each Document Covers

- `architecture.md`
  - high-level design, source-of-truth model, generation flow, repo layout, and why Waybar is treated differently
- `file-ownership.md`
  - who owns each file and runtime surface: this repo, Omarchy templates, local repaired state, qbar, or the user
- `build-and-apply.md`
  - exact behavior of `build-theme.sh`, `audit-theme.sh`, `repair-waybar.sh`, and `apply-theme.sh`
- `runtime-surfaces.md`
  - detailed mapping from repo file to live runtime file and reload path
- `waybar-repair.md`
  - the historical Waybar failure mode, the current repair model, and how to recover from drift
- `troubleshooting.md`
  - practical diagnosis and recovery procedures for the known failure modes

## Fast Facts

- `theme.tokens.sh` is the only source of truth for palette and shared design tokens.
- `scripts/build-theme.sh` regenerates the repo-owned generated files.
- `scripts/audit-theme.sh` enforces ownership and anti-drift rules.
- `scripts/repair-waybar.sh` repairs the local stock Waybar base in `~/.config/waybar`.
- `scripts/apply-theme.sh` is the end-to-end path for applying the theme.
- This repository must not edit `~/.local/share/omarchy`.
- `qbar` is not part of the default Waybar contract for this theme.

## Operational Principle

The theme is intentionally split into three layers:

1. token source
2. generated repo-owned artifacts
3. Omarchy-generated template outputs plus repaired local runtime state

That split is deliberate. Most historical bugs in this repo came from violating ownership boundaries, especially around Waybar.

## Legacy Documents

- [theme-color-map.md](./theme-color-map.md) is kept only as a compatibility entrypoint for older links.
- `docs/plans/` contains historical planning documents and should not be treated as current operational truth.
