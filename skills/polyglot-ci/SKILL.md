---
name: polyglot-ci
description: >-
  Use when generating GitHub Actions CI/CD, release.yml, workflow matrix,
  win/mac/lin/BSD, x64, arm64, macos-14, ubuntu-24.04-arm, windows-11-arm,
  cosmocc, APE, binary-tailor, polyglot pack, or GitHub Intel Mac runners.
---

# Polyglot CI matrix

House release matrix for owned apps and CLIs. Expand **named patterns** from skill `release-targets` (`patterns.sdl`) — default **`common`** / GUI **`desktop`**. Detail: [workflow.yml](workflow.yml), [matrix.md](matrix.md). Docs: https://docs.devcentr.org/general-knowledge/latest/how-to/polyglot-ci.html · https://docs.devcentr.org/general-knowledge/latest/explanation/architecture/release-target-patterns.html

## Do this

1. Resolve the release-target pattern (`common`, `desktop`, `lab`, dated `common/2026`, …) via skill `release-targets`.
2. Copy [workflow.yml](workflow.yml) to `.github/workflows/release.yml` (or merge the `matrix.include` into an existing workflow) so it matches that pattern’s triplets.
3. Replace the `Build` step with the project's compiler (`dub build`, `cargo build --release`, `pnpm build`, …). Stamp version from the git tag.
4. Upload **per-triplet** artifacts named `app-${{ matrix.triplet }}`.
5. On tags, a `pack` job runs `binary-tailor pack` and attaches **one** `app.bin` to the GitHub Release.
6. Optional job: `cosmocc` APE **in addition to** native slices — never instead of native GUI/GPU builds.

## Matrix (hosted) — pattern `desktop` / `common` (2026)

| Triplet | `runs-on` | In `common` | In `desktop` |
| --- | --- | --- | --- |
| `windows-x64` | `windows-latest` | yes | yes |
| `windows-arm64` | `windows-11-arm` (omit job only if the org cannot use it; still document the triplet) | yes | yes |
| `linux-x64` | `ubuntu-latest` | yes | yes |
| `linux-arm64` | `ubuntu-24.04-arm` | yes | yes |
| `macos-arm64` | `macos-14` (or `macos-15`) | no | yes |

**Never** add `macos-13` / Intel Mac GitHub-hosted runners. They are not a supported path. macOS = arm64 only.

**BSD / lab ISAs:** no GitHub-hosted images for FreeBSD, ppc64le, riscv64, s390x. Add Cirrus or self-hosted; or cross-compile **and** document that the slice is untested on that kernel. See pattern `lab` / `omnibus` in `patterns.sdl`.

## Delivery

Users download one pack. [Binary Tailor](https://github.com/dev-centr/binary-tailor) writes a host PE/ELF/Mach-O. Do not grow a 12-button Download page unless Tailor is unavailable.

## Do not

- One workflow per OS as twelve copy-pasted files
- Claim APE is AV-safe; Tailor exists because it is not
- Replace `ship-app` Product Essentials (About, installer, signing) with a zip pack
- Ship only x64 Windows/Linux when the project uses living `common` / `desktop` (2026+)
