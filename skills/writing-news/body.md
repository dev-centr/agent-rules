# News body copy (Dev-Centr)

Do **not** ship telegraphic bullet-essays on the news channel. Develop scenes and claims the way narrative journalism does.

**Required reading:** Laurie Hertzel, [Six Writing Tips for Crafting Scenes](https://niemanstoryboard.org/2005/03/24/six-tips-for-crafting-scenes/) (Nieman Storyboard).

Titles + ledes: `agents/editorial/titles.md`. Audience / channel split: `general/documentation.md`.

## Hertzel checklist (apply to every draft)

1. **Write with a camera angle** — Aim the camera; close vs wide; do not describe everything at once.
2. **Use both scene and summary** — Scene shows (time, place, action, dialogue, detail). Summary tells (compresses, bridges). Stepping stones, not a continuous sidewalk of detail.
3. **Telling details and metaphor** — Significant details only; sensory description in action; metaphor when it clarifies.
4. **Vary pace** — Slow for decisive moments; clip fast action with short lines.
5. **Move forward and backward in time** — Mostly chronological; flashback OK with clear time cues.
6. **End with pull-forward completion** — Close the scene but leave forward motion; avoid fully sealed endings.

## News-specific voice

- **Outward:** what happened in the shared record — not inward philosophy
- **Attribution:** who did what; facts before interpretation
- **No editorializing:** report; do not argue a thesis
- **No second person** unless quoting
- **Lead:** why this matters to the reader now (concrete shared knowledge first)
- **Changelog / AGENTS boundary:** version pins and task lists → changelog; slug history / nicknames / “do not confuse…” → `AGENTS.md` — not the news lead
- **Slug = title** unless a named absorb exception applies

## Anti-patterns

- Bullet-essay without scenes
- Blog-style thesis lede on a news item
- Whitepaper section labels dressed as headlines
- Surplus org name on first-party news titles (see title module)
- Structural chat residue in the lead (slug absorb, internal nickname, agent briefing asides)
- Opaque slug kept after a retitle when nobody depends on the old URL

## Post-draft gate (required)

Before commit: title self-test (`agents/editorial/titles.md`) + Audience / POV pass checks (`general/documentation.md`), including slug match and no chat residue.

## Optional upstream references

Published news-writing suites (Claude news researcher/writer, etc.) are optional context only — **`agents/editorial/titles.md` + `general/documentation.md` + this file win** unless the user asks otherwise.
