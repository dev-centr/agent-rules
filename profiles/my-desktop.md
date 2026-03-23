# Device profile: desktop (template)

Rename this file to match how you use it (for example `desktop.md`) and point your agent configuration at it. Update any path references in `RULES.md` after copying into an app.

Constants use `NAME = value` with an inline comment after `#` where helpful.

```text
CODE_ROOT = <your-code-root>              # e.g. Z:\code or /home/you/src
GITHUB_USER = <your-github-username>
ISSUES_REPO = <path-to-.issues-repo>        # optional; omit or leave commented if unused
ENVIRONMENT = windows                       # windows | mac | linux — picks general/<os>.md
```
