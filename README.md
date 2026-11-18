# delux-sh/homebrew-tap

Homebrew formulae for [Delux](https://github.com/delux-sh/delux), which finds your tmux sessions across your computers and attaches to them over SSH.

Install Delux with [Homebrew](https://brew.sh) on macOS or Linux:

```bash
brew install delux-sh/tap/delux
```

The formula covers macOS Apple Silicon and Intel, and Linux ARM64 and x86_64, using prebuilt archives attached to each [Delux release](https://github.com/delux-sh/delux/releases). It installs tmux and, on Linux, OpenSSH; macOS uses its system OpenSSH. Remote computers need their own SSH server and tmux 3.2+ installation, but no Delux service. This is a project-maintained tap, not a listing in `homebrew/core`.

On Intel macOS, Homebrew no longer supplies dependency bottles, so installation can include slow source builds. Delux itself still uses a prebuilt archive; native Intel checks remain part of the release gate.

## Updating the formula

The formula is updated by hand after each Delux GitHub release, never automatically. Generate `Formula/delux.rb` from that release's published `SHA256SUMS` with `scripts/homebrew-formula.sh` from the matching Delux source; never use guessed or dry-run checksums. Install it from the published URLs with full dependency resolution, then run `brew test delux` and `brew audit --strict delux` before merging the tap update. See Delux's [release process](https://github.com/delux-sh/delux/blob/main/CONTRIBUTING.md#preparing-and-publishing-a-release).

Pull requests run native formula checks on macOS Apple Silicon and Intel, and Linux ARM64 and x86_64. Each clean runner installs the proposed formula from its published release URLs with dependencies, then runs `brew test` and `brew audit --strict`. Merge a formula update only after all four checks pass.

If an older manual Delux binary shadows Homebrew's installation, check `command -v delux` and adjust your `PATH`.

Problems with Delux itself go to [delux-sh/delux issues](https://github.com/delux-sh/delux/issues).

## License

The tap is [MIT licensed](LICENSE). Delux itself is licensed under [GPL-3.0-or-later](https://github.com/delux-sh/delux/blob/main/LICENSE); the tap's license does not relicense Delux or its bundled dependencies.
