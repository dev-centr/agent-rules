---
name: typeface-selection
description: >-
  Use when choosing fonts, picking a typeface, font foundry, Google Fonts vs
  paid retail, typography quality, neo-grotesk, optical sizing, variable font
  axes, Colophon Lineto Klim Commercial Type, DM Sans Inter, brand typography,
  UI font stack, or auditing whether a free font is engineered well.
---

# Typeface selection

Standing reference: `general/type-foundries-and-font-quality.md`. **Loading** faces on the web is skill **`self-host-fonts`** — run this skill first for *what*, then self-host for *how*.

## When to load

- New brand, docs theme, or app UI needs a primary sans/serif/mono.
- User asks which foundries or patterns indicate quality.
- Comparing Google Fonts options to a retail reference (e.g. only seeing Colophon’s **DM Sans** in an open catalog).
- Reviewing a design for “generic free font” tells (single master, weak small sizes).

## Steps

1. **Clarify constraints** — user `preference`: **oss**, **retail**, or **mixed**; scripts, weights, display vs long-form text, existing brand lock-in.
2. **Separate retail research from open catalogs** — flagship boutique faces are often **not** on Google Fonts; open entries are often commissions or product fonts (see general doc table).
3. **Apply quality patterns** — hybrid grotesk/humanist for UI sans; optical size or VF `opsz`; variable axes for weight/width without distortion; verify kerning and figure sets for the intended sizes.
4. **Shortlist 2–3 families** with designer/foundry and license URL; note which cuts exist on Fontsource for self-hosting.
5. **Hand off** — skill **`font-project-lock`** to write `.devcentr/fonts.sdl` and apply stack installs; skill **`self-host-fonts`** for web bundling; skill **`logo-svg-marks`** only for logo/glyph SVG (not body type).

## Do not

- Recommend Google Fonts `@import` or CDN as the primary load path (house policy: self-host).
- Treat one open-source Colophon face as their whole catalog.
- Attribute Google Fonts entries to foundries without checking the family page (many are independent designers or big-tech commissions).

## Coexistence with other “design” guidance

- **`logo-svg-marks`** — Opus subagent for **SVG marks**; does not pick UI body fonts.
- **Third-party “frontend design” skills** (e.g. Anthropic-style UI craft prompts) — fine for layout, color, and motion; **this skill wins on type licensing, foundry quality bar, and self-host policy** when they conflict.
- **`diagram-svg-output`** — system font fallbacks inside standalone SVG; not a site typography pick.

## Checklist

- [ ] License and web embedding rights confirmed
- [ ] Text vs display use matched to masters or `opsz`
- [ ] Fontsource or licensed `woff2` path exists before implementation
- [ ] `self-host-fonts` loaded for implementation
