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

Before drafting or revising any page under `docs/`, read **Audience / point of view** and **Antora page title = nav label** in `general/documentation.md`.

1. Set **`page-*` header attrs** (`page-audience`, `page-usage-context`, `page-orig-author`, `page-last-author`, `page-last-edited`, plus optional catalog fields). Agent-assisted: `<agent> on behalf of <human>`.
2. Include the **`ifndef::page-context-active[]`** body fallback for audience / authors / last updated only (attrs via `{page-…}` refs).
3. **Facto** already registers `@antora-supplemental/page-context` and sets `page-context-active` — do not hard-code the extended catalog into the body.
4. When wiring a playbook without Facto, either adopt Facto’s fragment or register `page-context` + `page-context-active` yourself.
5. **One title:** H1 = `nav.adoc` link text; prefer no `:navtitle:`. Only exception: `Overview` under a nav section that already names the area (landing H1 = area name; **file stays `index.adoc`** — public URL is the folder via indexify).
6. **Folder URLs:** set `urls.html_extension_style: indexify` on owned hub playbooks. Do not rename Overview landings to `overview.adoc`; do not advertise `index.html` in prose.

## Required

1. **One public Antora site per org** that already has a hub. Keep `docs/` in the product repo; **wire** the component into the hub playbook. Do not publish a second public Antora site on project GitHub Pages (or Netlify/etc. solely for that).
2. **Lunr** on every published site (`@antora/lunr-extension`). Register Lunr before wrappers.
3. **AI search** from `antora-supplemental` — prefer [`antora-search-chat`](https://github.com/antora-supplemental/antora-search-chat). If those packages cannot be found after a reasonable search, **stop and alert the user**; wait before inventing a substitute.
4. **Math on every docs surface**, even unused: Antora `stem: latexmath` + KaTeX/`site-math.js`; Markdown `remark-math` + `rehype-katex`. Real formulas as `stem:[…]` / `$…$`, not raw prose.
5. Versioned components: `@antora-supplemental/alias-component-to-latest` (or equivalent) until core ships opt-in. Prefer comments on [antora/antora#291](https://gitlab.com/antora/antora/-/issues/291) over duplicate issues.
6. **Multi-component hubs:** enable `@antora-supplemental/site-nav-tree` so every component appears in the sidebar forest. It **wraps navigation data** and keeps default `nav-tree` / expand-collapse — do **not** replace Valentus nav with OpenDevise Navigator unless the hub outgrows inlined nav HTML. Valentus: copy package `ui/partials/nav-menu.hbs` into hub `supplemental-ui/partials/`.
7. Brand from the org’s existing assets. Do not invent a one-off palette per component.
8. Repo-local `antora-playbook.yml` for **preview/validation CI** is fine if it does **not** publish a second public site.
9. A **member-only** sister Antora site is allowed (private playbook + Access). See [reference.md](reference.md).

Does **not** forbid mixing Antora with another docs system (e.g. Fumadocs).

## Valentus + Facto (suggestion — confirm)

**Suggest** Valentus (`antora-supplemental/valentus-theme`) as the house **theme**. **Ask before applying it.** Keep an existing theme unless they confirm a switch. After they choose Valentus, customize colors/logo from org brand assets — do not re-poll the UI on every later pass.

**Valentus stays lean.** Do not fold Lunr, STEM/math, Kroki, or page-context into Valentus core / default `v2`. For the usual stack, use the **Facto** compose pack (`antora-supplemental/antora-facto`) — Valentus + Lunr + math + Kroki (Mermaid + PlantUML → SVG) + **page-context** — like a VS Code extension pack. Org notes: `agents/engineering/antora.md`.

## AsciiDoc figures

- Quote image alt text that contains commas: `image::file.svg[alt="Setup: OAuth App, IdP, policy"]`.
- UTF-8 without BOM; ASCII punctuation in SVG labels; skill `fix-docs-encoding` on touched `docs/` before commit.
- Hub deploy: pushing a component repo alone may not refresh the aggregator — redeploy the docs hub playbook so `_images/` goes live.

## Partner footers (related / partner strips)

**One entry point per org** in `footer-content.hbs` and mirrored site footers: prefer the public org homepage; GitHub only when there is no homepage. Do **not** stack homepage + docs hub + GitHub for the same org (no “OSO Docs” beside OpenShellOrg, no “DevCentr Docs” beside DevCentr). Detail: `general/partner-org-entrypoints.md`.

## Deduplicate

When you find a second public Antora site in an Antora org: confirm the component is (or will be) in the hub, then disable the errant Pages/workflow and point README “Explore the docs” (and About homepage, unless main-site or product-domain exception) at the hub component URL. New-repo About homepage policy: skill `bootstrap-org`.
