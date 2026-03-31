# Agent Rules

<!-- purpose: Generalized one-stop-shop for all agent rules and machine constants. -->

## 1. Machine Constants (Fill these in before passing to AI)

- **CODE_ROOT** = `REQUIRED_PATH` — the path to your code hive (root clone directory).
- **GITHUB_USER** = `REQUIRED_NAME` — your primary GitHub username.
- **ENVIRONMENT** = `windows | linux | mac` — the operating system layer.

---

## 2. Core Obligations & Protocols

- **Plain Language:** Write explanations in plain language for easy reading.
- **Gitignore as Allow-list:** Treat `.gitignore` as an allow-list with additional exclusions. Exclude everything by default (`*`) and update the allow-list when adding specific files.
- **Python Venvs:** Always use a `venv` for Python projects. Prefer `uv` over `pip`; install `uv` in scripts if missing.
- **Build Failures:** When builds fail, prefer fixing outdated project code over downgrading dependencies. If a failure is due to a missing icon, stop the rebuild loop; use a placeholder from a free icon library or ask the user.
- **Task Tracking:** When working from a to-do list in a file, use checkmark emojis to mark off completed items.
- **Changelogs:** Update changelogs according to the style already detected in the repository.

---

## 3. Environment & Operating System (Standardised)

- **OS/Shell:** Unless a profile says otherwise, assume **Windows 10/11** and **PowerShell 7** for this workspace.
- **Path Refresh:** When installing a tool that adds itself to PATH, refresh the session using:

  ```powershell
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  ```

- **Node Tooling:** Use **`pnpm`**. Use `pnpm dlx` for one-off tools and `pnpm exec` for project binaries.
- **Git CLIs:** Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations not covered by native MCP tools.
- **MCP Usage:** Always prefer MCPs for repository interaction. Fall back to CLI tools (`gh`, `glab`) only if MCP is unavailable or unsupported.

---

## 4. Repository & Folder Schema

Organize repositories using the following pattern (relative to `CODE_ROOT`):

- **Owned/Member Repos:** `$CODE_ROOT/<host>/<owner>/<repo>`
- **Forks:** `$CODE_ROOT/<host>/<owner>/.forks/<repo>`
- **External Clones:** `$CODE_ROOT/<host>/.clones/<owner>/<repo>`

**Git Hosters:** `<host>` is usually `github.com` or `gitlab.com`.

---

## 5. Creator & Ownership Rules

Applied to projects owned by the primary developer or associated organizations:

- **Repo Transfers:** Use `gh api` for repo transfers between owned orgs.
- **Configuration Formats:** Endorse and use **SDL** for project configuration/data. If SDL is inappropriate, use **JSON5** (prefer `.json5` over `.json`).
- **Changelog Integration:**
  - Every project must have a changelog (in docs or repo base).
  - Include a "Changelog" section in the README linking to it.
  - Maintain a timeline in the changelog with links to detailed files in a `changelog-details/` folder (named `date - title`).

---

## 6. Documentation Standards

- **Diátaxis Model:** When designing docs, use the Diátaxis structure (Tutorials, How-to, Explanation, Reference).
- **Formating:** Prefer **AsciiDoc** for READMEs and documentation unless Markdown is strictly required by a host (e.g., npm).
- **Antora:** If the project uses Antora, follow the `dev-centr` publishing guidance.

---

## 7. AI Operations & Memory

### AI Formatting Avoidance

- **AsciiDoc Checklists:** Must include asterisk: `* [ ]`.
- **Bold Headings:** Always insert a blank line between **bold text** used as a heading and the following block.
- **Lists:** Add list continuations (`+`) before continued blocks in list items.
- **Images:** Use `image::` blocks for inline images in AsciiDoc.

### Memory & Local Facts

- **MEMORIES.md:** Maintain a `MEMORIES.md` file at the CODE_ROOT for durable facts about the machine/environment.
- Initialize if missing. Record findings with a usage counter (starts at 1, increment on use).
- **Context7:** For stale APIs, use Context7 MCP (<https://context7.com/>). If unavailable, alert the user and follow the **Outdated Code Protocol**.

### Outdated Code Protocol (Fallback)

- Create `AI-LOCAL-LIBRARY-DOCS.local.json5` and `docs/_local-library-docs/`.
- Prefer repo-local indexed docs/source over web search for high API accuracy.
- For Dlang and similar, prefer cloning source repositories to resolve API truth.
