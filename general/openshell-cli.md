# OpenShellOrg CLI stack

A CLI we build uses the OpenShellOrg standards and the prohelp library. Do not hand-write a second help screen.

| Job | Where |
| --- | --- |
| What the command prints | [CLI Output](https://docs.opensh.org/open-shell-org/standard-cli-output/) (`CO-n`). Pointer: `general/cli-output.md`. |
| Help | [CLI Help](https://docs.opensh.org/open-shell-org/standard-cli-help/) (`CH-n`). The text is an authored `help.sdl`, rendered by [prohelp](https://github.com/openshellorg/prohelp). |
| Which arguments are errors | [CLI Dispatch](https://docs.opensh.org/open-shell-org/standard-cli-dispatch/) (`CD-n`). |
| More than one process | [Service Manager](https://docs.opensh.org/open-shell-org/standard-service-manager/) (`SM-n`). Pointer: `general/service-manager.md`. |

Skill: `openshell-cli`.

Libraries:

- New D command: [prohelp-cli](https://github.com/openshellorg/prohelp-cli) with arsd.cli, plus prohelp. Parsing stays in the router. Help stays in prohelp.
- D command that already has a parser: `prohelp.intercept` and `help.sdl` before that parser. `help.sdl` is the only help text.
- Any other language: the same `help.sdl`, rendered by the `prohelp` executable. Do not write another help renderer.
