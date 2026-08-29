---
name: release-targets
description: >-
  Use when choosing release architectures, build/release target patterns,
  common/desktop/lab/omnibus/all matrices, common/2026, default 2025,
  win/lin x64 arm64 defaults, release target patterns, patterns.sdl,
  ISA catalog, or which triplets to ship on a GitHub Release.
---

# Release target patterns

Read [patterns.sdl](patterns.sdl) and [../../general/release-target-patterns.md](../../general/release-target-patterns.md).
Docs: https://docs.devcentr.org/general-knowledge/latest/explanation/architecture/release-target-patterns.html

## Do this

1. Resolve the pattern name:
   - Bare (`common`, `desktop`, …) → `current_year` block in `patterns.sdl`.
   - Dated (`common/2026`, “lab 2025”) → that `year` block only.
   - Unspecified → **`common`** (alias **`default`**). GUI apps that need a Mac build → prefer **`desktop`**.
2. Expand `triplets` from the pattern. Map each to `github_runs_on` when generating CI (skill `polyglot-ci`).
3. Empty `github_runs_on` → Cirrus / self-hosted / cross-compile; document “untested on kernel” if cross-only.
4. **`omnibus` / `all`**: confirm with the user — it is deliberately unusual.
5. After changing `patterns.sdl`, update the published docs page in `dev-centr/general-knowledge` in the same effort when practical.

## Do not

- Schedule GitHub `macos-13` / Intel Mac runners.
- Silently replace a dated citation (`common/2025`) with living `common`.
- Drop `windows-arm64` or `linux-arm64` from `common` without bumping `current_year` and freezing the old year block.

## Related

- Skill `polyglot-ci` — workflow YAML + runner notes
- Skill `tag-release` — SemVer tags for the release that carries these slices
- Skill `ship-app` — installers / About still required
