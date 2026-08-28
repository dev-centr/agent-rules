# Hive remotes (hive-watch)

<!---
Always-on obligation: prefer scheduled hive-watch over per-chat git fetch.
-->

## Rule

Do **not** `git fetch` the whole code hive at the start of every agent chat.

Prefer [**hive-watch**](https://github.com/dev-centr/hive-watch) — a **machine-local scheduler** that fetches remotes daily and writes:

| Path | Content |
| --- | --- |
| `$CODE_ROOT/hive-watch.status.json` | Per-repo ahead / behind / dirty after last fetch |
| `$CODE_ROOT/machine.md` | `<!-- hive-watch:begin -->` … **Last checked** ISO timestamp … `<!-- hive-watch:end -->` |

Agents read those artifacts. Run skill **`hive-watch`** when installing or when the stamp is stale.

## When to fetch

| Situation | Action |
| --- | --- |
| **Last checked ≤ 24h ago** (in `machine.md`) | Read `hive-watch.status.json`; fetch/pull **only** repos you will edit that show `behind > 0` |
| **Stamp missing or > 24h old** | Run `hive-watch` once (`scripts/hive-watch.ps1` or `.sh`), or fetch only repos in scope for this task |
| **User asks to sync everything** | Run `hive-watch` or explicit fetch/pull per repo |
| **Skills/rules drift** | Skill `sync-agent-rules` (separate from hive remotes) |

## Bootstrap

After `harness-setup` on a new machine:

1. Install **hive-watch** from [GitHub Releases](https://github.com/dev-centr/hive-watch/releases) or DevCentr CLI catalog (`hive-watch`); enable **Start at login**. Optional: install [**rules-manager**](https://github.com/dev-centr/rules-manager) for agent-rules compose.
2. Confirm `machine.md` and `hive-watch.status.json` exist under `$CODE_ROOT`.
3. Optional: install **rules-manager** for compose/watch of agent-rules markdown.

The **`hived`** daemon (port 17356) replaces OS cron for fetch duty. Agents must not re-fetch the hive when the stamp is fresh.

## Machine-local only

Never commit `machine.md`, `harness.md`, or `hive-watch.status.json`.

## Related

- Skill `hive-watch`
- Skill `sync-agent-rules` (agent-rules/skills install — not the same as git remotes)
- Skill `harness-setup`
- `skills/BOOTSTRAP.md`
