---
name: hub-home-overview
description: >-
  Use when wiring an org Antora docs hub, hub home component, `name: home`,
  `title: Home`, `site.start_page: home::index.adoc`, hub portal page,
  Overview in left nav, `:navtitle: Overview` on hub index, portal-branded H1,
  avoid component named `docs` on GitHub Pages `/docs` base, `/docs/docs/` URL,
  `start_path: docs` vs component id, Dev-Centr hub pattern,
  dlang-supplemental hub; pairs with antora-org-site and site-nav-tree.
---

# Hub home component (Overview + portal H1)

House pattern for **multi-repo org hubs** (`{org}/docs` aggregator). Reference hubs: Dev-Centr (`dev-centr/docs`), D Lang Supplemental (`dlang-supplemental/docs`). Publishing detail: Dev-Centr xref on the public hub — `publishing/hub-home-component.adoc` (path varies by site).

Related: skill `antora-org-site`, `general/documentation.md` (nav/title rules), `@antora-supplemental/site-nav-tree` README (Overview vs Home in the forest).

## When to use

- Creating or revising the **aggregator** component that owns portal tiles, org roadmap, and publishing notes — not product components (`uniconfig`, `agent-rules`, …).
- Fixing wrong start URLs, duplicate `/docs/docs/` segments, or sidebar labels that say Portal/Home instead of **Overview**.

## Checklist

1. **Component id `home`, title `Home`** in the hub repo’s Antora component (Dev-Centr: `{org}/docs/docs/antora.yml`; content still lives under the repo’s `docs/` tree with playbook `start_path: docs`).
2. **Playbook** — `site.start_page: home::index.adoc` (or `home:ROOT:index.adoc` when you use an explicit module id).
3. **Left nav** — first item is `* xref:index.adoc[Overview]` (link text exactly **Overview**). Do **not** use Portal, Home, or the portal H1 as the first sidebar label.
4. **Hub index page**
   - **H1** = portal-branded title (e.g. *The Dev Center Portal*, *D Lang Supplemental Portal*, *DevCentr portal* on Dev-Centr).
   - **Exception to “H1 = nav label”:** only on this hub `index.adoc`. Set `:navtitle: Overview` so Antora/sidebar use Overview while the page H1 stays portal-branded. Nowhere else unless the same hub-home rule applies.
5. **Product components** — keep `name:` matching the product/repo (`agent-rules`, `uniconfig`, …). Their `ROOT/pages/index.adoc` follows normal title rules (H1 = nav label; section landings use linked parents — not `.Section` + Overview).
6. **Avoid `/docs/docs/`** — when GitHub Pages (or `site.url`) already ends with `/docs`, do **not** name the hub component `docs`. Published hub segment is `/home/` (plus indexify folder URL for the start page). Playbook `content.sources` still use `start_path: docs` pointing at each repo’s `docs/` folder — that is unrelated to the component **name**.
7. **site-nav-tree** — put `home` first in `include` / `order`. Prefer **Overview** over **Home** in product nav so forest roots do not collide with the Home component title (extension also synthesizes Overview when missing).
8. **page-context** — hub component home is a **component home**: footer authors only; no audience-role chrome (`antora-org-site` + page-context 0.5+).

## Do not

- Rename the hub component to `docs` “because content is in `docs/`”.
- Repeat the component title as the first nav item under a site-nav-tree root (use Overview for the start page leaf).
- Paste this checklist into `AGENTS.md` — one-line pointer only.

## Verify

- Local/playbook build: site entry opens `home` start page; sidebar first link reads **Overview**; browser path has `/home/` (or your `site.url` + `/home/`), not `/docs/docs/`.
- After deploy: sitemap/indexable URL for the portal uses the `home` component segment.
