---
name: chat-file-links
description: >-
  Use when mentioning a file you are working on, just edited, or that the
  user asked about; file name as a markdown link; workspace-relative path
  with forward slashes; no file://; no Windows backslashes; no drive-letter
  links; do not link incidental mentions of a common filename;
  CHAT_FILE_LINKS; chat file links.
---

# Chat file links

When you mention a file you are working on, just edited, or that the user asked about, the file name is a markdown link to the workspace-relative path with forward slashes.

- Link text is the file name (the basename).
- The target is the workspace-relative path using forward slashes. Example: [`SKILL.md`](skills/write-a-skill/SKILL.md).
- Do not use `file://`.
- Do not use Windows backslashes in the link.
- Do not use drive-letter links (`C:/...`, `Z:/...`).
- Do not link incidental mentions of a common filename as a concept.
- Line ranges use the harness code-citation fence (`startLine:endLine:filepath`), not a markdown URL with `#L`.
- A backtick-wrapped relative path is not a substitute for this link on a file you edited or that the user asked about.

Follow `CHAT_FILE_LINKS` in `$HARNESS` when it names another mode. The default mode is `markdown-workspace-links` (this skill). `plain-paths` and `harness-default` are recorded in `general/harness.md`.
