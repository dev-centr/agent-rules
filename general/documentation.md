# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Structure

- When you design documentation for a project, consider the **Diátaxis** model (tutorials, how-to, explanation, reference) so material is easy to navigate.
- **GitHub README layout** (linked badges, centered header, Built With grouping, back-to-top, contributors image) is specified in `general/readme-layout.md`. Blanks: `dev-centr/readme-template`. Hand-edit per repo; do not batch-script cross-repo README rewrites.

## Antora (when used)

- **Default stack:** Antora + **Valentus** UI (`antora-supplemental/valentus-theme`). Customize colors and logo from the org’s existing brand assets (org `.github` profile, eponymous site repo, or other central branding repo)—do not invent a one-off palette per component.
- If the project uses **Antora**, follow the publishing and layout guidance in the Dev-Centr documentation repository: `dev-centr/devcentr` — see `docs/modules/publishing/pages/antora-deployment.adoc` for deployment-oriented details.
- **One Antora site per org** that already has a hub (e.g. https://docs.devcentr.org). Do not publish secondary per-repo Antora sites on GitHub Pages. Keep `docs/` in the product repo; **wire** into the hub playbook. See `general/antora-docs-sites.md`. Actively deduplicate when you find errant sites. Does **not** apply to mixtures of different docs systems (Antora + Fumadocs is fine). Repo-local `antora-playbook.yml` for **preview/validation CI** is fine if it does **not** publish a second public site.
- **Search:** Enable `@antora/lunr-extension` on every published Antora site. Add the AI-assisted search/help layer from **`antora-supplemental`** — prefer [`@antora-supplemental/antora-search-chat`](https://github.com/antora-supplemental/antora-search-chat) (Lunr-first Search/Ask omnibox). Related: [`antora-ai-help-extension`](https://github.com/antora-supplemental/antora-ai-help-extension). Register Lunr before wrappers that depend on it.
- If `antora-supplemental` (or those extensions) cannot be found after a reasonable search (rename/move), **stop and alert the user** (email, Slack, or whatever channel is available) so they can notify whoever owns this automation rule — then wait for a reply before inventing a substitute.

## Relationship to creator rules

- Changelog placement and ownership expectations live in `general/creator.md`. This file covers **how** documentation is shaped and **when** Antora-specific paths apply.
- Shippable **product** architecture (About, updates, packaging, pipelines) lives in `general/app-architecture.md` and the local general-knowledge Software Product Essentials pages—not here.

## Titles for news, blogs, and essays

**Stance before title shape:**

- **News** faces **outward** — what entered the shared record (shipped, added, partnered). Org announcements and status lines.
- **Blog / essay** faces **inward** — ideas, ideals, philosophy, craft tutorials, working theories; often a small social beat (thinking in public).
- **Changelog** is neither — shipping minutiae stay in Antora / `/changelog`.

If announcing that a thing exists → news. If thinking through a claim or how to see → blog.
Essay: https://ryanjohnson.dev/blog/posts/blog-as-inner-thought/ · house STYLE: HCI-Nerdz `STYLE.adoc`.

When authoring or reviewing titles:

1. **First-party news** — omit the org; notification line unless another actor did it.
2. **Action essays** — invisible **[On]**; drop surplus *the*; no bare imperatives.
3. **Framing** — prefer `X as Y` / process / `A X` / *when* / disproof / questions over rigid `X is Y`.
4. **Modifiers** — attach to an object.
5. **Docs topics** — concept names.
6. One idea per news item; big idea first.

See each site’s `STYLE.adoc`. Philosophy: **Titles as orientation**. Cursor `.cursor/rules/*.mdc` is a directory. Project agent facts → `AGENTS.md`. Workstation facts → `$CODE_ROOT/MEMORIES.md` only (never per-repo `MEMORIES.md`).
