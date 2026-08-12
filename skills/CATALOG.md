# Cursor skills catalog (Dev-Centr)

Living inventory for team skills in **`dev-centr/agent-rules/skills/`**. Personal-only experiments stay in your fork until upstreamed.

## Contract

| Location | Role |
| --- | --- |
| `$AGENT_RULES_PATH/skills/<name>/` | Canonical (this repo) |
| `~/.cursor/skills/<name>/` | What Cursor discovers (junction or copy) |
| `~/.cursor/skills-cursor/` | Cursor built-ins — **do not author here** |

Install: [`BOOTSTRAP.md`](./BOOTSTRAP.md). Team SOP: member-only [team.docs.devcentr.org](https://team.docs.devcentr.org).

## Rules

1. **One skill per job** — separate skills with descriptions that trigger on distinct tasks (not one router skill for unrelated modes).
2. **Junction, don’t fork** on disk unless intentionally diverging.
3. **Thin pointers** in `AGENTS.md` / `RULES.md` only — never paste `SKILL.md` bodies into always-on rules.
4. **PR to update this file** when adding, moving, or deprecating a skill.
5. **`description`** must state WHAT + WHEN (third person).

## Registered skills

| Skill | Triggers on | Status | Notes |
| --- | --- | --- | --- |
| `writing-news` | News item, ship note, org announcement, news channel body | active | `skills/writing-news/` |
| `writing-blog` | Blog post, essay, philosophy, thinking-in-public body | active | `skills/writing-blog/` |

## Adding a skill (checklist)

- [ ] One job per skill; description names the trigger scenario
- [ ] Create `skills/<name>/SKILL.md` + progressive-disclosure siblings
- [ ] Junction: `cmd /c mklink /J "%USERPROFILE%\.cursor\skills\<name>" "%AGENT_RULES_PATH%\skills\<name>"`
- [ ] Add row to this catalog
- [ ] Optional one-line pointer in `AGENTS.md`
- [ ] New agent chat → verify discovery

## Deprecating

Mark `deprecated`, point to replacement, remove junction after team notice. Changelog entry in this repo.

**Removed:** `writing-news-vs-blog` (router) — replaced by `writing-news` + `writing-blog`.
