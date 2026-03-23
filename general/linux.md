# Linux environment

Use this file when `ENVIRONMENT = linux` in your profile (or when you are clearly on Linux).

## Shell and OS

- Linux varies by distribution. Prefer the user’s stated distro or package manager. If unknown, ask before assuming **apt**, **dnf**, **pacman**, or **apk**.
- After installing tools that modify `PATH`, use a **new shell** or `source` the appropriate profile (`~/.bashrc`, `~/.zshrc`, and so on).

## Node and Python tooling

- Use **`pnpm`** for Node when the project uses it. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python when applicable. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
