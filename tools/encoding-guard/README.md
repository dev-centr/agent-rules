# encoding-guard

Stops double-encoded UTF-8 ("mojibake", e.g. an em dash turned into three junk characters) from being committed. Policy and background: [`general/text-encoding.md`](../../general/text-encoding.md).

| File | Purpose |
| --- | --- |
| `check-mojibake.mjs` | Scanner and verified repair. No dependencies; Node 18+. `--staged`, `--fix`, `--json`, `--allow-non-utf8`. |
| `hooks/` | Global git hook dispatchers (one copy of `_dispatch.sh` per hook name). |
| `install-global-hooks.mjs` | Points `git config --global core.hooksPath` here, keeping any previous value chained. `--status [--scan <dir>]`, `--uninstall`, `--write-hooks`. |
| `../../.github/workflows/encoding-guard.yml` | Reusable CI workflow (`workflow_call`), the backstop. |

```text
node tools/encoding-guard/install-global-hooks.mjs          # once per machine
node tools/encoding-guard/check-mojibake.mjs --fix <paths>  # repair
git commit --no-verify                                       # bypass all hooks once
ENCODING_GUARD=0 git commit ...                              # skip only this check
```

Opt-outs for intentional examples: `mojibake-guard: allow` on a line, `mojibake-guard: allow-file` in the first 10 lines, or globs in `.encoding-allow` at the repo root.
