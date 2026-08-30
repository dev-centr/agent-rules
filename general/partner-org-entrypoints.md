# Partner org entry points (footers & related strips)

When listing **other organizations** in site or docs chrome — footers, “Partner organizations”, “Related projects”, homepage partner rows — use **one entry point per org**.

## Prefer

| Priority | URL |
| --- | --- |
| 1 | Public **org homepage** / marketing site (e.g. `https://openshellorg.github.io/`, `https://devcentr.org`) |
| 2 | GitHub org URL **only if** there is no public homepage |

## Do not

- Stack **homepage + docs hub + GitHub** for the same org in one strip (e.g. OpenShellOrg · OSO Docs · `openshellorg`)
- Duplicate **docs** next to a homepage that already routes to docs
- Use a **repo URL** when the org homepage exists

## Still fine

- In-site **nav** links to *this* site’s Docs / Blog / Philosophy
- Topic-level deep links in essay/demo bodies (not org chrome)
- Listing several **different** orgs, each with a single link
- GitHub-only orgs that have no homepage yet (one GitHub org link)

## Where this shows up

- Antora `supplemental-ui/partials/footer-content.hbs`
- Org site footers (`BaseLayout`, static HTML shells, news page templates)
- Homepage “Partners” / “Related” sections that mirror the footer

Skills: `antora-org-site`, `bootstrap-org` (partner cross-links).
