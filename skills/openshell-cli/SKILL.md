---
name: openshell-cli
description: >-
  Use when creating or changing a CLI, command-line help, help.sdl, prohelp,
  prohelp-cli, arsd.cli, --help, -help, first-run usage text, a daemon serve
  command, or a hand-written help string.
---

# OpenShellOrg CLI

A CLI uses the OpenShellOrg standards and the prohelp library. Detail: `general/openshell-cli.md`. Do not invent a second help screen in source code.

## Before writing the command

Read the page that matches the change:

- What it prints: [CLI Output](https://docs.opensh.org/open-shell-org/standard-cli-output/) (`CO-n`). House pointer `general/cli-output.md`.
- Help: [CLI Help](https://docs.opensh.org/open-shell-org/standard-cli-help/) (`CH-n`).
- Which arguments are a usage error: [CLI Dispatch](https://docs.opensh.org/open-shell-org/standard-cli-dispatch/) (`CD-n`).
- More than one running process: skill `service-manager` and [Service Manager](https://docs.opensh.org/open-shell-org/standard-service-manager/) (`SM-n`).

## Which library

- A new D command uses [prohelp-cli](https://github.com/openshellorg/prohelp-cli) and arsd.cli, and depends on [prohelp](https://github.com/openshellorg/prohelp). The router parses and runs. Prohelp renders help.
- A D command that already has a parser calls `prohelp.intercept` on the argument list before that parser, with the authored `help.sdl` passed in (`InterceptConfig.fromContent` or `fromFile`). Bare invocation and `?`, `help`, `-h`, and `-help` render that file.
- Node, or any other language, ships the same `help.sdl` and renders it with the `prohelp` executable (`prohelp -f <file> ?`). It does not keep a `printHelp` string.

`help.sdl` is the only copy of the help. A string in `main` that repeats it is a bug.

## Help file

The file is SDL. The root is `command "<name>"` with `summary`, `description`, and `section` blocks for the jobs a new person does first (`start`, then the other groups). The first section is the start path from skill `new-user-text`. A service start section matches the Service Manager card: background by default, the id, the stop command, and `-listen`.

Cite `CO-n`, `CH-n`, `CD-n`, and `SM-n` in the change notes. Do not paste those standards into the tool's repository.
