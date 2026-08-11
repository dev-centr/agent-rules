# Contributing

## Upstream

Portable rules belong in `general/`.

Open pull requests against **this** repository ([`dev-centr/agent-rules`](https://github.com/dev-centr/agent-rules)) for shared improvements. Keep personal constants and org-specific examples in **your own fork**.

**Dev-Centr product behavior** (automation acting for the user) belongs in [dev-centr/devcentr-agent-rules](https://github.com/dev-centr/devcentr-agent-rules), not in this repository.

## Profiles

Add new device templates under `profiles/` with clear constant names. Prefer one file per machine or role rather than many overlapping names. Use **placeholder** values in upstream examples; personal paths belong in forks. Profiles must set **`ENVIRONMENT`** (`windows`, `mac`, or `linux`).

## Layout

- `general/environment.md` — cross-platform.
- `general/windows.md`, `general/mac.md`, `general/linux.md` — OS-specific tooling and shells.
- `general/documentation.md` — optional doc authoring (Diátaxis, Antora when used).
- `skills/BOOTSTRAP.md` — shop entry for optional Cursor skills (not MAIN assembly). Deep docs: general-knowledge *Vibe coding bootstrap*.
