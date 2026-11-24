# Modern HTML and Web Platform guidance

When authoring HTML, CSS, or browser UI, prefer current Baseline native web platform primitives over legacy JavaScript workarounds and generic `<div>`-soup (for example `<dialog>`, `popover`, `<details name="...">`, `<search>`, `inert`, CSS container queries, `:has()`, and View Transitions).

## Canonical reference

- **MDN HTML Elements Reference:** https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements
- Developer reference page: `general-knowledge` -> `docs/modules/ROOT/pages/reference/modern-web-platform.adoc`

## Recommended maintained tooling (cross-harness)

Do not hand-maintain a custom modern-HTML/CSS rule pack. Prefer browser-vendor-maintained packages that stay current with Web Platform Baseline:

1. **Modern Web Guidance (`GoogleChrome/modern-web-guidance`)** — stewarded by Chrome, Edge, Mozilla, and MDN contributors:
   - Project/cross-harness CLI: `npx modern-web-guidance@latest install` or `npx skills add GoogleChrome/modern-web-guidance`
   - Also installable through harness plugin marketplaces where supported.
2. **Mozilla MDN MCP Server (`https://mcp.mdn.mozilla.net/`)** — official remote HTTP MCP server for live MDN Web Docs and Browser Compatibility Data (BCD). Works across MCP-capable coding harnesses; pass `X-Moz-1st-Party-Data-Opt-Out: 1` to opt out of first-party analytics.
