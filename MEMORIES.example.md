# MEMORIES.example.md (committed template)

Copy to **`$CODE_ROOT/MEMORIES.md`** on each workstation. That file is **machine-local** (this user's machine — paths, tools, hardware) and must **not** be committed.

**Harness config** (skill discovery, always-on injection, chat behaviors) belongs in **`$CODE_ROOT/HARNESS.md`** — see `HARNESS.example.md` and skill `harness-setup`.

Do **not** create per-repo `MEMORIES.md` for project knowledge — use `AGENTS.md` + docs instead.

Format (usage counter starts at 1; increment when reused):

```text
# Memories (Workstation)

- <fact about this machine or clone layout> (counter: 1)

## Paths
- **SOME_TOOL:** `C:\path\to\tool` (counter: 1)
```

Examples of what belongs here:

- Tool install locations / PATH gaps (`ffmpeg` missing, Flutter SDK path)
- Screenshot folders, hardware quirks on this PC
- “This machine’s CODE_ROOT is …”

Examples of what does **not** belong here (put elsewhere):

| Fact type | Where |
| --- | --- |
| Harness name, skill discovery paths | `$CODE_ROOT/HARNESS.md` |
| How to build/deploy the project | README / docs |
| Product architecture gotchas | docs explanation or `AGENTS.md` |
| Editorial voice | `STYLE.adoc` |
| Forkable agent policy | `RULES.md`, `AGENTS.md`, `general/*` |
