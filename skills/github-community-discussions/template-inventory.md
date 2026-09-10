# Community DISCUSSION_TEMPLATE inventory

Upstream: `community/community` → `.github/DISCUSSION_TEMPLATE/*.yml`

Refresh before filing if templates may have changed (do not treat this file as
authoritative forever).

## How to refresh

```powershell
# List templates
gh api repos/community/community/contents/.github/DISCUSSION_TEMPLATE --jq '.[].name'

# Fetch one category (PowerShell decode)
$raw = gh api repos/community/community/contents/.github/DISCUSSION_TEMPLATE/repositories.yml | ConvertFrom-Json
[System.Text.Encoding]::UTF8.GetString(
  [System.Convert]::FromBase64String(($raw.content -replace "`n",""))
)
```

Raw HTTPS alternative:

`https://raw.githubusercontent.com/community/community/main/.github/DISCUSSION_TEMPLATE/<file>.yml`

After refresh, update the table below if labels or required fields changed.
Snapshot date for this inventory: **2026-09-10**.

## Category → template file

| Category slug / file | Typical template labels | Notes |
| --- | --- | --- |
| `a-welcome-to-github.yml` | A Welcome to GitHub, `source:ui` | Onboarding; may lack Discussion Type |
| `accessibility.yml` | Accessibility, `source:ui` | Discussion Type + topic area |
| `actions.yml` | Actions, `source:ui` | Discussion Type + Actions topic |
| `announcements.yml` | Announcement, `source:ui` | Staff-oriented; may lack Discussion Type |
| `apps-api-and-webhooks.yml` | Apps API and Webhooks, `source:ui` | Discussion Type + API/Apps/Webhooks |
| `code-security.yml` | Code Security, `source:ui` | Discussion Type + security topic |
| `codespaces.yml` | Codespaces, `source:ui` | Discussion Type |
| `copilot-conversations.yml` | Copilot, `source:ui` | Discussion Type + Copilot surface |
| `discussions.yml` | Discussions, `source:ui` | Product Discussions only; body often **≥ 1000 chars** |
| `enterprise.yml` | Enterprise, `source:ui` | Discussion Type |
| `github-education.yml` | GitHub Education, `source:ui` | Discussion Type + education topic |
| `github-learn.yml` | GitHub Learn, `source:ui` | Discussion Type + learn topic |
| `mobile.yml` | Mobile, `source:ui` | Discussion Type + Android/iOS |
| `npm.yml` | npm, `source:ui` | Discussion Type |
| `other-feature-feedback-questions-ideas.yml` | Other Features and Feedback, `source:ui` | Discussion Type + Feature/Topic Area |
| `packages.yml` | Packages, `source:ui` | Discussion Type |
| `programming-help.yml` | Programming Help, `source:ui` | Guidelines checkbox common |
| `projects-and-issues.yml` | `source:ui` (+ topic labels) | Discussion Type + Issues/Projects + guidelines checkbox |
| `pull-requests.yml` | Pull Requests, `source:ui` | Discussion Type |
| `repositories.yml` | Repositories, `source:ui` | Discussion Type: Bug / Product Feedback / Question |

Every template that Community accepts via UI includes **`source:ui`** in
`labels:`. Non-UI creates get `source:other` and are closed.

## Repositories schema (detail)

File: `repositories.yml`

```yaml
labels: [Repositories, source:ui]
body:
- type: dropdown
  attributes:
    label: Discussion Type   # UI may show an emoji prefix
    options:
      - Bug
      - Product Feedback
      - Question
  validations:
    required: true
- type: textarea
  attributes:
    label: Body
  validations:
    required: true
```

**Discussion Type** values for Repositories: `Bug`, `Product Feedback`, `Question`.

Other categories reuse those three often, but add extra dropdowns, markdown
gates, checkboxes, or length rules — always re-read the YAML for the category
you are filing into.

## Teaching pair

- Closed non-UI: https://github.com/orgs/community/discussions/207398
- Open UI+template: https://github.com/orgs/community/discussions/207400
