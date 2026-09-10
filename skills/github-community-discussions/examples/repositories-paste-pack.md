# Example paste pack — Repositories / Product Feedback

Portable example for agents and humans. Copy structure; replace title/body with
the real request. Do **not** submit via `gh discussion create`.

## Meta

| Field | Value |
| --- | --- |
| Category | Repositories |
| New discussion URL | https://github.com/orgs/community/discussions/new?category=repositories |
| Template file | `.github/DISCUSSION_TEMPLATE/repositories.yml` |
| Discussion Type | Product Feedback |
| Expected labels after submit | `source:ui`, `Repositories`, `Product Feedback` (or similar) |

## Title

```text
AsciiDoc as README default: repo-creation chooser plus user/org/repo preferences
```

## Discussion Type

Select: **Product Feedback**

## Body (paste into the Body field)

```markdown
GitHub already renders AsciiDoc well, but every path that creates a README still assumes Markdown. Please add a first-class way to choose AsciiDoc (`README.adoc`) at repo creation time, and to set that choice as a default for users, organizations, and repositories.

### Problem

When you check **Add a README** on the new-repository form (or use `auto_init` / `gh repo create --add-readme`), GitHub always seeds `README.md`. …

### Proposed solution

1. Repo creation UI — README format chooser (Markdown vs AsciiDoc)
2. User / org / repo defaults with clear precedence
3. API / CLI parity (`readme_format`, `gh repo create --readme-format`)

(Include mockups, related links, and product areas as needed.)
```

## Human steps

1. Open the New discussion URL while logged into GitHub.
2. Confirm category **Repositories** and that the template form is visible (Discussion Type + Body).
3. Paste title; choose Discussion Type; paste Body.
4. Submit.
5. Within ~60s, confirm the discussion is **open** and labels include **`source:ui`**.

## Verify (agent)

```powershell
gh api graphql -f query='query($o:String!,$n:String!,$num:Int!){
  repository(owner:$o,name:$n){
    discussion(number:$num){ closed labels(first:20){nodes{name}} url }
  }
}' -f o=community -f n=community -F num=<NUMBER>
```

Reference open filing: https://github.com/orgs/community/discussions/207400  
Reference closed API filing: https://github.com/orgs/community/discussions/207398
