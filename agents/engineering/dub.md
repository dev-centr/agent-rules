# DUB packages (org)

Applies to **devcentr** and other org repos that use DUB. Repo-specific overrides stay in that repo’s `AGENTS.md`.

## Registry and pins

- `repo-get` is on the DUB registry (`~>0.2.1`); GitHub webhook on `dlang-supplemental/repo-get` keeps it synced. Prefer registry over git pins in dependents.
- `arsd-official` for Dev Center is **11.5.3** (matches dlangui). Do not `dub add-local` `.forks/arsd` as 10.9.10.
- Intentional local package: `unit-threaded` 0.7.55 → `devcentr/unit-threaded` via `dub add-local`.
- Do not recreate deprecated `%LOCALAPPDATA%\dub\packages\local-overrides.json`; prefer `dub add-local`.

## Publishing to code.dlang.org

Official `dub` has **no** `publish` command. When the user asks to **publish to dub / dlang**, use Cursor skill `publish-to-dub` (`skills/publish-to-dub/`) — `dubx` / `dub-publish`. Do not paste that skill body here.

Always **set registry categories** (1–4 taxonomy ids) as part of that skill — infer, `dubx categories`, verify JSON. Do not leave them empty for the web UI.
