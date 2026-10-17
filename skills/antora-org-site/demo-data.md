# Demo data (Antora content fixtures)

Canonical org layout for **mock AsciiDoc** that exercises Valentus chrome and supplemental extensions without polluting production hub docs.

| Doc | Role |
| --- | --- |
| https://docs.antora-supplemental.org/docs/ROOT/proposals/demo-data-catalog.html | Architecture, rejected alternatives, extension survey |
| https://github.com/antora-supplemental/demo-data | **Authority** for naming, `start_path` layout, versioning, playbook snippets |

Skill `demo-site-wiring` covers **interactive org demos** (HCI-Nerdz-style Pages desks). This file covers **Antora stack demos** (facto-stack, extension CI, Valentus visual preview).

## Three layers

| Layer | Where | Use when |
| --- | --- | --- |
| **Baseline** | `demo-data` → `docs/theme-demo` (`theme-demo` component) | Rich body fixtures: nav, xrefs, admonitions, tables, code, images, extension-oriented samples. Wire as a git `content.sources` entry — **not** copied into each extension repo. |
| **Extension supplement** | `demo-data` → `docs/fixtures/{scope}/` | Shared smoke when **two or more** demos need the same pages (e.g. `site-nav-tree` → `catalog-alpha`, `catalog-beta`). One `start_path` per supplement folder; playbooks may add multiple sources from the same clone URL. |
| **Extension-local** | `{extension}/examples/docs` or `{pack}/demo/docs` | Minimal CI / single-demo proof for **that** package only. Do **not** duplicate baseline pages; compose `theme-demo` in the playbook instead. |

**Generic AsciiDoc syntax** (language tutorial samples): keep https://github.com/antora-supplemental/antora-demo (`samples` component) on the org docs hub. Do **not** merge `antora-demo` into `demo-data` unless the org wants one clone URL for everything.

## Transport (required pattern)

* **Git `content.sources`** with explicit `start_path` — normal aggregation, xrefs, Lunr index.
* **Do not** inject tens of static demo pages via extension `contentCatalog.addFile`. Narrow generators only (e.g. page-context keyword listing pages).

Styles and design tokens stay in Valentus `ui.bundle` and extension supplemental UI. **demo-data is content-only.**

## Playbook composition

Typical stack demo (reference: `facto-stack/demo/playbook.yml`):

1. `demo-data` `docs/theme-demo` — baseline body catalog.
2. Consumer `demo/docs` (or `examples/docs`) — stack-only behavior proofs (Mermaid client, lightbox, SoftNav, …).
3. Optional `demo-data` `docs/fixtures/{scope}` — shared multi-component forest or other supplement.
4. `@antora-supplemental/facto-stack` `profile: demo` (or explicit extension list) for Lunr, page-context, Kroki, etc.
5. **`siteNavTree.include` + `order`** when site-nav-tree is enabled — wiring a source does **not** auto-promote it into the sidebar forest.

Pin reproducible CI: `tags: vX.Y.Z` on the `demo-data` source; preview may track `main`.

## When to promote fixtures into `demo-data`

| Stay extension-local | Add under `docs/fixtures/{package-name}/` |
| --- | --- |
| Single repo CI smoke | `facto-stack` demo **and** another published demo need identical pages |
| Pages that only prove npm package behavior | Multi-root nav forests, shared search-chat corpora, repeated outbound-link corpora for linkinator |

Document the chosen path in the extension README under **Demo data** (playbook snippet + link to fixture README or “supplement lives in repo at `examples/docs`”).

## Related skills

* `antora-org-site` — hub policy, site-nav-tree allowlist, Facto compose pack.
* `demo-site-wiring` — org demos browser / variant UX (non-Antora or hybrid).
* `antora-extension-consumers` — SemVer pins when demos depend on extension packages.
