# machine.example.md (committed template)

Copy to **`$CODE_ROOT/machine.md`** on each workstation. That file is **machine-local** (machine rules for this user's workstation) and must **not** be committed.

**Harness rules** (skill discovery, always-on injection, chat behaviors) belong in **`$CODE_ROOT/harness.md`** — see `harness.example.md` and skill `harness-setup`.

Do **not** create per-repo `machine.md` for project knowledge — use `AGENTS.md` + docs instead.

Format (usage counter starts at 1; increment when reused):

```text
# Machine (workstation)

- <fact about this machine or clone layout> (counter: 1)

## Paths
- **SOME_TOOL:** `C:\path\to\tool` (counter: 1)
```

Examples of what belongs here:

- Tool install locations / PATH gaps (`ffmpeg` missing, Flutter SDK path)
- Screenshot folders, hardware quirks on this PC
- “This machine’s CODE_ROOT is …”
- **Hive remotes stamp** — maintained by [`hive-watch`](https://github.com/dev-centr/hive-watch) between `<!-- hive-watch:begin -->` / `<!-- hive-watch:end -->` (do not hand-edit the timestamp unless hive-watch is unavailable)

Examples of what does **not** belong here (put elsewhere):

| Fact type | Where |
| --- | --- |
| Harness name, skill discovery paths | `$CODE_ROOT/harness.md` |
| How to build/deploy the project | README / docs |
| Product architecture gotchas | docs explanation or `AGENTS.md` |
| Editorial voice | `agents/editorial/titles.md` (site `STYLE.adoc` = thin pointer only) |
| Forkable agent policy | `user.md`, `AGENTS.md`, `general/*` |
