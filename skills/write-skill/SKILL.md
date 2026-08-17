---
name: write-skill
description: >-
  Use when authoring or editing a Cursor skill, SKILL.md, skill frontmatter,
  or a skill YAML `description` field; when adding a skill under
  agent-rules/skills or ~/.cursor/skills; when create-skill would fill
  description with a lay description of the skill; when writing trigger
  words, invocation phrases, or when a skill should be called; when the
  user asks how to write skills.
---

# Write a Cursor skill

Cursor’s built-in `create-skill` is for **layout** (folders, 500-line cap, progressive disclosure, scripts). **This file wins on `description` and on auto-invocation.**

Do **not** copy skills into `~/.cursor/skills-cursor/` (Cursor-managed built-ins).

## The description is a matcher, not a blurb

Agents see `name` + `description` in the available-skills list and decide whether to **read the body**. If `description` is a lay description of what the skill does, matching fails: the user never types the blurb, and the agent never loads the instructions.

| Field | Job |
| --- | --- |
| `name` | Identity (lowercase, hyphens, max 64 chars) |
| `description` | **Trigger words** — phrases, filenames, and tasks that should load this skill |
| Body | How to do the job |

The body (and the `#` title) may explain the skill. The YAML `description` must **not**.

## How to write `description`

- Third person (the field is injected into the system prompt). Max 1024 chars.
- Lead with **when**: utterances, quoted commands, file names (`SKILL.md`), paths (`~/.cursor/skills`), symptoms.
- Include the exact words people say (`"publish to dub"`, `"write a skill"`).
- Omit `disable-model-invocation` so ambient matching works. Set it only when the skill must load by explicit name.
- Do **not** open with a capability paragraph. Do **not** follow create-skill’s “WHAT + WHEN” sandwich.

**Test:** would someone type these words in chat, or only read them on a landing page? If the latter, move the sentence into the body.

Wrong (lay description)::
`description: Guide for writing effective Agent Skills that teach specialized workflows.`

Wrong (WHAT then WHEN — create-skill default)::
`description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files…`

Right (trigger words)::
`description: Use when extracting text or tables from a PDF, filling PDF forms, merging PDFs, or when the user mentions PDFs or .pdf files.`

More before/after pairs: [examples.md](examples.md).

## House install

Canonical: `$AGENT_RULES_PATH/skills/<name>/` (`dev-centr/agent-rules` for team; personal fork until upstreamed).

Discover: junction into `~/.cursor/skills/<name>/` — do not keep a second diverging copy on disk.

```text
cmd /c mklink /J "%USERPROFILE%\.cursor\skills\<name>" "%AGENT_RULES_PATH%\skills\<name>"
```

Inventory: `skills/CATALOG.md`. Thin pointer only in `AGENTS.md` / `RULES.md`. Structure leftover: Cursor `create-skill`.

When you **touch** an existing skill, rewrite a blurb `description` to trigger words. Do not batch-rewrite unrelated skills.

## Checklist

- [ ] `description` is only trigger words (utterances / files / task phrases) — not a lay summary
- [ ] Third person; no “I can help…” / “You can use this…”
- [ ] `disable-model-invocation` omitted (unless named-only)
- [ ] One job per skill; distinct triggers from siblings
- [ ] Canonical under `skills/<name>/`; junction to `~/.cursor/skills/<name>/`
- [ ] Catalog row + optional one-line pointer; body not pasted into User Rules
- [ ] `SKILL.md` under 500 lines; extra detail one level deep
---