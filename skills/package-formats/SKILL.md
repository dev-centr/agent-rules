---
name: package-formats
description: >-
  Use when choosing installer or package formats, "which package managers",
  "should we ship a snap", Snap, Flatpak, AppImage, MSI, MSIX, winget, .pkg,
  .dmg, Homebrew tap, brew formula, .deb, .rpm, nfpm, AUR, PKGBUILD, -bin
  package, Nix flake, nix run, container image, systemd unit, packaging a CLI,
  GUI app, library, service, daemon, SDK, or toolchain for release, or
  "release in standard package formats".
---

# Package formats by software type

The DevCentr defaults for which package formats to ship. Architectures come from skill `release-targets`. CI wiring comes from skill `polyglot-ci`. Product features come from skill `ship-app`. Deviate only with a reason recorded in the repo's changelog details.

## Defaults

| Type | Windows | macOS | Linux | Not by default |
| --- | --- | --- | --- | --- |
| CLI / TUI | MSI; winget manifest optional | `.pkg` (universal when possible) + Homebrew tap formula | `.deb` + `.rpm` (x64, arm64), tarballs, AUR `<name>-bin` PKGBUILD, Nix flake with `apps.default` | Snap, Flatpak |
| GUI desktop app | MSIX or MSI (+ winget) | `.dmg` (drag-install) or `.pkg` | Flatpak (primary) + AppImage; `.deb`/`.rpm` optional; Snap optional | - |
| Library | - | - | - | OS packages. Ship to the language registry only (DUB, npm, crates.io, PyPI, NuGet); see `library-registry-choice` |
| Service / daemon | MSI with a Windows service when supported | Homebrew formula with `service do` if relevant | OCI container image (multi-arch) + `.deb`/`.rpm` with a systemd unit and a dedicated user | Snap, Flatpak, AppImage |
| Dev SDK / toolchain | MSI or zip + winget | `.pkg` + Homebrew | tarball with relocatable layout + `.deb`/`.rpm`; Nix flake; version-manager friendly (one dir per version) | Snap, Flatpak (sandboxing breaks toolchains) |
| Editor / IDE extension | - | - | - | OS packages. Ship to the marketplace (VS Code Marketplace + Open VSX, JetBrains) |
| GitHub Action / CI template | - | - | - | Packages. Use a tagged release in the repo, with Marketplace listing optional |

Always also: SHA256SUMS on the GitHub Release, plain archives (`.tar.gz`, `.zip`) for every target, and an install section in the README listing each command.

## Why

- **CLIs: no Snap or Flatpak.** Both sandbox the process. A CLI has to read the user's project files, `$PATH` and dotfiles, and confinement breaks that or forces classic confinement and store review. Flatpak is built for GUI apps and has no good CLI story. Native `.deb`/`.rpm` and Homebrew put a plain binary on `PATH` with no runtime.
- **CLIs: AUR `-bin` and Nix flake** cost almost nothing (they repackage the release tarball) and reach users who never touch `.deb`. The release workflow refreshes their checksums on every tag. Submission to the AUR or nixpkgs is a separate, manual, maintainer-owned step. Never do it without asking.
- **Homebrew tap before homebrew-core.** A tap ships on day one. Core needs notability and review.
- **macOS `.pkg` for CLIs, `.dmg` for GUI.** A `.pkg` can write to `/usr/local/bin`. A `.dmg` is the expected drag-to-Applications path for `.app` bundles. Without a Developer ID, say "unsigned" in the release notes.
- **GUI on Linux: Flatpak primary.** One build runs across distros, with sandboxed portals and Flathub discovery. AppImage covers no-install use. Snap is optional because its store is Canonical-centric.
- **Libraries: registry only.** Consumers resolve libraries through their language's package manager. OS packages for libraries are for distro maintainers to make.
- **Services: container + systemd packages.** Operators deploy via containers or config management. `.deb`/`.rpm` with a unit file gives `systemctl enable --now` and clean upgrades.
- **SDKs: side-by-side versions.** Toolchains are pinned per project, so layouts must allow several versions installed at once. Sandboxed formats break compiler and linker access.

## Implementation notes

- Build `.deb`/`.rpm` with nfpm from one `packaging/nfpm.yaml`. Name them `<name>_<ver>_<amd64|arm64>.deb` and `<name>-<ver>-1.<x86_64|aarch64>.rpm`.
- Smoke-install the `.deb` in CI (install, `--version`, remove, `test ! -e /usr/bin/<name>`. Do not use `command -v`, because bash's hash cache gives a false pass).
- Generate tap formulas, PKGBUILD, `.SRCINFO` and Nix sources from `SHA256SUMS` with scripts kept in `packaging/`. Do not hand-edit the checksums.
- Pushing to a tap needs a token secret. When it is missing, warn and document the manual bump. Never fail the release over it.
- Never move a tag. If a release run fails after tagging, fix it and cut the next patch version.

## Reference implementation

`dev-centr/envsafe` (`packaging/`, `.github/workflows/release.yml`, `flake.nix`) and `dev-centr/homebrew-tap`. Public explainer: DevCentr docs, general-knowledge, "Package formats by software type".
