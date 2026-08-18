---
name: publish-to-dub
description: >-
  Use when the user says "publish to dub", "publish to dlang", "publish
  dlang", register a D package, DUB categories, code.dlang.org categories,
  dubx categories, dub-publish, or asks to publish to the DUB registry.
  Official dub has no publish command.
---
# Publish to DUB (code.dlang.org)

Official `dub` has **no** `publish` / `submit` command (`dlang/dub#3139` is the upstream proposal). Do **not** run `dub publish`.

| Tool | Role |
| --- | --- |
| **dubx** | Front door. Registry verbs → `dub-publish`; builds → redub (fallback `dub`). |
| **dub-publish** | Owner CLI: login, register, update, logo, docs URL, categories, hooks. |

Prefer `dubx <verb>` when `dubx` is on `PATH`. Same verbs work as `dub-publish <verb>` or `dubx publish <verb>`.

`dubx publish --ignore-fork` is **wrong** (forwards flags with no command). Use `dubx register --ignore-fork` or `dubx publish register --ignore-fork`.

## Checklist

```
- [ ] Package root (dub.sdl / dub.json) + origin URL
- [ ] dubx and/or dub-publish on PATH
- [ ] Credentials saved (never -p)
- [ ] Dry-run register
- [ ] Register (idempotent)
- [ ] status -n <pkg>
- [ ] Categories (required): pick 1–4 ids, POST, verify JSON
- [ ] Other extras: docs-url, logo, hooks
- [ ] SemVer tags pushed; update to refresh
```

**Categories are not optional.** Register (or any later publish/audit) is incomplete until the package has 1–4 taxonomy ids on the registry. Infer them, `dubx categories` immediately, then verify. Do not leave the slot empty for the user to fill in the web UI.

## 1. Tools

Refresh PATH, then:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
dubx which
# or: Get-Command dubx, dub-publish
```

Install dirs: `%LOCALAPPDATA%\Programs\dlang-supplemental\dubx` and `...\dub-publish`. Releases: [dubx](https://github.com/dlang-supplemental/dubx/releases), [dub-publish](https://github.com/dlang-supplemental/dub-publish/releases). Run `install.ps1` from the zip, then refresh PATH.

If only `dub-publish` is installed, use it directly.

## 2. Auth (no passwords on argv)

Never `-p` / `--password` (shell history + process list). Never commit `credentials.v1`, `password.incoming`, `cookies.txt`, or `hooks/*.secret`.

Config dir: `%LOCALAPPDATA%\dlang-supplemental\dub-publish\` (Unix: `~/.dlang-supplemental/dub-publish/`).

If `credentials.v1` is missing, **stop** and have the user drop the registry password:

```powershell
$dir = Join-Path $env:LOCALAPPDATA "dlang-supplemental\dub-publish"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Set-Content -Path (Join-Path $dir "password.incoming") -Value "<password>"
dubx login --user <name> --save-credentials
```

`--save-credentials` verifies, writes DPAPI `credentials.v1`, **deletes** `password.incoming`. Later commands reuse the store (no password flags). CI uses `DUB_REGISTRY_USER` / `DUB_REGISTRY_PASSWORD` secrets — not the local store.

If the user pasted a password in chat, write the drop file; do not put it on the command line.

## 3. Register

From the package repo (default URL = `git remote get-url origin`; name from recipe):

```powershell
dubx register --dry-run
dubx register
# fork checkout or registry rejects a fork:
dubx register --ignore-fork
dubx status -n <pkg>
```

Register **links the Git repo**. It is idempotent: already registered → treat as success and refresh. It does **not** upload a tarball or create a version.

Then go straight to **§5 Categories** — do not stop at `status`.

## 4. Versions

New versions appear when **SemVer tags** (`v1.2.3`) are pushed. The registry polls ~twice an hour. Queue an immediate refresh:

```powershell
dubx update -n <pkg>
# or with webhook secret:
dubx update -n <pkg> --secret <secret>
```

Do not invent tags. If the user asked only to register, skip tagging unless they also asked to ship a version. Still set categories.

## 5. Categories (required — always POST)

Do this on **every** register, republish, or category audit. The web form is not a substitute.

1. Read current (empty array if unset):

   ```powershell
   (Invoke-RestMethod "https://code.dlang.org/packages/<pkg>.json").categories
   ```

2. Choose **1–4** most specific dotted ids from [reference.md](reference.md) using `targetType`, description, and README. Do **not** also list ancestors (search matches prefixes). Ask the user only when two siblings are equally plausible.

3. **Push** to the registry (this is the owner POST — not a git push, not `dubx update`):

   ```powershell
   dubx categories -n <pkg> --category library.development --category application.desktop.development
   ```

   Repeat `--category` for each id. The CLI requires at least one; empty means you skipped the job.

4. Verify the JSON from step 1 matches what you sent. If it does not, fix and POST again.

If the live set is already correct, skip the POST and say so. If it is empty, stale, or wrong (e.g. `library.gui` on a TUI, `library.std_aspirant` on a binding), overwrite.

Typical picks: CLI/tooling → `library.development` + `application.desktop.development` (or a more specific child). Binding → `library.binding`. TUI → `library.tui` (never `library.gui`). GUI → `library.gui`. BetterC → `library.betterc`.

## 6. Other owner settings

Ask when unclear; do not rotate secrets unprompted.

```powershell
dubx docs-url -n <pkg> --docs-url https://...
dubx logo -n <pkg> --logo-file path/to/logo.png
dubx hooks -n <pkg>              # status only — safe
dubx hooks get -n <pkg>          # enable if unset; reuse local secret; print URLs
```

- `hooks get` does **not** rotate an existing secret. `hooks regenerate --yes` invalidates forge URLs — only when the user asks.
- `remove --yes` is owner delete — only when the user asks.

## 7. Report

- Package: `https://code.dlang.org/packages/<name>`
- Categories that landed (ids, not only “set”)
- What else ran (register vs tag vs docs/logo/hooks)
- If versions are empty: waiting on SemVer tags + poll/`update`

## Do not

- `dub publish` / `dub submit`
- `-p` / `--password` / `--prompt-password` in agent terminals
- Skip categories, or tell the user to pick them on code.dlang.org
- `hooks regenerate` or `remove` unless explicitly requested
- A second public Antora site on GitHub Pages for docs URL — use the **org docs hub**

Command map and category ids: [reference.md](reference.md).
