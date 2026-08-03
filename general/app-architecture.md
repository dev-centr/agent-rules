# App architecture (optional layer)

Read this file when you **scaffold, build, ship, package, or maintain** an application, CLI, TUI, library intended for publish, game client, or long-running service—for repositories the user owns. Skip it for pure infra/docs-only tasks with no product surface.

## Local source of truth

Consult and **adhere** to the Software Product Essentials framework in the local general-knowledge clone (do not reinvent shipping architecture from memory):

- **Hub:** `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/software-product-essentials.adoc`
- **Index:** `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/index.adoc`
- **Checklist:** `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/reference/app-essentials-checklist.adoc`

Deep dives in the same `explanation/architecture/` folder cover About/build info, automatic updates (Windows emphasis), distribution/installers, build pipeline, and diagnostics. Type-specific pages live under `explanation/architecture/types/` (libraries, gui-apps, cli, tui, games, services).

Published mirror (when online): `https://docs.devcentr.org/general-knowledge/latest/explanation/architecture/software-product-essentials.html`

If the local clone is missing, clone `https://github.com/dev-centr/general-knowledge` to `$CODE_ROOT/github.com/dev-centr/general-knowledge` before inventing an alternate checklist.

## Obligations when building apps

- Treat **About / version + build id**, **debug dump** (redacted), **update path**, **installer/package**, and **CI release pipeline** as core features—not polish—for the artifact types where the matrix marks them required or adapted.
- On **Windows GUI apps**, plan MSI/MSIX or winget-friendly installers and auto-update (or Store/winget updates) before calling 1.0 done.
- Stamp build metadata at CI/compile time; About, `--version`, crash headers, and updaters must share one version truth.
- Prefer platform-native distribution first; add in-app updaters when channels or UX require it.
- Follow type-specific pages instead of forcing GUI patterns onto libraries or services.

## Relationship to other layers

- Documentation structure (Diátaxis, Antora) remains in `general/documentation.md`.
- Changelog/README expectations remain in `general/creator.md`.
- This layer is about **product architecture for shippable software**, not Dev-Centr app automation (`devcentr-agent-rules`).
