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
- Produce a standalone SVG suitable for direct navigation and external `<img>`, Markdown, and AsciiDoc embedding.
- If a fixed-color consumer is known or requested, also produce a fixed preset or paired light/dark files.

## Standalone contract

- Include the SVG namespace, a `viewBox`, `preserveAspectRatio`, `role="img"`, `<title>`, and `<desc>`.
- Scale without clipping at narrow and wide widths. Keep labels in dedicated layout space.
- Use system font fallbacks. Do not depend on scripts, remote fonts, external images/styles, or `foreignObject`.
- Use semantic tokens rather than scattering presentation colors through geometry.
- Bundle complete light and dark presets inside the SVG. Light is the default fallback; an internal `@media (prefers-color-scheme: dark)` selects dark.
- Every variable reference must have a concrete fallback. The SVG must remain readable without host CSS.
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
`--svg-<namespace>-<kebab-case-role>`.

A site/build may inject its design-language light and dark palette into the SVG's bundled presets. This creates a self-contained themed asset; it does not make an external image inherit page CSS.

## Output modes

- `standalone-adaptive` (default for the web): internal light/dark presets and media selection.
- `fixed`: one preset resolved to concrete values; no CSS variables or media queries.
- `paired-fixed`: separate `.light.svg` and `.dark.svg` files for consumers that select assets.
- `host`: variable references with fallbacks for intentionally inline SVG or an application that injects values into the SVG document.

CSS custom properties, `currentColor`, and page theme classes do **not** cross an external `<img>` boundary. A manual site toggle that can differ from the operating-system preference must use inline SVG or select paired assets. Do not claim `host` output is page-themable through `<img>`.

Mermaid, PlantUML, Kroki, and Graphviz fixed renderer output is not sufficient by itself. Render both presets or transform it into this contract while retaining the source.

## Standard tooling

Use `@dev-centr/themed-svg` (https://github.com/dev-centr/themed-svg) for versioned manifests, structural bindings, palette injection, diagnostics, and fixed/adaptive serialization. Generator-specific packages such as `@openshellorg/mermaid-svg-css-vars` are consumers/adapters; they do not define the cross-generator contract.

## Verification

Before calling the diagram done:

1. Parse the output as XML.
2. Render `standalone-adaptive` in both `prefers-color-scheme` modes.
3. Check direct-file and target embedding behavior at representative narrow and wide sizes.
4. Check contrast, clipping, overlap, missing fonts, arrow visibility, and readable labels.
5. Confirm fixed output has no unresolved `var()` or media rules when fixed output is required.
6. Run skill `fix-docs-encoding` after touching Antora SVGs on Windows.
