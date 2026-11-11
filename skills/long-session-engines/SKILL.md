---
name: long-session-engines
description: >-
  Use when a desktop app or agent session stays open a long time, UI uptime,
  thin host, UI engine, session engine, nested engines, child engine crash,
  crash reboot loop, hot swap a UI library, window stays up, long-running
  agent desktop, decouple a crashing sub-engine from its parent.
---

# Long-session engines

Keep durable state in a session engine. Keep the window up except when the frame that owns it crashes. Detail, options, and diagrams: `general/long-session-engines.md`.

Pick the smallest option that meets the uptime goal:

1. **Session engine and one UI program.** The window may restart. It reads the session file again.
2. **UI thin host and UI engine.** The host owns the window and reloads the UI library. Use this when a screen change should not close the window.
3. **Nested engines.** A child engine restarts in its own loop. The parent stays up.

A new session-engine build migrates the session file before it serves. The MSIX or per-user update dance in the detail file stays on the session engine. The UI host does not have to take part.
