# Service manager

A service that can run more than once follows the **OpenShellOrg Service Manager standard**: https://docs.opensh.org/open-shell-org/standard-service-manager/
(source: https://github.com/openshellorg/docs/blob/main/docs/modules/ROOT/pages/standard-service-manager.adoc).

The standard is canonical. Do not copy it here. Read it when a command starts a process that is not a singleton.

Short version:

- One manager remembers every instance. It exits when the last instance is gone.
- Ids are `1` and `server 1`. The person stops an instance with that id, not with the process id.
- Start detaches. The command prints the id, the stop command, which terminal spawned it, and the log path. `-listen` keeps the output in this window.
- The manager records `detached` or `listen`, which terminal spawned the instance, and which terminal is showing the output.
- A singleton stays one process and does not use this id space.

Cite requirement ids (`SM-n`) in reviews and issues.
