# Antora / Valentus / Facto (org)

Applies when creating or changing Antora playbooks, UI bundles, or docs hubs for owned orgs. Skill: **`antora-org-site`**.

## Experimental — antora-solidstart

When the user or task names **antora-solidstart**, **antora-next** (deprecated alias), **SolidStart docs shell**, **content manifest**, **asciidoctor-d engine**, or an Antora **rewrite** (not incremental/site-rebuild on static hubs), load skill **`antora-solidstart`** first. Default assumption remains **Antora 3 static generate** until then. Hub proposal: antora-supplemental/docs `proposals/antora-next-shell.adoc`. Reader shell repo: `antora-supplemental/antora-solidstart`.

## Valentus stays lean

- **Valentus** (`antora-supplemental/valentus-theme`, rolling `v2`) is the house **theme** suggestion — confirm before applying.
- Do **not** fold recommended playbook defaults (Lunr, STEM/math, Kroki/Mermaid/PlantUML, reused fragments) into Valentus core or the default `v2` bundle.
- Theme-only adopters must not be forced into the full stack.

## Facto compose pack

- **facto-stack** (`antora-supplemental/facto-stack`) is the named **compose pack** (VS Code extension-pack pattern): Valentus + Lunr + STEM/math + Kroki diagrams + **page-context** (+ optional neighbors documented there).
- Prefer pointing playbooks at Facto / its `playbook.fragment.yml` over inventing a parallel “full Valentus” product line.
- Page metadata: `page-*` attrs; Facto sets `page-context-active`. Body fallback pattern in `general/documentation.md`.
- **Related docs sites (Facto 0.2.65+):** Facto registers `@antora-supplemental/related-docs`. When the org has other docs sites (team/internal, partner, legacy), set pack key `relatedDocs: { sites: [{ name, url, audience, requires_login, description }] }` so every page gets a top/footer link and a generated registry page. When there are none, opt out explicitly with `relatedDocs: { sites: none }`. Left unconfigured, it stays hidden and logs one info hint. Each site should link back to the others.
- **Link registry (Facto 0.2.66+):** register shared outside URLs once as `{url-...}` attributes; `links` CI job (sparse checkout, no install) on every push + PR, with build/deploy `needs: links`. Never auto-fix in CI. See skill `link-registry`.
- **page-context 0.6+:** teaching byline `Last updated … by …`; authorship/classification in footer; agent credit **displays** as `Name (via Agent)` (source attr may still say `Agent on behalf of Name`).
- **Keywords:** footer values link to `/home/keywords/{slug}/` (override `page-context-keyword-base`); register `@antora-supplemental/page-context/antora` for generated filtered listings.
- **page-edit 0.2+:** lead-table **Source** row with `View | Edit` (blob URL derived from edit URL when possible).
- **Component homes:** never render Audience role / Usage context chrome (attrs may still exist); authorship / dates at document end (`page-context` 0.5+).

## Page title = nav label

- One canonical title: document H1, `:navtitle:` (prefer omit), and `nav.adoc` link text must match.
- Section / area landings: **linked parent** whose link text equals the H1 (`* xref:email/index.adoc[Email]` + `**` children). Do not use `.Email` / `.Org infra` + Overview child. Do not invent `overview.adoc`.
- Keep landings as `…/index.adoc`. Public face is the folder path under `urls.html_extension_style: indexify` (`…/email/`). Do not advertise `index.html` / `overview.html` in prose.
- **Titled-list gotcha:** do **not** mix `.Title` / dotted nav headers with sibling `* xref:…` linked parents. A dotted line owns all following `*` items until the next `.Title`, so `.Tutorials` + later `* xref:how-to/…` silently nests How-to under Tutorials. Buckets without a landing: unlinked `* Label` + `**` children (not `.Label`). Buckets with `index.adoc`: linked parent + `**`.
- Detail and pass checks: `general/documentation.md` (Antora page title = nav label).

## Folder URLs (indexify)

- Owned hub playbooks set `urls.html_extension_style: indexify` so published URLs drop `.html` and `index.adoc` collapses to the parent folder. Canonical links and sitemaps follow Antora’s page URL.
- Prefer xrefs or trailing-slash absolute links in hub copy.

## Site-wide component nav tree

- Multi-component hubs: `@antora-supplemental/site-nav-tree` — wraps `getNavigation` into a forest of component roots; **keeps** default `nav-tree` behavior (no UI wipe).
- **Content source ≠ forest root.** Registering a repo under `content.sources` publishes pages/xrefs; it does not mean the component belongs in the sidebar. Prefer an **`include` allowlist** so new product sources do not auto-join the forest.
- Thin product stubs: hub portal page under `home` only, **or** keep the source for URL space but omit from `include`. Promote to `include` only when the component is worth browsing as a first-class tree.
- Set `include` + `order` (and optional `exclude`) on every fat hub. Breadcrumb component picker must use the same curation (`site.keys.site_nav_tree_*` or a matching allowlist) — do not let the dropdown and sidebar tell different stories.
- Under site-nav-tree, do **not** repeat the component start page as the first `nav.adoc` item (no Component > Component). Linked parents are for section landings inside the component. Load companion `site-nav-tree-current.js` after `site.js` so expand prefers the deepest `is-current-page` when URLs collide.
- Valentus companion: package `ui/partials/nav-menu.hbs` in hub `supplemental-ui`.
- Facto documents it as an optional neighbor; Valentus stays lean.

## Hub dispatch (content → aggregator)

Multi-repo hubs rebuild on **`repository_dispatch`** (star topology). Dev-Centr hub (`dev-centr/docs`) listens for `extension-updated` and **`link-cache-invalidate`** (surgical link-validator env from payload). Default caller: reusable workflow + secret **`DOCS_HUB_DISPATCH_TOKEN`** — skill **`docs-hub-link-invalidate`**.

## Extension consumers (discovery + recursive updates)

Antora topic/pin rules: skill **`antora-extension-consumers`** (topic = upstream **repo name**, not `uses-*`; **provider rule** — a facto-stack hub tags `facto-stack` only, not pack members or `valentus-theme`). Recursive fan-out for any lib: skill **`update-consumers`** (scans for specializations such as `antora-extension-consumers`). Hub topic checklist: antora-supplemental/docs `hub-github-topics.adoc`.

## Related content architecture

- **Internet Architecture / Internet Reliability** nests under DevCentr (`general-knowledge` body; portal `dev-centr/docs`). Peer of product SPE Architecture — not a new digital-/sys-architecture org for now.
- HCI Nerdz **Labels versus wires** remains the symptom ↔ diagnosis/treatment face (not the systems umbrella). Instruction-flows keeps the phrase *Navigating by content*.
- **connectome-fs** is substrate for content-addressed / wire identity claims.
