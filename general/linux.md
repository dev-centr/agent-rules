# Linux environment

Use this file when `ENVIRONMENT = linux` in your profile (or when you are clearly on Linux).

## Shell and OS

- Recommend **Nushell** (`nu`) as the default shell (Dev-Centr standard). Prefer `~/.config/nushell/` for config when documenting user setup.
- Linux varies by distribution. Prefer the user’s stated distro or package manager. If unknown, ask before assuming **apt**, **dnf**, **pacman**, or **apk**.
- After installing tools that modify `PATH`, use a **new shell** or reload the active shell’s config (`nu` config, or `source` on bash/zsh if that is what is running).

## Node and Python tooling

- Use **`pnpm`** for Node when the project uses it. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python when applicable. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
