---
name: session-router
description: >-
  Use when a harness MCP or CLI is missing a feature, session router,
  hack profile, removed-features.md, profiles/<app>/<version>.json,
  prompt an existing desktop chat, inherit the previous hack, commits
  between releases, fork the catalog and open a pull request, repair-needed,
  worst-case state database, --worst-case --i-understand, polyglot MCP CLI wrapper.
---

# Session router

The catalog is `dev-centr/session-router`, file `removed-features.md`. Read it before choosing a door. Do not copy a hack into this skill. The next run reads the catalog again.

## Loop

1. Run `dub run --compiler=ldc2 -- resolve --app <app> --version <release> --operation <name>` from that repo. Pass `--compiler=ldc2` when DMD is not on `PATH`.
2. Use the first door it prints.
   - `mcp`: call the harness MCP tool it names. Do not add a second copy on the polyglot MCP.
   - `cli`: the polyglot MCP may wrap that command, and only that command.
   - `hack`: follow the signal in the profile for that release.
   - `worst_case`: stop and offer. Include the warning the command printed, in full. Wait for a yes before `--worst-case --i-understand`. Never point `--db` at the live Cursor `state.vscdb` without that yes.
3. A version with no profile, or a build of commits between releases, sets `inherited=true` and prints the repair checklist. Try that profile.
4. If the inherited profile fails or needs a fix, fork `dev-centr/session-router` (not the harness), patch `profiles/<app>/<version>.json`, and open a pull request upstream. Name the app, the version that failed, the older profile, and the change. `session-router repair-needed` prints that checklist.

## Self-update

The pull request is the self-update. After it merges, the next resolve reads the new profile. Do not record the patched hack only in the chat.
