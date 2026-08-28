# Optional: Bitwarden CLI session persistence

<!---
OPTIONAL WORKSTATION PATTERN — not default. Enable only on machines where the
operator accepts local storage of BW_SESSION for agent convenience.
Personal implementation: skill `bitwarden-unlock` (AMDphreak fork and downstream overlays).
--->

## When to use

Choose this when:

- Agents run `bw list`, `bw get`, or similar often on **one workstation**
- The operator wants to **avoid re-entering the master password** every shell
- Secrets stay **machine-local** (never git, never synced User Rules, never chat)

Do **not** enable by default for org members, shared CI, or laptops without disk encryption.

## What `BW_SESSION` is

`bw unlock` returns a **vault decrypt session key** (`BW_SESSION`). It is **not** the master password and **not** the API key (`BW_CLIENTID` / `BW_CLIENTSECRET` from `bw login --apikey`).

Per Bitwarden CLI docs, the session key stays valid until `bw lock` or `bw logout` — there is no built-in CLI timeout (unlike desktop app auto-lock).

## Suggested local storage (Windows)

| Store | Path / name | Notes |
| --- | --- | --- |
| User env | `BW_SESSION` | Hydrates new shells |
| DPAPI file | `%USERPROFILE%\.bw-session.dpapi` | CurrentUser protected blob |
| Agent entry | `%USERPROFILE%\ensure_bw_unlocked.ps1` | Restore, unlock if needed, persist |

Never commit live session material. Agents dot-source scripts by path; never `Read` secret files.

## Agent rules (machine-local)

When enabled, stamp in `$HARNESS`:

```text
BITWARDEN_SESSION_PERSIST = enabled
BITWARDEN_AGENT_ENTRY = ensure_bw_unlocked.ps1
```

Add an always-on IDE overlay (example: `bitwarden-unlock.mdc`) and a `$MACHINE` block pointing agents at `ensure_bw_unlocked.ps1`.

## Enable on a machine

1. Install skill `bitwarden-unlock` (or copy scripts from its `scripts/` folder to the user profile).
2. Copy templates to `%USERPROFILE%`: `ensure_bw_unlocked.ps1`, `bw_session_store.ps1`, unlock/login helpers.
3. Optional: personal API key in `bw-apikey.local.ps1` for non-interactive login.
4. User unlocks once; `persist_bw_session.ps1` or `ensure_bw_unlocked.ps1` saves the session locally.
5. Set harness + machine overlays so agents **always** call `ensure_bw_unlocked.ps1` first.

## AI safety (required)

- Never print, log, or copy `BW_SESSION`, `BW_CLIENTSECRET`, or DPAPI/session files into chat or git.
- Capture `bw status` JSON only (`status`, `userEmail`).
- Clear on demand: `bw lock` or `Clear-BwSessionLocal` (when using the reference scripts).

## Docs hub

Antora how-to (figures, nav, cross-links):

* https://docs.devcentr.org/agent-rules/bitwarden-cli-agents.html (source: `docs/modules/ROOT/pages/bitwarden-cli-agents.adoc`)

Sibling for Google Cloud SDK: `docs/modules/ROOT/pages/gcloud-cli-agents.adoc`.

## Reference implementation

Personal skill **`bitwarden-unlock`** — scripts under `skills/bitwarden-unlock/scripts/` (personal fork until catalogued). Upstream org repos do **not** ship live credentials or enable this by default.

Link by **path** (`blob/main/skills/bitwarden-unlock/SKILL.md`), not `#L…` line anchors.
