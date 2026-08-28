# Org agent orchestrator

Read this file during org context assembly (`AGENTS.md` pass).

## Editorial

- Titles for news, blogs, docs → [`editorial/titles.md`](editorial/titles.md)
- Pull request titles and inviting summaries → skill `draft-pr`
- Skills governance when adding or linking agent skills → [`../skills/CATALOG.md`](../skills/CATALOG.md)

## Task → skill routing

Load from `$AGENT_RULES_PATH/skills/<name>/` (discovery per `$CODE_ROOT/harness.md`, or direct read):

| Trigger / task | Skill |
| --- | --- |
| "publish to dub" / "publish to dlang" / "publish dlang" / DUB categories | `publish-to-dub` |
| New library / path dep / publish vs local disk / unpublished owned dep | `library-registry-choice` |
| Bootstrap / initialize an org, `{org}/agent-rules` overlay | `bootstrap-org` |
| Authoring a skill / `SKILL.md` / skill `description` | `write-a-skill` |
| New machine or harness setup / populate harness.md | `harness-setup` |
| Skills/rules drift / sync discovery / `AGENT_RULES_SYNCED_SHA` | `sync-agent-rules` |
| Opening or drafting a pull request | `draft-pr` |
| News body copy (ship note, org announcement) | `writing-news` |
| Blog body copy (essay, philosophy, tutorial narrative) | `writing-blog` |
| Antora site / docs hub / Valentus / Facto | `antora-org-site` |
| New UI concept / interactive explainer / layout or chrome idea → demos | `demo-site-wiring` (+ `agents/demos-and-push.md`) |
| Persist a preference / update agent-rules layers | `record-rule` |
| Public README | `public-readme` |
| Shipping an app | `ship-app` |
| Changelog (owned project) | `owned-changelog` |
| Bug/blocker/external issue (when filing warranted) | `issue-reports` |
| Record issue/PR in `ISSUES_REPO` / `.issues` | `issues-repo-record` |
| Git commit | `git-commit` |
| Push code / git push | `push-code` |

## Engineering

- DUB / D packages → [`engineering/dub.md`](engineering/dub.md)
- Antora / Valentus / Facto / Internet Architecture nesting → [`engineering/antora.md`](engineering/antora.md)

## Machine-local (never in templates)

- Harness config → `$CODE_ROOT/harness.md`
- Workstation facts → `$CODE_ROOT/machine.md`
