---
name: issue-reports
description: >-
  Use when filing is warranted (bug, blocker, external coordination, user
  asked) — not after every owned-repo change. gh issue create; ISSUES_REPO;
  .issues submissions; do not leave the issue only in chat.
---

# Issue reports

**How** to draft and submit an issue. **When** to file is always-on policy in `AGENTS.md` or `.cursor/rules/issue-reports.mdc` — do not open issues for normal owned-repo functional changes (use skill `owned-changelog` instead).

Draft the report as a durable artifact, then submit to the forge. Do **not** leave the body only in chat or in a one-shot `gh` argument that the shell can mangle.

If `ISSUES_REPO` is set in the profile / Cursor `machine.mdc`, **follow that repository's README**. Typical house layout:

```text
ISSUES_REPO/
  submissions/{issue-short-name}/   # lowercase
    issue.md                        # shared base description
    screenshots/                    # descriptive names
    {org}-{repo}-{issue-number}.md  # per-forge copy after submit
```

GitHub CLI cannot upload images; keep screenshots in the submission folder (and `images/` when the house repo says so).

## Draft

1. Create `submissions/{short-name}/` if using the house store.
2. Write `issue.md` — **do not put the title in the issue body**.
3. Pass the file into `gh` (or `glab`) so the body is not expanded by the shell.
4. After submit, add `{org}-{repo}-{issue-number}.md` with front matter:

```markdown
---
title: Feature Request: …
repository: OWNER/REPO
issue_number: 123
url: https://github.com/OWNER/REPO/issues/123
submitted: YYYY-MM-DD
---
```

5. Format markdown under `submissions/` per that repo (e.g. prettier) before committing.

## Do not

- File issues for routine owned-repo work that changelog + PR already capture
- Invent an issues store when `ISSUES_REPO` is unset — still write a file (repo `docs/` or a path they name) rather than chat-only
- Put secrets in issue bodies
- Commit `archives/` / `*.sqlite` if that repo uses issues-browser backups

## User Rules preamble

If Cursor Settings User Rules still say only `Issues: never only in chat — skill issue-reports`, update that line to match `RULES.md` / org `AGENTS.md`: file for bugs, blockers, and external coordination; use `owned-changelog` for owned functional changes. Re-paste or re-compose via `rules-manager` after pulling agent-rules updates.
