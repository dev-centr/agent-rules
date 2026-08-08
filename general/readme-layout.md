# Public README layout (Best-README adapted)

Read this when creating or revising a **GitHub-facing** `README.md` / `README.adoc` for owned or org repos. Structure inspiration: [othneildrew/Best-README-Template](https://github.com/othneildrew/Best-README-Template). Canonical blanks: [dev-centr/readme-template](https://github.com/dev-centr/readme-template) (fork to other orgs / personal profile as needed).

Do **not** batch-script README rewrites across repos. Hand-edit each file so stack grouping, contact, and omitted sections stay accurate. Not every repo needs the full template — omit fields that will never apply (e.g. no logo). That template assumes the repo is a project hub; lighter repos stay simpler.

## Format choice

| Situation | README format |
|-----------|----------------|
| **Default (owned / first-party)** | Prefer **AsciiDoc** (`README.adoc`). On GitHub, use embedded HTML for the centered title/header; use `[.text-center]` (or HTML) for other centered blocks. |
| **Fork of an upstream project** | **Retain Markdown** if upstream is Markdown. Do not convert away from the fork’s face format. |
| **Package registry that only parses Markdown** (npm, crates.io listing copy, etc.) | Keep or add a **Markdown** README (or registry-facing copy) for the registry. Do **not** delete a Markdown copy that exists for that reason. Deep docs may still be AsciiDoc/Antora. |
| **Major user-facing + Best-README HTML centering** | GitHub’s AsciiDoc subset centers poorly; **`README.md`** as the repo face is fine (deep docs under `docs/`). |

## Docs link (org repos)

For **organization** repositories with a README: include an **Explore the docs »** text link in the centered header (same pattern as `dev-centr/readme-template` / `switchyard`), pointing at the **org docs hub** component URL (e.g. `https://docs.devcentr.org/<component>/`), not a secondary per-repo Pages Antora site. Do **not** add a separate `Docs | Org` shield — that fights the established contributors/forks/stars/issues/(license) chrome.

**CI status badges** are optional. Prefer leaving them out of the centered header unless the repo already uses one; do not require a CI chip for every workflow-enabled repo.

Personal-user repos: skip the org-hub docs CTA unless that user publishes a docs site you should link.

## Why the prior refresh broke

1. **Badge targets** — Shields must open the *thing they represent* (contributors graph, stargazers, issues, license blob, tech homepage). Never the shield image URL. Docs discovery is the **Explore the docs »** text link (hub URL), not an extra Docs shield.
2. **Markdown inside `<div align="center">`** — GitHub often does **not** resolve `[![x][shield]][url]` inside HTML blocks, so badges appear to link only to the image (or nowhere useful). **In the centered header, use HTML:** `<a href="DEST"><img src="https://img.shields.io/…" alt="…"></a>`.
3. **AsciiDoc `env-github` trap** — Do **not** strip `link=` under `ifdef::env-github[]`. Prefer HTML `<a href><img>` on GitHub, or always keep `link=` on `image:` macros.
4. **Centering** — One centered block for **badges + title + one-liner + quick links**. Title-only centering with badges left above is incomplete.
5. **Built With** — Role-grouped (runtime / UI / docs / packaging), not a Nascar sticker row.
6. **Separators** — Prefer `&middot;` between quick links (avoids mojibake of raw `·`).

## Tiers

| Audience | Layout |
|----------|--------|
| **User-facing / downstream** (apps, installable CLIs, public libs, product sites) | Full: centered header (contributors/forks/stars/issues/license as applicable), **Explore the docs »** → hub when docs exist, structured Built With, TOC when >3 sections, section back-to-top, Contact, optional contrib.rocks |
| **Internal / non-downstream** | Simplified: linked shields + short About + install/usage if needed + License/Contact. Skip LinkedIn, empty Roadmap/Acknowledgments, contrib.rocks, demo marketing links |
| **Skip** | School repos, org `.github` profiles, archived, package-tap / registry-instruction-only, empty repos |

## Table of contents

Include a TOC when the README has **more than three** sections (collapsible `<details>` is fine on Markdown).

## Markdown header (required shape)

```markdown
<a id="readme-top"></a>
<div align="center">
  <a href="https://github.com/OWNER/REPO/graphs/contributors"><img src="https://img.shields.io/github/contributors/OWNER/REPO.svg?style=for-the-badge" alt="Contributors"></a>
  <a href="https://github.com/OWNER/REPO/network/members"><img src="https://img.shields.io/github/forks/OWNER/REPO.svg?style=for-the-badge" alt="Forks"></a>
  <a href="https://github.com/OWNER/REPO/stargazers"><img src="https://img.shields.io/github/stars/OWNER/REPO.svg?style=for-the-badge" alt="Stargazers"></a>
  <a href="https://github.com/OWNER/REPO/issues"><img src="https://img.shields.io/github/issues/OWNER/REPO.svg?style=for-the-badge" alt="Issues"></a>
  <a href="https://github.com/OWNER/REPO/blob/BRANCH/LICENSE"><img src="https://img.shields.io/github/license/OWNER/REPO.svg?style=for-the-badge" alt="License"></a>

  <h3 align="center">project_title</h3>

  <p align="center">
    project_description
    <br />
    <a href="https://docs.devcentr.org/COMPONENT/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="DEMO_OR_OMIT">View Demo</a>
    &middot;
    <a href="https://github.com/OWNER/REPO/issues">Report Bug</a>
    &middot;
    <a href="https://github.com/OWNER/REPO/issues">Request Feature</a>
  </p>
</div>
```

Omit license / demo / docs links when absent. Point **Explore the docs** at the org hub component URL when the org has a docs site. Collapsible TOC via `<details>` is fine when the README has more than three sections.

### Built With (outside the HTML header)

Reference-style Markdown is fine **outside** HTML blocks:

```markdown
### Built With

* **App shell** — [![Electron][Electron.com]][Electron-url]
  * [![React][React.js]][React-url]
  * [![shadcn/ui][shadcn]][shadcn-url]
* **Docs** — [![Antora][Antora]][Antora-url]

[Electron.com]: https://img.shields.io/badge/Electron-191970?style=for-the-badge&logo=Electron&logoColor=white
[Electron-url]: https://www.electronjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://react.dev/
```

Wrong: `[![x][shield]][shield]`, bare `![x](https://img.shields.io/…)`, or any destination that is also `img.shields.io`.

### Back to top

```html
<p align="right">(<a href="#readme-top">back to top</a>)</p>
```

### Contributors image (full tier)

```html
### Top contributors

<a href="https://github.com/OWNER/REPO/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=OWNER/REPO" alt="contributors" />
</a>
```

One image → contributors graph (avatars are not separate links). For **per-person profile links**, use [all-contributors](https://allcontributors.org/) or list people manually.

## AsciiDoc

On GitHub, use HTML passthrough for the centered header (same `<a href><img>` pattern as Markdown). Locally (`ifndef::env-github`), AsciiDoc `image:…[alt,link=DEST]` is fine — **always** include destinations; never a link-stripped `env-github` twin.

```asciidoc
ifdef::env-github[]
++++
<a id="readme-top"></a>
<div align="center">
<a href="https://github.com/OWNER/REPO/graphs/contributors"><img src="https://img.shields.io/github/contributors/OWNER/REPO.svg?style=for-the-badge" alt="Contributors"></a>
…
<h3 align="center">project_title</h3>
<p align="center">…</p>
</div>
++++
endif::[]
```

Built With: nested lists by role; `link:homepage[image:shield[Name]]` so the badge opens the project site.

## Contact

Org/user profile fields for that owner. Omit empty social. Do not invent LinkedIn/Twitter.

## Package-registry READMEs

Keep install one-liners near the top. Light Contact/License only; do not bury registry-critical commands under marketing chrome.

## Relation to Diátaxis / Antora

README ≠ product docs. Preserve useful README body; deep material stays in `docs/`. See also `general/documentation.md`.
