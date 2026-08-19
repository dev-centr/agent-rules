---
name: write-a-skill
description: >-
  Use when authoring or editing an agent skill, SKILL.md, skill frontmatter,
  or a skill YAML `description` field; when adding a skill under
  agent-rules/skills; when writing trigger words, invocation phrases,
  or when a skill should be called; when the user asks how to write
  a skill or write-a-skill; harness-neutral skill authoring.
---

# Write an agent skill

Harness-neutral skill bodies live under `$AGENT_RULES_PATH/skills/<name>/`. Install/discovery is recorded in `$CODE_ROOT/HARNESS.md` — not in forkable templates.

Some harnesses ship layout scaffolds (e.g. Cursor `create-skill`). **This file wins on `description` and on auto-invocation.**

## The description is a matcher, not a blurb

Agents see `name` + `description` in the available-skills list and decide whether to **read the body**. If `description` is a lay description of what the skill does, matching fails.

| Field | Job |
| --- | --- |
| `name` | Identity (lowercase, hyphens, max 64 chars) |
| `description` | **Trigger words** — phrases, filenames, and tasks that should load this skill |
| Body | How to do the job |

## How to write `description`

- Third person. Max 1024 chars.
- Lead with **when**: utterances, quoted commands, file names (`SKILL.md`), paths (`agent-rules/skills`), symptoms.
- Include exact words people say (`"publish to dub"`, `"write a skill"`).
- Do **not** open with a capability paragraph.

More before/after pairs: [examples.md](examples.md).

## House install

Canonical: `$AGENT_RULES_PATH/skills/<name>/`.

Install into `$SKILLS_DISCOVERY_ROOT` per `$CODE_ROOT/HARNESS.md` (`SKILLS_INSTALL`). When discovery is `none`, agents read the canonical path directly.

Inventory: `skills/CATALOG.md`. Thin pointer only in `AGENTS.md` / `RULES.md`.

## Checklist

- [ ] `description` is trigger words only — not a lay summary
- [ ] Third person; one job per skill
- [ ] Canonical under `skills/<name>/`; install per `$HARNESS.md`
- [ ] Catalog row + optional one-line pointer; body not pasted into always-on rules
- [ ] No machine paths or harness-specific install baked into the skill policy body
