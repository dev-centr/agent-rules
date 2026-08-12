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
- **Math formulas:** Ship KaTeX (or equivalent) on every docs surface **whether or not** the page uses math yet. Antora: `stem: latexmath` in the playbook + Valentus/`site-math.js`. Markdown: `remark-math` + `rehype-katex`. Encode real formulas as `stem:[…]` / `$…$`, not plain text.
- **Images with commas in the caption/alt:** AsciiDoc splits `image::file.svg[alt text, more text]` on commas into `width` / `height`. That emits HTML like `width="Zero Trust IdP"`, and figures look broken even though the file is in `_images/`. Always quote: `image::file.svg[alt="Setup: OAuth App, IdP, policy"]` or `image::file.png[alt="vault, hosting, MCP",width=640]`.
- **Hand-authored SVG / AsciiDoc encoding (agent, not Antora):** Antora copies `modules/*/images/` as-is; it does not generate those Access/GCP mock SVGs (Mermaid in the hub is client-side and separate). When you write `.svg` or `.adoc` on Windows:
  - Save **UTF-8 without BOM**. Do not write Windows-1252 smart punctuation into SVG (browsers parse SVG as UTF-8 XML → *Encoding error*).
  - Prefer **ASCII** in SVG text labels (`"`, `'`, `--`, `...`, `->`). Escape `&` `<` `>` as `&amp;` `&lt;` `&gt;`. Declare `<?xml version="1.0" encoding="UTF-8"?>` on new SVGs.
  - Never “fix” encoding by re-saving mojibake (`â€œ` etc.) — that double-encodes. If you see those literals in source, recover once (`latin-1` bytes → UTF-8) or replace with ASCII.
  - Before commit: open the SVG URL / parse as XML; skim the page for `â€œ` / `Ã`.
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

## News and blog body copy (anti-terse)

Do **not** ship telegraphic bullet-essay posts when the channel is News/blog.
Develop scenes and claims the way narrative journalism does.

**Resource (required reading before drafting News/blog):** Laurie Hertzel, [Six Writing Tips for Crafting Scenes](https://niemanstoryboard.org/2005/03/24/six-tips-for-crafting-scenes/) (Nieman Storyboard; from the 2005 Nieman Seminar for Narrative Editors).

Copy these parameters into the draft checklist (Hertzel’s six tips):

1. **Write with a camera angle** — Aim the “camera”; choose close/intimate vs wide/sweeping; do not describe everything at once.
2. **Use both scene and summary** — Scene *shows* (real time, place, action, dialogue, detail). Summary *tells* (compresses time, bridges scenes). Prefer stepping stones over a continuous sidewalk of detail; do not stay stuck in summary-only gist, and do not scene every minor beat.
3. **Use telling details and metaphor** — Significant details only (not random inventory); fold sensory description into action; metaphor when it clarifies.
4. **Vary your pace** — Slow down for decisive moments (more sentences, tension). Speed up fast action with shorter, clipped lines. Do not give every fact equal weight.
5. **Move forward and backward in time** — A scene mostly runs chronologically; flashback / brief “fore-story” is allowed if time cues keep the reader oriented; delay resolving the climactic decision only when control stays clear.
6. **Know where to end your scene** — Close with completion that still pulls the reader forward; avoid endings that feel fully sealed.

Also apply existing house stance: news = outward shared record; blog = inward ideas/craft; lead with why it matters; one framing beat per post; shipping minutiae → changelog.

For **news body copy** use Cursor skill `writing-news`; for **blog body copy** use `writing-blog`. See [`skills/CATALOG.md`](../skills/CATALOG.md). Keep them out of always-on rules: [`skills/BOOTSTRAP.md`](../skills/BOOTSTRAP.md).

## Pull request titles and summaries

When opening or drafting a PR, follow [`general/pull-requests.md`](./pull-requests.md): simple-language titles; inviting plain-English intros; screenshots for UI-visible changes. Org shortcut: [`agents/editorial/pull-requests.md`](../agents/editorial/pull-requests.md).
