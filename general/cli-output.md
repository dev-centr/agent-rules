# CLI output

CLIs we build follow the **OpenShellOrg CLI Output standard**: https://docs.opensh.org/open-shell-org/standard-cli-output/
(source: https://github.com/openshellorg/docs/blob/main/docs/modules/ROOT/pages/standard-cli-output.adoc).

The standard is canonical. Do not copy it here; read it when designing what a command prints. Short version:

- Default output: outcome, what changed, what needs a decision, then the absolute log path as the last line.
- Routine checks, progress, and dependency warnings go to a sectioned log (one-line summary at most, pointing at the log section).
- Failures print the reason inline; never make someone open the log to learn why it failed.
- Provide `--verbose` (+ `<TOOL>_VERBOSE`), `--json` / JSON Lines, per-OS log locations with rotation, meaningful exit codes, results on stdout and diagnostics on stderr.

Cite requirement ids (`CO-n`) in reviews and issues.