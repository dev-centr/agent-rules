# dubx / dub-publish reference

## Command map

Short aliases on `dubx` are the same verbs as `dub-publish`. `dubx publish <args…>` is an opaque passthrough to `dub-publish <args…>`.

| Intent | Command |
| --- | --- |
| Login + save store | `dubx login --user NAME --save-credentials` |
| Logout | `dubx logout` |
| Dry-run register | `dubx register --dry-run` |
| Register / refresh | `dubx register` / `dubx register --ignore-fork` |
| Exists? | `dubx status -n NAME` |
| Queue metadata refresh | `dubx update -n NAME` |
| Docs URL | `dubx docs-url -n NAME --docs-url URL` |
| Categories (max 4, **required**) | `dubx categories -n NAME --category ID [--category ID …]` — POST immediately; not optional |
| Logo | `dubx logo -n NAME --logo-file PATH` |
| Reset logo | `dubx logo-delete -n NAME` |
| Hook status (safe) | `dubx hooks -n NAME` |
| Enable / print URLs | `dubx hooks get -n NAME` |
| Rotate secret | `dubx hooks regenerate -n NAME --yes` |
| Revoke hooks | `dubx hooks disable -n NAME` |
| Retarget repo | `dubx repo -n NAME --kind github --owner ORG --project REPO` |
| Share user | `dubx perms-add -n NAME --username USER --perm update` |
| Leave shared pkg | `dubx leave -n NAME` |
| Owner delete | `dubx remove -n NAME --yes` |
| Escape hatch | `dubx dub-publish status -n NAME` |
| Which backends | `dubx which` |

Common flags: `--registry` (default `https://code.dlang.org`), `--user` / `-n` / `--url` / `--root` / `--ignore-fork` / `--dry-run` / `--save-credentials`.

Package name defaults from `dub.sdl` / `dub.json`. URL defaults from `git remote get-url origin`.

## How versions get onto the registry

1. `register` points the registry at the Git host (GitHub, GitLab, Bitbucket, Codeberg/Gitea).
2. Push a SemVer tag (`v1.2.3`).
3. Wait for poll (~2/h) or `update` / webhook.

`/api/packages/:name/latest` returns a **JSON string** (quoted); unwrap before display.

## Credentials paths

| | Windows | Unix |
| --- | --- | --- |
| Drop file | `%LOCALAPPDATA%\dlang-supplemental\dub-publish\password.incoming` | `~/.dlang-supplemental/dub-publish/password.incoming` |
| Store | `...\credentials.v1` (DPAPI) | `~/.../credentials.v1` (mode 0600) |
| Hook secret | `...\hooks\<pkg>.secret` | `~/.../hooks/<pkg>.secret` |
| Hook URLs | `...\hooks\<pkg>.hooks.txt` | `~/.../hooks/<pkg>.hooks.txt` |

Install binaries: `%LOCALAPPDATA%\Programs\dlang-supplemental\dubx` and `...\dub-publish`.

CI: reusable workflow `dlang-supplemental/dub-publish/.github/workflows/register-package.yml` + secrets `DUB_REGISTRY_USER` / `DUB_REGISTRY_PASSWORD`.

## Categories — always populate and POST

Never leave `categories` empty on a package you register or audit. Infer 1–4 ids, run `dubx categories`, verify.

Read live (public JSON; empty if unset):

```powershell
(Invoke-RestMethod "https://code.dlang.org/packages/NAME.json").categories
```

Owner list after login: `https://code.dlang.org/my_packages`. Cookie jar: `%LOCALAPPDATA%\dlang-supplemental\dub-publish\cookies.txt`.

`dubx categories` **pushes** to `POST /my_packages/:name/set_categories`. It does **not** wait for git tags or `dubx update`. `update` refreshes recipe/versions only.

Pick the **most specific** dotted path from the [registry taxonomy](https://code.dlang.org). Do not also send ancestors — browse/search already matches prefixes (`library.tui` shows under `library`). Max 4. Ask only when two siblings are equally plausible.

| Signal | Prefer |
| --- | --- |
| CLI / desktop tooling | `library.development` + `application.desktop.development` (or a child: `.build`, `.packaging`, …) |
| D bindings | `library.binding` (Deimos: `library.binding.deimos`) |
| TUI | `library.tui` — **not** `library.gui` |
| GUI | `library.gui` |
| BetterC | `library.betterc` |
| VCS | `library.vcs` |
| Config / file formats | `library.data` |
| Phobos candidate only | `library.std_aspirant` — never for a third-party binding |

If JSON already matches the chosen set, skip the POST. If empty or wrong, overwrite.

## Category ids (max 4)

Dotted path from the taxonomy. Pick the most specific matches.

**Libraries** — `library`, `library.audio`, `library.betterc`, `library.binding`, `library.binding.deimos`, `library.crypto`, `library.development`, `library.development.parsing`, `library.data`, `library.data_structures`, `library.database`, `library.filesystem`, `library.gamedev`, `library.geospatial`, `library.graphics`, `library.gui`, `library.tui`, `library.testing`, `library.memory`, `library.network`, `library.network.messaging`, `library.scripting`, `library.vcs`, `library.video`, `library.vibed`, `library.wasm`, `library.web`, `library.web.auth`, `library.web.communication`, `library.web.framework`, `library.web.cms`, `library.general`, `library.generic`, `library.encoding`, `library.i18n`, `library.scientific`, `library.scientific.linalg`, `library.scientific.numeric`, `library.scientific.newton`, `library.scientific.bioinformatics`, `library.optimized_cpu`, `library.optimized_mem`, `library.nogc`, `library.std_aspirant`

**Applications** — `application`, `application.desktop`, `application.desktop.development`, `application.desktop.development.analyzer`, `application.desktop.development.build`, `application.desktop.development.compiler`, `application.desktop.development.debugger`, `application.desktop.development.documentation`, `application.desktop.development.packaging`, `application.desktop.development.plugin`, `application.desktop.development.ide`, `application.desktop.editor`, `application.desktop.game`, `application.desktop.graphics`, `application.desktop.multimedia`, `application.desktop.network`, `application.desktop.photo`, `application.desktop.productivity`, `application.desktop.web`, `application.mobile`, `application.server`, `application.server.messaging`, `application.server.database`, `application.server.game`, `application.server.web`, `application.web`, `application.web.development`, `application.web.communication`, `application.web.productivity`

Typical CLI/tooling package: `library.development` + `application.desktop.development`. Binding: `library.binding`. TUI: `library.tui`. Always POST after register.

## See also

- https://github.com/dlang-supplemental/dubx
- https://github.com/dlang-supplemental/dub-publish
- Org how-to: dlang-supplemental docs *Publishing D packages from the CLI*
- Official site flow (browser): https://dub.pm/publish
