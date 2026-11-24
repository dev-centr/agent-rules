# Agent-operable web UI

Interactive web applications should expose a structured, safe state and action surface alongside the visual DOM and ARIA tree so runtime AI agents and semantic automation do not rely on whole-DOM traversal or screenshot clicking.

## Where it fits

- **Static / content-first routes** (marketing, docs, blogs, changelogs): covered by `general/web-crawlability.md` (meaningful HTML, `/sitemap.xml`, `/robots.txt`, Schema.org JSON-LD). Mark the Web Band B agent-UI item **N/A** with a written reason.
- **Interactive web applications** (SPAs, dashboards, forms, SaaS frontends): treat an **agent-operable UI surface** as a **Band B** web auxiliary feature in `general-knowledge` (`explanation/architecture/classes/web.adoc`, `reference/auxiliary-features-checklist.adoc`, `examples/product-essentials/auxiliary-web.cmk`).

## Adoption rules

1. **Adopt the abstraction layer, not a single beta dependency.** Prefer progressive enhancement over library lock-in:
   - **Simple forms:** declarative **WebMCP** (`<form toolname="..." tooldescription="...">`).
   - **Existing SPAs:** imperative **WebMCP** via feature-detected `document.modelContext.registerTool(...)`. Always target `document.modelContext` (not the deprecated early-2026 `navigator.modelContext` alias) and degrade cleanly when absent.
   - **New or cross-framework UI primitives:** evaluate a behavior-first library with a native agent bridge — for example **Vercel UI SDK** (`vercel-labs/ui` / `ui-sdk.dev`, Apache-2.0, public beta `0.1.0-beta.x`, `@ui-sdk/core` + framework adapters + `createAgent` / `registerTools`). Pin beta dependencies deliberately; do not force UI SDK onto apps that already have a healthy UI stack.
2. **Gate destructive and external-effect mutations.** Intercept delete, billing, permission, account, and external-send actions with explicit human confirmation (`allow` hook or confirmation flow).
3. **Keep server authorization authoritative.** Client-side agent gates never replace server authentication, RBAC, CSRF/origin checks, or tenant isolation.
4. **Preserve provenance and privacy.** Distinguish agent-initiated transitions (`details.source === "agent"` or equivalent audit metadata) and never leak tokens or secrets into component labels, `snapshot()` outputs, or tool descriptions.

## Canonical docs

- Reference: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/reference/agent-operable-web-ui.adoc` (`https://docs.devcentr.org/general-knowledge/reference/agent-operable-web-ui/`)
- How-to: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/how-to/add-agent-operable-web-ui.adoc` (`https://docs.devcentr.org/general-knowledge/how-to/add-agent-operable-web-ui/`)
- Web essentials matrix: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/classes/web.adoc`
