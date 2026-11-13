---
name: service-manager
description: >-
  Use when a service, daemon, or server can run more than once, serve command,
  detach, background server, -listen, --listen, server 1, stop an instance,
  manager process, which terminal spawned a server, listen mode, singleton
  server, multiple instances, pid to kill, SM-1, service manager standard.
---

# Service manager

A service that can have more than one process on one machine follows the OpenShellOrg Service Manager standard. That page is the rule. Do not copy it into the tool's docs. Cite `SM-n`.

https://docs.opensh.org/open-shell-org/standard-service-manager/

Source: https://github.com/openshellorg/docs/blob/main/docs/modules/ROOT/pages/standard-service-manager.adoc

House pointer: `general/service-manager.md`.

## Decide first

A singleton has at most one process for that role on the machine. A second start finds that process and reports it. Stop takes no id. Do not assign `server 1`.

Every other service is this skill. Read the standard before writing the start command.

## What the command does

- `serve` detaches. It prints the id, the process id, the address, the terminal that spawned it, `serve stop 1`, `serve status`, and a line that names `-listen`. The log path is the last line. The command then exits. The instance keeps running.
- `serve -listen` stays in this terminal and prints output as it happens. The manager still records it, with mode `listen`, and records that this terminal is showing the output.
- `serve status` lists every instance. Each row says `detached` or `listen`, who spawned it, and which terminal is showing it. A detached row says the output is in the log. A second block groups those rows by terminal.
- `serve stop 1`, `serve stop server 1`, and `serve stop` with no id (that stops every instance).

One manager holds the set. It starts with the first instance and exits when the last one is gone. The person does not start the manager by a separate name.

The first screen of that command follows skill `new-user-text`, and the words live in `help.sdl` rendered by prohelp (skill `openshell-cli`). The sentence says the instance is in the background, or that this window is showing it. The id and the stop command come next.

## Do not

Do not make the process id the way a person stops an instance. Do not leave a detached instance's output only in a terminal that has already returned. Do not invent a second id scheme beside `1` and `server 1`. Do not keep the manager running after the last instance is gone.
