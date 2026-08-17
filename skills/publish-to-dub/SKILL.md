---
name: publish-to-dub
description: >-
  Register and manage D packages on the DUB registry (code.dlang.org) with
  dubx and dub-publish. Use when the user says "publish to dub", "publish to
  dlang", "publish dlang", register a D package, or asks to publish to the DUB
  registry. Official dub has no publish command.
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
- [ ] Owner extras: docs-url, categories (max 4), logo, hooks
- [ ] SemVer tags pushed; update to refresh
```

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

## 4. Versions

New versions appear when **SemVer tags** (`v1.2.3`) are pushed. The registry polls ~twice an hour. Queue an immediate refresh:

```powershell
dubx update -n <pkg>
# or with webhook secret:
dubx update -n <pkg> --secret <secret>
```

Do not invent tags. If the user asked only to register, skip tagging unless they also asked to ship a version.

## 5. Owner settings (first publish)

Ask when unclear; do not rotate secrets unprompted.

```powershell
dubx docs-url -n <pkg> --docs-url https://...
dubx categories -n <pkg> --category library.development --category library.network
dubx logo -n <pkg> --logo-file path/to/logo.png
dubx hooks -n <pkg>              # status only — safe
dubx hooks get -n <pkg>          # enable if unset; reuse local secret; print URLs
```

- Categories: **max 4** dotted ids. See [reference.md](reference.md).
- `hooks get` does **not** rotate an existing secret. `hooks regenerate --yes` invalidates forge URLs — only when the user asks.
- `remove --yes` is owner delete — only when the user asks.

## 6. Report

- Package: `https://code.dlang.org/packages/<name>`
- What ran (register vs tag vs metadata)
- If versions are empty: waiting on SemVer tags + poll/`update`

## Do not

- `dub publish` / `dub submit`
- `-p` / `--password` / `--prompt-password` in agent terminals
- `hooks regenerate` or `remove` unless explicitly requested
- A second public Antora site on GitHub Pages for docs URL — use the **org docs hub**

Command map and category ids: [reference.md](reference.md).
