---
name: agent-operable-web-ui
description: >-
  Use when scaffolding or extending an interactive web app, SPA, dashboard, or
  form workflow for runtime AI agents; WebMCP, document.modelContext,
  navigator.modelContext, registerTool, toolname, tooldescription, UI SDK,
  ui-sdk, vercel-labs/ui, @ui-sdk/core, createAgent, registerTools, snapshot,
  query, act, agent bridge, avoiding DOM scraping or screenshot traversal, or
  checking the Web Band B agent-operable UI checklist item.
---

# Agent-operable web UI

Apply [`general/agent-operable-web-ui.md`](../../general/agent-operable-web-ui.md) and consult the canonical Dev-Centr docs in `general-knowledge`:

- Reference: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/reference/agent-operable-web-ui.adoc`
- How-to: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/how-to/add-agent-operable-web-ui.adoc`
- Web class matrix: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/classes/web.adoc`

## Workflow

1. **Classify the surface:**
   - Static/content routes (marketing, docs, blog) stay on skill `web-crawlability`; mark the Web Band B agent-UI item N/A with that reason.
   - Interactive web apps adopt the lightest path that fits.
2. **Choose the progressive implementation path:**
   - **Simple forms:** annotate semantic HTML `<form>` elements with declarative WebMCP `toolname` and `tooldescription`.
   - **Existing interactive SPA:** feature-detect `document.modelContext` (not deprecated `navigator.modelContext`) and register typed domain tools via `document.modelContext.registerTool(...)`.
   - **New or cross-framework primitives:** evaluate Vercel UI SDK (`vercel-labs/ui`, Apache-2.0, beta — `@ui-sdk/core` + framework adapter + `createAgent` + `registerTools`) as a reference implementation; pin beta versions intentionally.
3. **Wire safety and provenance:**
   - Add an `allow` confirmation gate for destructive, billing, permission, or external-send actions.
   - Keep server-side authn/authz authoritative for every request.
   - Tag agent-originated state updates (e.g., `details.source === "agent"`) for logs and diagnostics, and keep secrets out of snapshots and tool payloads.
4. **Verify:**
   - Check `snapshot()` / tool listing for clean, secret-free labels.
   - Test `query()` (or tool invocation) against closed/virtualized controls without opening DOM popups.
   - Confirm destructive mutations pause or block at the `allow` gate.
   - Confirm graceful no-op fallback when `document.modelContext` is `undefined`.
