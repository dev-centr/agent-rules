---
name: logo-svg-marks
description: >-
  Use when creating a product logo, SVG mark, app icon, favicon, brand glyph,
  or icon set on first scaffold or first brand pass — new app, new project,
  ship-app icon, assets/icons, *-glyph.svg, *-mark.svg, *-glyph-mono.svg,
  app tile SVG, mono badge, currentColor icon; also when redrawing, "redo the
  logo", "SVG looks bad", or "hideous icon". Default path is first try, not
  only after rejection.
---

# Logo SVG marks (first-pass design-subagent)

Portable craft for **product SVG marks**. **Default is the first logo pass** — do not wait for the user to reject a coding-agent doodle.

Born from Thumbelina: main-session SVG hacks looked cheap; a dedicated design model with a tight brief and render feedback worked on the successful pass. That successful path is now the **initial** path.

## Standing rule

When a product needs an SVG logo / app glyph / favicon mark family:

1. **Load this skill immediately** (scaffold, rebrand, or “add an icon”).
2. **Launch the design subagent on the first try** — do not invent the final mark in the parent coding agent “as a placeholder.”
3. Parent wires paths, README, and commits; subagent owns the SVG craft.

Redo / “hideous icon” cases use the same pipeline (add a rejection list to the brief).

## When to load (auto)

- New app / CLI / GUI / library **branding** or `assets/icons/`
- `ship-app` / bootstrap / public README that needs a mark
- Org or product **rebrand**
- User asks for logo, icon, favicon, glyph, mark, or mono badge
- User rejects an existing SVG (then include what failed)

Pair with **`github-profile-assets`** when the mark also lands on an org `.github` profile.

## Model / routing

1. Launch a **design subagent** with a strong craft model (house default: **Claude Opus thinking high** / `claude-opus-5-thinking-high`, or the session’s current Opus thinking slug).
2. Subagent deliverable = the three SVGs (+ short design notes). Parent does not hand-author competing marks in parallel.
3. Parent spot-checks, syncs to demos/site/profile if needed, commits/pushes.

## Brief the subagent must receive

| Include | Why |
| --- | --- |
| Product one-liner + motif | Silhouette matches the product |
| Palette (hex) | Avoid accidental neon candy |
| Size rule | Must read at **32px**; intentional at 128px |
| File paths | Exact repo paths to write |
| Aesthetic target | Premium, iconic — not Material blobs, not skeuomorphism chaos |
| Rejection list | **Required on redo**; optional on first pass (known anti-patterns OK) |

First-pass anti-patterns to name even without prior failure: busy scenes, characters, unreadably tiny detail, wrong-object silhouette (e.g. vertical “perfume bottle” when the product is a horizontal USB drive).

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

- [ ] Design subagent ran **before** shipping a parent-authored “temporary” SVG as the product mark
- [ ] Brief includes product, palette, paths (+ rejections if any)
- [ ] Three SVGs written (glyph / mark / mono)
- [ ] Spot-check render at 32px
- [ ] Sync to site/demos/profile assets when those surfaces exist
- [ ] Commit + push per end-of-run

## Anti-patterns

- Parent coding agent drawing the “real” logo on first pass “to save a round-trip”
- Waiting for the user to say “redo” before using this skill
- Crowding the mark with characters, scenes, or unreadably tiny details
- Shipping only a tiled mark with no isolated glyph
