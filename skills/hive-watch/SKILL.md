---
name: hive-watch
description: >-
  Use when hive-watch, hive remotes, remote fetch schedule, hive-watch.status.json,
  HIVE_REMOTES_LAST_CHECKED, machine.md remote stamp, daily git fetch CODE_ROOT,
  avoid fetch every chat, hived daemon, hive watch tray HUD, or installing hive-watch.
---

# Hive-watch (daemon + tray)

**Prefer this desktop tool over per-chat `git fetch`.** [`hive-watch`](https://github.com/dev-centr/hive-watch) runs as **`hived`** (daemon) + **tray/HUD** (Electron). It fetches on a schedule and when local/remotes change, then writes machine-local status agents read.

## Artifacts

| Path | Role |
| --- | --- |
| `$CODE_ROOT/hive-watch.status.json` | Per-repo ahead/behind/dirty after last fetch |
| `$CODE_ROOT/machine.md` | Block between `<!-- hive-watch:begin -->` … **Last checked** |
| `$CODE_ROOT/hive-watch.config.json` | Daemon interval, IPC port (17356), paths |

Detail: `general/hive-watch.md`.

## Agent behavior

1. Read **Last checked** in `machine.md` (hive-watch block).
2. If **≤ 24 hours ago**: use `hive-watch.status.json`; pull only repos you will edit that are behind.
3. If **missing or stale**: ask the user to run the tray app or `hived --fetch` — do not blanket-fetch at chat open.
4. **Do not** replace skill `sync-agent-rules` (skills/rules install drift) or **rules-manager** (compose agent-rules markdown).

## Install

**Release (standalone or DevCentr CLI catalog id `hive-watch`):** [GitHub Releases](https://github.com/dev-centr/hive-watch/releases) — tray installer spawns `hived` automatically.

**Hive clone:**

```powershell
git clone https://github.com/dev-centr/hive-watch.git "$env:CODE_ROOT/github.com/dev-centr/hive-watch"
cd "$env:CODE_ROOT/github.com/dev-centr/hive-watch/daemon"
npm install
node src/index.js --write-config --code-root $env:CODE_ROOT
node src/index.js --serve
```

Tray: `ui/` → `pnpm install && pnpm start`. Enable **Start at login** from the tray menu.

## IPC (optional)

`GET http://127.0.0.1:17356/status` · `POST /fetch`

## Do not

- Commit `hive-watch.status.json` or machine-local `machine.md`
- Reimplement fetch logic in agent context when the daemon is running
