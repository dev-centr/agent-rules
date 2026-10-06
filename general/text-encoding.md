# Text encoding: never double-encode UTF-8

**Rule:** never rewrite a text file through a path that guesses the encoding. On Windows that means: do **not** use Windows PowerShell 5.1 `Get-Content` / `Set-Content` / `Out-File` / `Add-Content` / `>` redirection on text files unless you pass an explicit UTF-8 (no BOM) encoding. Prefer the harness file-edit tools, PowerShell 7 (`pwsh`, UTF-8 by default), Node/Python with explicit `utf8`, or .NET with `UTF8Encoding($false)`. Check for mojibake before every commit.

## Why (the failure we keep seeing)

Agent terminals on Windows are often **Windows PowerShell 5.1** (`powershell.exe`), not PowerShell 7, and the console code page is usually IBM437. In 5.1:

- `Get-Content` reads a UTF-8 file **without a BOM** as the ANSI code page (Windows-1252).
- `Set-Content` / `Out-File` then write those wrong characters back, as ANSI or as UTF-16 / UTF-8-with-BOM depending on the cmdlet.

Every non-ASCII character is turned into two to four junk characters. The damage survives commits and spreads when the next agent copies the text.

| Intended | Bytes (UTF-8) | Read as Windows-1252 | Read as IBM437 (console) |
| --- | --- | --- | --- |
| `—` em dash | `E2 80 94` | `â€”` <!-- mojibake-guard: allow --> | `ΓÇö` <!-- mojibake-guard: allow --> |
| `’` apostrophe | `E2 80 99` | `â€™` <!-- mojibake-guard: allow --> | `ΓÇÖ` <!-- mojibake-guard: allow --> |
| `→` arrow | `E2 86 92` | `â†’` <!-- mojibake-guard: allow --> | `ΓåÆ` <!-- mojibake-guard: allow --> |
| `é` | `C3 A9` | `Ã©` <!-- mojibake-guard: allow --> | `├⌐` <!-- mojibake-guard: allow --> |
| `×` | `C3 97` | `Ã—` <!-- mojibake-guard: allow --> | `├ù` <!-- mojibake-guard: allow --> |

Real incidents: InstaLay `release.yml` (GitHub rejected the workflow file), InstaLay `CHANGELOG.adoc`, and UI strings such as a multiplication sign rendered as `Ã—` <!-- mojibake-guard: allow --> in a Flutter screen. Git history cannot tell which agent did it because every agent commits under the user's name, so the fix has to be a guard, not blame.

## Safe ways to edit text

| Need | Use |
| --- | --- |
| Edit a file | The harness file-edit / write tool (writes UTF-8). |
| Script on Windows | `pwsh` 7, or in 5.1: `[IO.File]::ReadAllText($p, [Text.UTF8Encoding]::new($false))` and `[IO.File]::WriteAllText($p, $text, [Text.UTF8Encoding]::new($false))`. |
| 5.1 cmdlets you cannot avoid | `Get-Content -Raw -Encoding UTF8` (reads fine) and **write with .NET** as above; 5.1's `-Encoding UTF8` on write adds a BOM. |
| Node / Python | `fs.readFileSync(p, "utf8")` / `open(p, encoding="utf-8")`, and the same on write. |
| Never | `(Get-Content f) -replace ... | Set-Content f` with no `-Encoding`; `>` / `>>` redirection into tracked text files in 5.1. |

Console output in 5.1 is also lossy: non-ASCII printed to the terminal may show as `?` or junk even when the file is fine. Do not "fix" a file because the terminal showed garbage; verify with the guard (it prints escapes such as `\u{2014}`).

## The guard (`tools/encoding-guard`)

`tools/encoding-guard/check-mojibake.mjs` is a dependency-free Node script. It flags a run of characters only when mapping it back to Windows-1252 or IBM437 bytes yields exactly one valid UTF-8 character in a plausible range, so normal accented text, box-drawing art and currency signs pass. `--fix` applies only that verified round-trip (repeating for text that was double-encoded twice, including Windows-1252 over IBM437). Files that are not valid UTF-8 at all (PowerShell 5.1 `Set-Content` wrote them in the ANSI code page, e.g. a lone `0x97` byte for an em dash) also fail; `--fix` re-decodes those bytes as Windows-1252 when every byte is defined there. `U+FFFD` replacement characters and undefined bytes are reported but never auto-fixed: the original characters are gone, so recover them from git history or context.

```text
node tools/encoding-guard/check-mojibake.mjs            # all tracked files
node tools/encoding-guard/check-mojibake.mjs --staged   # what you are about to commit
node tools/encoding-guard/check-mojibake.mjs --fix docs # repair in place
```

Layers, strongest first:

1. **Machine-wide pre-commit hook.** `node tools/encoding-guard/install-global-hooks.mjs` sets `git config --global core.hooksPath` to `tools/encoding-guard/hooks`. The dispatcher runs the check on staged content, then chains to the repo's own `.git/hooks/<name>` (lefthook, pre-commit, git-lfs, husky v4 live there) and to any global hooks path that existed before (`encodingguard.previousHooksPath`). Bypass once with `git commit --no-verify`; skip only the encoding check with `ENCODING_GUARD=0`. Limitation: a repo whose **local** config sets `core.hooksPath` (husky v9) overrides the global value; `--status --scan <dir>` lists those.
2. **CI backstop.** Reusable workflow `dev-centr/agent-rules/.github/workflows/encoding-guard.yml` (`workflow_call`). Each repo carries only a thin caller, `.github/workflows/encoding-guard.yml`:

   ```yaml
   name: Encoding guard
   on:
     push:
       branches: [main]
     pull_request:
   jobs:
     encoding:
       uses: dev-centr/agent-rules/.github/workflows/encoding-guard.yml@main
   ```

3. **Editor hint.** `.editorconfig` with `charset = utf-8` under `[*]`.

## Intentional examples

Docs that teach about mojibake (like this file) and test fixtures need the bad sequences. Opt out narrowly:

- end the line with `mojibake-guard: allow` (in a comment for the file's syntax), or
- put `mojibake-guard: allow-file` in the first 10 lines, or
- list globs in `.encoding-allow` at the repo root (one per line, `#` comments; same glob style as `.gitignore`).

Nothing is exempt by file type except binaries, lockfiles, `*.min.*` and source maps; `.txt` is checked.

## New repositories

- The global hook covers every repo on a machine where it is installed; nothing to add per repo.
- Add the thin caller workflow above (copy from any owned repo, or start from a template repo that already has it).
- Org-level rulesets that *require* the workflow need GitHub Team or Enterprise. All owned orgs were on the Free plan as of 2026-10; revisit if an org upgrades (Settings, Rules, Rulesets, "Require workflows to pass").
- New machine: clone `agent-rules`, run `install-global-hooks.mjs`, and record it in `$HARNESS` (`ENCODING_GUARD`).

## Agent checklist before commit

1. Edited text with a UTF-8-safe method (table above).
2. `node $AGENT_RULES_PATH/tools/encoding-guard/check-mojibake.mjs --staged` passes (the global hook does this automatically).
3. If it fails: `--fix` the listed files, review the diff, re-stage. Never re-save the garbled glyphs "as UTF-8" by hand.

Related: skill `fix-docs-encoding` (Antora SVG/AsciiDoc repair), `general/windows.md`.
