---
name: web-ui-design-references
description: >-
  Use when asked for good design, better design, stronger visual polish,
  website UI inspiration, redesigning a landing page or web UI, drawing
  inspiration from good website designs, avoiding generic AI or Tailwind
  defaults, or adding/looking up an entry in the notable web UI designs
  catalog (notable-web-ui-designs.adoc).
---

# Web UI design references

AI models regress toward narrow defaults when asked for a "nice" or "modern" page: purple/blue gradients, nested bordered cards, arbitrary palette utilities, and generic icons in glowing rounded squares. Ground visual work in curated real-world examples and a locked token contract before writing markup.

## When asked for good design or UI inspiration

1. **Read the curated catalog first:**
   - Local checkout: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/reference/notable-web-ui-designs.adoc`
   - Published hub: `https://docs.devcentr.org/general-knowledge/reference/notable-web-ui-designs/`
2. **Pair with the visual contract:**
   - `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/reference/ai-site-design-contract.adoc` (semantic tokens, banned generated defaults, prompt shapes)
   - `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/constrained-ai-web-design.adoc` (why hierarchy and taste are locked before implementation)
   - `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/how-to/tighten-an-ai-built-site.adoc` (when polishing an existing site)
3. **Check the era via the archive link:**
   - Sites redesign over time. Each catalog entry records its **date added** and a direct **Wayback Machine snapshot URL** in the AsciiDoc source.
   - When working locally (without the published docs site's Linkinator hover button), use the source's dated archive URL to inspect the version that earned inclusion rather than assuming today's live page is identical.
4. **Extract structural principles, not copied branding:**
   - Study surface separation, spacing rhythm, typographic hierarchy, border restraint, and how real product surfaces are depicted.
   - Lock those choices into semantic CSS variables (`--surface-primary`, `--surface-muted`, `--border-subtle`, `--text-primary`, `--text-muted`, `--space-*`, `--radius-*`) and typography pins (`typeface-selection`, `font-project-lock`, `self-host-fonts`) before building sections.
   - Never copy proprietary logos, trademarks, copy, or assets from reference sites.

## When adding a new site to the catalog

Edit `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/reference/notable-web-ui-designs.adoc` (and its changelog):

1. Include the canonical **live URL**.
2. Record **Added (`YYYY-MM-DD`)** — required minimum for every entry.
3. Include a **direct Wayback Machine snapshot URL** (`https://web.archive.org/web/<timestamp>/<url>`) verified to return HTTP 200 on or near the date added. If no recent snapshot exists yet, capture one via Wayback Machine or link the calendar (`https://web.archive.org/web/*/<url>`) and note that a dated snapshot is pending.
4. Keep notes concrete and honest — do not fabricate visual details you have not inspected.
