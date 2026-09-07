---
name: logo-svg-marks
description: >-
  Use when creating or redrawing a product logo, SVG mark, app icon glyph,
  favicon SVG, brand mark, mono badge, currentColor icon, isolated SVG without
  tile, app-tile SVG, thumbdrive icon, "redo the logo", "SVG looks bad",
  "hideous icon", vector art for a product, logo family glyph/mark/mono, or
  when the user asks to use the Opus / design-subagent logo strategy.
---

# Logo SVG marks (design-subagent strategy)

Portable craft for **product SVG marks**. Born from Thumbelina: coding-session SVG hacks failed; a dedicated design model with a tight brief and render feedback succeeded.

## When to load

- New or replacement **SVG logo / app glyph / favicon mark**
- User says the current SVG is bad, cheap, clipart, or unreadable small
- Shipping a **glyph + tile + mono** family for a product repo

Pair with **`github-profile-assets`** when the mark also lands on an org `.github` profile.

## Model / routing

1. **Do not** invent the final mark in the main coding agent when prior SVG attempts failed or the mark must look premium.
2. Launch a **design subagent** with a strong craft model (house default: **Claude Opus thinking high** / `claude-opus-5-thinking-high`, or whatever the session lists as the current Opus thinking slug).
3. Subagent deliverable = SVG files only (or SVG + short design notes). Parent commits/pushes.

## Brief the subagent must receive

Paste failures and constraints explicitly:

| Include | Why |
| --- | --- |
| Product one-liner + motif | So the silhouette matches the product |
| Palette (hex) | Rose/gold/etc. — avoid neon candy unless asked |
| What was rejected | e.g. busy scene, vertical “perfume bottle”, cheap rounded-rect clipart |
| Size rule | Must read at **32px** and look intentional at 128px |
| File paths | Exact repo paths to overwrite |
| Aesthetic target | Premium, iconic, SF-Symbols clarity — not Material blobs, not skeuomorphism chaos |

## Deliverable family (default)

Write **three** files that share geometry:

| File pattern | Role |
| --- | --- |
| `*-glyph.svg` | **Isolated** mark — transparent, **no** rounded app tile, tight `viewBox` |
| `*-mark.svg` | Same glyph on a restrained rounded-square tile (optional thin rim) |
| `*-glyph-mono.svg` | Minimal / `evenodd` path, `fill="currentColor"` for badges |

Prefer product-repo paths like `assets/icons/` unless the org standard says `profile/assets/brand/` (`github-profile-assets`).

## Craft checks (subagent)

- Render candidates (Inkscape, ImageMagick, or browser) at 32 / 48 / 128 before declaring done.
- If a silhouette reads as the wrong object at small size, **change orientation/proportions** — don’t polish gradients on a bad read.
- Prefer real product proportions over decorative detail.
- Soft bevel via shared-edge gradients OK; avoid heavy SVG filters that disappear in some renderers.
- No wordmark inside the glyph unless the user asked for a lockup.

## Parent agent checklist

- [ ] Brief includes rejection list + palette + paths
- [ ] Opus (or listed design model) subagent wrote the three SVGs
- [ ] Spot-check render at 32px
- [ ] Sync copies to site/demos/profile assets if those surfaces exist
- [ ] Commit + push per end-of-run

## Anti-patterns

- Coding agent “quickly” redrawing the logo after the user already rejected SVG attempts
- Vertical USB / bottle / lipstick silhouettes when the product is a horizontal drive (or vice versa — match the object)
- Crowding the mark with characters, scenes, or unreadably tiny details
- Shipping only a tiled mark with no isolated glyph
