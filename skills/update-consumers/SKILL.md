---
name: update-consumers
description: >-
  Use when updating consumers, bump dependents, recursive consumer fan-out,
  fan out after a library release, update all dependents, consumers of
  consumers, intermediate package bump, discover dependents after ship,
  specialization scan for consumer updates, update-consumers skill.
---

# Update consumers (recursive fan-out)

Generic procedure after releasing or bumping any **library, package, extension, theme, or compose pack** **P**. Domain-specific discovery and pin rules live in **specialization skills** — this skill owns the BFS and the scan that loads them.

Pair with **`tag-release`** (cutting tags) and **`push-code`** / **`github-repo-access`** (per-repo push route).

## Specialization scan (required)

Before discovering consumers, **scan** installed skills for specializations of this job.

1. Roots: `$AGENT_RULES_PATH/skills/` and, when distinct, `$SKILLS_DISCOVERY_ROOT/` (from `$CODE_ROOT/harness.md`).
2. For each `*/SKILL.md`, read YAML frontmatter. A specialization declares:

```yaml
update-consumers:
  when:
    - antora-supplemental   # org, repo name, ecosystem keyword, or path fragment
    - antora-search-chat
```

3. Match **case-insensitive** against P’s GitHub `owner`, `repo`, npm/package name, and a short ecosystem label the agent already knows (e.g. `antora`, `dub`).
4. **Load every matching specialization** (Read the skill body) before fan-out. Apply their discovery, topic/tag, and pin rules.
5. If **none** match: use § Default discovery only; do not invent Antora-only (or other domain) conventions.

**Authoring a specialization:** one skill per ecosystem/job; declare `update-consumers.when`; keep recursive BFS out of the specialization — call this skill for the walk. Inventory: `skills/CATALOG.md` (note `specializes: update-consumers`).

## Recursive fan-out (required)

```
queue ← [P]
visited ← ∅
specializations ← scan (above)
while queue not empty:
  X ← dequeue
  consumers ← discover(X) via specializations, else § Default discovery
  for each consumer C in consumers, skip X itself:
    if C ∈ visited: continue
    visited ← visited ∪ {C}
    bump C’s pin / lockfile / artifact ref for X (per specialization pin rules)
    ensure discovery tags/topics specializations require
    changelog when the consumer repo keeps one
    if C is itself a consumable package
       AND C changed in a way dependents must pick up
       (new tag, moved rolling line, or change inside C’s published artifact):
         cut/move tags per tag-release when a release is warranted
         enqueue C
```

**Leaf apps / docs hubs / binaries** that are not themselves dependencies: bump + stop (do not enqueue).

**Intermediate packages** (A depends on P; B depends on A):

1. Bump A’s pin of P.
2. If A **ships** that change to B (published files, UI bundle, compose fragment, registry tarball), release/retag A when needed, then enqueue A.
3. If the change is **dev-only** inside A (tests, demos that do not alter A’s published artifact), bump A but **do not** enqueue A’s consumers solely for that — unless those consumers also depend on P directly (they already appear in P’s discovery).

Never stop after the first layer when an intermediate **published** artifact moved.

## Default discovery (no specialization)

Use whatever the package ecosystem already provides, in order:

1. Registry dependents / GitHub Dependency graph / `gh` search for the package name in manifests, when available
2. Hive grep of lockfiles and manifests under `$CODE_ROOT`
3. Ask the user if discovery is empty and the package is known to have consumers

Do **not** assume GitHub repository topics unless a loaded specialization defines that convention.

## Agent checklist

1. Resolve P (repo, package id, new pin / tag / rolling line).
2. Run § Specialization scan; load matches.
3. BFS § Recursive fan-out.
4. Commit/push each consumer per `push-code`.
5. Report: specializations loaded, direct consumers, intermediates released, second-hop updates, discovery gaps fixed.

## Anti-patterns

- Hard-coding Antora (or any one ecosystem) rules in this skill
- Skipping the specialization scan because “we already know the consumers”
- Bumping an intermediate and skipping *its* consumers when a release/rolling tag moved
- Stopping at layer one when consumers-of-consumers must move
