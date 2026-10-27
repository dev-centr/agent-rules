---
name: ship-app
description: >-
  Use when scaffolding, building, shipping, packaging, or maintaining an
  application, GUI, CLI, TUI, library, game client, or service; Software
  Product Essentials; About dialog; Help; debug dump; auto-update; installer;
  MSI; MSIX; winget; CI release pipeline; calling 1.0 done.
---

# Ship an application

Read [reference.md](reference.md), then adhere to local Software Product Essentials — do not invent shipping architecture from memory.

If `$CODE_ROOT/github.com/dev-centr/general-knowledge` is missing, clone `https://github.com/dev-centr/general-knowledge` there before improvising a checklist.

When the product is a **publishable library** (or depends on an owned/unpublished library), also load skill `library-registry-choice` before locking dependency metadata.

**Language:** libraries, runtimes, frameworks and CLIs use the org's primary language from its design docs (for example D for openshellorg and dlang-supplemental). If the design docs do not settle it, ask the human. Never default to TypeScript. The SolidStart/pnpm web stack from skill `bootstrap-org` applies only to sites, docs and web apps.

## Local source of truth

- Hub: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/software-product-essentials.adoc`
- Index, auxiliary features, delivery classes (`classes/desktop.adoc`, `web.adoc`, `mobile.adoc`), and checklists live in the same `explanation/architecture/` tree
- Type pages: `explanation/architecture/types/` (libraries, gui-apps, cli, tui, games, services)
- How-tos: `windows-auto-updates.adoc`, `unix-auto-updates.adoc`
- Interactive CentrMark checklists: `examples/product-essentials/` → project `.devcentr/checklists/` with progress in `.cmk.checks/`
- Published: https://docs.devcentr.org/general-knowledge/latest/explanation/architecture/software-product-essentials.html

## Core (not polish)

Treat these as required or adapted per the delivery-class matrix **before** calling 1.0:

- About / version + build id
- Help
- Debug dump (redacted)
- Update path
- Installer / package
- CI release pipeline (current action majors per `general/github-actions-versions.md`; `.github/dependabot.yml` for github-actions, grouped, monthly)

Copy the matching **delivery-class** auxiliary matrix (desktop / web / mobile) into the project plan; ship Band A first.

Windows GUI: plan MSI/MSIX or winget-friendly installers and auto-update (or Store/winget) before 1.0. Unix GUI: Store/Sparkle/Homebrew or distro/Flatpak/AppImage; never overwrite a running binary — quit → replace → relaunch.

Stamp build metadata at CI/compile time. About, `--version`, crash headers, and updaters share one version truth. Prefer platform-native distribution first; add in-app updaters when the channel needs them. Follow type pages instead of forcing GUI patterns onto libraries or services.

CLI and TUI apps: terminal output, logs, `--verbose`, `--json`, and exit codes follow the OpenShellOrg CLI Output standard (`general/cli-output.md`).

Functional shipping notes: skill `owned-changelog`. Version tags: skill `tag-release`. Docs hub: skill `antora-org-site`.

Public web apps and sites: load skill `web-crawlability`. Content-first routes need meaningful raw HTML plus generated sitemap/robots artifacts; hydration and transitions remain client enhancements.

**Product SVG logo / app glyph:** when the app needs an icon or mark family, load skill **`logo-svg-marks` on the first brand pass** (Opus design subagent; glyph + tile + mono) — do not ship a parent-authored placeholder SVG and wait for rejection.
