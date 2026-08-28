# harness.example.md (committed template)

Copy to **`$CODE_ROOT/harness.md`** on each workstation. That file is **machine-local** (harness rules for this user's machine) and must **not** be committed.

Your agent discovers how this workstation runs AI assistants and writes concrete values here — **never** into forkable templates (`user.md`, `AGENTS.md`, `profiles/*.md` in upstream, skill bodies).

Polyglot harness use is normal: one machine may run Cursor, Claude Code, Hermes, or T3code on different days. Record what applies **on this machine**; re-probe when the harness changes.

## Variables (fill on this machine)

```text
HARNESS_NAME = <cursor | claude-code | hermes | t3code | windsurf | other>
HARNESS_VERSION = <optional; if the harness exposes a version string>

# Where always-on rules are injected (Settings field, CLAUDE.md, system prompt file, etc.)
ALWAYS_ON_RULES = <description or path>

# Where this harness discovers installed agent skills (if any)
SKILLS_DISCOVERY_ROOT = <path or "none — load from $AGENT_RULES_PATH/skills/<name>/ directly">

# Machine-local rules overlay — does not sync across machines or harness accounts
LOCAL_RULES_DIR = <path or none>

# How to link canonical skills into SKILLS_DISCOVERY_ROOT (examples below)
SKILLS_INSTALL = <junction | copy | harness-native | none>

# Chat / editor behaviors (see general/harness.md)
CHAT_FILE_LINKS = markdown-workspace-links | plain-paths | harness-default
CODE_CITATION = line-range-fence | none | harness-default
IDE_PROJECT_RULES = mdc-in-repo | claude-rules | none

# Integrations probed on this machine
MCP_CONTEXT7 = available | unavailable
MCP_OTHER = <optional list>

# Last successful sync-agent-rules run (machine-local stamp; skill sync-agent-rules)
AGENT_RULES_SYNCED_SHA = <git SHA of $AGENT_RULES_PATH HEAD after sync, or empty>
AGENT_RULES_SYNCED_LABEL = <skills-set/YYYY.MM.DD from nearest tag, or empty>
AGENT_RULES_SYNCED_AT = <ISO-8601 date, or empty>

# Token provenance — inline heuristic vs grounded marks (HCI Nerdz contract)
# emit-spans: runtime attaches span metadata alongside streamed text
# consume-spans: renderer styles incoming provenance from another harness
# off: plain text only
TOKEN_PROVENANCE = emit-spans | consume-spans | off

# Project inbox — parallel task grid (HCI Nerdz contract; DevCentr harness routing)
# grid-forks: card grid + cosmetic fork views; serialized: all lines in main scroll; off: single-task
PROJECT_INBOX = grid-forks | serialized | off
PROJECT_INBOX_CHAPTERS = on | off
PROJECT_INBOX_WAIT_GRAPH = enforce | warn | off
```

## Example: Cursor on Windows

```text
HARNESS_NAME = cursor
ALWAYS_ON_RULES = Cursor Settings → User Rules (composed via rules-manager)
SKILLS_DISCOVERY_ROOT = C:\Users\<you>\.cursor\skills
LOCAL_RULES_DIR = C:\Users\<you>\.cursor\rules
SKILLS_INSTALL = junction from $AGENT_RULES_PATH/skills/<name>/ to SKILLS_DISCOVERY_ROOT/<name>/
CHAT_FILE_LINKS = markdown-workspace-links
CODE_CITATION = line-range-fence
IDE_PROJECT_RULES = mdc-in-repo
MCP_CONTEXT7 = available
TOKEN_PROVENANCE = off
PROJECT_INBOX = serialized
PROJECT_INBOX_CHAPTERS = off
PROJECT_INBOX_WAIT_GRAPH = off
AGENT_RULES_SYNCED_SHA =
AGENT_RULES_SYNCED_LABEL =
AGENT_RULES_SYNCED_AT =
```

## Example: direct filesystem load (no skill discovery dir)

```text
HARNESS_NAME = other
ALWAYS_ON_RULES = pasted user.md preamble in harness system prompt
SKILLS_DISCOVERY_ROOT = none — read $AGENT_RULES_PATH/skills/<name>/SKILL.md on demand
LOCAL_RULES_DIR = none
SKILLS_INSTALL = none
CHAT_FILE_LINKS = plain-paths
CODE_CITATION = none
IDE_PROJECT_RULES = none
MCP_CONTEXT7 = unavailable
TOKEN_PROVENANCE = off
PROJECT_INBOX = serialized
PROJECT_INBOX_CHAPTERS = off
PROJECT_INBOX_WAIT_GRAPH = off
AGENT_RULES_SYNCED_SHA =
AGENT_RULES_SYNCED_LABEL =
AGENT_RULES_SYNCED_AT =
```

## Relationship to other layers

See **Layer names vs harness vocabulary** in https://docs.devcentr.org/agent-rules/harness-neutral.html — how `user.md`, `harness.md`, and `machine.md` map to Cursor User Rules, `CLAUDE.md`, etc.

| File | Role |
| --- | --- |
| `$CODE_ROOT/harness.md` | **Harness rules** — discovery paths, chat behaviors, always-on slot, sync stamp |
| `$CODE_ROOT/machine.md` | **Machine rules** — tool paths, PATH gaps, hardware (see `machine.example.md`) |
| `user.md` in **agent-rules** | **User rules** — portable preamble (forkable) |
| `profiles/<machine>.md` in **your fork** | Machine constants: `CODE_ROOT`, `GITHUB_USER`, `ENVIRONMENT`, `ISSUES_REPO` |
| `LOCAL_RULES_DIR` overlay | Per-harness local rules (e.g. `%USERPROFILE%\.cursor\rules\*.mdc`) |

## Agent obligation

Before editing anything under `$AGENT_RULES_PATH`, read **`general/harness-boundary.md`**. When setup is missing or stale, run skill **`harness-setup`**. When skills/discovery/`AGENT_RULES_SYNCED_SHA` drift, run skill **`sync-agent-rules`**.
