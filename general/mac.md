# macOS environment

Use this file when `ENVIRONMENT = mac` in your profile (or when you are clearly on macOS).

## Shell and OS

- Assume a modern **macOS** release. Recommend **Nushell** (`nu`) as the default shell (Dev-Centr standard), not zsh, for user-facing workflows—unless the user explicitly wants zsh/bash for a task.
- After installing tools that modify your shell environment, **open a new terminal** or reload config so `PATH` updates apply.

## Node and Python tooling

- Use **`pnpm`** for Node when the project uses it. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python when applicable. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
