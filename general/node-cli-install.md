# Node CLI and package install location

<!---
NODE CLI INSTALL — where agents may put npm/pnpm packages.
Prevents accidental home-directory projects (package.json + node_modules).
--->

## Rule

Never run a bare `pnpm add` / `npm install` / `yarn add` from the **user home directory** (or any non-project cwd that lacks an intentional `package.json`). That creates a fake project (`package.json`, lockfile, `node_modules`) in the home folder — not a global install.

| Intent | Do this |
| --- | --- |
| CLI available everywhere | `pnpm add -g <pkg>` (or `npm install -g <pkg>` if the machine is npm-global) |
| One-off / no install | `pnpm dlx <pkg> …` |
| Dependency of a real app/lib | `cd` into that project (or `move_agent_to_root` first), then `pnpm add <pkg>` |
| Project binary already listed | `pnpm exec <bin>` from that project |

## Why this bites agents

From home, package managers treat cwd as the project root. Forgetting `-g` looks like a successful install (`pnpm list` / `npm list` show packages) but leaves `~/package.json`, `~/pnpm-lock.yaml` (or `package-lock.json`), and `~/node_modules`. That is **not** the pnpm store and **not** the npm global prefix.

## Cleanup if it already happened

If home has an accidental `package.json` + `node_modules` from agent work:

1. Confirm it is not a deliberate scratch project the user wants.
2. Remove `node_modules`, `package.json`, and the matching lockfile from home only.
3. Leave user config alone (`.npmrc`, global store, Playwright browser cache under the OS app-data path).
4. Reinstall with `-g` or inside a real project if the tools are still needed.

## Related

- OS Node defaults: `general/windows.md`, `general/mac.md`, `general/linux.md`
- Environment layer: `general/environment.md`
