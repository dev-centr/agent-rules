---
name: sync-agent-rules
description: >-
  Use when skills or rules drift from the shared reference, installed skills
  are missing or stale, catalog vs discovery mismatch, broken skill junction,
  agent-rules behind origin, AGENT_RULES_SYNCED_SHA mismatch,
  skills-set label, AGENT_RULES_SYNCED_LABEL, sync skills, update local skills,
  refresh harness install, new machine skills catch-up, autoupdate agent-rules,
  or keeping skills/rules current across machines.
---

# Sync agent rules and skills

Keep **this machine’s** install aligned with the **shared reference** clone. Do not wait for the user to ask once drift is visible.

## Version model

| Layer | What | Role |
| --- | --- | --- |
| **Authoritative** | git **SHA** of `$AGENT_RULES_PATH` | Drift detection and stamp |
| **Human label** | annotated git tag `skills-set/YYYY.MM.DD` (optional `.N` same day) | Readable set version on top of SHA |
| **Not used** | Per-skill SemVer | Skip |

After a successful sync, stamp SHA, label (nearest `skills-set/*` on `HEAD`, if any), and date in machine-local `$CODE_ROOT/harness.md`.

### Cutting a `skills-set/*` tag

On `$AGENT_RULES_PATH` after a meaningful skills/rules-set change lands on the default branch:

1. Choose label: `skills-set/YYYY.MM.DD` (UTC or local ship date). If that tag exists, use `skills-set/YYYY.MM.DD.1`, `.2`, …
2. Annotated tag on the release commit, then push tags:

```powershell
git tag -a skills-set/YYYY.MM.DD -m "Skills/rules set YYYY.MM.DD"
git push origin skills-set/YYYY.MM.DD
```

Do not move existing `skills-set/*` tags. SHA remains source of truth if a machine has not fetched tags yet.

## Shared reference

| Role | Path |
| --- | --- |
| Canonical skills + portable/org templates | `$AGENT_RULES_PATH` (usually `$CODE_ROOT/github.com/dev-centr/agent-rules`) |
| Personal overlay (optional) | fork under `$CODE_ROOT/.../<you>/.forks/agent-rules` — profiles / personal tweaks / personal-only skills; **not** a HEAD-parity mirror of the template |
| Discovery install | **This harness's** `$SKILLS_DISCOVERY_ROOT` from `$CODE_ROOT/harness.md` (its own harness section) |
| Machine-local IDE overlay | **This harness's** `$LOCAL_RULES_DIR` from `$harness.md` |
| Always-on paste slot | **This harness's** `$ALWAYS_ON_RULES` from `$harness.md` |
| Last successful sync | **Per-harness** `AGENT_RULES_SYNCED_SHA`, `AGENT_RULES_SYNCED_LABEL`, `AGENT_RULES_SYNCED_AT` in `$harness.md` |

If `$CODE_ROOT/harness.md` is missing (or lacks a section for the currently running harness), run skill **`harness-setup`** first, then continue here.

**Canonical-first, harness-isolated rule:**
- Never author a shared/team skill directly inside a harness's private skills folder. Create or edit the canonical folder under `$AGENT_RULES_PATH/skills/<name>/` and register it in `skills/CATALOG.md`.
- **Each harness maintains only its own skills, rules, and sync stamp.** Do **not** depend on, import from, or edit another harness's files (for example, Antigravity must not read from or edit `~/.cursor/`, and Cursor must not touch `~/.gemini/` or `~/.claude/`). When another harness next runs, it compares `$AGENT_RULES_PATH` `HEAD` against **its own** sync stamp in `$harness.md` and updates its own files autonomously.
- If a harness struggles to follow multi-hop references to canonical files, generate thin one-level shim skills/rules inside **this harness's** own directory pointing at the canonical files rather than crossing into another harness's directory.

## When (mandatory)

Run this skill **before** relying on installed skills, and whenever any of these appear:

- Catalog skill missing from `$SKILLS_DISCOVERY_ROOT`
- Discovery entry points at the wrong path, a dead target, or a deprecated skill
- `$AGENT_RULES_PATH` is **behind** its upstream (authoritative for skills + shared policy)
- `HEAD` of `$AGENT_RULES_PATH` ≠ `AGENT_RULES_SYNCED_SHA` in `$harness.md` (missing stamp counts as drift)
- Always-on paste / `$LOCAL_RULES_DIR` still describes an old skill set or omits this sync obligation
- Personal overlay fork used as a compose/paste source is behind *its* origin (refresh deltas only)
- User says skills/rules feel out of date on this machine
- **You just committed, pulled, or pushed `$AGENT_RULES_PATH`** (your own commits move `HEAD` past the stamp and may add uninstalled catalog skills) - sync before ending the run

**Always sync when local is out of date** - do not ask first. Nothing updates the stamp automatically; hive-watch only fetches remotes.

**Hive git remotes:** skill **`hive-watch`** + `$CODE_ROOT/hive-watch.status.json` handle routine remote fetch. Do not conflate “repo behind origin” with skills install drift — run this skill for the latter; run hive-watch (or read its status file) for the former.

Autoupdate. Do not only report drift. Label mismatch alone is informational if SHA already matches.

**Not drift:** personal fork HEAD ≠ template HEAD. Layered geography keeps the personal repo as an overlay; do not rebase the overlay onto the template just to “catch up” unless the user asks.

## Sequence

### 1. Fetch shared trees

In `$AGENT_RULES_PATH` first (skills + shared templates). Also fetch the personal overlay fork when it supplies compose/paste inputs (`profiles/`, personal tweaks) — that refresh is **overlay currency**, not template parity:

1. `git fetch` (include tags: `git fetch --tags` or `git fetch origin tag skills-set/*` as needed)
2. If tracking branch is **behind** and the working tree is clean enough to fast-forward/rebase: pull or rebase onto upstream.
3. If local **owned** commits would be overwritten or the tree is dirty with unrelated WIP: stop, report, and ask — do not destroy work.

Do **not** force-push. Do **not** reset away uncommitted user edits. Do **not** merge the team template into the personal overlay unless the user requests that.

Record after fetch/pull:

- `REF_SHA=$(git -C $AGENT_RULES_PATH rev-parse HEAD)`
- `REF_LABEL` = newest `skills-set/*` tag that points at `HEAD`, else newest `skills-set/*` reachable from `HEAD` (`git describe --tags --match "skills-set/*" --exact-match` then fall back to `git describe --tags --match "skills-set/*" --abbrev=0`), else empty

### 2. Reconcile this harness's own skill discovery

When **this harness's** `SKILLS_DISCOVERY_ROOT` is set and `SKILLS_INSTALL` supports linking, copying, or shim generation:

1. Read `skills/CATALOG.md` — active team skills only (skipping any skill explicitly listed in this harness's `SKILLS_EXCLUDED` setting in `$harness.md`), plus any personal skills from the personal overlay repo when configured.
2. For each active skill: ensure **this harness's** `$SKILLS_DISCOVERY_ROOT/<name>/` exists and resolves directly to `$AGENT_RULES_PATH/skills/<name>/` (junction, symlink, copy, or thin shim — never pointing into another harness's discovery directory).
3. Remove or replace **broken** links and **deprecated** discovery entries (e.g. removed routers) inside **this harness's** discovery root only.
4. Leave **personal-only** packs that are not in the shared catalog (document them; do not delete without asking).
5. **Do not modify other harnesses' discovery roots, rules, or sync stamps.** Leave other harnesses' sections in `$harness.md` untouched so they detect drift and self-update on their next run.

When discovery is `none`: confirm this harness can read `$AGENT_RULES_PATH/skills/<name>/SKILL.md` directly; skip link repair.

### 2b. Check PATH integrity and auto-install rules/skills dependencies

Before declaring any dependency CLI (`git-ai`, `uv`, `node`, `pnpm`, `gh`, `hive-watch`, etc.) missing:

1. **Windows `PATH` truncation / corruption check (mandatory — skill `windows-path-safety`, `general/windows-path-safety.md`):** compare process `$env:Path` against Registry `Machine` + `User` `PATH` at session/conversation start (and before concluding any binary is missing). Windows Explorer and legacy process launchers can silently drop or truncate `User` `PATH` when `PATH` exceeds ~2,047 characters. Refresh `$env:Path` from Registry `Machine` + `User` when truncated, report once with https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/, and record in `$harness.md` / `$machine.md`.
2. **Auto-install missing ungated dependencies** that the rules/skills system relies on:
   - **Encoding guard** (`tools/encoding-guard/install-global-hooks.mjs`): check `--status`; if not installed, install it machine-wide and re-verify.
   - **`uv`** (Python toolchain): install if missing after full-`PATH` refresh.
   - **`hive-watch`** (`dev-centr/hive-watch`): verify status/install per skill `hive-watch`; flag or install if absent.
3. **Git AI (`git-ai`, required by `code-provenance`):**
   - Check the **`git-ai-guest-repos`** `#2399` safety gate first (`git-ai#2399` / `#2485`) on any workstation that holds guest repositories or forks.
   - If the workstation holds **no** guest repos/forks, or `#2399` is verified fixed end-to-end per `git-ai-guest-repos`, or the user explicitly overrides the gate: **auto-install `git-ai`** via the upstream installer (`code-provenance`), refresh `PATH`, run `git ai install-hooks`, verify, and record in `$harness.md` + `$machine.md`.
   - If `#2399` is still open on a workstation with guest repos/forks: **do not** silently install `git-ai`; record `GIT_AI_STATUS = hold (git-ai#2399 open; checked YYYY-MM-DD)` in `$harness.md` and tell the user so they can keep the hold or explicitly override it.

### 3. Refresh local rule overlays

1. Ensure `$LOCAL_RULES_DIR` (when set) has a short always-apply overlay that points at this skill and the sync obligation — machine paths only here, not in forkable templates.
2. Compare `$ALWAYS_ON_RULES` paste to the current one-liners in `user.md` / personal `RULES.md` / org `AGENTS.md`. If the paste is missing the sync-on-drift line, **update the always-on slot** via the harness’s rule API when available; otherwise tell the user exactly which section to re-paste.
3. Never write hive drive letters into account-synced always-on rules.

### 4. Stamp and verify

1. Write into `$CODE_ROOT/harness.md` (machine-local only):

```text
AGENT_RULES_SYNCED_SHA = <REF_SHA>
AGENT_RULES_SYNCED_LABEL = <REF_LABEL or empty>
AGENT_RULES_SYNCED_AT = <ISO-8601 date>
```

2. Spot-check: a newly required catalog skill is discoverable or directly readable.
3. Briefly report what was updated (fetch/pull, links fixed, rules refreshed, SHA + label stamp).

## Do not

- Paste skill bodies into always-on rules
- Commit `$CODE_ROOT/harness.md` or `$CODE_ROOT/machine.md`
- SemVer individual skill folders
- Move or rewrite existing `skills-set/*` tags
- Treat a dirty personal experiment under discovery as “drift” to wipe without asking
- Skip this skill after noticing drift “to save time”

## Related

- First-time probe → skill `harness-setup`
- Persist a new preference → skill `record-rule`
- Product app version tags → skill `tag-release` (different axis from `skills-set/*`)
- Detail / always-on pointer → `general/rules-skills-sync.md`
