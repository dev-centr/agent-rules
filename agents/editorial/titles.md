# Editorial titles (house default)

Canonical title and channel doctrine for owned orgs.
Site `STYLE.adoc` files (if present) are **thin pointers** here — do **not** maintain a second rulebook per website.
Philosophy essays: [Titles as orientation](https://hci-nerdz.github.io/blog/titles-as-orientation/) · [ryanjohnson.dev](https://ryanjohnson.dev/blog/posts/titles-as-orientation/).

When authoring or reviewing **news**, **blog**, or **doc** titles: load this file.
Org overlays (`{org}/agent-rules/AGENTS.md`) may add org-only quirks; they must not restate or contradict this module.

## Cold-reader gate (hard)

Title **and** first paragraph must orient a stranger **out of thin air**.

- Name the topic, claim, or job before the case study.
- A private scene shorthand that only makes sense after the body is a **fail** — even if it fits a `When …` pattern.
- Prefer a claim or job title when the scene is insider-only.
  Example prefer: `Making model assumptions transparent`.
  Example avoid: `When the agent names a fork before it looks`.
- `When …` is allowed only when a cold reader can recognize the **class of failure** from the title alone (`When 'non-technical' products lie`).

## Voice / channel

| Kind | Faces | Title job |
| --- | --- | --- |
| *News* | **Outward** — what entered the shared record | Notification / status line (first-party) or subject + present-tense verb (external actor) |
| *Blog / essay* | **Inward** — ideas, craft, working theories | Orient to a claim, framing, question, or *recognizable* situation |
| *Changelog* | Neither | Shipping minutiae stay in changelog / Antora |
| *Antora topic* | Reference | Concept name; no forced news verb |

Stance essay: [Blog as inner thought](https://ryanjohnson.dev/blog/posts/blog-as-inner-thought/).

## Title shapes (tools, not defaults)

Use the shape that orients. **Do not** force `When …` for every essay.

- **First-party news** — omit the org (`Instruction flows added to the repertoire`, not `OrgName adds…`).
- **Action essays** — implied **[On]**; drop surplus *the*; no bare imperatives (`Navigating by content`).
- **Framing** — prefer `X as Y` / process / `A X` / disproof / identity questions over rigid `X is Y`.
- **Situation (`When …`)** — only with the cold-reader gate above.
- **Modifiers** — attach to an object (`Sequence as top-level organization`, not `Sequence as the top-level`).
- **Big idea first** — human job before implementation nuance.
- One strong idea per news item.

### *Is* equates; *as* orients

| Shape | Effect |
| --- | --- |
| `Theme is a contract` | Rigid equation; little room to ask “which?” |
| `Theme as a contract` | Framing without closing the definition |
| `Theming is a contract` | Process/verb noun |
| `A theme is a contract` | Existential opener; invites *which theme?* |

### Shapes that plant a question

- *Disproof:* `Attention is not inventory` — reader asks *why not?* (needs a real finding)
- *Situation:* `When the UI hides what counts` — class of events a stranger can recognize
- *Identity question:* `What is Antora Supplemental?` — matches an existing mental query

Avoid commitment without a finding, and floating jargon without an object.

## Quick checklist

1. Cold reader: title + lede name the topic without the body scene?
2. First-party news → org omitted unless another actor?
3. Action title → *[On] + title* sounds human? Surplus *the* dropped?
4. Abstract claim → orientation shape, not rigid `X is Y`?
5. Modifiers attached to an object?
6. One idea per news item? Big idea first?
7. Sentence case? Accurate enough?

## Body copy

- **News body** → skill `writing-news`
- **Blog body** → skill `writing-blog` (thesis early; scene after orientation)
- Nieman anti-terse checklist → `general/documentation.md`
- **Docs / README / profile** → `general/documentation.md` (`page-*` + page-context)
- **PRs** → skill `draft-pr` / `general/pull-requests.md`

## Optional site pointer

If a repo keeps `STYLE.adoc` for humans browsing GitHub, make it a **short pointer** to this module (and the philosophy essay). Do not fork competing checklists into the website repo.
