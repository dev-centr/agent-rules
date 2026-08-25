---
name: antora-org-site
description: >-
  Use when creating, wiring, or publishing an Antora site, docs site, or
  docs hub; antora theme; antora-playbook.yml; playbook; GitHub Pages for
  docs; one Antora site per org; Lunr; antora-search-chat; docs.devcentr.org;
  Valentus; Valentus theme; Facto; antora-facto; compose pack; KaTeX;
  stem latexmath; alias-component-to-latest; Kroki; Mermaid; PlantUML;
  docs audience; visitor POV; naive reader docs.
---

# Antora org site

Minimum bar for a published Antora site in an owned org. Detail and hub table: [reference.md](reference.md). Encoding/mojibake: skill `fix-docs-encoding` (transcode, not a refactor).

## Audience / POV

Before drafting or revising any page under `docs/`, read **Audience / point of view** in `general/documentation.md`. Published pages teach **naive readers and visitors** — not the chat commissioner. Name the published reader; keep agent playbooks in skills / `AGENTS.md`.

## Required

1. **One public Antora site per org** that already has a hub. Keep `docs/` in the product repo; **wire** the component into the hub playbook. Do not publish a second public Antora site on project GitHub Pages (or Netlify/etc. solely for that).
2. **Lunr** on every published site (`@antora/lunr-extension`). Register Lunr before wrappers.
3. **AI search** from `antora-supplemental` — prefer [`antora-search-chat`](https://github.com/antora-supplemental/antora-search-chat). If those packages cannot be found after a reasonable search, **stop and alert the user**; wait before inventing a substitute.
4. **Math on every docs surface**, even unused: Antora `stem: latexmath` + KaTeX/`site-math.js`; Markdown `remark-math` + `rehype-katex`. Real formulas as `stem:[…]` / `$…$`, not raw prose.
5. Versioned components: `@antora-supplemental/alias-component-to-latest` (or equivalent) until core ships opt-in. Prefer comments on [antora/antora#291](https://gitlab.com/antora/antora/-/issues/291) over duplicate issues.
6. Brand from the org’s existing assets. Do not invent a one-off palette per component.
7. Repo-local `antora-playbook.yml` for **preview/validation CI** is fine if it does **not** publish a second public site.
8. A **member-only** sister Antora site is allowed (private playbook + Access). See [reference.md](reference.md).

Does **not** forbid mixing Antora with another docs system (e.g. Fumadocs).

## Valentus + Facto (suggestion — confirm)

**Suggest** Valentus (`antora-supplemental/valentus-theme`) as the house **theme**. **Ask before applying it.** Keep an existing theme unless they confirm a switch. After they choose Valentus, customize colors/logo from org brand assets — do not re-poll the UI on every later pass.

**Valentus stays lean.** Do not fold Lunr, STEM/math, or Kroki into Valentus core / default `v2`. For the usual stack, use the **Facto** compose pack (`antora-supplemental/antora-facto`) — Valentus + Lunr + math + Kroki (Mermaid + PlantUML → SVG) — like a VS Code extension pack. Org notes: `agents/engineering/antora.md`.

## AsciiDoc figures

- Quote image alt text that contains commas: `image::file.svg[alt="Setup: OAuth App, IdP, policy"]`.
- UTF-8 without BOM; ASCII punctuation in SVG labels; skill `fix-docs-encoding` on touched `docs/` before commit.
- Hub deploy: pushing a component repo alone may not refresh the aggregator — redeploy the docs hub playbook so `_images/` goes live.

## Deduplicate

When you find a second public Antora site in an Antora org: confirm the component is (or will be) in the hub, then disable the errant Pages/workflow and point README/About at the hub URL.
