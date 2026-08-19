# Contributing

## Upstream

Portable rules belong in `general/`.

Open pull requests against **this** repository ([`dev-centr/agent-rules`](https://github.com/dev-centr/agent-rules)) for shared improvements. Keep personal constants and org-specific examples in **your own fork** or machine files (`$CODE_ROOT/harness.md`, `$CODE_ROOT/machine.md`).

**Dev-Centr product behavior** (automation acting for the user) belongs in [dev-centr/devcentr-agent-rules](https://github.com/dev-centr/devcentr-agent-rules), not in this repository.

## Harness-neutral policy

Do **not** embed harness names, discovery paths, or machine paths in forkable templates. Use placeholders and `$HARNESS` variables. See `general/harness-boundary.md` and https://docs.devcentr.org/agent-rules/harness-neutral.html.

## Profiles

Add new device templates under `profiles/` with clear constant names. Prefer one file per machine or role rather than many overlapping names. Use **placeholder** values in upstream examples. Profiles must set **`ENVIRONMENT`** (`windows`, `mac`, or `linux`).

## Layout

- `general/harness.md`, `general/harness-boundary.md` — harness-neutral operations and template boundary
- `harness.example.md` — machine-local harness config template (copy to `$CODE_ROOT/harness.md`)
- `general/environment.md` — cross-platform.
- `general/windows.md`, `general/mac.md`, `general/linux.md` — OS-specific tooling and shells.
- `general/documentation.md` — optional doc authoring (Diátaxis, Antora when used).
- `skills/BOOTSTRAP.md` — shop entry for optional agent skills (not MAIN assembly).
