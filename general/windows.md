# Windows environment

Use this file when `ENVIRONMENT = windows` in your profile (or when you are clearly on Windows).

## Shell and OS

- Assume **Windows 10/11**. Recommend **Nushell** (`nu`) as the user’s default shell (Dev-Centr standard on all OSes). See general-knowledge: Why We Recommend Nushell.
- **Agent tool shells** on this machine may still be **PowerShell 7** when the host IDE launches `pwsh`. Use PowerShell for agent terminal commands when that is what the environment provides; write **user-facing** scripts and docs for Nushell unless a task truly requires PowerShell.
- Agent terminals are often **Windows PowerShell 5.1** (`powershell.exe`, console code page 437), not 7. In 5.1, `Get-Content` reads BOM-less UTF-8 as ANSI and `Set-Content` / `Out-File` / `>` write it back, double-encoding every non-ASCII character (an em dash becomes three junk characters). Never rewrite text files that way; use the file-edit tool, `pwsh`, or `[IO.File]::WriteAllText($p, $t, [Text.UTF8Encoding]::new($false))`. Detail and guard: `general/text-encoding.md`.
- **Profile paths:** use `$env:USERPROFILE` or `[Environment]::GetFolderPath('UserProfile')`. Cmd-style `%userprofile%` is **not** expanded in PowerShell and creates a literal `%userprofile%` folder under the profile if used as a path segment.
- **Agent workspace:** canonical `%LOCALAPPDATA%\AgentWorkspace`; optional junction `%USERPROFILE%\AgentWorkspace` (`AGENT_WORKSPACE_LINK`). Record workspace, link, temp, utilities in `$HARNESS`; detail `general/agent-workspace.md` + `general/agent-temp.md`.
- When you install a tool in PowerShell and it adds itself to `PATH`, refresh the session:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

- **Windows `PATH` truncation / corruption check (mandatory at session/conversation start):** Windows Explorer and legacy process launchers can silently truncate or drop the entire `User` `PATH` when `PATH` exceeds ~2,047 characters. Do **not** wait for a CLI lookup to fail: at the start of every new Windows conversation (and before concluding any tool such as `git-ai`, `uv`, `rg`, `nu`, `dub`, or `pnpm` is missing), run skill **`windows-path-safety`** (`general/windows-path-safety.md`) to compare process `$env:Path` against Registry `Machine` + `User` `PATH`, refresh `$env:Path` when truncated, report once with https://docs.devcentr.org/general-knowledge/reference/windows-path-truncation/, and record the state in `$HARNESS` / `$MACHINE`. Owned harnesses (such as `dev-centr/harness`) must check and auto-repair natively on process launch and report the fix or error in the app UI with that link.

## Node and Python tooling

- Use **`pnpm`** for Node. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`. Global CLIs: `pnpm add -g`. Never bare `pnpm add` / `npm install` from the user profile home — detail: `general/node-cli-install.md`.
- Use **`uv`** instead of `pip` for Python. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
