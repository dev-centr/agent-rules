# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Audience / point of view (required gate)

**Published docs are for the reader on the page — not for the person in this chat.**

The chat user commissioned the page. They already know the session context, house jargon, and why the change exists. The published audience does **not**: new org members, naive adopters, forge visitors, and search arrivals. Write for *them*.

### Encode as page attributes (required)

Put audience, usage context, and authors in the **document header** as `page-*` attributes. Do **not** hand-write visible `Audience::` / author labeled lists when `@antora-supplemental/page-context` is registered — that extension formats the lead + footer from metadata.

AsciiDoc house schema:

```asciidoc
= Page title
:description: Short SEO blurb (optional; not rendered by page-context).
:page-audience: New Dev-Centr members and anyone adopting agent-rules on a fresh machine
:page-usage-context: Full teaching page on the docs hub (not a sidebar snippet or agent playbook)
:page-orig-author: Ryan Johnson
:page-last-author: Cursor agent on behalf of Ryan Johnson
:page-last-edited: 2026-08-25
```

| Attribute | Required | Rendered by extension as |
| --- | --- | --- |
| `page-audience` | yes (for teaching pages) | Audience (lead) |
| `page-usage-context` | when not obvious | Usage context (lead) |
| `page-orig-author` | yes | Original author (footer; set once) |
| `page-last-author` | yes | Latest contributor (footer) |
| `page-last-edited` | no | Date on latest line |

Extension: **`@antora-supplemental/page-context`** — register under `asciidoc.extensions` in the Antora playbook. Repo: https://github.com/antora-supplemental/page-context

Markdown / README (no Antora): a short lead that names **who** and **when**; credit authors in a footer line. Prefer AsciiDoc + the extension on hub docs.

| Doc kind | Typical `page-audience` | Typical `page-usage-context` |
| --- | --- | --- |
| Tutorial / how-to / onboarding | New member, adopter, first-time setup | Full-page guide; start-here path |
| Explanation | Reader who wants the model / why | Hub article; may link out from README |
| Reference | Practitioner looking up a fact | May be **sidebar**, in-app help, or deep link — say so |
| Changelog index | Maintainers and readers tracking ships | Timeline; detail pages may inherit |
| Changelog detail | Same as index unless scoped narrower | Subordinate to the index |
| Public README / profile | Forge visitor / downstream user | Repo face — not agent briefing |
| News / blog | Channel readers (see skills) | Outward record vs inward essay |

Different pages **may** target different audiences. That is expected (e.g. a dense reference meant for a docs sidebar vs an onboarding explainer). The statement must match the page you are writing — do not default every page to “new org member.”

If you cannot name the reader **and** set `page-audience`, you are not ready to draft.

### Who “you” is

| Surface | “You” means | Must not mean |
| --- | --- | --- |
| Antora / site docs, public README, profile README | The **published reader** named in `page-audience` | The chat commissioner, the agent, “this session” |
| News body | Prefer no second person (skill `writing-news`) | Chat-only asides |
| Blog body | The essay’s reader when clarity needs it | The commissioning chat partner by name/deixis |
| `AGENTS.md`, skills, always-on rules | The **agent** | Visitors |

Do **not** mix agent-obligation copy into visitor pages. Agent playbooks stay in skills / `AGENTS.md` / `general/*`. Human setup guides may *describe* what an agent will do, but they teach the human first.

### Anti-patterns (fail the gate)

- Omitting `page-audience` / author attrs, or hand-duplicating what `page-context` already renders
- Crediting only an agent without `on behalf of <human>`
- Writing as a **chat continuation** (“as we discussed”, “per your setup”, assuming filled constants the stranger never set)
- **Insider deixis** without teaching (“this user’s machine”, “your agent probes…”) when the stranger has no “this user” yet
- Leading with **house variable soup** (`$AGENT_RULES_PATH`, `$CODE_ROOT`, …) before saying who the page is for
- Dumping **maintainer / agent notes** onto a public page (first-person “I decided…”, “start here for me”, session TODOs)
- Assuming the reader already joined the org, cloned the hive, or ran `harness-setup`
- Using a generic “developers” audience when the real context is sidebar reference, first-time setup, or changelog scanning

Motivating failure mode: architecture pages that read like an agent briefing for the commissioner instead of an onboarding guide for a naive joiner (e.g. early drafts of harness-neutral architecture).

### Pass checks (before commit)

1. Are `page-audience` (and `page-usage-context` when needed) set in the header?
2. Are `page-orig-author` and `page-last-author` set, with agent-assisted work as `<agent> on behalf of <human>`?
3. Is `@antora-supplemental/page-context` registered on the site playbook (or a documented fallback for non-Antora)?
4. Could a smart stranger who never opened this chat follow the page?
5. Does every `$PLACEHOLDER` / jargon term get a plain gloss on first use, or a link to a prior onboarding page?
6. Would removing chat context still leave a coherent document?
7. Is agent-facing procedure elsewhere (skill / `AGENTS.md`), with the docs page teaching the human outcome?

Skills that ship visitor copy must re-check this gate: `antora-org-site`, `public-readme`, `bootstrap-org` (profile/site), `owned-changelog` (reader-facing summaries), `writing-news`, `writing-blog`.

## Author credits

| Field | Attribute | Lifecycle |
| --- | --- | --- |
| **Original author** | `page-orig-author` | Set once; never overwrite on later edits |
| **Latest contributor** | `page-last-author` (+ optional `page-last-edited`) | Update on meaningful content changes |

### Attribution strings

| How the work was done | Credit string |
| --- | --- |
| Human only | `Ryan Johnson` (display name; forge handle OK) |
| Agent-assisted | `<agent> on behalf of <human>` — e.g. `Cursor agent on behalf of Ryan Johnson` |

- **`<agent>`** = harness/product readers recognize (`Cursor agent`, `Claude Code`, `Hermes`, …), not an internal model slug.
- **`<human>`** = person who directed or owns the change.
- Do **not** list only the agent. Do **not** invent agent credit when history was clearly human-only.
- Backfill from git when missing: first commit adding the file → original; latest substantive → latest. Add `on behalf of` only when the session was agent-assisted (e.g. `Co-authored-by: Cursor`). If unsure, credit the human alone.

Changelog **detail** pages may inherit from the index when thin stubs; otherwise set their own attrs.

### Pass checks (authors)

1. Both original and latest attrs are present.
2. Agent-assisted edits use `<agent> on behalf of <human>`.
3. Original was not overwritten by a later edit.

## Structure

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**. Blanks: `dev-centr/readme-template`. Hand-edit per repo.
- Antora sites / hubs: skill **`antora-org-site`** (Valentus is a suggestion — confirm; lean theme + **Facto** compose pack — `agents/engineering/antora.md`). Encoding: skill **`fix-docs-encoding`**. Register **`@antora-supplemental/page-context`** under `asciidoc.extensions` so `page-*` audience/author attrs render.
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
