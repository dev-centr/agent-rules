# Bootstrap agent skills (this repo)

**One-stop for this repository.** Illustrated architecture: https://docs.devcentr.org/agent-rules/harness-neutral.html

Deep narrative (taxonomy, dual on-ramps, worked examples) may also live in general-knowledge — do not copy long bodies here:

- [Vibe coding bootstrap](https://docs.devcentr.org/general-knowledge/latest/explanation/infrastructure/vibe-coding-bootstrap.html) (explanation)

If docs are not published yet locally: `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/…`.

## Contract (agent-rules)

| Path | Role |
|------|------|
| `skills/<name>/SKILL.md` (+ siblings) | Canonical curriculum — **not** part of `MAIN.md` / `user.md` assembly |
| `$SKILLS_DISCOVERY_ROOT/<name>/` | Harness discovery path when installed (from `$CODE_ROOT/harness.md`) |
| `user.md` / always-on slot | At most a **one-line** pointer |
| `general/documentation.md` | Titles + thin always-on News/blog tips (Nieman scene checklist) |
| `$CODE_ROOT/harness.md` | Machine-local: harness name, discovery root, install method |

Skills are for **heavy curricula** split **one skill per job** (e.g. `writing-news`, `writing-blog` — not a router skill). Keep short always-on tips in `general/documentation.md`. Inventory: `skills/CATALOG.md`.

## On-ramp A — configure yourself

1. Run skill **`harness-setup`** if `$CODE_ROOT/harness.md` is missing.
2. Create `skills/<skill-name>/` with `SKILL.md` (`name` + trigger-word `description` — skill `write-a-skill`) and progressive-disclosure siblings.
3. Install into `$SKILLS_DISCOVERY_ROOT` per `SKILLS_INSTALL` in `$harness.md` (junction, copy, or harness-native — **record method in harness.md, not in templates**).
4. Optional: one AI-ops line in `user.md` naming the skill.
5. New agent chat → verify discovery (or direct read from `$AGENT_RULES_PATH/skills/<name>/`).

## On-ramp B — drop this into a permissive agent

Paste (and `@`-mention this file):

```text
Follow skills/BOOTSTRAP.md in this agent-rules clone.
Run skill harness-setup if $CODE_ROOT/harness.md is missing.
Install agent skills under skills/<name>/ per harness.md.
YAML description = trigger words (skill write-a-skill), not a lay blurb.
Do not paste skill bodies into always-on rules — thin pointer only.
Read docs.devcentr.org/agent-rules/harness-neutral.html for architecture.
```

Attach source notes or an export. Same end state as on-ramp A.

## House writing split

- **Titles / stance / Nieman anti-terse** → `general/documentation.md` (loaded when drafting docs).
- **News body** → skill `writing-news` (`skills/writing-news/`).
- **Blog body** → skill `writing-blog` (`skills/writing-blog/`).
- **Docs mojibake / SVG XML** → skill `fix-docs-encoding` (`skills/fix-docs-encoding/`).
- **DUB registry publish** → skill `publish-to-dub` (`skills/publish-to-dub/`).
- **GitHub org / project bootstrap** → skill `bootstrap-org` (`skills/bootstrap-org/`).
- **Tag / ship a version** → skill `tag-release` (`skills/tag-release/`).
- **Authoring a skill / `SKILL.md` / skill `description`** → skill `write-a-skill` (`skills/write-a-skill/`).
- **Ship an app** → skill `ship-app` (`skills/ship-app/`).
- **Antora / org docs hub** → skill `antora-org-site` (`skills/antora-org-site/`).
- **Public README** → skill `public-readme` (`skills/public-readme/`).
- **Draft a PR** → skill `draft-pr` (`skills/draft-pr/`).
- **Git commit** → skill `git-commit` (`skills/git-commit/`).
- **Push code** → skill `push-code` (`skills/push-code/`).
- **Owned changelog** → skill `owned-changelog` (`skills/owned-changelog/`).
- **Env names registry** → skill `env-names-registry` (`skills/env-names-registry/`).
- **Outdated code protocol** → skill `outdated-code-protocol` (`skills/outdated-code-protocol/`).
- **Issue reports** → skill `issue-reports` (`skills/issue-reports/`).
- **`.issues` record + push** → skill `issues-repo-record` (`skills/issues-repo-record/`).
- **Polyglot CI / release matrix** → skill `polyglot-ci` (`skills/polyglot-ci/`).
- **Harness setup / harness.md** → skill `harness-setup` (`skills/harness-setup/`).
- **Sync skills/rules on drift** → skill `sync-agent-rules` (`skills/sync-agent-rules/`).
- One skill per job; descriptions must trigger on the matching task.

Portable skills upstream here; personal-only packs stay in your fork until PR.
