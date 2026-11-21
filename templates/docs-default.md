# Default documentation template

Suggested default for an org's documentation preferences. This is not personal always-on law. An org records a pointer to this file, or to a different template, in `{org}/agent-rules` and `{org}/.github/AGENT-RULES.md`. Do not paste this file into the personal preamble.

Canonical URL (survives a clone that does not contain this file): https://github.com/dev-centr/agent-rules/blob/main/templates/docs-default.md

Path inside the `dev-centr/agent-rules` clone: `templates/docs-default.md`

When you apply this template, or when someone asks what the org's docs rules are, link this file in chat. Workspace-relative markdown link when the clone is in the workspace: [`docs-default.md`](dev-centr/agent-rules/templates/docs-default.md). Skill `chat-file-links`.

The sentences below are the always-on preamble text this template replaces, plus the constraint text those sentences pointed at. Apply `general/documentation.md`, `agents/editorial/titles.md`, skill `writing-news`, and skill `writing-blog` with this template. Skill `public-readme` stays the public README front door.

## Structure

- Structure: Diátaxis (tutorials, how-to, explanation, reference).

From `general/documentation.md`:

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**. Blanks: `dev-centr/readme-template`. Hand-edit per repo.
- Antora sites / hubs: skill **`antora-org-site`** (Valentus is a suggestion — confirm; lean theme + **Facto** compose pack — Valentus + Lunr + STEM + Kroki + **page-context** — `agents/engineering/antora.md`). **Stack/extension mock content:** `demo-data` baseline + supplements via git `content.sources` — skill **`antora-org-site`** → `demo-data.md`; catalog https://docs.antora-supplemental.org/docs/ROOT/proposals/demo-data-catalog.html. Encoding: skill **`fix-docs-encoding`**. Page metadata: `page-*` attrs + `ifndef::page-context-active[]` fallback (`general/documentation.md`).
- Changelogs: skill **`owned-changelog`**. Shippable apps: skill **`ship-app`**. PRs: skill **`draft-pr`**.

## Format

- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown. npm and code.dlang.org read root `README.md`. The DUB registry does not render AsciiDoc. A D package adds that Markdown file beside `README.adoc`. Do not rename or delete it. Detail: skill `public-readme`, skill `publish-to-dub`.

- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.

## Audience role / point of view

- **Audience / POV:** encode `page-audience` / `page-usage-context` / `page-orig-author` / `page-last-author` (agent-assisted: `<agent> on behalf of <human>`); register `@antora-supplemental/page-context` on the playbook. Detail: `general/documentation.md`.

- **Audience role / POV:** `page-audience` renders as **Audience role** (Facto/`page-context` 0.6.2+); keep `ifndef::page-context-active[]` fallback (teaching: audience role / authors; **component homes: footer authors only — never show audience-role/usage chrome**). Value = **necessary role** (permissions / access / usage expectations — Developer ≠ User, Admin ≠ Member; not task padding). Surface/channel → `page-usage-context`. **Lede must orient without the Audience role table** (chrome ≠ body orientation). Agent-assisted **source** form: `<agent> on behalf of <human>` — **display** (page-context 0.6+): `Name (via Agent)`. Keywords link to `/home/keywords/{slug}/` listings. **Re-check after drafting** (no structural chat residue in openings; slug = H1 unless named absorb). Detail: `general/documentation.md`. Case study: docs hub `case-study-agent-voice-vs-reader-voice`.

Current write form for agent-assisted credits (from `general/documentation.md`; do not overwrite `page-orig-author` on later edits):

```asciidoc
= Page title
:description: Short SEO blurb (optional; Antora — not owned by page-context).
:page-audience: New Dev-Centr members and anyone adopting agent-rules on a fresh machine
:page-usage-context: Full teaching page on the docs hub (not a sidebar snippet or agent playbook)
:page-orig-author: Ryan Johnson
:page-last-author: name=Ryan Johnson; harness=Cursor; model=grok-4.7
:page-last-edited: 2026-08-25
```

| Attribute | Required | Rendered by extension as |
| --- | --- | --- |
| `page-audience` | yes (for teaching pages) | **Audience role** (**lead** table) — **not shown** on component home surfaces |
| `page-usage-context` | when not obvious | Usage context (**lead**) — **not shown** on component home surfaces |
| `page-orig-author` | yes | Original author (**footer**; set once) |
| `page-last-author` | yes | Latest contributor — teaching **byline** (`Last updated … by …`); also footer on component homes. Set `name`, `harness`, and `model` as separate keys. The byline links to the page's commit history. |
| `page-last-edited` | yes (when you know it) | Teaching **byline** date; omitted from footer when shown in byline |

**Display vs source:** write `name`, `harness`, and `model` as separate keys. page-context 0.8 shows `Ryan Johnson, harness Cursor, agent grok-4.7` and links that byline to the page's commit history. A legacy `Cursor agent on behalf of Ryan Johnson` still displays as `Ryan Johnson via Cursor` and is not labeled a harness.

| Field | Attribute | Lifecycle |
| --- | --- | --- |
| **Original author** | `page-orig-author` | Set once; never overwrite on later edits |
| **Latest contributor** | `page-last-author` (+ optional `page-last-edited`) | Update on meaningful content changes |

```asciidoc
:page-last-author: name=Ryan Johnson; harness=Cursor; model=grok-4.7
```

- Human only: `name=Ryan Johnson` (or a plain `Ryan Johnson` when no agent was involved).
- Do **not** list only the agent. Do **not** invent a model id. If the harness does not expose one, omit `model`.
- Do **not** put the model in `harness`, and do **not** put the harness in `model`.
- A legacy `Grok 4.7 on behalf of Ryan Johnson` line is one unlabeled credit. Leave old pages as they are unless you know the harness and the model for that edit. Do not guess a split.

**Never show** Audience role or Usage context on an org Antora **component home** (ROOT start page / hub portal), even when the attrs are set for agents and HTML meta. **Author / contributor metadata must be at the end** of that document (footer aside), not in the lead.

Teaching-page fallback when page-context is missing:

```asciidoc
ifndef::page-context-active[]
[.page-context.page-context-lead]
****
Audience role:: {page-audience}
Original author:: {page-orig-author}
Latest contributor:: {page-last-author}
Last updated:: {page-last-edited}
****
endif::[]
```

Component-home fallback (footer authors only, no audience lead):

```asciidoc
ifndef::page-context-active[]
[.page-context.page-context-footer]
****
Original author:: {page-orig-author}
Latest contributor:: {page-last-author}
Last updated:: {page-last-edited}
****
endif::[]
```

**Title + first paragraph must orient without the metadata table.** If you cannot name the **necessary role** (permissions / access / usage expectations) **and** set `page-audience`, you are not ready to draft. If the lede still needs the lead table to make sense, you are not done drafting.

Pass checks from `general/documentation.md` (before commit, after drafting):

1. Are `page-audience`, `page-orig-author`, `page-last-author` (and `page-last-edited` when known) set in the header?
2. Is the `ifndef::page-context-active[]` fallback present (teaching: audience role / authors / last updated; **component home: footer authors only, no audience lead**)?
3. Agent-assisted credits set `name`, `harness`, and `model` separately?
4. Facto / hub playbook registers `page-context` and sets `page-context-active` when using Antora?
5. Component home: no visible Audience role / Usage context; authorship at document end?
6. Could a smart stranger who never opened this chat follow the page?
7. Does every `$PLACEHOLDER` / jargon term get a plain gloss on first use, or a link to a prior onboarding page?
8. Would removing chat context still leave a coherent document?
9. Is agent-facing procedure elsewhere (skill / `AGENTS.md`), with the docs page teaching the human outcome?
10. Does the opening hook with **their** words (URL, broken link, rename) rather than house metaphors (“chase the *thing*”)?
11. Does paragraph one **orient without the Audience role table** (role and/or situation in the prose — not chrome-only)?
12. Is `page-audience` the **necessary role** (permissions / access / usage expectations), not task filler? Is surface/channel in `page-usage-context`?
13. Are slug / nickname / “do not confuse with…” / Cool-URI notes **absent** from the body (they live in `AGENTS.md` / changelog)?
14. Does the **page slug / filename match the public H1** (unless you can name who still needs the old URL)?
15. Did you re-check this list **after** drafting — not only before?

## Titles

- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward**; **blog = inward**. First-party news omits org; action essays pass implied [On]; prefer `X as Y` / *when* / disproof / questions; attach floating modifiers to an object; Antora topics = concept names. Philosophy: `Titles as orientation` (HCI Nerdz + ryanjohnson.dev).

- Titles: cold-reader + enthymeme — `agents/editorial/titles.md`. Title **and lede** orient a stranger **without relying on Audience role chrome**; do not “fix” implication-dense titles into fully scoped theses unless asked; **slug = title**. News outward / blog inward via `writing-news` / `writing-blog`. **Antora:** H1 = `nav.adoc` label = no divergent `:navtitle:`; section landings = linked parent (link text = H1) + `index.adoc` + `html_extension_style: indexify` — never `.Section` + Overview, never mix `.Title` with sibling linked parents, never `overview.adoc` / advertise `index.html` — `general/documentation.md`.

From `general/documentation.md`:

- **News** faces **outward** — what entered the shared record → skill `writing-news`
- **Blog / essay** faces **inward** — ideas, craft, thinking in public → skill `writing-blog`
- **Changelog** is neither — shipping minutiae stay in Antora / `/changelog`
- If announcing that a thing exists → news. If thinking through a claim or how to see → blog.
- Site `STYLE.adoc` = thin pointer only if present. Project facts → `AGENTS.md`. Workstation → `$CODE_ROOT/machine.md`. Harness → `$CODE_ROOT/harness.md`.

From `agents/editorial/titles.md`:

- **Title and first paragraph must orient that stranger out of thin air.**
- Site `STYLE.adoc` files, if present, are thin pointers here — not a second checklist.
- **Slug = public title.** Filename / Antora page slug / blog slug / demo slug match the public title (kebab-case of the H1).
- **News** — outward shared record · skill `writing-news`
- **Blog** — inward thesis · skill `writing-blog`
- **Antora topics** — concept names; **H1 = nav label** (no divergent `:navtitle:`; section landings = linked parent = H1, not Overview; never mix `.Title` with sibling linked parents).

One canonical title per page. The document H1 (`= Title`), any `:navtitle:`, and the link text in `nav.adoc` must be the **same string**.

Pass checks (titles / nav) from `general/documentation.md`:

1. H1 equals `nav.adoc` link text (or nav uses empty `xref:…[]` / omits text so the title wins).
2. No `:navtitle:` unless it is identical to the H1 (prefer deleting it).
3. Area landings: linked parent = H1; children under `**`; file remains `index.adoc`; no `.Section` + Overview pattern.
4. No `.Title` dotted headers mixed with sibling `* xref:…` linked parents in the same nav list; buckets without a landing use unlinked `* Label` + `**`, not `.Label`.
5. Hub playbooks use `urls.html_extension_style: indexify` so public URLs are folders; outbound absolute links use trailing-slash paths, not `…/index.html`.
