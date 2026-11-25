# Windows PATH truncation safety check

<!---
Portable mandatory rule for Windows AI coding harnesses (both third-party hosts
and DevCentr-owned runtimes). Canonical explanation:
https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/
--->

## Rule

On Windows (`ENVIRONMENT = windows`), checking for Windows `PATH` truncation is **mandatory at the start of every session / conversation** — not only after a CLI fails.

Windows Explorer and legacy launchers silently truncate `PATH` or drop the entire `User` `PATH` when the expanded value exceeds ~2,047 characters. Because AI harnesses inherit the parent launcher's environment block, agents routinely conclude installed CLIs (`uv`, `pnpm`, `dub`, `rg`, `nu`, `git-ai`, etc.) are missing and enter broken reinstall or fallback loops.

Canonical reference article: https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/

## Session start vs. conversation start (third-party harnesses)

Inside third-party harnesses (Cursor, Antigravity, Claude Code, Codex, Windsurf), an agent generally **cannot tell whether a new chat shares an already-checked host process or started a fresh one** — and several harnesses spawn a new shell subprocess on every command so in-shell `$env:Path` edits do not persist across calls.

Follow this contract on Windows:

1. **Treat every new conversation as a session boundary.** On the first shell command of a conversation (or via a native `SessionStart` hook when the harness runs it in the same inherited environment), compare process `$env:Path` against expanded Registry `Machine` + `User` `PATH` (skill `windows-path-safety`).
2. **If truncation is detected (any Registry entry missing from process `PATH`):**
   - Refresh `$env:Path` from Registry (`Machine + ";" + User`) in that command — and in harnesses whose command runner spawns a fresh subprocess per call, prepend the Registry refresh on subsequent CLI-dependent commands in the conversation.
   - Report the truncation once to the user (process length vs. Registry length, dropped-entry count, and link to https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/).
   - Record or update `WINDOWS_PATH_TRUNCATION = detected (...)` in machine-local `$CODE_ROOT/harness.md`.
3. **If Registry `PATH` exceeds 2,047 characters even without current drops**, note it in `$CODE_ROOT/harness.md` and suggest permanent cleanup (`pathman` / deduplication / removing missing directories) without blocking work.
4. **Never conclude a CLI is missing or re-install a tool** before verifying against expanded Registry `Machine` + `User` `PATH`.

## Owned / native harness requirement (DevCentr Harness)

Any agent harness we own and build (including `dev-centr/harness`) must enforce this check **natively on process launch / harness run** rather than relying on LLM prompts:

1. **Detect on launch:** Read `HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\Path` and `HKCU\Environment\Path` directly from the Windows Registry, expand `REG_EXPAND_SZ` references, and compare against the inherited process `PATH`.
2. **Automatically repair:** When entries from Registry are missing from process `PATH`, merge and deduplicate `Machine` + `User` + any process-only additions and update the harness process's own `PATH` so every spawned tool and subshell inherits the full `PATH`.
3. **Report visibly in the UI (and `stderr` on CLI runs):**
   - When repaired: display a visible alert in the app interface stating that Windows truncated `PATH` and the harness automatically repaired it for this process (with dropped-entry counts / details) and linking to https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/.
   - When the check or repair fails: display an error alert in the app interface explaining the failure and linking to the same reference article.
   - Do **not** hide the auto-fix silently: surfacing the defect helps developers trim their Registry `PATH` and keeps visibility on the Windows Explorer 2,047-character bug.

## Related

- Skill **`windows-path-safety`** (`skills/windows-path-safety/SKILL.md`)
- `general/windows.md`
- `general/harness.md`
- Reference article: https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/
