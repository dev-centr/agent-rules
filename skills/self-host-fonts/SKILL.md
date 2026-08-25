---
name: self-host-fonts
description: >-
  Use when adding web fonts, Google Fonts, @fontsource, Fontsource, @import
  fonts.googleapis, FOUC, flash of unstyled text, font-display, preload woff2,
  self-host fonts, CDN fonts, Plus Jakarta Sans or other webfont setup, or
  fixing fonts that flash system defaults on load.
---

# Self-host web fonts

Standing preference: detail in `general/self-host-fonts.md`. Prefer bundled fonts over Google Fonts / CDNs. Never gate first paint on a remote font.

## Steps

1. **Pick the face** — keep the brand/type choice; only change *how* it loads.
2. **Add a self-host package** when available (e.g. `@fontsource-variable/<family>` or static `@fontsource/<family>`). Otherwise copy licensed `woff2` into the app’s static/assets tree.
3. **Import CSS via the bundler** (entry CSS or root layout) — not a Google Fonts `<link>` / CSS `@import` as the primary path.
4. **Match `font-family`** to the package’s real name (variable packages often use `"… Variable"`).
5. **Preload** the critical Latin (or primary subset) file in the HTML head:

   ```html
   <link rel="preload" as="font" type="font/woff2" href="…latin….woff2" crossorigin />
   ```

   In Vite, `import face from '@fontsource-variable/…/files/…-latin-….woff2?url'` then use that URL in the document template.
6. **Skip unused axes/styles** (e.g. omit italic CSS if the UI never uses italic).
7. **Verify** production CSS references local hashed assets (no `fonts.googleapis.com` / `fonts.gstatic.com` on the critical path).

## Anti-patterns

| Avoid | Prefer |
| --- | --- |
| `@import url("https://fonts.googleapis.com/css2?…")` | Fontsource / local `@font-face` |
| Hide body until `document.fonts.ready` for a CDN face | Preload + self-host; paint with fallback |
| `preconnect` + CDN as the only fix | Self-host; optional size-adjusted fallbacks |

## Notes

- Specimen links (e.g. Google Fonts specimen page) in a brand kit are fine as **attribution / browse**; they are not the runtime load path.
- Theme FOUC is separate — keep an early inline boot script for `dark` / `color-scheme` when the product supports themes.
