---
name: demo-site-wiring
description: >-
  Use when making demos, interactive explainers, product-idea demos, demo pages,
  demos browser, demos index, org-site demo catalog, demo breadcrumb, VCS logo
  on a demo, GitHub mark on demo chrome, lay-person demo copy, variant tabs on
  a demo, variant mockup grid, mockup-as-nav, placeholder until chosen, multi-
  variant desk, wiring a demo into the parent org site, demo-site-wiring,
  publishing a demo to hci-nerdz.github.io/demos (or another org demos index),
  inventing or shipping a new UI concept, layout mode, chrome idea, spatial or
  windowing concept, product-idea desk, or interactive explainer for an owned
  org; demo intro screenshot, anchoring mockup, suite lede image, memory-hook,
  context edges, Edge Bar.
---

# Demo site wiring

Standing UX for **interactive explainers / product-idea demos** on owned org sites (DevCentr, HCI-Nerdz, OpenShellOrg, and related owned orgs). Org policy companion: `agents/demos-and-push.md`.

**Auto-apply on new UI concepts.** When inventing or shipping a new UI concept / idea (interactive explainer, layout mode, chrome idea, spatial or windowing concept, product-idea desk, and similar), load this skill and stand up or update demos + org demos indexes as **part of that work** — not an optional afterthought the human must remember to request.

**Grandfather existing demos.** Do **not** mass-audit or retrofit every historical demo. Apply this skill on **create** and on **substantive edit** of a demo's page chrome / catalog wiring (and to in-flight work already under edit). Leaving older pages as-is is OK until someone touches them.

## Whenever you make a demo

1. **Wire into the parent org's site** (Pages / docs hub / marketing site — whichever the org uses as the public face).
2. **Index in that org's demos browser** (`/demos/` or equivalent). **Create the browser/catalog if missing.**
3. Include **lay-person text** for how the idea works and how it fits a real workflow (not only engineer shorthand).

Pair with skill `antora-org-site` when the org's teaching surface is Antora; pair with the org site's existing demos catalog (e.g. HCI-Nerdz `src/lib/demos.ts`) when that is the browser.

## Mandatory page structure (top to bottom)

Apply this order on create / substantive chrome edit:

1. **`org / repo` identity strip** (nav and breadcrumb are the **same** band — do **not** render two separate chrome rows for them). This strip is **site navigation only** — neither crumb links to the VCS repository.
   - **Org** → org calling page (usually the **demos index**)
   - **Repo name** → this demo's **site home** (Pages / demo root for this project; clear variant hash to suite home when applicable). **Not** the GitHub/GitLab URL.
2. **New line after that strip: VCS logo** → canonical repository URL (GitHub mark, GitLab mark, etc.). **Only** this control (and its optional text label) links out to the VCS repo. Default: its **own line under** the identity strip. Do **not** place the logo after the variant switcher. Do **not** treat the variant switcher as "the nav" the logo follows.
3. **Demo-level description** — lay text: how the idea works / fits a workflow. **Before** the variant chooser.
4. **Variant chooser + anchoring visuals** — see [Suite vs multi-variant anchoring](#suite-vs-multi-variant-anchoring) below. Teaching blurbs for each variant sit **outside** the interactive facsimile (hub lede / variant blurb), not as narrator captions inside the mock.
5. **Demo zone** — interactive UI (mock / desk / controls) for the active variant, **or** a clear placeholder until the user chooses a variant (see [Placeholder until chosen](#placeholder-until-chosen)).

Do not put the demo-level lede below the variant UI. Do not skip variant blurbs when the page has more than one variant. Do not split org and repo into separate bands above the VCS logo. Do not invent a second identity band.

## Suite vs multi-variant anchoring

| Desk type | Anchoring visual |
| --- | --- |
| **Single-variant** (or one primary interactive surface) | **Exactly one** suite-level hero screenshot / contextual mockup with or right after the demo-level description — a single memory-hook. **Not** a gallery; **not** competing heroes. |
| **Multi-variant** (tabs / hash routes / named modes) | **One compact mockup per variant**, enumerated in a grid/flex sized to fit about **three columns on desktop**. Group mockups with the chooser. Do **not** ship only a single suite hero and omit per-variant imagery. Compact CSS/SVG thumbs beat oversized “impressive” frames that break the grid. |

### Variant titles as a real tab bar

Variant titles must read as a **tab bar** (tabbiness: connected track, selected tab surface, `role="tablist"` / `role="tab"` when interactive on one page). Do **not** style them as a generic button row or pill cluster.

The **demo zone below is the tab content**.

### Mockup-as-nav (compatible with tabs)

Per-variant mockups are **clickable navigation**, not decoration only:

- **Desktop:** tabs **and** clickable mockups. Clicking a mockup selects that variant and loads the interactive demo in the tab content / demo zone.
- **Mobile:** clicking a mockup to load the demo is the preferred path (same click-to-populate; layout reflows). Tabs may remain for accessibility / parity.

Reference feel: HCI-Nerdz **Edge Bar** (`context-rails`) hub — visual variant tiles + clear variant organization. Apply that pattern cleanly on SPA/hash desks too (e.g. `virtual-pages`).

### Placeholder until chosen

On multi-variant desks where mounting the interactive stack is non-trivial, the **demo zone starts as a placeholder** until the user chooses (tab or mockup). Do **not** auto-mount the deep interactive stack on first paint. Deep-linking a variant hash/route still mounts that variant (choice already expressed by the URL).

## Identity strip + VCS logo (detail)

| Control | Links to |
| --- | --- |
| Org name (in the identity strip) | Org demos index (or the org's designated calling page for demos) |
| Repo name (same strip) | This demo's site home (Pages root / suite home) — **site nav**, not VCS |
| VCS logo (next line) | Canonical VCS repository URL — **only** repo link in the chrome |

Do **not** make the repo crumb and the VCS logo both open GitHub/GitLab. That duplicates the destination and makes the breadcrumb read as a second repo button.

Reference implementations: `HCI-Nerdz/shell-context-demo` hub chrome; `HCI-Nerdz/virtual-pages` (multi-variant tabs + compact mockups + placeholder); Edge Bar hub tiles in `HCI-Nerdz/context-rails`. Org catalog example: `HCI-Nerdz/HCI-Nerdz.github.io` `src/lib/demos.ts`.

## Push / PR while prototyping (anti-suppression)

Do **not** disable standing end-of-run commit/push (`push-code`) or normal PR norms because demo work is “still prototyping.”

- Local preview is encouraged; it does **not** block push.
- Iterate via subsequent commits and PR updates.
- Cross-machine visibility beats holding the first push until the demo feels finished.

## Conflicts

When concurrent edits or competing design philosophies collide on demos/docs: prefer **resolve** when the fix is clear; otherwise **report the inconsistency** to the user — do not silently pick one side and hide the tension.

## Checklist (create or substantive edit)

- [ ] Live under / linked from the parent org site
- [ ] Card / entry in the org demos browser (create browser if absent)
- [ ] One `org / repo` identity strip (not two bands); site nav only (org → demos index; repo → demo site home)
- [ ] VCS logo on the line **after** that strip is the **only** link to the VCS repo
- [ ] Demo-level lay workflow copy above the variant chooser
- [ ] Anchoring visuals: one suite hero **or** one compact mockup per variant (multi-variant)
- [ ] Variant titles look like a real tab bar (not generic buttons)
- [ ] Mockups clickable to select / load the demo (desktop + mobile)
- [ ] Demo zone placeholder until chosen (unless URL already selects a variant)
- [ ] Active variant: title + blurb **outside** the facsimile + interactive UI inside
- [ ] Skipped retrofit of unrelated historical demos
- [ ] Did not suppress push/PR for prototyping; pushed so work is visible elsewhere

## Do not

- Leave a new demo only on repo Pages with no org index entry
- Skip demos when inventing/shipping a new UI concept for an owned org
- Use engineer-only jargon as the sole page description
- Ship a multi-variant suite with only a single suite hero and no per-variant mockups
- Ship a suite intro with zero anchoring visuals, or with competing suite-level heroes in the lede
- Style the variant switcher as generic buttons / pills when tabs are the pattern
- Auto-mount a heavy interactive stack on first paint before the user chooses (multi-variant)
- Put tour-guide / narrator captions **inside** the interactive facsimile (teaching stays in hub / variant blurbs)
- Treat nav and breadcrumb as two separate bands
- Point the identity-strip repo crumb at the VCS URL (duplicates the logo; strip must stay site nav)
- Put the VCS logo after the variant switcher, or treat the variant switcher as the identity nav
- Invent a second org/repo identity band
- Mass-migrate every old demo "for consistency" without an explicit ask
- Suppress automatic push/PR “until the demo is done”
- Silently paper over competing demo/docs philosophies
- Put machine paths or harness names in this skill body
