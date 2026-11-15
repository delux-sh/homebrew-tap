# delux-sh/homebrew-tap

Homebrew formulae for [Delux](https://github.com/delux-sh/delux), which finds your tmux sessions across your computers and attaches to them over SSH.

This tap is in private, pre-release testing and does not yet contain a published formula. After the first public release:

```bash
brew tap delux-sh/tap
brew trust --formula delux-sh/tap/delux
brew install delux-sh/tap/delux
```

Current Homebrew requires explicit trust before loading third-party formula code. This trusts only Delux, not every formula in the tap.

The planned formula covers macOS Apple Silicon and Intel, and Linux ARM64 and x86_64, using prebuilt archives attached to each [Delux release](https://github.com/delux-sh/delux/releases). It installs tmux and, on Linux, OpenSSH; macOS uses its system OpenSSH. Remote computers need their own SSH server and tmux 3.2+ installation, but no Delux service. This is a project-maintained tap, not a listing in `homebrew/core`.

## Manual publication

The first formula and this tap will be published only after separate maintainer approval. After the Delux GitHub release is published, download its actual `SHA256SUMS` and archives, verify the checksums, and run `scripts/homebrew-formula.sh VERSION SHA256SUMS` from the matching Delux source to generate `Formula/delux.rb`. Never use guessed or dry-run checksums. Review the formula, install it with full dependency resolution from the published URLs in a clean Homebrew environment, and run `brew test delux` and `brew audit --strict delux` before publishing the tap. No automatic workflow update or Homebrew token is required. See Delux's [release process](https://github.com/delux-sh/delux/blob/main/CONTRIBUTING.md#preparing-and-publishing-a-release).

If an older manual Delux binary shadows Homebrew's installation, check `command -v delux` and adjust your `PATH`.

Problems with Delux itself go to [delux-sh/delux issues](https://github.com/delux-sh/delux/issues).

## License

The tap is [MIT licensed](LICENSE). Delux itself is licensed under [GPL-3.0-or-later](https://github.com/delux-sh/delux/blob/main/LICENSE); the tap's license does not relicense Delux or its bundled dependencies.
