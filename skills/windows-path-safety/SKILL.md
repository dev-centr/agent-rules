---
name: windows-path-safety
description: >-
  Use at the start of every Windows session or conversation before relying on
  CLI probes, or when Windows PATH truncation, User PATH dropped, 2047
  character limit, Explorer PATH bug, WINDOWS_PATH_TRUNCATION, Get-Command
  fails on an installed tool, CLI reported missing on Windows, harness process
  launch PATH repair, or Registry Machine+User PATH check occurs.
---

# Windows PATH truncation safety check

Mandatory on Windows (`ENVIRONMENT = windows`) at the start of every new conversation (unless a verified native harness startup check already repaired the host process) and on process launch in owned harnesses.

Canonical explanation: https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/

## Why conversation-start (not only "new session")

An agent inside a chat cannot reliably tell whether a conversation shares an already-checked host process or started a fresh shell, and many harnesses spawn a fresh subprocess per command (where in-shell `$env:Path` edits do not persist). Treat every new Windows conversation as a session boundary.

## 1. Run the detection check (PowerShell)

Run this once at the start of the conversation (or folded into the first shell command):

```powershell
$proc = $env:Path
$m = [Environment]::GetEnvironmentVariable("Path", "Machine")
$u = [Environment]::GetEnvironmentVariable("Path", "User")
$split = { param([string]$s) $s -split ';' | ForEach-Object { $_.Trim().TrimEnd('\') } | Where-Object { $_ } }
$procSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($p in (& $split $proc)) { [void]$procSet.Add($p) }
$dropped = @(& $split $m) + @(& $split $u) | Where-Object { -not $procSet.Contains($_) } | Select-Object -Unique
[pscustomobject]@{
  ProcessLen = $proc.Length
  MachineLen = $m.Length
  UserLen    = $u.Length
  Dropped    = $dropped.Count
  Over2047   = ($u.Length -gt 2047) -or (($m.Length + 1 + $u.Length) -gt 2047)
}
```

## 2. Act on the result

- **`Dropped > 0` (truncation detected):**
  1. Refresh `$env:Path` from Registry (`Machine + ";" + User`) before invoking user-installed CLIs:
     ```powershell
     $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
     ```
  2. In harnesses where every tool command runs in a fresh subprocess, prepend that refresh to CLI-dependent commands for the rest of the conversation.
  3. Notify the user once (process vs. Registry lengths, dropped count) with a link to https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/.
  4. Record `WINDOWS_PATH_TRUNCATION = detected (process <P> vs Machine <M> + User <U>; <K> entries dropped; checked YYYY-MM-DD)` in machine-local `$CODE_ROOT/harness.md`.
- **`Dropped == 0` and `Over2047 == true`:**
  - Record warning in `$CODE_ROOT/harness.md` (`User` or combined `PATH` > 2,047 chars; at risk of Explorer truncation) and suggest trimming duplicates/missing dirs or using `pathman`.
- **`Dropped == 0` and `Over2047 == false`:**
  - Record `WINDOWS_PATH_TRUNCATION = ok (checked YYYY-MM-DD)` if updating `$CODE_ROOT/harness.md`; proceed normally.

## 3. Owned harnesses (native process-launch repair)

When implementing or maintaining an owned harness (such as `dev-centr/harness`):

1. Run the Registry `HKLM` + `HKCU` check automatically on process launch (expanding `REG_EXPAND_SZ`).
2. Auto-repair the process `PATH` (preserving process-only entries, deduplicating) so all child processes inherit the full `PATH`.
3. Surface the repair — or the error if repair failed — in the app's UI (and `stderr` on CLI runs) with a direct link to https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/.

## Do not

- Declare a CLI missing or re-install a tool before checking expanded Registry `Machine` + `User` `PATH`.
- Use `setx` to edit `PATH` (silently truncates at 1,024 chars).
- Silently hide a detected truncation in an owned harness UI.
