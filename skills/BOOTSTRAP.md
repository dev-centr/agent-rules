# Bootstrap Cursor skills (this repo)

**One-stop for this repository.** Deep narrative (taxonomy, dual on-ramps, worked examples) lives in general-knowledge—do not copy it here:

- [Vibe coding bootstrap](https://docs.devcentr.org/general-knowledge/latest/explanation/infrastructure/vibe-coding-bootstrap.html) (explanation)
- [Bootstrap Cursor skills](https://docs.devcentr.org/general-knowledge/latest/how-to/bootstrap-cursor-skills.html) (how-to)

If docs are not published yet locally: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/…`.

## Contract (agent-rules)

| Path | Role |
|------|------|
| `skills/<name>/SKILL.md` (+ siblings) | Canonical curriculum — **not** part of `MAIN.md` / `RULES.md` assembly |
| `~/.cursor/skills/<name>/` | What Cursor discovers (junction or copy of the folder above) |
| `RULES.md` / User Rules | At most a **one-line** pointer |
| `general/documentation.md` | Titles + thin always-on News/blog tips (Nieman scene checklist) |
| `~/.cursor/skills-cursor/` | Cursor built-ins — **do not author here** |

Skills are for **heavy curricula** split **one skill per job** (e.g. `writing-news`, `writing-blog` — not a router skill). Keep short always-on tips in `general/documentation.md`. Inventory: `skills/CATALOG.md`.

## On-ramp A — configure yourself

1. Create `skills/<skill-name>/` with `SKILL.md` (`name` + `description` WHAT/WHEN) and progressive-disclosure siblings.
2. Junction or copy into `~/.cursor/skills/<skill-name>/` (Windows: `mklink /J`).
3. Optional: one AI-ops line in `RULES.md` naming the skill.
4. New agent chat → verify discovery.

## On-ramp B — drop this into a permissive agent

Paste (and `@`-mention this file):

```text
Follow skills/BOOTSTRAP.md in this agent-rules clone.
Install a Cursor skill under skills/<name>/; junction to ~/.cursor/skills/<name>/.
Do not paste the skill body into always-on User Rules — thin pointer only.
Read the general-knowledge vibe-coding / bootstrap-cursor-skills pages for framing if needed.
```

Attach source notes or an export. Same end state as on-ramp A.

## House writing split

- **Titles / stance / Nieman anti-terse** → `general/documentation.md` (loaded when drafting docs).
- **News body** → skill `writing-news` (`skills/writing-news/`).
- **Blog body** → skill `writing-blog` (`skills/writing-blog/`).
- One skill per job; descriptions must trigger on the matching task.

Portable skills upstream here; personal-only packs stay in your fork until PR.
