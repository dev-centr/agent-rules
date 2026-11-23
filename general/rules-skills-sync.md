# Rules and skills — sync on drift

<!---
Always-on obligation: keep local skill discovery and rule overlays aligned with
the shared agent-rules reference so every machine stays current.
--->

## Rule

When **this harness's** local skills, rule overlays, or rules/skills dependencies **drift** from the shared reference (`$AGENT_RULES_PATH`), the agent **must** run skill **`sync-agent-rules`** and **apply** updates (fetch/pull reference, repair **this harness's** discovery installs directly from canonical repos, verify `PATH` integrity and auto-install missing rules/skills dependencies, refresh **this harness's** `$LOCAL_RULES_DIR` / always-on pointers, and stamp **this harness's** SHA + label in `$HARNESS`). Do not only diagnose.

**Always sync when local is out of date - no asking, no deferring.** Check at session start (before relying on skills) and again after you commit to, pull, or push `$AGENT_RULES_PATH` yourself: your own commits move `HEAD` past this harness's `AGENT_RULES_SYNCED_SHA` and may add catalog skills that are not yet installed. Nothing else updates the stamp automatically.

**Canonical-first, harness-isolated:** never author a shared skill directly inside a harness's private skills directory. Add it under `$AGENT_RULES_PATH/skills/<name>/` and register it in `skills/CATALOG.md`. Each harness owns **only its own** discovery directory, local rules/shims, and sync stamp in `$HARNESS` — never depend on or edit another harness's rules or skills files. Other harnesses on the same workstation detect drift against their own sync stamps and update themselves when they next run.

**Dependencies & Windows `PATH` check:** before reporting a dependency CLI (`git-ai`, `uv`, `hive-watch`, etc.) missing on Windows, compare process `PATH` against Registry `Machine` + `User` `PATH` to catch Explorer `PATH`-length truncation (`general/windows.md`). Auto-install missing ungated dependencies (`encoding-guard`, `uv`, etc.); for `git-ai`, check the `git-ai-guest-repos` `#2399` gate first and either auto-install (when clear or explicitly overridden) or record the hold in `$HARNESS`.

## Version model

| Layer | What |
| --- | --- |
| **Authoritative** | git **SHA** of `$AGENT_RULES_PATH` |
| **Human label** | git tag `skills-set/YYYY.MM.DD` (optional `.N` same day) |
| **Avoid** | Per-skill SemVer |

After a successful sync, record in machine-local `$CODE_ROOT/harness.md`:

```text
AGENT_RULES_SYNCED_SHA = <sha>
AGENT_RULES_SYNCED_LABEL = <skills-set/YYYY.MM.DD or empty>
AGENT_RULES_SYNCED_AT = <ISO-8601 date>
```

Cut `skills-set/*` annotated tags on meaningful set milestones (skill `sync-agent-rules`).

## What counts as drift

- Active catalog skill missing from `$SKILLS_DISCOVERY_ROOT` (when discovery is used)
- Broken or wrong-target skill link/copy
- Deprecated skill still installed under discovery
- `$AGENT_RULES_PATH` **behind** its upstream (skills + shared policy live here)
- `HEAD` of `$AGENT_RULES_PATH` ≠ `AGENT_RULES_SYNCED_SHA` (or stamp missing)
- Always-on / local IDE rules missing the sync-on-drift obligation or pointing at removed skills
- Personal **overlay** fork used as a compose/paste source is behind *its* origin (refresh overlays only — **not** a requirement that personal HEAD equal template HEAD)

Label mismatch with a matching SHA is informational only. Layered model: personal fork is deltas; do not treat rebase parity with the team template as sync success.

## What stays machine-local

- `$CODE_ROOT/harness.md`, `$CODE_ROOT/machine.md` (including the sync stamp)
- Hive paths in `$LOCAL_RULES_DIR` only — never in account-synced always-on paste

## Related

- Skill `sync-agent-rules`
- Skill `harness-setup` (first probe / missing `harness.md`)
- `skills/CATALOG.md`, `skills/BOOTSTRAP.md`
- `general/harness-boundary.md`
