# Antora / Valentus / Facto (org)

Applies when creating or changing Antora playbooks, UI bundles, or docs hubs for owned orgs. Skill: **`antora-org-site`**.

## Valentus stays lean

- **Valentus** (`antora-supplemental/valentus-theme`, rolling `v2`) is the house **theme** suggestion — confirm before applying.
- Do **not** fold recommended playbook defaults (Lunr, STEM/math, Kroki/Mermaid/PlantUML, reused fragments) into Valentus core or the default `v2` bundle.
- Theme-only adopters must not be forced into the full stack.

## Facto compose pack

- **Facto** (`antora-supplemental/antora-facto`) is the named **compose pack** (VS Code extension-pack pattern): Valentus + Lunr + STEM/math + Kroki diagrams + **page-context** (+ optional neighbors documented there).
- Prefer pointing playbooks at Facto / its `playbook.fragment.yml` over inventing a parallel “full Valentus” product line.
- Page metadata: `page-*` attrs; Facto sets `page-context-active`. Body fallback pattern in `general/documentation.md`.

## Related content architecture

- **Internet Architecture / Internet Reliability** nests under DevCentr (`general-knowledge` body; portal `dev-centr/docs`). Peer of product SPE Architecture — not a new digital-/sys-architecture org for now.
- HCI Nerdz **Labels versus wires** remains the symptom ↔ diagnosis/treatment face (not the systems umbrella). Instruction-flows keeps the phrase *Navigating by content*.
- **connectome-fs** is substrate for content-addressed / wire identity claims.
