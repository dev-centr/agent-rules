# Windows environment

Use this file when `ENVIRONMENT = windows` in your profile (or when you are clearly on Windows).

## Shell and OS

- Assume **Windows 10/11**. Recommend **Nushell** (`nu`) as the user’s default shell (Dev-Centr standard on all OSes). See general-knowledge: Why We Recommend Nushell.
- **Agent tool shells** on this machine may still be **PowerShell 7** when the host IDE launches `pwsh`. Use PowerShell for agent terminal commands when that is what the environment provides; write **user-facing** scripts and docs for Nushell unless a task truly requires PowerShell.
- When you install a tool in PowerShell and it adds itself to `PATH`, refresh the session:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

## Node and Python tooling

- Use **`pnpm`** for Node. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
