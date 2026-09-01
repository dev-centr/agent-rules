# Demos + push (owned orgs)

**Scope:** owned orgs only - DevCentr, HCI-Nerdz, OpenShellOrg, and related owned orgs. This is **not** a default for every AI user; it is house workflow for these orgs.

Skill body: **`demo-site-wiring`**. End-of-run push: skill **`push-code`** / `general/end-of-run.md`.

## UI concepts ship with demos

When inventing or shipping a **new UI concept / idea** (interactive explainer, layout mode, chrome idea, spatial or windowing concept, product-idea desk, and similar), **auto-apply** skill `demo-site-wiring`:

1. Stand up or update interactive demos as part of the invent/ship work - demos are **not** an optional afterthought.
2. Wire into the parent org site and that org's demos index/browser (create the browser if missing).
3. Keep the skill's grandfather clause: do **not** mass-retrofit untouched historical demos.

Agents should load `demo-site-wiring` on these triggers without waiting for an explicit "make a demo" ask.

## Do not suppress push / PR for demo prototyping

Prototyping often wants local iteration before or beside commit + PR. That tension was considered and **rejected as a reason to disable auto push/PR**.

- Keep standing end-of-run commit + push (`push-code`) and normal PR norms.
- Local preview is encouraged and does **not** block push.
- Iterate by subsequent commits and PR updates - do **not** hold the first push "until the demo feels done."
- Goal: avoid cross-machine friction; push so work is visible elsewhere.

## Suite / variant anchoring visuals

Skill `demo-site-wiring` owns the full order. Short rule:

- **Single-variant** desks: **exactly one** suite-level hero screenshot / contextual mockup (memory-hook). Not a gallery; not competing heroes.
- **Multi-variant** desks: **one compact mockup per variant** in a ~3-column grid on a **selector hub** that links to **separate variant pages** (default; Context Edge / virtual-pages). Do not mount interactive desks on the hub. In-page tabs are a narrow exception — either **tabs + one swapping mockup** (shell-context-demo) or the richer **aligned chooser grid** (virtual-pages in-page history).

Grandfather: do not retrofit every old demo unless substantively editing; apply on create / substantive intro edit.

## Trust and conflict handling

- Trust the team to make changes; trust AI to **intercept conflicts**.
- When concurrent edits or competing design philosophies collide on demos/docs: **resolve** when the fix is clear; otherwise **surface the clash clearly** to the user - do not silently pick one philosophy and hide the tension.

