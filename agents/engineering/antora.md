# Antora / Valentus / Facto (org)

Applies when creating or changing Antora playbooks, UI bundles, or docs hubs for owned orgs. Skill: **`antora-org-site`**.

## Valentus stays lean

- **Valentus** (`antora-supplemental/valentus-theme`, rolling `v2`) is the house **theme** suggestion — confirm before applying.
- Do **not** fold recommended playbook defaults (Lunr, STEM/math, Kroki/Mermaid/PlantUML, reused fragments) into Valentus core or the default `v2` bundle.
- Theme-only adopters must not be forced into the full stack.

## Facto compose pack

- **Facto** (`antora-supplemental/antora-facto`) is the named **compose pack** (VS Code extension-pack pattern): Valentus + Lunr + STEM/math + Kroki diagrams + **page-context** (+ optional neighbors documented there).
- Prefer pointing playbooks at Facto / its `playbook.fragment.yml` over inventing a parallel “full Valentus” product line.
- Page metadata: `page-*` attrs; Facto sets `page-context-active`. Body fallback pattern in `general/documentation.md`.

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

## Related content architecture

- **Internet Architecture / Internet Reliability** nests under DevCentr (`general-knowledge` body; portal `dev-centr/docs`). Peer of product SPE Architecture — not a new digital-/sys-architecture org for now.
- HCI Nerdz **Labels versus wires** remains the symptom ↔ diagnosis/treatment face (not the systems umbrella). Instruction-flows keeps the phrase *Navigating by content*.
- **connectome-fs** is substrate for content-addressed / wire identity claims.
