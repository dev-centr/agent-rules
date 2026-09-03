# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Audience / point of view (required gate)

**Published docs are for the reader on the page — not for the person in this chat.**

The chat user commissioned the page. They already know the session context, house jargon, and why the change exists. The published audience does **not**: new org members, naive adopters, forge visitors, and search arrivals. Write for *them*.

### Encode as page attributes (required)

**Primary:** put metadata in the **document header** as `page-*` attributes. **Facto** registers `@antora-supplemental/page-context`, which formats lead + footer (and HTML meta) from those attrs. Do **not** hard-code the full catalog into the body when the extension is active.

AsciiDoc house schema (minimal required attrs):

```asciidoc
= Page title
:description: Short SEO blurb (optional; Antora — not owned by page-context).
:page-audience: New Dev-Centr members and anyone adopting agent-rules on a fresh machine
:page-usage-context: Full teaching page on the docs hub (not a sidebar snippet or agent playbook)
:page-orig-author: Ryan Johnson
:page-last-author: Cursor agent on behalf of Ryan Johnson
:page-last-edited: 2026-08-25
```

Optional but encouraged when known: `page-doc-type` / `page-diataxis`, `page-status`, `page-keywords`, `page-license`, `page-lang`, `page-prerequisites`, dates (`page-created` / `page-published`), identifiers (`page-doi`, `page-url`), reviewers, etc. Full catalog + aliases: https://github.com/antora-supplemental/page-context#full-attribute-catalog

| Attribute | Required | Rendered by extension as |
| --- | --- | --- |
| `page-audience` | yes (for teaching pages) | Audience (lead) |
| `page-usage-context` | when not obvious | Usage context (lead) |
| `page-orig-author` | yes | Original author (footer; set once) |
| `page-last-author` | yes | Latest contributor (footer); agent-assisted → `<agent> on behalf of <human>` |
| `page-last-edited` | yes (when you know it) | Last edited / folded into latest contributor |

Extension: **`@antora-supplemental/page-context`** (part of **Facto**). Repo: https://github.com/antora-supplemental/page-context

### Fallback when page-context is missing

Always keep a **body fallback** for the three fields readers most need — audience, authorship, last updated — wrapped so Facto / playbooks that set `page-context-active` hide it:

```asciidoc
ifndef::page-context-active[]
[.page-context.page-context-lead]
****
Audience:: {page-audience}
****

[.page-context.page-context-footer]
****
Original author:: {page-orig-author}
Latest contributor:: {page-last-author}
Last updated:: {page-last-edited}
****
endif::[]
```

| Situation | What to emit |
| --- | --- |
| Facto / playbook has `page-context` + `page-context-active` | Header `page-*` attrs **and** the `ifndef` fallback block (hidden at build) |
| Playbook has extension but forgot `page-context-active` | Prefer fix the playbook; avoid unwrapped hard-coded lists (extension would duplicate) |
| No Antora / no extension (plain AsciiDoc, Markdown) | Attrs if the format supports them; otherwise hard-code the three fields in the lead/footer |

Do **not** hard-code the extended catalog (keywords, DOI, license, …) into the body — attrs only for those. Markdown / README: short lead naming who/when + author footer line.

Markdown / README (no Antora): a short lead that names **who** and **when**; credit authors in a footer line. Prefer AsciiDoc + Facto on hub docs.

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

- Omitting `page-audience` / author attrs
- Hard-coding extended metadata into the body when Facto/`page-context` is available (attrs + `ifndef` fallback only for audience / authors / last updated)
- Unwrapped hard-coded lists **and** the extension (duplicate chrome) — use `ifndef::page-context-active[]` or attrs-only
- Crediting only an agent without `on behalf of <human>`
- Writing as a **chat continuation** (“as we discussed”, “per your setup”, assuming filled constants the stranger never set)
- **Insider deixis** without teaching (“this user’s machine”, “your agent probes…”) when the stranger has no “this user” yet
- Leading with **house variable soup** (`$AGENT_RULES_PATH`, `$CODE_ROOT`, …) before saying who the page is for
- Dumping **maintainer / agent notes** onto a public page (first-person “I decided…”, “start here for me”, session TODOs)
- Assuming the reader already joined the org, cloned the hive, or ran `harness-setup`
- Using a generic “developers” audience when the real context is sidebar reference, first-time setup, or changelog scanning

Motivating failure mode: architecture pages that read like an agent briefing for the commissioner instead of an onboarding guide for a naive joiner (e.g. early drafts of harness-neutral architecture).

### Pass checks (before commit)

1. Are `page-audience`, `page-orig-author`, `page-last-author` (and `page-last-edited` when known) set in the header?
2. Is the `ifndef::page-context-active[]` fallback present for audience / authors / last updated (or the playbook is Markdown-only with an equivalent hard-coded lead)?
3. Agent-assisted credits use `<agent> on behalf of <human>`?
4. Facto / hub playbook registers `page-context` and sets `page-context-active` when using Antora?
5. Could a smart stranger who never opened this chat follow the page?
6. Does every `$PLACEHOLDER` / jargon term get a plain gloss on first use, or a link to a prior onboarding page?
7. Would removing chat context still leave a coherent document?
8. Is agent-facing procedure elsewhere (skill / `AGENTS.md`), with the docs page teaching the human outcome?

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

## Illustrations and figures (default)

When you **add or substantially update** visitor-facing docs (explanations, how-tos, curated lists, architecture, onboarding), ship **at least one orientation visual** unless the page is pure tabular reference or a thin changelog stub.

Prefer, in order:

1. **Local diagram** — Mermaid / PlantUML (Kroki) and/or a hand SVG under `modules/.../images/` (Antora `_images/`)
2. **Screenshot or mockup** — real UI, not decorative noise; crop to the one idea
3. **Source thumbnail / still** — e.g. YouTube `hqdefault` / `maxresdefault` saved locally when hotlinking is brittle

Rules of thumb:

* Wall-of-text concept pages without a figure are incomplete — add the figure before calling the doc done.
* Quote AsciiDoc alts that contain commas: `image::file.svg[alt="A, B, C",width=720]` (unquoted commas break attribute lists).
* Prefer **committed** images over remote-only CDN links for Antora hubs; Markdown profile pages may hotlink thumbnails.
* One job per figure; caption or nearby sentence must say what to notice.
* PRs that change UI: skill **`draft-pr`** still wants screenshots in the PR body.

### Pass checks (figures)

1. Does a stranger get a spatial or visual orientation within one screen of the lead?
2. Is the figure local (or an intentional durable hotlink)?
3. Are alts descriptive and comma-safe in AsciiDoc?

## Structure

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**. Blanks: `dev-centr/readme-template`. Hand-edit per repo.
- Antora sites / hubs: skill **`antora-org-site`** (Valentus is a suggestion — confirm; lean theme + **Facto** compose pack — Valentus + Lunr + STEM + Kroki + **page-context** — `agents/engineering/antora.md`). Encoding: skill **`fix-docs-encoding`**. Page metadata: `page-*` attrs + `ifndef::page-context-active[]` fallback (`general/documentation.md`).
- Changelogs: skill **`owned-changelog`**. Shippable apps: skill **`ship-app`**. PRs: skill **`draft-pr`**.

## Antora page title = nav label (one name)

**One canonical title per page.** The document H1 (`= Title`), any `:navtitle:`, and the link text in `nav.adoc` must be the **same string**. Do not invent a shorter “nav name” that means something different from the article title.

Why: mismatched names break search memory, changelogs, xrefs, and agent/human recall (“I swear the page was called X”).

### How to author

1. Write a **short H1** that also fits the sidebar (cold-reader gate still applies — see `agents/editorial/titles.md`).
2. Prefer **no** `:navtitle:` — Antora falls back to the document title when `nav.adoc` omits link text (`xref:page.adoc[]`) or when link text matches the H1.
3. If `nav.adoc` uses explicit link text, it **must equal** the H1 exactly.
4. Do not keep a divergent `:navtitle:` “just in case.”

### Section landings — linked parents (not Overview)

Capability / Diátaxis area landings stay on disk as `…/index.adoc` with H1 = the area name (`= Email`, `= Org infra`, `= How-to Guides`). With playbook `urls.html_extension_style: indexify`, Antora publishes the folder path (`…/email/`, `…/how-to/`) — that is the public/canonical face.

In `nav.adoc`, use a **linked parent** whose link text **equals the H1**. Nested pages hang under it with `**` (and deeper). Do **not** use a dotted section header plus an Overview child:

```asciidoc
* xref:email/index.adoc[Email]
** xref:email/how-to/….adoc[…]
```

Not:

```asciidoc
.Email
* xref:email/index.adoc[Overview]
```

Do **not** invent `overview.adoc`. Do **not** advertise `index.html` (or `overview.html`) in prose, hard-coded hub links, or changelogs; prefer trailing-slash folder URLs or xrefs.

Component / module **start pages** stay `ROOT/pages/index.adoc` (Antora default `start_page`) unless `antora.yml` sets a different `start_page`.

**With `@antora-supplemental/site-nav-tree`:** the component root already links to the start page. Do **not** also put `* xref:index.adoc[Component Title]` as the first nav item — that creates Component > Component. Linked parents are for **section** landings inside the component (`Email`, `How-to Guides`), not for repeating the component title. The extension also unwraps that duplicate when present.

### Antora nav: never mix `.Title` with sibling linked parents

In Antora `nav.adoc`, a dotted line (`.Tutorials`, `.How-to`) starts a **titled list**. That titled block **owns every following `*` item** until the next `.Title`. Mixing a dotted header with sibling `* xref:…` linked parents silently nests those siblings as children of the titled list — How-to / Reference / Explanation disappear from the top level even though the AsciiDoc still looks like peers.

**Do not** mix `.Title` / dotted nav headers with sibling `* xref:…` linked parents in the same list.

| Bucket | Pattern |
| --- | --- |
| Diátaxis (or other) bucket **without** a landing page | Unlinked parent `* Label` + `**` children — **not** `.Label` |
| Bucket **with** `index.adoc` | Linked parent `* xref:…/index.adoc[Label]` + `**` children |

Wrong (`.🎓 Tutorials` absorbs the next `* xref:` How-to as a nested child):

```asciidoc
.🎓 Tutorials
* xref:tutorials/foo.adoc[…]
* xref:how-to/index.adoc[How-to Guides]
** xref:how-to/bar.adoc[…]
```

Right — no landing:

```asciidoc
* 🎓 Tutorials
** xref:tutorials/foo.adoc[…]
* xref:how-to/index.adoc[How-to Guides]
** xref:how-to/bar.adoc[…]
```

Right — with landing:

```asciidoc
* xref:tutorials/index.adoc[Tutorials]
** xref:tutorials/foo.adoc[…]
* xref:how-to/index.adoc[How-to Guides]
** xref:how-to/bar.adoc[…]
```

### Pass checks (titles / nav)

1. H1 equals `nav.adoc` link text (or nav uses empty `xref:…[]` / omits text so the title wins).
2. No `:navtitle:` unless it is identical to the H1 (prefer deleting it).
3. Area landings: linked parent = H1; children under `**`; file remains `index.adoc`; no `.Section` + Overview pattern.
4. No `.Title` dotted headers mixed with sibling `* xref:…` linked parents in the same nav list; buckets without a landing use unlinked `* Label` + `**`, not `.Label`.
5. Hub playbooks use `urls.html_extension_style: indexify` so public URLs are folders; outbound absolute links use trailing-slash paths, not `…/index.html`.

## Titles for news, blogs, and essays

**Cold reader + enthymeme:** title and first paragraph must orient a stranger out of thin air — load **`agents/editorial/titles.md`** (implication-dense titles, agent self-test, new-idea rejected-assumption check). Teaching page: docs hub `agent-rules` → `editorial-titles.adoc`. No shape checklists.

Channel stance (bodies, not title formulas):

- **News** faces **outward** — what entered the shared record → skill `writing-news`
- **Blog / essay** faces **inward** — ideas, craft, thinking in public → skill `writing-blog`
- **Changelog** is neither — shipping minutiae stay in Antora / `/changelog`

If announcing that a thing exists → news. If thinking through a claim or how to see → blog.

Site `STYLE.adoc` = thin pointer only if present. Project facts → `AGENTS.md`. Workstation → `$CODE_ROOT/machine.md`. Harness → `$CODE_ROOT/harness.md`.

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
