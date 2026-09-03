# Editorial titles (house default)

When writing or reviewing **news**, **blog**, or **doc** titles (and their ledes): assume a **cold reader** — someone who arrived with no prior chat, no product lore, and no case-study context.

Teaching page on the docs hub: component `agent-rules` → `editorial-titles.adoc` (once published). Philosophy depth: [Titles as orientation](https://hci-nerdz.github.io/blog/titles-as-orientation/).

## Cold-reader gate (the rule)

**Title and first paragraph must orient that stranger out of thin air.**

- Orient through **concrete, shared knowledge** first (URL, broken link, rename, file, settings). Deliberate through abstract frames in the body (*labels*, *wires*, *dependents*, *identity*).
- If removing the body would leave the title opaque *or* locked in private jargon, rewrite.
- Prefer: `Broken links after a URL rename`
- Fail: `When the agent names a fork before it looks` (only makes sense after you already know the story)
- Fail: `Path renames that break dependents` (*dependents* is abstract before the hook lands)

Site `STYLE.adoc` files, if present, are thin pointers here — not a second checklist.

## Enthymemic / implication-dense titles

Some titles **pack a second title the reader invents** without writing it.

Surface phrase + charged relation to a known object → the reader supplies *why?* / *for what?* / *instead of what?* and arrives ready to **accept or reject**.

| Surface title | Second title the stranger invents (approx.) |
| --- | --- |
| `An alternative to URLs` | *Why would URLs need an alternative?* / *Alternative for what job?* |
| `Attention is not inventory` | *Why isn't attention inventory?* |
| `When 'non-technical' products lie` | *How do they lie?* / *Which products?* |

**New ideas:** assume the cold reader has **already rejected** the claim (by ignorance or habit). The title's job is to reopen the case against that implicit assumption — not to summarize the architecture diagram.

**Calculated width is allowed.** `An alternative to URLs` is not an overclaim when the body scopes the use-case (e.g. URL-as-identity / URL-as-wire). Do **not** "fix" implication-dense titles into fully scoped thesis titles (`URLs as labels, not wires`) unless the author asked for disambiguation over charge.

**AI failure mode:** models over-explicitize and hedge scope in the title. Prefer implication density when the common concrete object is already in the reader's head (*URL*, not *wire*).

### Agent self-test (run before shipping a title)

1. **Concrete hook?** Does the title name an object or event a stranger already has words for?
2. **Second title?** What unanswered question does a stranger invent on first read? If *nothing*, too flat. If the *wrong job*, too vague or misleading.
3. **Accept/reject fork?** Can they feel a stance forming before paragraph one?
4. **Abstraction demoted?** Are *wires / labels / dependents / identity / CAS* in the body (or subtitle), not stealing the public title when a concrete rival exists?
5. **New-idea check?** If this challenges habit, does the title reopen a rejected assumption rather than only naming the in-group concept?

## Examples bank (house)

| Prefer (public) | Demote / internal nickname |
| --- | --- |
| `Broken links after a URL rename` | path renames / dependents / navigating by content |
| `An alternative to URLs` | Labels versus wires (concept nickname after the hook) |
| `Attention is not inventory` | cognitive-load inventory metaphor alone |
| `Making model assumptions transparent` | when the agent names a fork before it looks |

## Channel (one line each)

- **News** — outward shared record · skill `writing-news`
- **Blog** — inward thesis · skill `writing-blog` (thesis early; scene after orientation)
- **Changelog** — shipping minutiae, not news/blog
- **Antora topics** — concept names; **H1 = nav label** (no divergent `:navtitle:`; section landings = linked parent = H1, not Overview; never mix `.Title` with sibling linked parents) — detail `general/documentation.md`. Public H1 still follows this file's cold-reader + enthymeme guidance.
- **PRs** — skill `draft-pr` / `general/pull-requests.md`
