---
name: sync-agent-rules
description: >-
  Use when skills or rules drift from the shared reference, installed skills
  are missing or stale, catalog vs discovery mismatch, broken skill junction,
  agent-rules behind origin, AGENT_RULES_SYNCED_SHA mismatch, sync skills,
  update local skills, refresh harness install, new machine skills catch-up,
  autoupdate agent-rules, or keeping skills/rules current across machines.
---

# Sync agent rules and skills

Keep **this machine’s** install aligned with the **shared reference** clone. Do not wait for the user to ask once drift is visible.

**Version model:** the skills/rules set is versioned by the **git SHA** of `$AGENT_RULES_PATH` (not per-skill SemVer). After a successful sync, stamp that SHA in machine-local `$CODE_ROOT/harness.md`.

## Shared reference

| Role | Path |
| --- | --- |
| Canonical skills + portable/org templates | `$AGENT_RULES_PATH` (usually `$CODE_ROOT/github.com/dev-centr/agent-rules`) |
| Personal portable paste (if used) | fork under `$CODE_ROOT/.../<you>/.forks/agent-rules` or equivalent |
| Discovery install | `$SKILLS_DISCOVERY_ROOT` from `$CODE_ROOT/harness.md` |
| Machine-local IDE overlay | `$LOCAL_RULES_DIR` from `$harness.md` |
| Always-on paste slot | `$ALWAYS_ON_RULES` from `$harness.md` |
| Last successful sync | `AGENT_RULES_SYNCED_SHA` (+ optional `AGENT_RULES_SYNCED_AT`) in `$harness.md` |

If `$CODE_ROOT/harness.md` is missing, run skill **`harness-setup`** first, then continue here.

## When (mandatory)

Run this skill **before** relying on installed skills, and whenever any of these appear:

- Catalog skill missing from `$SKILLS_DISCOVERY_ROOT`
- Discovery entry points at the wrong path, a dead target, or a deprecated skill
- `$AGENT_RULES_PATH` (or personal fork used for paste) is **behind** its upstream
- `HEAD` of `$AGENT_RULES_PATH` ≠ `AGENT_RULES_SYNCED_SHA` in `$harness.md` (missing stamp counts as drift)
- Always-on paste / `$LOCAL_RULES_DIR` still describes an old skill set or omits this sync obligation
- User says skills/rules feel out of date on this machine

Autoupdate. Do not only report drift.

## Sequence

### 1. Fetch shared trees

In `$AGENT_RULES_PATH` (and the personal fork if that is the always-on paste source):

1. `git fetch`
2. If tracking branch is **behind** and the working tree is clean enough to fast-forward/rebase: pull or rebase onto upstream.
3. If local **owned** commits would be overwritten or the tree is dirty with unrelated WIP: stop, report, and ask — do not destroy work.

Do **not** force-push. Do **not** reset away uncommitted user edits.

Record `REF_SHA=$(git -C $AGENT_RULES_PATH rev-parse HEAD)` after fetch/pull.

### 2. Reconcile skill discovery

When `SKILLS_DISCOVERY_ROOT` is set and `SKILLS_INSTALL` supports linking/copying:

1. Read `skills/CATALOG.md` — active team skills only.
2. For each active catalog name: ensure `$SKILLS_DISCOVERY_ROOT/<name>/` exists and resolves to `$AGENT_RULES_PATH/skills/<name>/` (or the install method recorded in `$harness.md`).
3. Remove or replace **broken** links and **deprecated** discovery entries (e.g. removed routers) that still sit in the discovery root.
4. Leave **personal-only** packs that are not in the shared catalog (document them; do not delete without asking).

When discovery is `none`: confirm agents can read `$AGENT_RULES_PATH/skills/<name>/SKILL.md` directly; skip link repair.

### 3. Refresh local rule overlays

1. Ensure `$LOCAL_RULES_DIR` (when set) has a short always-apply overlay that points at this skill and the sync obligation — machine paths only here, not in forkable templates.
2. Compare `$ALWAYS_ON_RULES` paste to the current one-liners in `user.md` / personal `RULES.md` / org `AGENTS.md`. If the paste is missing the sync-on-drift line, **update the always-on slot** via the harness’s rule API when available; otherwise tell the user exactly which section to re-paste.
3. Never write hive drive letters into account-synced always-on rules.

### 4. Stamp and verify

1. Write into `$CODE_ROOT/harness.md` (machine-local only):

```text
AGENT_RULES_SYNCED_SHA = <REF_SHA>
AGENT_RULES_SYNCED_AT = <ISO-8601 date>
```

2. Spot-check: a newly required catalog skill is discoverable or directly readable.
3. Briefly report what was updated (fetch/pull, links fixed, rules refreshed, new stamp).

## Do not

- Paste skill bodies into always-on rules
- Commit `$CODE_ROOT/harness.md` or `$CODE_ROOT/machine.md`
- SemVer individual skill folders (set version = agent-rules SHA)
- Treat a dirty personal experiment under discovery as “drift” to wipe without asking
- Skip this skill after noticing drift “to save time”

## Related

- First-time probe → skill `harness-setup`
- Persist a new preference → skill `record-rule`
- Detail / always-on pointer → `general/rules-skills-sync.md`
