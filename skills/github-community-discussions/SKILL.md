---
name: github-community-discussions
description: >-
  Use when GitHub Community discussions, orgs/community, community/community,
  DISCUSSION_TEMPLATE, source:ui, Product Feedback on Community, community
  feature request, github-actions closed discussion, gh discussion create
  community, createDiscussion GraphQL community, paste pack for community
  discussion, repositories.yml discussion template, category discussion form.
---

# GitHub Community discussions

Submit product feedback, bugs, and questions to **GitHub Community**
(`orgs/community` / repo `community/community`) so posts are **not**
auto-closed by `github-actions`.

This skill is **standalone**. Success = an open Community discussion that
used the category UI template. It does **not** require `ISSUES_REPO` /
`.issues`. Optional bookkeeping is a separate post-step only when that
store is configured.

## Hard rule

**Never** create discussions on `community/community` via:

- `gh discussion create`
- GraphQL `createDiscussion` / similar API creates
- Any non-UI path that yields label `source:other` instead of `source:ui`

Community bots close those within seconds. Teaching example:

| Path | Discussion | Labels | Outcome |
| --- | --- | --- | --- |
| API/CLI | [#207398](https://github.com/orgs/community/discussions/207398) | `source:other`, `Welcome` | Closed by `github-actions` (~8s); bot asks for UI + template resubmit |
| GitHub UI + category template | [#207400](https://github.com/orgs/community/discussions/207400) | `source:ui`, `Repositories`, `Product Feedback` | Stays open |

Same title/body intent; only the **source** path differed.

## When to use

- Feature requests / product feedback / bugs aimed at GitHub product surfaces
- User says Community, `orgs/community/discussions`, or “file on GitHub Community”
- Prior Community filing was closed for non-UI create
- Skill `issue-reports` target is Community discussions (load **this** skill first)

Ordinary repo issues/PRs stay on `issue-reports` + forge CLI. This skill is
only for Community category discussions.

## Workflow

### 1. Pick the category

Match the product area (Repositories, Actions, Copilot, Projects and Issues,
…). Use the Community category list or
https://github.com/orgs/community/discussions/categories.

Slug ≈ template basename: category **Repositories** → `repositories.yml`.

### 2. Fetch the live template (do not invent fields)

```powershell
gh api repos/community/community/contents/.github/DISCUSSION_TEMPLATE/<category>.yml `
  --jq .content
# decode base64 → YAML
```

Or browse raw:
`https://raw.githubusercontent.com/community/community/main/.github/DISCUSSION_TEMPLATE/<category>.yml`

Read every `required: true` control: dropdowns, textareas, checkboxes,
min-length patterns. Categories **differ** — never assume Repositories’
shape for Copilot or Discussions.

Snapshot inventory + refresh notes: [template-inventory.md](template-inventory.md).

### 3. Map content into required fields

Typical Repositories (`repositories.yml`) shape:

- **Discussion Type** (required dropdown): `Bug` | `Product Feedback` | `Question`
- **Body** (required textarea)
- Template labels applied by UI: `Repositories`, `source:ui`
  (Discussion Type selection also drives labels such as `Product Feedback`)

Other categories add Feature/Topic Area dropdowns, guidelines checkboxes,
or min body length (e.g. Discussions product category ≥ 1000 chars).

### 4. Deliver a paste pack (preferred)

Prefer giving the human a **paste pack** over fragile UI automation:

1. New discussion URL for that category  
   (e.g. https://github.com/orgs/community/discussions/new?category=repositories)
2. Exact **title**
3. Exact **Discussion Type** (and any other dropdown values)
4. Full **Body** text ready to paste into the template textarea
5. Checkbox instructions when the template requires them
6. Verify checklist (below)

Example pack layout: [examples/repositories-paste-pack.md](examples/repositories-paste-pack.md).

Keep paste-pack examples **inside this skill folder** so the skill travels with
agent-rules — not only under someone’s `.issues` tree.

### 5. Optional: drive the UI carefully

Automation is optional. If used:

- Use the human’s **already logged-in** browser / Cursor browser session
- Fill the category form fields that mirror the YAML template
- Submit via the real New discussion UI

**Do not:**

- Clone or copy a browser profile into a TEMP `user-data-dir` to fake login
- Use pywinauto (or similar) to surgically edit profile/session files
- Bypass the template by posting a blank/markdown-only discussion

Those anti-patterns caused fragile auth and still risked non-`source:ui`
creates. Prefer the paste pack when automation is unreliable.

### 6. Verify it stayed open

Within ~60 seconds of create:

```powershell
gh api graphql -f query='query($o:String!,$n:String!,$num:Int!){
  repository(owner:$o,name:$n){
    discussion(number:$num){
      closed stateReason
      labels(first:20){nodes{name}}
      url
    }
  }
}' -f o=community -f n=community -F num=<NUMBER>
```

Success signals:

- `closed: false`
- Labels include `source:ui` (and usually the category label)
- No immediate `github-actions` close comment about UI/templates

If closed with `source:other` / Welcome-only labels: treat as failed CLI/API
path — rebuild via UI paste pack; do not “retry” with `gh discussion create`.

### 7. Optional record (never required for success)

**Filing succeeded when the Community discussion is open.** Stop there unless
the user wants local archive **and** `ISSUES_REPO` is configured.

Then, and only then, skill **`issues-repo-record`**: per-forge markdown under
`submissions/…`, commit + push. Do not invent an issues store. Do not block
the Community workflow on `.issues`.

## Integration

| Skill | Role |
| --- | --- |
| **This skill** | Community schema compliance, paste pack / UI path, verify not bot-closed |
| `issue-reports` | General forge filing; **defers to this skill** for Community discussions |
| `issues-repo-record` | **Optional** archive when `ISSUES_REPO` is set — not part of Community success |

## Do not

- `gh discussion create` / API create against `community/community`
- Assume one category’s dropdowns apply to all categories
- Call the job done without checking `closed` + `source:ui` after create
- Require `.issues` / `ISSUES_REPO` for a successful Community filing
- Profile cloning / TEMP user-data-dir / pywinauto profile surgery for “login”
- Put secrets in discussion bodies
