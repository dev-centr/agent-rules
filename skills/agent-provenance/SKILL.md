---
name: agent-provenance
description: >-
  Use before agent file edits, writes, patches, shell-generated changes, or commits;
  when bootstrapping Git AI, git-ai, agent-v1, install-hooks, AI blame,
  refs/notes/ai, user/harness/model attribution, unknown models or new harnesses,
  mixed-agent sessions, provenance trailers, or unsupported coding agents arise.
---

# Agent provenance

Keep logical commits; do not split features by model. Git AI checkpoints provide
line-level provenance between commits. Existing human author/signing and harness
co-author rules stay unchanged: provenance is metadata, not a cryptographic signature.

## Identity and trust

Git AI's `agent_id` has separate `tool` (harness), `model`, and `id` (session)
fields. The term **agent** groups them; `human_author` is separate. Check the
normal Git identity with `git var GIT_AUTHOR_IDENT`; never change git config or
invent the directing human. Inspect the resulting note's `human_author` after a
verification commit; missing/wrong identity is a reported gap, not guessed data.

- Harness: stable lowercase slug, e.g. `grok-bot`; not a model name. If the
  harness is genuinely unknown, use `unknown` and record the limitation.
- Model: exact identifier explicitly exposed by the harness, otherwise `unknown`.
  Never infer it from branding, task type, or an earlier session. Respect harness
  identity/disclosure policy; an unavailable identifier remains `unknown`.
- Session: actual conversation ID; if unavailable, generate one UUID once and
  retain it for that session (not per edit, file, commit, or tool call).
- Each subagent records its own harness/model/session. Record changes of model
  at the next checkpoint; do not attribute an entire mixed-model run to its closer.
  Verify model switching with the installed release: if it collapses models into
  one session record, report that limitation rather than claim exact attribution.
- Human edits need no manual calls. **Unattributed is unknown/untracked, not proof
  of human authorship.** Known human attribution and missing instrumentation are
  different; never relabel missing AI checkpoints as human work.

## Detect and bootstrap

Before the first edit, detect `git-ai` on PATH (`Get-Command git-ai` or
`command -v git-ai`), then `git ai --version`. Missing during ordinary work:
report provenance unavailable; do not silently install. During authorized machine
bootstrap, use `harness-setup` and the upstream installer (review organizational
software/security policy first):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://usegitai.com/install.ps1 | iex"
```

```bash
curl -sSL https://usegitai.com/install.sh | bash
```

Refresh PATH/restart the agent when required. Run `git ai install-hooks` for
supported harnesses. These are **agent integration hooks**, not Git hooks;
current Git AI manages/checks them daily and does not require wrapping Git.
Preserve other hook systems, especially the encoding guard. Do not install a
Git wrapper or overwrite `core.hooksPath` based on older CLI documentation.

Record actual version, PATH availability, integration mode (`native`, `agent-v1`,
`unavailable`), stable harness slug, verification outcome, and notes-sharing policy
in machine-local `$CODE_ROOT/harness.md`; use `tool-inventory` for the installation
record in `machine.md`. Never claim installation from documentation alone.

## Native integrations first

Check the installed version and current upstream support table, not a frozen
allow-list. Examples include Cursor, Claude Code, Codex, Copilot, OpenCode, Pi,
Windsurf, Droid, Amp, Gemini, Continue, Junie, Rovo Dev, and Firebender. Background
agents have separate integration paths; do not launch them without authorization.
Grok Bot currently needs the generic path. A future harness is not native just
because its model is supported elsewhere.

Run `git ai install-hooks`, inspect its result, and restart if needed. Verify in
a disposable repository under agent scratch: make an edit **through the actual
harness**, manually change one line, commit, and inspect `git ai blame <file>` and
`git log --show-notes=ai`. Confirm harness, model and directing human. An optional
`mock_ai` smoke test proves the binary works, **not** native hook wiring. Do not
also wrap native edits with generic checkpoints (double counting). If native
wiring fails, report it and deliberately select one generic integration instead.

## Unsupported or future harness: self-register locally

No central registration or Git AI source patch is needed. Instrument the edit
loop with `agent-v1`; arbitrary harness slugs/model IDs remain data. A durable
before/after tool adapter is preferable to relying on the agent's memory. Rules
alone are best-effort, not a guarantee that every write was captured.

1. Run from inside the target repository (prefer its root/worktree).
2. Before **each** write/patch/script, checkpoint `type: human`,
   `repo_working_dir`, and `will_edit_filepaths`.
3. Perform only those edits; immediately checkpoint `type: ai_agent`, same repo,
   `agent_name`, `model`, `conversation_id`, `edited_filepaths`, and `transcript`.
4. Include the **full available session** each time, with `user`, `assistant`, and
   `tool_use` messages only; no tool results. Use harness-provided message objects,
   not fabricated transcripts. Remove private values/secrets before passing them.
   If session access is unavailable, report incomplete integration; do not claim
   compliance by sending an empty or invented conversation.
5. Checkpoint partial writes even if the editing tool fails; stop on checkpoint
   errors and investigate instead of letting an attribution gap grow.

Ready examples: [PowerShell](checkpoint.ps1) (5.1 and 7, dot-source it) and
[Bash](checkpoint.bash) (source it). They need neither jq nor Node. PowerShell
constructs JSON with `ConvertTo-Json` and explicitly sets native stdin/output
encoding to UTF-8, restoring it afterward. Write files with `UTF8Encoding($false)`;
never default `Set-Content`, `Out-File`, or `>` on Windows PowerShell 5.1.

```powershell
. "$AGENT_RULES_PATH/skills/agent-provenance/checkpoint.ps1"
# Retain $sessionId for the whole session; $messages is the sanitized real session.
if (-not $sessionId) { $sessionId = [guid]::NewGuid().ToString() }
Invoke-GitAiEdit -Repo (Get-Location).Path -Harness 'grok-bot' -Model 'unknown' `
  -ConversationId $sessionId -Messages $messages -Paths @('src/example.txt') -Edit {
    [IO.File]::WriteAllText((Join-Path (Get-Location) 'src/example.txt'),
      "example`n", (New-Object Text.UTF8Encoding($false)))
  }
```

```bash
source "$AGENT_RULES_PATH/skills/agent-provenance/checkpoint.bash"
# Set GIT_AI_SESSION once from the real conversation ID or a retained generated UUID.
# GIT_AI_TRANSCRIPT_JSON is {"messages":[...]} from the harness's JSON serializer.
# No shell evaluation of transcript content; it is data.
git_ai_edit "$PWD" grok-bot unknown "$GIT_AI_SESSION" \
  "$GIT_AI_TRANSCRIPT_JSON" src/example.txt -- \
  bash -c 'printf "%s\n" example > src/example.txt'
```

Paths are repo-relative or absolute in that repo; include creates, deletions,
renames and generated files. Do not batch unrelated agents' simultaneous edits
under one identity. Serialize overlapping writers. For multi-repo scripts, split
into one command/checkpoint pair per repo with cwd inside that repo. Setting only
`repo_working_dir` while executing a cross-repo shell from elsewhere is not enough.

## Commit, inspect and share

Use `git-commit`; preserve logical staging (including partial staging). Git AI
consolidates checkpoints into notes at `refs/notes/ai`; never clear its working
log manually. Inspect `git log --show-notes=ai`, `git ai blame <file>`, and
`git ai stats <commit> --json`. Notes may appear asynchronously after the commit;
wait for actual data before declaring verification complete. Rebase, squash,
cherry-pick, stash, reset and amend are handled by Git AI, but normal authorization
for rewriting history still applies. Server-side squash/rebase merges need the
upstream CI integration; do not promise preservation without it. Renames and bulk
history filters have documented gaps; verify instead of promising universal tracking.

**Owned repositories:** current upstream docs explicitly say `git push`/`fetch`
automatically synchronize attribution notes. Do not add duplicate refspecs by
default. Verify behavior for the installed version/backend and destination before
publishing. If automatic synchronization is absent and sharing was authorized,
review the complete notes ref (it can contain other commits' metadata), then use
`git push origin refs/notes/ai` and the fetch refspec
`refs/notes/ai:refs/notes/ai`. Never force the shared notes ref to resolve conflicts.
Notes sharing is not authorized by permission merely to make a local commit.

**Third-party/upstream PRs (e.g. dlang/*), including personal forks of upstream:**
no extra provenance trailers and no notes publication. Merely omitting an explicit
notes push is **not sufficient**, because Git AI auto-syncs. Before any push,
verify a supported no-sync/exclusion policy for the installed release and every
push remote; if unavailable/unverified, stop and report rather than push. The
`exclude_repositories` configuration is a possible full opt-out, not a verified
local-only tracking switch. Do not change global config without authorization.

Notes no longer embed transcript messages (removed v1.3.4); legacy prompt records
may have `messages_url`, while current session records do not. Input transcripts
still pass through the integration and may have separate local/platform storage.
Review telemetry/session-store settings; never treat notes format as a privacy
or no-network guarantee.

## Optional GitHub-visible trailers

[notes-to-trailers.ps1](notes-to-trailers.ps1) automatically derives sorted,
deduplicated `Agent-Harness:` / `Agent-Model:` lines from **existing commit notes**,
handling both `sessions` and legacy `prompts`. Model values retain the harness
association. It is a read-only exporter, disabled unless the exact owned repo is
explicitly allow-listed by its caller. It never changes authors, signatures,
commit messages, Git config, or notes and never pushes. Example:

```powershell
& "$AGENT_RULES_PATH/skills/agent-provenance/notes-to-trailers.ps1" `
  -Commit HEAD -OwnedRepository 'dev-centr/agent-rules'
```

**Timing limitation:** `git ai stats` without a revision describes HEAD, not the
staged commit. A `prepare-commit-msg` hook cannot use HEAD's stats/notes for the
new commit. This draft deliberately does not install an inaccurate hook or an
automatic post-commit amend (which would rewrite signed commits). To embed these
trailers in that same commit automatically, first implement/test a supported
**staged-attribution** exporter with partial staging, worktrees, model switching,
aborted commits, and existing-hook chaining. Until then, notes are authoritative
and the optional exporter is for summaries of completed commits. No agent should
manually guess a model list. Upstream repos remain trailer-free.

## Adapter tests

Run `powershell -NoProfile -File skills/agent-provenance/test.ps1` from the
repository root. It mocks Git/Git AI and checks ordering, Unicode serialization,
partial-write failure handling, encoding restoration, modern and legacy note
parsing, and upstream/opt-in gates. It does not establish live Git AI support.

## Sources (checked 2026-11-07)

- [Add a coding agent](https://usegitai.com/docs/guides/add-your-agent)
- [Authorship standard v3](https://github.com/git-ai-project/git-ai/blob/main/specs/git_ai_standard_v3.0.0.md)
- [How Git AI works](https://usegitai.com/docs/get-started/how-git-ai-works)
- [CLI reference](https://usegitai.com/docs/cli/reference) (some examples lag the spec)
