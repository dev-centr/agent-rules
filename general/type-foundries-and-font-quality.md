# Type foundries and font quality

Reference for **choosing** typefaces and reading foundry catalogs — not how fonts load on the web (that is `general/self-host-fonts.md`, skill **`self-host-fonts`**).

## Two markets

| Market | What you get | Typical license |
| --- | --- | --- |
| **Retail / foundry-direct** | Full families, optical sizes, display/text masters | Paid desktop/web/app |
| **Open catalogs** (Google Fonts, Fontshare, etc.) | Subset of a foundry’s work, commissions, or indie releases | Open license (OFL, etc.) |

Boutique foundries often keep flagship retail faces off free catalogs. Seeing only **DM Sans** from Colophon on Google Fonts does not mean they only ship one face — it means most of the catalog is proprietary (**Aperçu**, **Basis Grotesque**, **Space Grotesk**, **Fortescue**, and many others).

## Foundries consistently associated with elite engineering

Use as a **shortlist for research**, not an endorsement of every cut in a large catalog.

| Foundry | Region | Hallmarks | Names worth knowing |
| --- | --- | --- | --- |
| **Lineto** | CH / UK | Tight Swiss modernism; small curated library | Circular, Akkurat, Brown, LL Simplon |
| **Dinamo** | CH / DE | Systemic design; strong variable fonts | GT America, GT Walsheim, GT Sectra |
| **Commercial Type** | US / UK | Editorial polish; historical depth | Graphik, Lyon, Druk, Marian |
| **Optimo** | CH | Precision; luxury / art-direction favorites | Supreme, New Rail Alphabet, Px Grotesk |
| **Klim Type Foundry** | NZ | Rebuilt classics; micro-metrics | Founders Grotesk, Tiempos, Signifier, National |
| **Production Type** | FR | Sharp, screen-aware display and text | Spectral (Google commission), Panorama |
| **Colophon Foundry** | UK | Geometric–humanist sans; editorial UI | Aperçu, Basis Grotesque, Space Grotesk, DM Sans (open) |

## Patterns in top-tier work

When comparing a retail family to a generic free sans, these engineering choices show up repeatedly:

1. **Neo-grotesk / humanist hybrid** — geometry for structure, humanist terminals and proportions so text stays warm at small sizes (Colophon **Aperçu** is the textbook 2010s example).
2. **Optical sizing** — separate **Display** vs **Text** masters (or explicit `opsz` axis): tighter display spacing vs sturdier text stems, ink traps, and tracking.
3. **Historical model, contemporary finish** — shapes derived from specimen history, redrawn for screens and modern proportions (Klim and Commercial Type are explicit about this).
4. **Variable architecture** — weight, width, and optical size interpolated without collapsing glyph geometry; retail families increasingly ship as VF first.

Cheap or single-master free faces often scale one outline for all sizes and skimp on kerning tables — that is why “same genre” can still feel flat.

## Open catalogs (Google Fonts and peers)

### How good work lands for free

- **Commissioned open source** — Google (or Adobe, etc.) pays a foundry to draw an **analog** face for an open license. Example: Colophon **DM Sans** relates to commercial **Basis Grotesque**; Production Type **Spectral** was a Google text commission.
- **Corporate open source** — **Inter** (Rasmus Andersson), **Roboto** (Android), **Fira** / **Fira Code** (Mozilla): elite *engineering for a product*, not necessarily a traditional foundry catalog.
- **Foundry participation** — **TypeTogether** (e.g. **Literata**, **Alegreya**), **Dalton Maag** (**Ubuntu**, **Lexend**), and others place selected families on Google Fonts; flagship retail fonts often stay paid.

Do not trust casual lists that attribute **Inter**, **Playfair Display**, **Source Serif**, or **Fira Sans** to a single foundry — check each family’s designer and license page.

### Open-source tradeoffs

- **Optical sizing** on free libraries historically lagged retail; variable fonts with `opsz` (or separate static Display/Text files when available) close part of the gap.
- **Character set and features** — retail cuts may include more scripts, small caps, and figure sets.
- **Licensing** — OFL allows bundling; still match brand guidelines and trademark names.

## Agent workflow (house)

1. **Pick the face** — skill **`typeface-selection`** (this reference + budget/license).
2. **Load it correctly** — skill **`self-host-fonts`** (Fontsource / local `woff2`, preload; no CDN on the critical path).
3. **Product mark / app icon** — skill **`logo-svg-marks`** (Opus design subagent for SVG glyphs — not body typography).

When choosing fonts for owned org UI or docs, prefer faces that exist on Fontsource or that you can license for self-hosting; do not treat Google Fonts CSS `@import` as the runtime default.

## Related skills

| Skill | Job |
| --- | --- |
| `typeface-selection` | Foundries, quality patterns, retail vs open catalogs |
| `self-host-fonts` | Bundling, preload, FOUC |
| `logo-svg-marks` | SVG logo / favicon craft (subagent) |
| `demo-site-wiring` | Demo chrome typography follows product palette |

Load skill **`typeface-selection`** when choosing or auditing typefaces.
