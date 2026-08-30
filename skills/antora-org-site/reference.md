# Antora docs sites (org policy)

Canonical skill: `antora-org-site`. **Valentus is a suggestion — confirm before applying** (`SKILL.md`).

Read this when creating, wiring, or publishing **Antora** documentation for an owned org that already has an Antora docs hub.

## One Antora site per org

If an organization already publishes a **central public Antora site**, do **not** create or keep a second **public** Antora site (especially not per-repo GitHub Pages Antora builds).

| Org | Public Antora hub |
|-----|-------------------|
| `dev-centr` | https://docs.devcentr.org (`dev-centr/docs` playbook) |
| `openshellorg` | https://docs.opensh.org |
| `dlang-supplemental` | https://dlang-supplemental.github.io/docs |
| `antora-supplemental` | https://docs.antora-supplemental.org |

**Does not apply** to mixtures of *different* docs systems in the same org (e.g. Antora hub + a Fumadocs/Next marketing docs app). The rule is: **do not duplicate public Antora**.

## What to do instead

1. Keep component content in the product repo under `docs/` + `docs/antora.yml` (docs close to code).
2. **Wire** that source into the org hub playbook (`dev-centr/docs` → `antora-playbook.yml`, `antora-playbook-local.yml`, `antora-playbook.testing.yml`).
3. Point README “Explore the docs” links at the hub component URL (e.g. `https://docs.devcentr.org/<component>/`), never at `https://<org>.github.io/<repo>/` for Antora.
4. **Repo About homepage** (`gh repo edit --homepage`): use the hub component URL for ordinary project repos. **Exceptions** — keep the product or org site URL instead when the repo is (a) the org **main** / marketing / `{org}.github.io` site, or (b) a **product** that already has its own domain or dedicated subdomain. Skill `bootstrap-org` owns the full table.
5. Do **not** add/enable GitHub Pages (or Netlify/etc.) solely to host another Antora build of the same component.

## Actively deduplicate

When you find a secondary Antora site in an Antora org:

1. Confirm the component is (or will be) in the hub playbook.
2. **Erase** the errant site: disable/delete GitHub Pages, delete `gh-pages` (or equivalent publish branch), and remove/disable workflows that deploy a standalone Antora site.
3. Leave a build-only docs CI job only if useful for PR validation — **no publish** of a second **public** site.
4. Update README “Explore the docs” links to the hub; set About homepage to the hub component URL unless the repo is the org main site or a product with its own domain/subdomain.
5. Update hub portal pages (`where-docs-live`, home nav/tools) if the component is newly wired.

## Local / CI Antora builds

- Repo-local `antora-playbook.yml` for **developer preview** of one component is fine if it does **not** get published as an org-facing site.
- Production publish path for Dev-Centr **public** Antora components is always the `dev-centr/docs` aggregator.

## Private sister site (member-only)

A **second Antora build** is allowed when it is **access-controlled** and does not put member-only SOP bodies on the public hub.

| Org | Public hub | Member-only sister |
|-----|------------|-------------------|
| `dev-centr` | https://docs.devcentr.org | https://team.docs.devcentr.org (`dev-centr/team-docs`) |

Rules:

1. Keep the sister playbook in a **private** repository (`team-docs` aggregator).
2. Wire member-only components there (e.g. `team-docs`, team SOPs cross-linking `agent-rules` org layer) — **not** into the public `docs` playbook.
3. Public hub may link the sister URL with a **members only** label; do not paste SOP bodies into public pages.
4. Sister site uses Valentus + Lunr (and org search extensions when available) for consistency with the public hub.
5. Put **Cloudflare Access** on the custom domain **and** the host `*.pages.dev`. Reader identities are GitHub org membership (or Google / email PIN), not Cloudflare dashboard users. Public how-to: `general-knowledge` → Protect a static site with Cloudflare Access.

## Default UI and search

- **Suggest** **Valentus** (`antora-supplemental/valentus-theme`) — confirm before applying (`SKILL.md`). With org brand colors/logo from the org’s central assets. Keep Valentus **lean** (theme only).
- **Facto** compose pack (`antora-supplemental/antora-facto`): Valentus + Lunr + STEM/math + Kroki diagrams + **page-context** (`page-*` metadata). Prefer Facto / its playbook fragment over stuffing defaults into Valentus `v2`.
- Every published site: `@antora/lunr-extension` plus the AI search/help extension from `antora-supplemental` (`antora-search-chat`; see also `antora-ai-help-extension`). Details in skill `antora-org-site`.
