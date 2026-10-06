---
name: diagram-svg-output
description: >-
  Use when creating, generating, rendering, exporting, or substantially editing
  a diagram, flowchart, architecture map, sequence diagram, Mermaid, PlantUML,
  Kroki, Graphviz, hand-authored diagram SVG, themed SVG, dark-mode diagram,
  light-mode diagram, or web-compatible SVG in any context.
---

# Diagram SVG output

Every diagram intended for durable use must ship as a web-compatible SVG that remains useful outside its original page.

## Required artifacts

- Preserve editable source (`.mmd`, PlantUML, DOT, or a documented hand-authored SVG).
- Produce a `host` SVG for runtime-inline delivery when the target site supports JavaScript.
- Produce a `standalone-adaptive` SVG when the diagram must work through external `<img>`, Markdown, AsciiDoc, direct navigation, or without JavaScript.
- If a fixed-color consumer is known or requested, also produce a fixed preset or paired light/dark files.

## SVG contract

- Include the SVG namespace, a `viewBox`, `preserveAspectRatio`, `role="img"`, `<title>`, and `<desc>`.
- Scale without clipping at narrow and wide widths. Keep labels in dedicated layout space.
- Use system font fallbacks. Do not depend on scripts, remote fonts, external images/styles, or `foreignObject`.
- Use semantic tokens rather than scattering presentation colors through geometry.
- Every variable reference must have a concrete fallback. The SVG must remain readable without host CSS.
- In `standalone-adaptive` output, bundle complete light and dark presets. Light is the default fallback; an internal `@media (prefers-color-scheme: dark)` selects dark.
- Meet readable contrast in both presets; preserve arrows, borders, labels, and status distinctions.

## Theme model

Keep two concerns separate:

1. **Mode selection:** light or dark.
2. **Palette:** concrete values for semantic roles in each mode.

Use stable logical roles where applicable:

```text
color.canvas
color.surface.primary
color.surface.secondary
color.text.primary
color.text.muted
color.border.primary
color.edge
color.edge.label
color.accent.primary
color.accent.on-primary
color.status.success
color.status.warning
color.status.danger
```

Diagram-specific roles may extend this list. CSS names use
`--themed-svg-<namespace>-<kebab-case-role>`.

A site/build may inject its design-language light and dark palette into the SVG's bundled presets. This creates a self-contained themed asset; it does not make an external image inherit page CSS.

## Output modes

- `host` (default for the web): variable references with fallbacks for runtime-inline SVG and host-controlled mode or palette changes.
- `standalone-adaptive`: internal light/dark presets and media selection for external images and no-JavaScript delivery.
- `fixed`: one preset resolved to concrete values; no CSS variables or media queries.
- `paired-fixed`: separate `.light.svg` and `.dark.svg` files for consumers that select assets.

CSS custom properties, `currentColor`, and page theme classes do **not** cross an external `<img>` boundary. A manual site toggle that can differ from the operating-system preference must use inline SVG or select paired assets. Do not claim `host` output is page-themable through `<img>`.

Mermaid, PlantUML, Kroki, and Graphviz fixed renderer output is not sufficient by itself. Render both presets or transform it into this contract while retaining the source.

## Delivery choice

Use runtime-inline delivery by default on a site that supports JavaScript:

- Generate `host` output.
- Load it through `@dev-centr/themed-svg/runtime` with `mountThemedSvg()` or `<themed-svg>`.
- Let the runtime fetch, sanitize, and insert the SVG so host CSS variables and manual theme state can cross the former document boundary.
- Keep same-origin fetching as the default. Cross-origin SVGs require CORS and an explicit JavaScript `trustedOrigins` allowlist; HTML alone must not widen it.
- Sanitize every fetched SVG regardless of origin. Do not permit scripts, event handlers, external resources, unsafe CSS URLs, SMIL mutation, or nested active content.

Use external delivery when JavaScript is unavailable or intentionally avoided:

- Generate `standalone-adaptive` output and embed it through `<img>`, Markdown, or AsciiDoc.
- Treat `prefers-color-scheme` as the selector. The SVG cannot observe a host application's independent theme toggle or palette.

Use `fixed` or `paired-fixed` for email, social cards, app surfaces without runtime CSS variables, deterministic exports, and consumers that select assets themselves.

If an existing SVG already has the required variables and only needs runtime DOM insertion for CSS styling, recommend an established injector such as `@iconfu/svg-inject`. Do not require the full Themed SVG manifest and build pipeline when injection alone solves the problem.

## Standard tooling

Use `@dev-centr/themed-svg` (https://github.com/dev-centr/themed-svg) for versioned manifests, structural bindings, palette injection, diagnostics, serialization, and the sanitized browser runtime. Generator-specific packages such as `@dev-centr/mermaid-svg-css-vars` are consumers/adapters; they do not define the cross-generator contract.


## Mermaid CLI 12 renderer settings

`@mermaid-js/mermaid-cli` 12 (Mermaid 12; Node.js >= 22.13; `puppeteer` ^25 as a peer) changes the flowchart defaults: ELK layout, the `neo` look (drop shadows, orthogonal edges), and 120px label wrapping (labels split mid-word). Themed SVG manifests and existing diagrams were tuned on Mermaid 11, so pin the previous rendering in the Mermaid config passed with `-c`:

```json
{
  "layout": "dagre",
  "look": "classic",
  "theme": "base",
  "htmlLabels": false,
  "flowchart": { "htmlLabels": false, "wrappingWidth": 200 }
}
```

- Set `theme` explicitly (`base` plus `themeVariables`, or `default`); unset, Mermaid 12 flowcharts default to `redux-color`.
- Declare `puppeteer` as a direct devDependency and list it in `pnpm.onlyBuiltDependencies`.
- Make the generator script fail when the config lacks `layout`, `look`, or `flowchart.wrappingWidth` (as `dev-centr/agent-rules` `scripts/generate-themed-diagrams.mjs` does).
- After any Mermaid major bump, render the previous and regenerated SVGs side by side in light and dark mode before committing; check for mid-word label breaks, size changes, and shadows on dark backgrounds.
- Switch to ELK or `neo` only as a deliberate redesign: re-tune the manifests and recheck dark-mode contrast.

## Borrow from light (stable light islands)

Dark-mode presets may **borrow** selected light-mode colors when a region must stay light inside a dark page (callout cards, stamps, screenshots of light UI).

Authoring (Themed SVG `theme.json`):

1. Set the dark preset value to the **same concrete color** as light for that token (schema-valid; adapters keep working).
2. Optionally list those token ids in `borrowFromLight` (authoring hint). Component `diagrams:generate` strips this key before calling `@dev-centr/themed-svg`.

Parent -> child dependency:

- If a **surface / canvas** token borrows light (does not change between themes), any **text (and nested content) inside that region** should also borrow light — do not force dark-mode text recoloring inside a light-stable island.
- Prefer region tokens such as `color.surface.note` + `color.text.on-note` so global `color.text.primary` can still adapt for dark canvas areas.

Verification must **not** WARN when dark intentionally borrows light for a stable island and its text. It **must** WARN when a surface/canvas **did** change (e.g. dark background) but text still borrows light-mode ink (dark-on-dark).

## Verification

Before calling the diagram done:

1. Parse the output as XML.
2. For runtime-inline delivery, test loading, sanitization, host palette inheritance, manual light/dark changes, disconnection, and reconnection.
3. For external delivery, render `standalone-adaptive` in both `prefers-color-scheme` modes.
4. Check direct-file and target embedding behavior at representative narrow and wide sizes.
5. Check contrast, clipping, overlap, missing fonts, arrow visibility, and readable labels.
6. Confirm fixed output has no unresolved `var()` or media rules when fixed output is required.
7. Run skill `fix-docs-encoding` after touching Antora SVGs on Windows.
