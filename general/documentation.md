# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Audience / point of view (required gate)

**Published docs are for the reader on the page — not for the person in this chat.**

The chat user commissioned the page. They already know the session context, house jargon, and why the change exists. The published audience does **not**: new org members, naive adopters, forge visitors, and search arrivals. Write for *them*.

### Before the first sentence

Name the published reader in one line (keep it in chat or a draft note — optional in the page lead). Examples:

- “New Dev-Centr member setting up agent-rules on a fresh machine”
- “Visitor evaluating whether to adopt this library”
- “Org engineer wiring a component into the docs hub”

If you cannot name the reader, you are not ready to draft.

### Who “you” is

| Surface | “You” means | Must not mean |
| --- | --- | --- |
| Antora / site docs, public README, profile README | The **published reader** (newcomer / visitor) | The chat commissioner, the agent, “this session” |
| News body | Prefer no second person (skill `writing-news`) | Chat-only asides |
| Blog body | The essay’s reader when clarity needs it | The commissioning chat partner by name/deixis |
| `AGENTS.md`, skills, always-on rules | The **agent** | Visitors |

Do **not** mix agent-obligation copy into visitor pages. Agent playbooks stay in skills / `AGENTS.md` / `general/*`. Human setup guides may *describe* what an agent will do, but they teach the human first.

### Anti-patterns (fail the gate)

- Writing as a **chat continuation** (“as we discussed”, “per your setup”, assuming filled constants the stranger never set)
- **Insider deixis** without teaching (“this user’s machine”, “your agent probes…”) when the stranger has no “this user” yet
- Leading with **house variable soup** (`$AGENT_RULES_PATH`, `$CODE_ROOT`, …) before saying what the page is for and what to install first
- Dumping **maintainer / agent notes** onto a public page (first-person “I decided…”, “start here for me”, session TODOs)
- Assuming the reader already joined the org, cloned the hive, or ran `harness-setup`

Motivating failure mode: architecture pages that read like an agent briefing for the commissioner instead of an onboarding guide for a naive joiner (e.g. early drafts of harness-neutral architecture).

### Pass checks (before commit)

1. Could a smart stranger who never opened this chat follow the page from the first screen?
2. Does every `$PLACEHOLDER` / jargon term get a plain gloss on first use, or a link to a prior onboarding page?
3. Would removing chat context still leave a coherent document?
4. Is agent-facing procedure elsewhere (skill / `AGENTS.md`), with the docs page teaching the human outcome?

Skills that ship visitor copy must re-check this gate: `antora-org-site`, `public-readme`, `bootstrap-org` (profile/site), `owned-changelog` (reader-facing summaries), `writing-news`, `writing-blog`.

## Structure

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**. Blanks: `dev-centr/readme-template`. Hand-edit per repo.
- Antora sites / hubs: skill **`antora-org-site`** (Valentus is a suggestion — confirm; lean theme + **Facto** compose pack — `agents/engineering/antora.md`). Encoding: skill **`fix-docs-encoding`**.
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
