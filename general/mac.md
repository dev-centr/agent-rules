# macOS environment

Use this file when `ENVIRONMENT = mac` in your profile (or when you are clearly on macOS).

## Shell and OS

- Assume a modern **macOS** release and **zsh** (default) unless the user specifies **bash** or another shell.
- After installing tools that modify your shell environment, **open a new terminal** or `source` the relevant profile file so `PATH` updates apply.

## Node and Python tooling

- Use **`pnpm`** for Node when the project uses it. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python when applicable. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
