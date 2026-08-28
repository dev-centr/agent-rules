---
name: demo-site-wiring
description: >-
  Use when making demos, interactive explainers, product-idea demos, demo pages,
  demos browser, demos index, org-site demo catalog, demo breadcrumb, VCS logo
  on a demo, GitHub mark on demo chrome, lay-person demo copy, variant tabs on
  a demo, wiring a demo into the parent org site, demo-site-wiring, or publishing
  a demo to hci-nerdz.github.io/demos (or another org demos index).
---

# Demo site wiring

Standing UX for **interactive explainers / product-idea demos** on owned org sites.

**Grandfather existing demos.** Do **not** mass-audit or retrofit every historical demo. Apply this skill on **create** and on **substantive edit** of a demo's page chrome / catalog wiring (and to in-flight work already under edit). Leaving older pages as-is is OK until someone touches them.

## Whenever you make a demo

1. **Wire into the parent org's site** (Pages / docs hub / marketing site — whichever the org uses as the public face).
2. **Index in that org's demos browser** (`/demos/` or equivalent). **Create the browser/catalog if missing.**
3. Include **lay-person text** for how the idea works and how it fits a real workflow (not only engineer shorthand).

Pair with skill `antora-org-site` when the org's teaching surface is Antora; pair with the org site's existing demos catalog (e.g. HCI-Nerdz `src/lib/demos.ts`) when that is the browser.

## Mandatory page structure (top to bottom)

Apply this order on create / substantive chrome edit:

1. **`org / repo` identity strip** (nav and breadcrumb are the **same** band — do **not** render two separate chrome rows for them).
   - **Org** → org calling page (usually the **demos index**)
   - **Repo name** → canonical GitHub/GitLab repository URL
2. **New line after that strip: VCS logo** → same repository URL (GitHub mark, GitLab mark, etc.). Default: its **own line under** the identity strip. Do **not** place the logo after the variant switcher. Do **not** treat the variant switcher as "the nav" the logo follows.
3. **Demo-level description** — lay text: how the idea works / fits a workflow. **Before** the variant switcher.
4. **Variant switcher** (tabs / hash routes / sections). This is only "nav" in a loose sense — it is **not** the identity nav from step 1.
5. **Active variant:** title + variant-specific description + interactive UI (mock / desk / controls).

Do not put the demo-level lede below the variant UI. Do not skip variant blurbs when the page has more than one variant. Do not split org and repo into separate bands above the VCS logo.

## Identity strip + VCS logo (detail)

| Control | Links to |
| --- | --- |
| Org name (in the identity strip) | Org demos index (or the org's designated calling page for demos) |
| Repo name (same strip) | Canonical VCS repository URL |
| VCS logo (next line) | Same repository URL |

Reference implementation (in-flight / updated when touched): `HCI-Nerdz/shell-context-demo` hub chrome in `src/demos/nav.ts` (+ hub CSS). Org catalog example: `HCI-Nerdz/HCI-Nerdz.github.io` `src/lib/demos.ts`.

## Checklist (create or substantive edit)

- [ ] Live under / linked from the parent org site
- [ ] Card / entry in the org demos browser (create browser if absent)
- [ ] One `org / repo` identity strip (not two bands)
- [ ] VCS logo on the line **after** that strip, linking to the repo
- [ ] Demo-level lay workflow copy above the variant switcher
- [ ] Variant switcher, then active variant: title + blurb + interactive UI
- [ ] Skipped retrofit of unrelated historical demos

## Do not

- Leave a new demo only on repo Pages with no org index entry
- Use engineer-only jargon as the sole page description
- Treat nav and breadcrumb as two separate bands
- Put the VCS logo after the variant switcher, or treat the variant switcher as the identity nav
- Mass-migrate every old demo "for consistency" without an explicit ask
- Put machine paths or harness names in this skill body
