# wmxscott/homebrew-tap

Homebrew formulas for small macOS tools.

```sh
brew tap wmxscott/tap
```

| Formula | What it does |
|---|---|
| [`git-autofetch`](https://github.com/wmxscott/git-autofetch) | Keeps git remotes up to date in the background, logging in at most once per host so ssh never prompts while you're away |
| [`herdr-wkt`](https://github.com/wmxscott/herdr-wkt) | Git worktrees that open as Herdr workspaces, with `wkt` as a short alias |
| [`pr-tracker`](https://github.com/wmxscott/pr-tracker) | Tracks the pull requests your AI agent sessions open, and tells each session when checks or reviews change |
| [`seckey-dialog`](https://github.com/wmxscott/seckey-dialog) | Native macOS PIN, passphrase and touch prompts for gpg-agent and ssh, for hardware security keys |
| [`theme-monitor`](https://github.com/wmxscott/theme-monitor) | Writes the macOS light/dark appearance to a file whenever it changes, so terminal tools can follow dark mode |
| [`upkeep`](https://github.com/wmxscott/upkeep) | Runs your update commands (brew, mise, npm and the like) in parallel, on demand or on a catch-up schedule |

Install one without tapping first:

```sh
brew install wmxscott/tap/theme-monitor
```

Formulas that run in the background ship a `brew services` definition:

```sh
brew services start theme-monitor
```

## Releasing a new version

1. Tag the release in the tool's repository (`vX.Y.Z`) and push the tag.
2. In `Formula/<tool>.rb`, update `url` to the new tag and `sha256` to the tarball's checksum:

   ```sh
   curl -sL https://github.com/wmxscott/<tool>/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
   ```

3. Open a pull request. CI checks style, audits the formula, builds it from source and runs its test.

## License

[MIT](LICENSE)
