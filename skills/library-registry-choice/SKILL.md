---
name: library-registry-choice
description: >-
  Use when creating a library, scaffolding a publishable package, adding a
  dependency on an owned or local library, path dependency, file: dependency,
  pathDependency, "use locally", "publish the library", registry vs local disk,
  npm/DUB/PyPI/crates.io/NuGet choice for a new package, or when bootstrap-org
  / ship-app hits a library profile or unpublished owned dep.
---

# Library: registry publish vs local path

When creating a **library that belongs on a package registry**, or a **project that depends on** such a library (especially owned / in-hive / unpublished), do not silently wire a path dependency or skip the registry.

## Checklist

```
- [ ] Identify each candidate library (new package or owned dep)
- [ ] Pick the natural registry for the ecosystem ([registries.md](registries.md))
- [ ] If consuming: check whether it is already published under the expected name
- [ ] Ask: publish to registry vs use on local disk (path)
- [ ] Encourage publish; name the registry
- [ ] Apply the choice (publish hand-off or path wiring)
```

## When this applies

Run this before locking dependency metadata (`package.json`, `dub.sdl` / `dub.json`, `Cargo.toml`, `pyproject.toml`, etc.):

1. **New library / package** the user is scaffolding (bootstrap `library` profile, crate, DUB package, npm package, PyPI module, …).
2. **Consumer project** that would depend on an **owned**, **in-hive**, or **unpublished** library that *would* make sense on a registry.
3. Skip for throwaway experiments the user already called private/local-only, or for third-party deps that are already clearly registry-published.

## Steps

### 1. Identify candidates

Name each library in play (new or dep). Note language/ecosystem and proposed package name.

### 2. Suggest the registry

Use [registries.md](registries.md). State **one** primary registry (and the publish skill/tool if we have one). Do not leave "wherever" open.

### 3. Check published status (when consuming)

If the project **depends on** a library:

- Look up the expected package name on that registry (CLI, web, or registry API).
- Report: **published** (version/range usable) vs **not found** / **wrong owner** / **name taken by someone else**.

If **creating** the library itself, skip the lookup unless renaming against an occupied name matters.

### 4. Ask before wiring

Ask explicitly (AskQuestion when available):

- **Publish** to the suggested registry (preferred default stance), or
- **Use locally on disk** (path / `file:` / pathDependency / workspace link)

Do not default to path wiring without that answer.

### 5. Encourage publish

Prefer registry install for anything meant to be reused across repos or by others. Say why briefly: reproducible installs, SemVer ranges, CI without hive paths, discoverability.

Local path is fine for same-repo workspaces, active co-development across two checkouts, or when they decline publish.

### 6. Apply the choice

| Choice | Do |
| --- | --- |
| **Publish** | Finish package metadata + README install line; hand off to the ecosystem publish path (`publish-to-dub` for D; `tag-release` + registry notes for others). Do not invent credentials. |
| **Local disk** | Wire the path dependency correctly for the package manager; note in chat that they can publish later and switch to a version range. |
| **Already published** | Prefer the registry version/range unless they insist on a path override for local edits. |

## Related

- DUB submit/register: skill `publish-to-dub`
- Version tags / registry refresh: skill `tag-release` (`registries.md` there)
- Org/library scaffold: skill `bootstrap-org` (load this skill when `library` / registry is in scope)
- Product scaffold: skill `ship-app`
