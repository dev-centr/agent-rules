# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Structure

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**. Blanks: `dev-centr/readme-template`. Hand-edit per repo.
- Antora sites / hubs: skill **`antora-org-site`** (Valentus is a suggestion — confirm). Encoding: skill **`fix-docs-encoding`**.
- Changelogs: skill **`owned-changelog`**. Shippable apps: skill **`ship-app`**. PRs: skill **`draft-pr`**.

## Titles for news, blogs, and essays

**Stance before title shape:**

- **News** faces **outward** — what entered the shared record (shipped, added, partnered).
- **Blog / essay** faces **inward** — ideas, ideals, philosophy, craft tutorials, thinking in public.
- **Changelog** is neither — shipping minutiae stay in Antora / `/changelog`.

If announcing that a thing exists → news. If thinking through a claim or how to see → blog.

When authoring or reviewing titles:

1. **First-party news** — omit the org; notification line unless another actor did it.
2. **Action essays** — invisible **[On]**; drop surplus *the*; no bare imperatives.
3. **Framing** — prefer `X as Y` / process / `A X` / *when* / disproof / questions over rigid `X is Y`.
4. **Modifiers** — attach to an object.
5. **Docs topics** — concept names.
6. One idea per news item; big idea first.

See each site’s `STYLE.adoc`. Philosophy: **Titles as orientation**. In-repo IDE rules per `IDE_PROJECT_RULES` in `$CODE_ROOT/harness.md`. Project agent facts → `AGENTS.md`. Workstation facts → `$CODE_ROOT/machine.md`. Harness config → `$CODE_ROOT/harness.md`.

## News and blog body copy (anti-terse)

Do **not** ship telegraphic bullet-essay posts on the News/blog channel.

**Resource (required reading before drafting):** Laurie Hertzel, [Six Writing Tips for Crafting Scenes](https://niemanstoryboard.org/2005/03/24/six-tips-for-crafting-scenes/).

1. Write with a camera angle
2. Use both scene and summary
3. Telling details and metaphor
4. Vary pace
5. Move forward/backward in time with clear cues
6. End scenes with pull-forward completion

For **news body** use skill `writing-news`; for **blog body** use `writing-blog`. See [`skills/CATALOG.md`](../skills/CATALOG.md).
