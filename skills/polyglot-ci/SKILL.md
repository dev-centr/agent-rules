---
name: polyglot-ci
description: >-
  Use when generating GitHub Actions CI/CD, release.yml, workflow matrix,
  win/mac/lin/BSD, x64, arm64, macos-14, ubuntu-24.04-arm, windows-11-arm,
  cosmocc, APE, binary-tailor, polyglot pack, or GitHub Intel Mac runners.
---

# Polyglot CI matrix

House release matrix for owned apps and CLIs. Detail: [workflow.yml](workflow.yml), [matrix.md](matrix.md). Docs: https://docs.devcentr.org/general-knowledge/latest/how-to/polyglot-ci.html

## Do this

1. Copy [workflow.yml](workflow.yml) to `.github/workflows/release.yml` (or merge the `matrix.include` into an existing workflow).
2. Replace the `Build` step with the project's compiler (`dub build`, `cargo build --release`, `pnpm build`, …). Stamp version from the git tag.
3. Upload **per-triplet** artifacts named `app-${{ matrix.triplet }}`.
4. On tags, a `pack` job runs `binary-tailor pack` and attaches **one** `app.bin` to the GitHub Release.
5. Optional job: `cosmocc` APE **in addition to** native slices — never instead of native GUI/GPU builds.

## Matrix (hosted)

| Triplet | `runs-on` |
| --- | --- |
| `windows-x64` | `windows-latest` |
| `windows-arm64` | `windows-11-arm` (omit if the org cannot use it) |
| `macos-arm64` | `macos-14` (or `macos-15`) |
| `linux-x64` | `ubuntu-latest` |
| `linux-arm64` | `ubuntu-24.04-arm` |

**Never** add `macos-13` / Intel Mac GitHub-hosted runners. They are not a supported path. macOS = arm64 only.

**BSD:** no GitHub-hosted images. Add Cirrus (`.cirrus.yml`) or a self-hosted runner; or cross-compile **and** document that the slice is untested on that kernel.

## Delivery

Users download one pack. [Binary Tailor](https://github.com/dev-centr/binary-tailor) writes a host PE/ELF/Mach-O. Do not grow a 12-button Download page unless Tailor is unavailable.

## Do not

- One workflow per OS as twelve copy-pasted files
- Claim APE is AV-safe; Tailor exists because it is not
- Replace `ship-app` Product Essentials (About, installer, signing) with a zip pack
