# Which registry to suggest

Pick **one** primary registry from the language/ecosystem. Mention the CLI or skill used to publish when known.

| Ecosystem | Primary registry | Typical publish path |
| --- | --- | --- |
| **D** | [code.dlang.org](https://code.dlang.org) (DUB) | Skill `publish-to-dub` (`dubx` / `dub-publish`); SemVer tags |
| **JavaScript / TypeScript** | [npmjs.com](https://www.npmjs.com) (npm) | `pnpm publish` / npm after `tag-release` as needed |
| **Python** | [PyPI](https://pypi.org) | `uv publish` / twine; version from project metadata |
| **Rust** | [crates.io](https://crates.io) | `cargo publish` |
| **Go** | Module proxy / [pkg.go.dev](https://pkg.go.dev) | Tagged SemVer modules on the forge (no separate "register" for most) |
| **.NET** | [NuGet.org](https://www.nuget.org) | `dotnet nuget push` |
| **Ruby** | [RubyGems](https://rubygems.org) | `gem push` |
| **PHP** | [Packagist](https://packagist.org) | Packagist + VCS tags |
| **Java / Kotlin (Maven)** | Maven Central (or org's chosen repo) | Publishing plugin + Sonatype/Central flow |
| **Swift** | Swift Package Index / git tags | SPM via repository tags |
| **Elixir** | [Hex](https://hex.pm) | `mix hex.publish` |

## Notes

- Prefer the **language-default** public registry over a private mirror unless the user already uses an org registry.
- If the package is **docs-only** or **app binary** with no library consumers, this skill usually does not apply (see `ship-app` / installers instead).
- Dual-language wrappers: name the registry for **each** publishable artifact, and ask once per artifact.
- Name collisions: if the desired name is taken by someone else, stop and ask for a scoped/alternate name before publishing or depending.
