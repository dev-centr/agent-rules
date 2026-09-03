# Blog body copy (Dev-Centr)

Do **not** ship telegraphic bullet-essays or generic AI slop on the blog channel.

**Required reading:** Laurie Hertzel, [Six Writing Tips for Crafting Scenes](https://niemanstoryboard.org/2005/03/24/six-tips-for-crafting-scenes/) (Nieman Storyboard).

Essay stance: https://ryanjohnson.dev/blog/posts/blog-as-inner-thought/

Titles + ledes: `agents/editorial/titles.md`. Audience / channel split: `general/documentation.md`. Worked failure modes: docs hub `case-study-agent-voice-vs-reader-voice.adoc`.

## Hertzel checklist (apply to every draft)

1. **Write with a camera angle** — Aim the camera; close vs wide.
2. **Use both scene and summary** — Scene shows; summary bridges; stepping stones not sidewalk.
3. **Telling details and metaphor** — Significant details; sensory in action.
4. **Vary pace** — Slow for decisive moments; clip fast action.
5. **Move forward and backward in time** — Clear time cues on flashback.
6. **End with pull-forward completion** — Forward motion at scene end.

## Blog-specific voice

- **Inward:** ideas, philosophy, craft, tutorials as thinking-in-public
- **Thesis early:** claim or orientation up front — not buried lede
- **Cold reader:** title + first paragraph orient via **concrete shared knowledge** before the case-study scene
- **Enthymeme:** prefer implication-dense titles that pack a second title the reader invents; do not "fix" them into fully scoped thesis titles unless asked
- **New ideas:** assume prior rejection by ignorance/habit; title reopens the case
- **Title ≠ body:** a good title does not excuse a briefing-memo or in-group-poetry lede
- **Conversational authority:** `you` and first person OK when they serve clarity (`you` = published reader)
- **Anti-slop:** no hollow intensifiers, vague abstractions, or listicle filler
- **One framing beat** per post; do not stack unrelated theses
- **Changelog / AGENTS boundary:** version noise → changelog; slug history, nicknames, “do not confuse…” → `AGENTS.md` — never the essay opening
- **Slug = title** unless a named absorb exception applies (`agents/editorial/titles.md`)

## Anti-patterns

- Press-release tone on an essay
- Neutral news voice without a thesis
- Imperative or cryptic titles that fail the cold-reader gate (`agents/editorial/titles.md`)
- Abstract-first titles (*dependents*, *wires*, *labels*) when a concrete hook exists (*URL*, *broken link*)
- Forced situation titles or ledes that only make sense after the body scene
- Telegraphic bullets without scenes
- Structural chat residue in the lede (slug absorb, internal nickname, “do not confuse with page X”, “this page remains the Y face”)
- In-group ledes (“people already chase the *thing*”) when a concrete hook exists
- Keeping an opaque filename/slug after a retitle when nobody depends on the old URL

## Post-draft gate (required)

Before commit, re-run:

1. Title self-test in `agents/editorial/titles.md` (include **lede check**)
2. Audience / POV pass checks in `general/documentation.md` (especially items on concrete opening, no chat residue, slug match)

## Optional upstream references

Published suites (claude-blog, marketingskills, Kimi anti-slop, etc.) are optional — **`agents/editorial/titles.md` + `general/documentation.md` + this file win** over per-site STYLE copies unless the user asks otherwise.
