# Environment and preferences

<!---
ENVIRONMENT RULES MANIFEST — cross-platform expectations before OS-specific layers.
Read one of `general/windows.md`, `general/mac.md`, or `general/linux.md` after this file (see `ENVIRONMENT` in your `profiles/*.md`).
--->

## Principles

- Prefer **one** OS-specific file (`general/windows.md`, `general/mac.md`, or `general/linux.md`) chosen by the `ENVIRONMENT` constant in your profile. Do not mix OS assumptions without reading the matching file.
- Prefer **package-manager defaults** for the stack you use (Node, Python, and so on); the OS files spell out common choices.
- **Node install location:** never bare `pnpm add` / `npm install` from the user home directory (creates accidental `package.json` + `node_modules`). CLIs → `pnpm add -g`; one-offs → `pnpm dlx`; project deps → install inside that project. Detail: `general/node-cli-install.md`.
- Use **MCPs** to interact with repositories when available. If no MCP or the operation is unsupported, use **`gh`** and **`glab`** when appropriate. If those are unavailable, try to install them or tell the user.

## Local Git strategies

- Clone git repositories using `general/folder-schema.md` with root set to the `CODE_ROOT` constant from your active `profiles/*.md` file.
- Before bulk clone or dedupe: verify GitHub `fork` flag; skill `hive-layout`.
- Prefer **AsciiDoc** for README and project docs unless Markdown is explicitly requested for a host (for example npm).
- Do not rename `README.md` files that are made for package hosts like npm.
