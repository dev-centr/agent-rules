# Runner notes

- GitHub-hosted macOS is Apple Silicon (`macos-14`, `macos-15`). Do not schedule `macos-13` for x64.
- `windows-11-arm` and `ubuntu-24.04-arm` are GitHub-hosted ARM. If a job is skipped in the org, still **name** the triplet in docs so self-hosted can fill it.
- FreeBSD: Cirrus `freebsd-14-2` (x64). ARM BSD is usually a self-hosted VM.
- Cache compilers (`dlang-community/setup-dlang`, `dtolnay/rust-toolchain`, `actions/setup-node`) per job, not a mega-image.
- Action versions: latest major on the current runner Node runtime, verified against the release and `action.yml` (never from memory). Table and commands: `general/github-actions-versions.md`. Pin by SHA only when the repo already pins (Dependabot updates SHA pins too).
