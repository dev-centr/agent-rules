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
- Exception: area landing under a named nav section may use `Overview` while the H1 is the area name (`= Email`, `= Org infra`).
- Keep those landings as `…/index.adoc` (not `overview.adoc`). Public face is the folder path under `urls.html_extension_style: indexify` (`…/email/`). Do not advertise `index.html` / `overview.html` in prose.
- Detail and pass checks: `general/documentation.md` (Antora page title = nav label).

## Folder URLs (indexify)

- Owned hub playbooks set `urls.html_extension_style: indexify` so published URLs drop `.html` and `index.adoc` collapses to the parent folder. Canonical links and sitemaps follow Antora’s page URL.
- Prefer xrefs or trailing-slash absolute links in hub copy.

## Site-wide component nav tree

- Multi-component hubs: `@antora-supplemental/site-nav-tree` — wraps `getNavigation` into a forest of component roots; **keeps** default `nav-tree` behavior (no UI wipe).
- Valentus companion: package `ui/partials/nav-menu.hbs` in hub `supplemental-ui`.
- Facto documents it as an optional neighbor; Valentus stays lean.

## Related content architecture

- **Internet Architecture / Internet Reliability** nests under DevCentr (`general-knowledge` body; portal `dev-centr/docs`). Peer of product SPE Architecture — not a new digital-/sys-architecture org for now.
- HCI Nerdz **Labels versus wires** remains the symptom ↔ diagnosis/treatment face (not the systems umbrella). Instruction-flows keeps the phrase *Navigating by content*.
- **connectome-fs** is substrate for content-addressed / wire identity claims.
