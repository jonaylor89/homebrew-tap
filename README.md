# homebrew-tap
Tap for Homebrew formulae and casks.

## Mino

Install [Mino](https://mino.so/), a native macOS email client:

```sh
brew install --cask jonaylor89/tap/mino
```

Requires macOS 14 (Sonoma) or later. Supports Apple Silicon and Intel Macs.

### Automatic release updates

The **Update Mino cask** GitHub Actions workflow checks Mino's public release
manifest hourly (at minute 17) and can also be run manually. When a newer stable
release is available, it downloads the DMG, verifies its published SHA-256,
and commits the new version and checksum to `main` using Jujutsu (`jj`).
The workflow installs a pinned, checksum-verified `jj` release and uses the
repository's `GITHUB_TOKEN` for authentication. No private Mino repository
access or additional secrets are needed. Unchanged releases create no commits;
invalid releases, checksum mismatches, and downgrades fail without changing the cask.

Actions must be enabled and the workflow's `GITHUB_TOKEN` must be allowed to
push to `main` (including any branch protection rules). GitHub may delay scheduled
runs or disable them after 60 days of repository inactivity; re-enable the workflow
if needed. Updates appear on the next successful check, not immediately on release.

Run the updater and its tests locally:

```sh
python3 -m unittest discover -s tests -v
python3 scripts/update-mino.py
```
