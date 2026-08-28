---
name: demo-site-wiring
description: >-
  Use when making demos, interactive explainers, product-idea demos, demo pages,
  demos browser, demos index, org-site demo catalog, demo breadcrumb, VCS logo
  on a demo, GitHub mark on demo chrome, lay-person demo copy, variant tabs on
  a demo, wiring a demo into the parent org site, demo-site-wiring, publishing
  a demo to hci-nerdz.github.io/demos (or another org demos index), inventing or
  shipping a new UI concept, layout mode, chrome idea, spatial or windowing
  concept, product-idea desk, or interactive explainer for an owned org;
  demo intro screenshot, anchoring mockup, suite lede image, memory-hook.
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

1. **`org / repo` identity strip** (nav and breadcrumb are the **same** band — do **not** render two separate chrome rows for them).
   - **Org** → org calling page (usually the **demos index**)
   - **Repo name** → canonical GitHub/GitLab repository URL
2. **New line after that strip: VCS logo** → same repository URL (GitHub mark, GitLab mark, etc.). Default: its **own line under** the identity strip. Do **not** place the logo after the variant switcher. Do **not** treat the variant switcher as "the nav" the logo follows.
3. **Demo-level description** — lay text: how the idea works / fits a workflow. **Before** the variant switcher.
4. **Exactly one anchoring screenshot or contextual mockup** in the suite/hub lede area (with or immediately after the demo-level description, still **before** the variant switcher). Purpose: capture attention and give a single memory-hook before the interactive web demo. **Not** a gallery; **not** multiple competing hero images. Complements (does not replace) the identity strip / VCS logo / lay description / variant switcher order.
5. **Variant switcher** (tabs / hash routes / sections). This is only "nav" in a loose sense — it is **not** the identity nav from step 1.
6. **Active variant:** title + variant-specific description + interactive UI (mock / desk / controls).

Do not put the demo-level lede below the variant UI. Do not skip variant blurbs when the page has more than one variant. Do not split org and repo into separate bands above the VCS logo.

## Identity strip + VCS logo (detail)

| Control | Links to |
| --- | --- |
| Org name (in the identity strip) | Org demos index (or the org's designated calling page for demos) |
| Repo name (same strip) | Canonical VCS repository URL |
| VCS logo (next line) | Same repository URL |

Reference implementation (in-flight / updated when touched): `HCI-Nerdz/shell-context-demo` hub chrome in `src/demos/nav.ts` (+ hub CSS). Org catalog example: `HCI-Nerdz/HCI-Nerdz.github.io` `src/lib/demos.ts`.

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
- [ ] One `org / repo` identity strip (not two bands)
- [ ] VCS logo on the line **after** that strip, linking to the repo
- [ ] Demo-level lay workflow copy above the variant switcher
- [ ] Exactly one intro anchoring screenshot/mockup in the suite lede (not a gallery)
- [ ] Variant switcher, then active variant: title + blurb + interactive UI
- [ ] Skipped retrofit of unrelated historical demos
- [ ] Did not suppress push/PR for prototyping; pushed so work is visible elsewhere

## Do not

- Leave a new demo only on repo Pages with no org index entry
- Skip demos when inventing/shipping a new UI concept for an owned org
- Use engineer-only jargon as the sole page description
- Ship a suite intro with zero anchoring visuals, or with a multi-image gallery / competing heroes in the lede
- Treat nav and breadcrumb as two separate bands
- Put the VCS logo after the variant switcher, or treat the variant switcher as the identity nav
- Mass-migrate every old demo "for consistency" without an explicit ask
- Suppress automatic push/PR “until the demo is done”
- Silently paper over competing demo/docs philosophies
- Put machine paths or harness names in this skill body
