# bootstrap-org reference

Agent loads this after `SKILL.md`. Commands assume GitHub `gh` unless the profile chose another forge.

## SDL profiles

Authoritative inventory is `profiles/catalog.sdl` plus one file per name. Do **not** keep a second name table in this file.

Compiled JSON (`profiles/catalog.json`) is a build artifact of those SDL files. The public selector on https://devcentr.org/skills/?cat=bootstrap is compiled from the same tree at site build — not a hand-maintained copy.

Merge order: catalog `defaults` → file or inline `profile` → user sentences in the prompt.

- `skip "…"` tags add to the skip-unless table for this session.
- `session_scope` sets the phase checklist; they may widen it.
- `site { if_auth { host "netlify" } }` applies only when they confirm login/dynamic this session.
- Unknown tags: keep them, do not fail. Do not invent a new built-in name mid-session; extra files live beside the catalog if they asked to save one.

Classic SDL only (no Extended SDL/XDL). Strings are quoted; nested blocks as in the catalog.

## Skip unless

| Thing | Skip unless |
| --- | --- |
| New org at all | Named public story + several shippable projects |
| `.github-private` | Member-only text that **differs** from public |
| Notable-repo lists on profile | Never (site/docs instead) |
| Custom domain / CNAME file | Domain bought and TXT-verified |
| Cloudflare orange-cloud in front of github.io | Never |
| Private team docs | Members + secrets |
| Org `infra` / Pulumi | DNS/email/keys they would otherwise copy again |
| News feed | Something actually newsworthy |
| Blog route | Essays that are not news |
| Workflow templates in `.github` | They will publish org starter workflows |
| Legal entity / bank / Workspace | They asked this session |

## `gh` snippets

Org metadata (website = public site):

```powershell
gh api -X PATCH orgs/{org} -f name='Display Name' -f description='One line.' -f blog='https://{org}.github.io' -f company='@org' -f location='...'
gh api orgs/{org}/repos --jq '.[].name'
```

Public profile repo:

```powershell
gh repo create {org}/.github --public --confirm
# content: profile/README.md  +  profile/assets/  (+ optional root README for maintainers)
```

Agent rules wrapper (after `.github` exists — not inside it):

```powershell
pwsh $CODE_ROOT/github.com/dev-centr/agent-rules/scripts/setup-org-agent-rules-wrapper.ps1 -Org {org}
```

Creates `{org}/agent-rules` with a pointer README and overlay `AGENTS.md` (no submodule) and adds `AGENT-RULES.md` in `.github`. Shared changes PR `dev-centr/agent-rules`; clone/fetch that repo as `AGENT_RULES_PATH`.

Visibility if they created `.github` private by mistake:

```powershell
gh repo edit {org}/.github --visibility public
```

Repo About:

```powershell
gh repo edit {org}/{repo} --description '...' --homepage 'https://...'
```

Transfer (REST, not `gh repo` alone):

```powershell
gh api -X POST repos/{owner}/{repo}/transfer -f new_owner={org}
```

Pages HTTPS / custom domain: follow general-knowledge **GitHub Pages custom domain** (grey-cloud). Poll Pages API; do not orange-cloud github.io.

## Profile vs Settings

GitHub renders org profile from **`{org}/.github` / `profile/README.md`**. Views: `https://github.com/{org}?view_as=public` and `?view_as=member`.

Wrong audience = first-person maintainer notes, “start here”, duplicating Display name as H1, listing repos GitHub already shows.

## Site vs docs

- **Site** (`{org}.github.io` or custom domain): landing, news/blog routes, partner links, CTA to docs.
- **Docs hub**: teaching + reference; one public Antora (or peer) site per org.
- Do not stand up `{org}.github.io` if a canonical marketing host already exists.

Private member docs (Access in front of static) are **not** the public hub. See Business Bootstrap org infra + general-knowledge Cloudflare Access how-to.

## News vs blog (reminder)

News = outward dated record. Blog = inward argument. Titles/stance stay in thin rules; bodies in `writing-news` / `writing-blog` skills.

## Email lanes (when phase 8 is in scope)

Do not pick one ESP for everything.

| Lane | Job | Lean default (see BB) |
| --- | --- | --- |
| Human / org mail | Inbox, Gmail send-as | Routing inbound + dedicated human SMTP |
| Product / app mail | Transactional API | ESP on a **subdomain**, not apex |
| Marketing journeys | Campaigns / events | Separate vendor and host |

Tracking hostnames (`links`, not `click` unless making a privacy claim); do not mix lanes on apex. Encode DNS in `{org}/infra` when they would otherwise paste records twice.

## Pitfalls

1. **`.github` is private** → profile looks vacant. Make it public.
2. **Profile text in repo-root `README.md`** → GitHub ignores it for the org landing. Use `profile/README.md`.
3. **Personal-account stubs** (`user/{org}-private`, leftover Actions) after a transfer. Move or delete; the real private org bootstrap is `{org}/.github-private` only if needed.
4. **Rename leftover**: remotes vs hive folder vs in-repo URLs; do not treat the org directory as one git repo.
5. **Cloudflare proxy + github.io** → redirect loops. DNS-only for that CNAME. MX/TXT on the same zone are fine.
6. **Antora** `GITHUB_TOKEN` cannot clone **other** private org repos.
7. Playbook `start_path` missing on the source default branch.
8. Theme pin to a one-off `2.0.0` instead of the org’s current v2 line.
9. Dual copies after a failed transfer — merge unique commits, delete the leftover remote.
10. Brand assets only in the site **or** only in `.github`.
11. Forks-org over-sync: prefer `.clones` + selective rebrand over mirroring every upstream repo live.
12. Registry identity (npm, DUB, …) does not follow GitHub transfer until package metadata is updated.

## Hand-off (do not duplicate)

Capability-area literature stays in Business Bootstrap. Fast path page: `business-bootstrap` **Fast org bootstrap**.

- Stage defaults, stack map, bootstrap org email, org infra repo pattern
- Vibe coding / Cursor skills bootstrap (AI studio — sibling, not this skill)
- Agent-rules shop: `skills/BOOTSTRAP.md` (installing skills, not orgs)
