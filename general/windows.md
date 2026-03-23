# Windows environment

Use this file when `ENVIRONMENT = windows` in your profile (or when you are clearly on Windows).

## Shell and OS

- Assume **Windows 10/11** and **PowerShell 7** unless the user says otherwise.
- When you install a tool in PowerShell and it adds itself to `PATH`, refresh the session:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

## Node and Python tooling

- Use **`pnpm`** for Node. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
