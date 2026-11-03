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

The explanation (defaults per type, and why) lives in general-knowledge. Read it before choosing formats:

- Published: https://docs.devcentr.org/general-knowledge/explanation/architecture/distribution-and-packaging/package-formats-by-software-type/
- Local clone: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/distribution-and-packaging/package-formats-by-software-type.adoc`

Architectures come from skill `release-targets`. CI wiring comes from skill `polyglot-ci`. Product features come from skill `ship-app`. Libraries: skill `library-registry-choice`. Deviate only with a reason recorded in the repo's changelog details.

## Agent rules

- Publishing to winget-pkgs, the AUR, homebrew-core, or nixpkgs is a manual, maintainer-owned step. Never submit without asking.
- Generate tap formulas, PKGBUILD, `.SRCINFO` and Nix sources from `SHA256SUMS` with scripts in `packaging/`. Do not hand-edit checksums.
- A missing tap-push token warns and documents the manual bump; it never fails the release.
- Never move a tag. If a release run fails after tagging, fix it and cut the next patch version.

Reference implementation: `dev-centr/envsafe` (`packaging/`, `.github/workflows/release.yml`, `flake.nix`) and `dev-centr/homebrew-tap`.
