---
name: git-ai-guest-repos
description: >-
  Use before agent work, commits, or pushes in a repository Ryan does not own
  (upstream projects, forks that PR upstream, guest or contributor repos) on a
  machine with Git AI; when proposing Git AI attribution to another project;
  when a project accepts or declines refs/notes/ai; when checking git-ai#2399.
---

# Git AI in guest repositories

A **guest repository** is any repo Ryan does not own or administer, including
his personal forks of upstream projects (for example `AMDphreak/dub` for
`dlang/dub`). Git AI's attribution notes (`refs/notes/ai`) are not files and are
not commits: they live in the repo's `.git` store and travel on push as a separate
ref. `.gitignore` cannot block them. Pull requests do not show them. Default:
**no Git AI notes reach a guest remote** until that project has agreed.

## Hard gate: git-ai#2399

[git-ai#2399](https://github.com/git-ai-project/git-ai/issues/2399) (open since
2026-10-06, reported on v1.7.6): `allow_repositories` / `exclude_repositories`
skip checkpoints but **do not** stop notes being written on commit or pushed by
the daemon's push side effect. The filter is per repository, not per remote, so
`git push upstream` from an allowed fork still sends notes upstream.

While #2399 is unresolved, **do not install or enable Git AI on a machine that
holds guest repositories or forks.** If it is already installed, stop and tell
Ryan before working in a guest repo.

Check the status yourself before any Git AI install, and before relying on it in a
guest repo. Do not trust a closed issue, a release note, or a maintainer's claim:

1. Read the issue, its linked PRs and commits, and newer releases. Search the repo
   for new or duplicate issues (`exclude_repositories`, `allow_repositories`,
   `notes push`, `per-remote`).
2. Read the fixing diff. Note writes, rewrite copies, fetches, and the push side
   effect must all be gated, and the push must check the actual target remote.
3. Reproduce in agent scratch with local bare remotes: one excluded repo, plus a
   repo with an allowed `origin` and a disallowed `upstream`. Commit with an agent
   checkpoint, push to each remote, then run
   `git ls-remote <remote> 'refs/notes/*'`. It must be empty for every disallowed
   remote.
4. Only after the reproduction passes, record the verified version in
   `harness.md` and lift this gate. If no fix exists, a fix PR by Ryan is the
   preferred path (draft it; Ryan approves before opening).

Evidence so far (2026-11-08): plain Git does not push `refs/notes/*` without a
refspec (scratch test, bare remote, `ls-remote` empty). Git AI's pre-push handler
calls `push_authorship_notes`
([push_hooks.rs](https://github.com/git-ai-project/git-ai/blob/f3da782e93c492303e44d14805179123d1740e7f/src/commands/hooks/push_hooks.rs)),
so refspecs alone do not suppress it. The HTTP notes backend is **not** a privacy
measure: it uploads attribution elsewhere. Installed-Git-AI suppression is
**not verified end to end**.

## After every push to a guest remote

Run `git ls-remote <remote> 'refs/notes/*'`. Anything returned: stop and tell
Ryan. Do not delete remote refs without his explicit OK.

## Proposing Git AI to a project

Some projects may want the attribution data. Ask once, briefly, and link the
reference page instead of explaining everything in the post.

- Channel: GitHub Discussions if enabled; else an issue; else whatever the
  project's CONTRIBUTING names (mailing list, forum, email).
- Link: DevCentr public reference page on Git AI attribution in guest repos
  (TODO: fill in the published URL).
- **Draft first.** Ryan reads and approves every post; never post on your own.
- One ask per project; if there is no answer, do not re-ask for at least 90 days.

Draft template:

> We use [Git AI](https://usegitai.com) to record which human, harness, and model
> wrote each line, stored as git notes (`refs/notes/ai`), separate from commits.
> Before any of our contributions include those notes here, we'd like to know
> whether this project wants them. Background and privacy details:
> <DevCentr reference link>. Either answer is fine; if you'd rather not, a line in
> CONTRIBUTING.md or AGENTS.md helps other contributors' tools respect that.

## Recording the outcome

Record each negotiation (repo, channel, URL, date, outcome) using the
`issues-repo-record` skill's submissions record.

- **Accepted:** notes may be pushed to that project's remote only, after the
  #2399 gate allows it. Offer a PR adding a short CONTRIBUTING/AGENTS.md note
  that links the discussion.
- **Declined:** keep notes suppressed. Offer a PR adding a line to
  CONTRIBUTING.md and/or AGENTS.md, for example: "Do not push Git AI attribution
  notes (`refs/notes/ai`) to this repository. See <discussion URL>." Explain in
  the PR that `.gitignore` cannot do this, because notes are refs, not files.
- **No response:** keep suppressed.

Proposed upstream mechanism (Ryan's preference): a project-controlled
`.gitattributes`-style key that Git AI reads before writing or pushing notes,
checked per remote. It is pending upstream (comment on #2399); it is not
implemented yet.

## Related

- `agent-provenance`: core Git AI setup and owned-repo notes sharing.
- `harness-setup` Step 4a: install guard.
