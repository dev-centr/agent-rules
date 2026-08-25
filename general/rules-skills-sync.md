# Rules and skills — sync on drift

<!---
Always-on obligation: keep local skill discovery and rule overlays aligned with
the shared agent-rules reference so every machine stays current.
--->

## Rule

When **local** skills or rule overlays **drift** from the shared reference (`$AGENT_RULES_PATH`), the agent **must** run skill **`sync-agent-rules`** and **apply** updates (fetch/pull reference, repair discovery installs, refresh `$LOCAL_RULES_DIR` / always-on pointers, stamp SHA + label). Do not only diagnose.

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
