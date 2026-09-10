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
5. **One title:** H1 = `nav.adoc` link text; prefer no `:navtitle:`. Section landings: **linked parent** (link text = H1) with nested `**` children — not `.Section` + Overview. **File stays `index.adoc`**; public URL is the folder via indexify.
6. **Nav titled lists:** never mix `.Title` / dotted headers with sibling `* xref:…` linked parents. A dotted line owns all following `*` items until the next `.Title` (siblings silently nest). No landing → unlinked `* Label` + `**`; with `index.adoc` → linked parent + `**`. Detail: `general/documentation.md`.
7. **Folder URLs:** set `urls.html_extension_style: indexify` on owned hub playbooks. Do not invent `overview.adoc`; do not advertise `index.html` in prose.

## Required

1. **One public Antora site per org** that already has a hub. Keep component `docs/` in the product repo; **wire** into the hub when the component needs its own URL/xref space (or stay a `home` portal-only stub). Do not publish a second public Antora site on project GitHub Pages (or Netlify/etc. solely for that). Wiring a source does **not** auto-promote it into the site-nav-tree forest — update `include` only when it should be a browseable root.
2. **Hub lives in `{org}/docs`**, not inside `{org}.github.io`. Playbook, supplemental-ui, Facto stack, and GitHub Pages for the public Antora site belong on the docs repo. The marketing site **links** to the hub — never nest Antora output under `public/docs/` (or similar) from the website build (`docs:build` into marketing `public/` is an anti-pattern). Detail: [reference.md](reference.md).
3. **Lunr** on every published site (`@antora/lunr-extension`). Register Lunr before wrappers.
4. **AI search** from `antora-supplemental` — prefer [`antora-search-chat`](https://github.com/antora-supplemental/antora-search-chat). If those packages cannot be found after a reasonable search, **stop and alert the user**; wait before inventing a substitute.
   - When wiring the extension into a playbook repo, set GitHub topic **`uses-antora-search-chat`** on that consumer (preserve existing topics). Pin with an immutable tag (`github:antora-supplemental/antora-search-chat#vX.Y.Z`) unless the hub already documents a rolling line.
   - After releasing `antora-search-chat`, discover consumers with `gh search repos "topic:uses-antora-search-chat"` (then hive `package.json` / playbook grep as a fallback). Bump pins/lockfiles and rebuild hubs that need the new UI.
5. **Math on every docs surface**, even unused: Antora `stem: latexmath` + KaTeX/`site-math.js`; Markdown `remark-math` + `rehype-katex`. Real formulas as `stem:[…]` / `$…$`, not raw prose.
6. Versioned components: `@antora-supplemental/alias-component-to-latest` (or equivalent) until core ships opt-in. Prefer comments on [antora/antora#291](https://gitlab.com/antora/antora/-/issues/291) over duplicate issues.
7. **Multi-component hubs:** enable `@antora-supplemental/site-nav-tree` with an **`include` allowlist** (plus `order`) so the sidebar forest is curated. **Wiring a repo into `content.sources` ≠ adding a forest root** — thin product stubs prefer a `home` portal page only, or register the source but omit it from `include`. Align the breadcrumb component picker with the same curated set (`site.keys.site_nav_tree_*`). Do **not** repeat the component start page as the first `nav.adoc` item under site-nav-tree (no Component > Component); linked parents are for **section** landings inside the component. Copy `ui/partials/nav-menu.hbs` and load `ui/js/site-nav-tree-current.js` after `site.js`. The extension **wraps navigation data** and keeps default `nav-tree` / expand-collapse — do **not** replace Valentus nav with OpenDevise Navigator unless the hub outgrows inlined nav HTML. **Recommended pairing** (product docs, not a hard skill gate): when you enable site-nav-tree, also ship `@antora-supplemental/nav-typology` + companion UI, and `@antora-supplemental/nav-typology-diataxis` when the hub uses Diátaxis — see Facto / site-nav-tree READMEs.
8. Brand from the org’s existing assets. Do not invent a one-off palette per component. **Soft default:** prefer a transparent **`logo-mark`** for site/docs chrome and heroes; keep plate-backed marks for favicon / org avatar / profile tile (skill `github-profile-assets`). Users may override.
9. Repo-local `antora-playbook.yml` for **preview/validation CI** is fine if it does **not** publish a second public site.
10. A **member-only** sister Antora site is allowed (private playbook + Access). See [reference.md](reference.md).
11. Apply skill **`web-crawlability`** to public hubs: sitemap + robots artifacts, canonical indexable URLs, and CI checks that representative pages contain meaningful raw HTML.
12. **Soft:** Style `page-*` metadata presentation in **`@antora-supplemental/page-context`** (point of interpretation), not via one-off per-hub supplemental CSS for the same chrome.

Does **not** forbid mixing Antora with another docs system (e.g. Fumadocs).

## Valentus + Facto (suggestion — confirm)

**Suggest** Valentus (`antora-supplemental/valentus-theme`) as the house **theme**. **Ask before applying it.** Keep an existing theme unless they confirm a switch. After they choose Valentus, customize colors/logo from org brand assets — do not re-poll the UI on every later pass.

**Valentus stays lean.** Do not fold Lunr, STEM/math, Kroki, or page-context into Valentus core / default `v2`. For the usual stack, use the **Facto** compose pack (`antora-supplemental/antora-facto`) — Valentus + Lunr + math + Kroki (Mermaid + PlantUML → SVG) + **page-context** — like a VS Code extension pack. Org notes: `agents/engineering/antora.md`.

## AsciiDoc figures

- Quote image alt text that contains commas: `image::file.svg[alt="Setup: OAuth App, IdP, policy"]`.
- UTF-8 without BOM; ASCII punctuation in SVG labels; skill `fix-docs-encoding` on touched `docs/` before commit.

## Hub refresh (component push ≠ site rebuild)

Pushing a **component** repo updates content on the next hub build — it does **not** by itself publish the aggregator. The `{org}/docs` workflow must run via **schedule**, **`workflow_dispatch`**, and/or **`repository_dispatch`** (from component CI) so Pages refreshes. After wiring or asset changes, trigger the hub deliberately so `_images/` and new sources go live. Valentus / Facto override details live in product docs (e.g. Valentus `head-meta` / footer-scripts), not as duplicate harness rules.

## Partner footers (related / partner strips)

**One entry point per org** in `footer-content.hbs` and mirrored site footers: prefer the public org homepage; GitHub only when there is no homepage. Do **not** stack homepage + docs hub + GitHub for the same org (no “OSO Docs” beside OpenShellOrg, no “DevCentr Docs” beside DevCentr). Detail: `general/partner-org-entrypoints.md`.

## Deduplicate / migrate (cutover order)

When you find a second public Antora site, or when moving a hub **out of** `{org}.github.io` into `{org}/docs`:

1. Confirm the component is (or will be) in the hub playbook.
2. **Deploy `{org}/docs` Pages first** (custom domain / `docs.` host live and serving).
3. Point README “Explore the docs” (and About homepage, unless main-site or product-domain exception) at the hub URL.
4. **Then** strip Antora from the marketing site (remove nested `public/docs/`, `docs:build` into the website, and errant Pages/workflows) so `/docs/` never 404s during cutover.
5. Disable leftover per-repo Antora publish jobs; leave build-only CI if useful.

New-repo About homepage policy: skill `bootstrap-org`. Site vs docs split: skill `bootstrap-org` [reference.md](../bootstrap-org/reference.md#site-vs-docs).
