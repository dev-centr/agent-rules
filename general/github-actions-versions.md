# GitHub Actions: current majors, verified, kept current by Dependabot

**Rule:** in every workflow and composite action, use the **latest major** of each action that runs on the Node runtime GitHub currently supports (`node24` as of 2026-10). Check the version yourself before writing it: the action's latest GitHub release **and** the `runs.using` line in `action.yml` at that tag. Never write an action version from memory or copy one from an old workflow. Every repo with workflows also carries a grouped, **monthly** `.github/dependabot.yml` for the `github-actions` ecosystem.

## Why

Workflows pin a major (`actions/checkout@v4`) and then nobody touches them. The pin keeps working until GitHub retires the runtime underneath it. In September 2025 GitHub deprecated Node 20 on the runners ([changelog](https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/)); every run that still used a Node 20 action got this annotation:

```text
Node.js 20 is deprecated. The following actions target Node.js 20 but are being forced to run on Node.js 24: actions/checkout@v4, actions/setup-node@v4, ... For more information see: https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/
```

Agent memory is the usual source of the stale pin: models learned `@v4` / `@v3` and keep writing them years later. Composite actions hide the problem one level down (`actions/upload-pages-artifact@v3` pulls in `actions/upload-artifact@v4`), so check composites too.

## How to verify a version (do this, do not guess)

```bash
# latest release tag (fall back to tags if the repo has no releases)
gh api repos/OWNER/ACTION/releases/latest --jq .tag_name
# runtime at that tag: node24 is current; composite means check the actions it calls
gh api "repos/OWNER/ACTION/contents/action.yml?ref=TAG" -H "Accept: application/vnd.github.raw" | grep -n "using:"
# the moving major ref you will pin to must exist (tag or branch)
gh api repos/OWNER/ACTION/git/matching-refs/tags/vN --jq '.[].ref'
```

Then read the release notes for every major you skip and adjust inputs (table below lists the ones that bit us).

`releases/latest` can be wrong: it returns whatever release is marked "latest", which is sometimes an old maintenance line (`dlang-community/setup-dlang` returned `v1.4.0` while `v2.0.0` existed). Compare against the tag list when the answer looks old.

## Reference table (verified on 2026-10-06)

Use the **Pin** column. Recheck before relying on it if this date is more than a few months old, and always when GitHub announces a runtime deprecation (watch the [GitHub changelog](https://github.blog/changelog/) for "deprecation of Node").

| Action | Latest release | `runs.using` | Pin |
| --- | --- | --- | --- |
| `actions/checkout` | v7.0.1 | node24 | `@v7` |
| `actions/setup-node` | v7.0.0 | node24 | `@v7` |
| `actions/setup-python` | v7.0.0 | node24 | `@v7` |
| `actions/setup-go` | v7.0.0 | node24 | `@v7` |
| `actions/setup-java` | v6.0.1 | node24 | `@v6` |
| `actions/setup-dotnet` | v6.0.0 | node24 | `@v6` |
| `actions/cache` | v6.1.0 | node24 | `@v6` |
| `actions/upload-artifact` | v7.0.1 | node24 | `@v7` |
| `actions/download-artifact` | v8.0.1 | node24 | `@v8` |
| `actions/configure-pages` | v6.0.0 | node24 | `@v6` |
| `actions/upload-pages-artifact` | v5.0.0 | composite (upload-artifact v7) | `@v5` |
| `actions/deploy-pages` | v5.0.1 | node24 | `@v5` |
| `actions/github-script` | v9.0.0 | node24 | `@v9` |
| `actions/create-github-app-token` | v3.2.0 | node24 | `@v3` |
| `actions/labeler` | v7 | node24 | `@v7` |
| `actions/stale` | v11 | node24 | `@v11` |
| `actions/attest-build-provenance` | v4.2.2 | composite | `@v4` |
| `pnpm/action-setup` | v6.1.0 | node24 | `@v6` |
| `oven-sh/setup-bun` | v2.2.0 | node24 | `@v2` |
| `denoland/setup-deno` | v2.0.5 | node24 | `@v2.0.5` (no `v2` moving tag) |
| `dlang-community/setup-dlang` | v2.0.0 | node24 | `@v2` |
| `dtolnay/rust-toolchain` | (branches) | composite | `@stable` / `@nightly` / `@1.xx` |
| `Swatinem/rust-cache` | v2.9.2 | node24 | `@v2` |
| `softprops/action-gh-release` | v3.0.3 | node24 | `@v3` |
| `peaceiris/actions-gh-pages` | v4.1.0 | node24 | `@v4` |
| `peter-evans/create-pull-request` | v8.1.1 | node24 | `@v8` |
| `docker/setup-buildx-action` | v4.4.1 | node24 | `@v4` |
| `docker/setup-qemu-action` | v4.4.0 | node24 | `@v4` |
| `docker/login-action` | v4.6.0 | node24 | `@v4` |
| `docker/metadata-action` | v6.2.0 | node24 | `@v6` |
| `docker/build-push-action` | v7.4.0 | node24 | `@v7` |
| `github/codeql-action/*` | v4 line | node24 | `@v4` |
| `codecov/codecov-action` | v7.1.1 | composite | `@v7` |
| `dependabot/fetch-metadata` | v3.1.0 | node24 | `@v3` |
| `cloudflare/wrangler-action` | v4.1.3 | node24 | `@v4` |
| `nwtgck/actions-netlify` | v4.0.0 | node24 | `@v4` |
| `subosito/flutter-action` | v2.23.0 | composite (cache v5) | `@v2` |
| `mislav/bump-homebrew-formula-action` | v4.2 | node24 | `@v4` |
| `vedantmgoyal9/winget-releaser` | v2 line | composite | `@v2` |
| `antora-supplemental/antora-build-action` | v3.0.0 | composite (pnpm v6, setup-node v7) | `@v3` |

No Node 24 release yet (keep, recheck, or replace): `ilammy/msvc-dev-cmd` (v1.13.0 is node20; it still runs, forced onto Node 24, with a warning; alternative: call `vcvarsall.bat` from a shell step). `dlang-actions/setup-dmd` does not exist; use `dlang-community/setup-dlang@v2`.

## Breaking changes to handle when bumping

| Action | Watch for |
| --- | --- |
| `actions/checkout` v5-v7 | Needs runner v2.327.1+ (self-hosted). v6 stores persisted credentials in a separate file. v7 blocks checking out fork PR code in `pull_request_target` / `workflow_run` workflows. |
| `actions/setup-node` v5-v7 | Automatic package-manager caching (`package-manager-cache`, default on, npm only since v6); set `package-manager-cache: false` if it misbehaves. v7 no longer exports a dummy `NODE_AUTH_TOKEN`. Keep `pnpm/action-setup` **before** `setup-node` when using `cache: pnpm`. |
| `actions/download-artifact` v5, v8 | A single artifact downloaded by ID lands directly in `path/`. v8 fails on digest mismatch (`digest-mismatch: error`) and no longer unzips non-zip files. |
| `actions/upload-pages-artifact` v4+ | Dotfiles are excluded; v5 adds `include-hidden-files: true` if you need them. |
| `actions/github-script` v9 | `require('@actions/github')` inside the script fails; use the provided `github` / `getOctokit`. Do not redeclare `getOctokit` with `const` / `let`. |
| `actions/setup-python` v7 | `pip-install` input removed; run `pip install` in a step. |
| `actions/setup-java` v6 | `jdkFile` renamed `jdk-file` (old name still accepted with a warning). |
| `dlang-community/setup-dlang` v2 | `$DC` is now an absolute path (`dc_format: absolute`); scripts that compare `$DC` to `dmd` / `ldc2` must compare `$(basename "$DC")` instead. |
| `docker/build-push-action` v7 | `DOCKER_BUILD_NO_SUMMARY` / `DOCKER_BUILD_EXPORT_RETENTION_DAYS` env vars removed (use the action inputs). |
| `cloudflare/wrangler-action` v4 | Installs Wrangler v4 by default; pin `wranglerVersion` if the project is on v3. |
| `pnpm/action-setup` v6 | Adds pnpm 11; the `packageManager` field (or `version`) still decides which pnpm runs. |

## Dependabot: required in every repo with workflows

Copy this file to `.github/dependabot.yml` (template: [`skills/polyglot-ci/dependabot.yml`](../skills/polyglot-ci/dependabot.yml)). If the repo already has a `dependabot.yml`, **merge**: add the `github-actions` entry and keep the existing ecosystems untouched.

```yaml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "monthly"
    groups:
      github-actions:
        patterns:
          - "*"
    commit-message:
      prefix: "ci"
    open-pull-requests-limit: 5
```

- **Monthly** is the house default. Weekly produced a stream of one-line PRs nobody wanted to review; monthly plus a single group gives one PR per repo per month at most. Security updates are not affected by the schedule.
- `directory: "/"` covers `.github/workflows/` and a root `action.yml`. Composite actions in subfolders need `directories: ["/", "/path/to/action"]`.
- Dependabot only **opens** the PR. A person (or an auto-merge workflow) still has to merge it, so check repos for stale Dependabot PRs during maintenance sweeps.
- Do not add other ecosystems (npm, cargo, ...) as part of this rule; that is a per-project decision.

Syntax reference: <https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference>. Guide for humans: <https://docs.devcentr.org/general-knowledge/how-to/keep-github-actions-current/>.

## Agent checklist (any workflow edit)

1. Every `uses: owner/action@ref` is at the Pin above, or you verified a newer one with the commands above.
2. Composite actions you own (`action.yml` with `runs.using: composite`) were checked the same way; publish a new major tag instead of force-moving an old one.
3. Breaking-change table applied for each major you skipped.
4. `.github/dependabot.yml` exists with the grouped, monthly `github-actions` entry.
5. After pushing, open the run and confirm there is no "Node.js 20 is deprecated" (or newer runtime) annotation.

Related: skill `polyglot-ci`, skill `bootstrap-org`, skill `tag-release` (major tags for actions you publish).
