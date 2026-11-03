---
name: secret-pipe
description: >-
  Use when an agent must create, mint, roll, rotate, copy, or move an API
  token, key, password, or secret between a vault (Bitwarden, bw), a provider
  API (Cloudflare tokens), and a destination (gh secret set, GitHub Actions
  secrets, Vercel, Netlify env); "set the secret", "add a repo secret",
  "rotate the token", "store it in Bitwarden"; when a secret value must not
  appear in chat, terminal output, logs, or files; when the harness has no
  built-in secrets manager.
---

# Secret pipe: move secrets without seeing them

Goal: the secret value lives only in a shell variable or a pipe on the user's machine. The agent sees only metadata: ids, names, booleans, and exit codes.

## Hard rules

- Never print, echo, log, or return a secret value. Print only `[bool]$x`, ids, names, exit codes, and equality checks (`$a -eq $b`).
- Never write a secret to a file: not in a repo, temp, or scratch. Use pipes and in-memory variables only.
- Never ask the user to paste a secret into chat.
- Use the narrowest credential that does the job. A broad key (for example a Cloudflare Global API Key) may only *mint* a scoped token. It is never the deployed secret.
- Mint one dedicated token per consumer unless the user says otherwise.
- If the harness has its own secret-ingest mechanism, use it instead.
- Secret *files* found on disk are a different job. Quarantine them per `general/agent-workspace-migrate.md` (`scratch/.../quarantine-secrets/`). Never display them.

## One script run

A minted value exists only in that process. If the run is split, interrupted, or fails midway, the value is lost and has to be rolled again.

1. Wrap everything in `try { ... } finally { Remove-Variable <vars> }` (bash: `unset` in a `trap`).
2. Refresh the vault first (`bw sync`).
3. Read the minting credential from the vault into a variable.
4. Create or roll the token through the provider API. Parse the value from the JSON response straight into a variable (Cloudflare: `POST /user/tokens` returns `result.value`; `PUT /user/tokens/{id}/value` returns `result`).
5. Set the destination by piping, for example `$tok | gh secret set NAME -R owner/repo` (gh reads stdin).
6. Store a copy in the vault as a hidden field (type 1) via `bw encode | bw edit item <id>`, then run `bw sync`.
7. Verify without revealing anything. Re-read the vault field and print `matches: $($chk.value -eq $tok)`, then make one authenticated call with the new token that prints only a resource name.
8. Keep it short, and tell the user not to interrupt. If the run is interrupted, roll again and redo every step in one run.

## Gotchas

- In Windows PowerShell 5, `ConvertFrom-Json` on `bw list items` can return one object whose properties are arrays. Use `bw get item <id>`.
- `bw edit item` takes the encoded JSON as an argument or on stdin. Check the exit code.
- The vault must already be unlocked (`BW_SESSION`). The agent never types the master password.
- Cloudflare Pages deploys need the `Pages Write` permission group, scoped to `com.cloudflare.api.account.<account_id>`.
- After setting the destination, re-run the consumer (for example `gh workflow run`) and confirm it is green.

## Report

Report the token's id or name and scope, where it is stored (secret name, vault item, field name), the verification results, and any old token the user may want to revoke.
