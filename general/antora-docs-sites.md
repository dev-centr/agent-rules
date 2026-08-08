# Antora docs sites (org policy)

Read this when creating, wiring, or publishing **Antora** documentation for an owned org that already has an Antora docs hub.

## One Antora site per org

If an organization already publishes a **central Antora site**, do **not** create or keep a second Antora site (especially not per-repo GitHub Pages Antora builds).

| Org | Central Antora hub |
|-----|--------------------|
| `dev-centr` | https://docs.devcentr.org (`dev-centr/docs` playbook) |
| `openshellorg` | https://docs.opensh.org |
| `dlang-supplemental` | https://dlang-supplemental.github.io/docs |
| `antora-supplemental` | https://docs.antora-supplemental.org |

**Does not apply** to mixtures of *different* docs systems in the same org (e.g. Antora hub + a Fumadocs/Next marketing docs app). The rule is: **do not duplicate Antora**.

## What to do instead

1. Keep component content in the product repo under `docs/` + `docs/antora.yml` (docs close to code).
2. **Wire** that source into the org hub playbook (`dev-centr/docs` → `antora-playbook.yml`, `antora-playbook-local.yml`, `antora-playbook.testing.yml`).
3. Point the repo **About homepage** and README “Explore the docs” links at the hub URL (e.g. `https://docs.devcentr.org/<component>/`), never at `https://<org>.github.io/<repo>/` for Antora.
4. Do **not** add/enable GitHub Pages (or Netlify/etc.) solely to host another Antora build of the same component.

## Actively deduplicate

When you find a secondary Antora site in an Antora org:

1. Confirm the component is (or will be) in the hub playbook.
2. **Erase** the errant site: disable/delete GitHub Pages, delete `gh-pages` (or equivalent publish branch), and remove/disable workflows that deploy a standalone Antora site.
3. Leave a build-only docs CI job only if useful for PR validation — **no publish** of a second site.
4. Update homepage + README links to the hub.
5. Update hub portal pages (`where-docs-live`, home nav/tools) if the component is newly wired.

## Local / CI Antora builds

- Repo-local `antora-playbook.yml` for **developer preview** of one component is fine if it does **not** get published as an org-facing site.
- Production publish path for Dev-Centr Antora components is always the `dev-centr/docs` aggregator.

## Default UI and search

- Prefer **Valentus** (`antora-supplemental/valentus-theme`) with org brand colors/logo from the org’s central assets.
- Every published site: `@antora/lunr-extension` plus the AI search/help extension from `antora-supplemental` (`antora-search-chat`; see also `antora-ai-help-extension`). Details in `general/documentation.md`.
