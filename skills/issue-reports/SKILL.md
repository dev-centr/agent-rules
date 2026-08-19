---
name: issue-reports
description: >-
  Use when filing is warranted (bug, blocker, external coordination, user
  asked) — not after every owned-repo change. gh issue create; ISSUES_REPO;
  .issues submissions; issues-repo-record; do not leave the issue only in chat.
---

# Issue reports

**How** to draft and submit an issue. **When** to file is always-on policy in `AGENTS.md` or `.cursor/rules/issue-reports.mdc` — do not open issues for normal owned-repo functional changes (use skill `owned-changelog` instead).

Draft the report as a durable artifact, then submit to the forge. Do **not** leave the body only in chat or in a one-shot `gh` argument that the shell can mangle.

If `ISSUES_REPO` is set, skill **`issues-repo-record`** owns layout, images, front matter, commit, and **push** (recording is submitting; always push). Follow that repo’s README for paths.

## Draft and submit

1. Write the body in `ISSUES_REPO/submissions/{short-name}/issue.md` — **no title in the body**.
   - The first lines of the body must be a **normal-talk introduction/summary** (plain English, 1–3 sentences).
   - Only after that intro/summary should you add structured sections (steps, expected/actual, screenshots, etc.).
2. If screenshots are needed: skill `issues-repo-record` — push `images/` **before** embedding URLs.
3. Follow `cli-body-file-first` for any CLI submission of multi-line formatted text (bodies, comments, edits); delete any temp file after the command succeeds.
4. Skill `issues-repo-record` — record outcome (`submitted`, `pending`, or `blocked`), commit, push.

## Do not

- File issues for routine owned-repo work that changelog + PR already capture
- Invent an issues store when `ISSUES_REPO` is unset — still write a file (repo `docs/` or a path they name) rather than chat-only
- Leave `ISSUES_REPO` submission files uncommitted or unpushed (skill `issues-repo-record`)
- Put secrets in issue bodies
- Commit `archives/` / `*.sqlite` if that repo uses issues-browser backups

## Always-on rules preamble

If the always-on rules slot still says only `Issues: never only in chat — skill issue-reports`, update that line to match `RULES.md` / org `AGENTS.md`: file for bugs, blockers, and external coordination; use `owned-changelog` for owned functional changes. Re-paste or re-compose via `rules-manager` after pulling agent-rules updates.
