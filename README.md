# fish config

Personal fish config, shared between macOS and CachyOS. Meant to be cloned
straight into `~/.config/fish`.

## Layout

- `config.fish` — interactive-shell setup (prompt, abbreviations, tool
  integrations). OS-specific bits are guarded by `set -l os (uname)` checks.
- `conf.d/00-env.fish` — runs on every fish invocation (env vars only).
- `conf.d/10-login.fish` — login-shell setup (Homebrew, PATH, umask).
- `fish_plugins` — fisher's plugin manifest (currently just fisher + tide).
- `fish_variables` — **not tracked**, see below.
- `.githooks/pre-push` — blocks pushes containing likely secrets (gitleaks).

## Fresh clone, either OS

```fish
# back up whatever's already at ~/.config/fish first if it's not empty
git clone <this-repo-url> ~/.config/fish
cd ~/.config/fish
git config core.hooksPath .githooks   # per-clone; doesn't travel with git clone
```

`fish_variables` is gitignored on purpose: it's mostly tide's prompt render
cache (churns every session) plus absolute paths that don't carry across
machines. That means a fresh clone starts with no tide theme configured and
an empty `fish_user_paths` — expected, not broken. Fix it with:

```fish
fisher update        # (re)installs plugins listed in fish_plugins
tide configure        # walks the tide prompt wizard again
```

## macOS-specific

1. Install [Homebrew](https://brew.sh) if you haven't.
2. `brew install fish gitleaks` (add `eza`, `bat`, `ripgrep`, `fd`, `dust`,
   `duf`, `procs`, `bottom`, `sd`, `git-delta`, `jq`, `shellcheck`,
   `hyperfine`, `tokei` as wanted — everything referencing them is guarded
   with `type -q`, so skipping any of them just skips that abbreviation).
3. Add fish to `/etc/shells` and `chsh -s /opt/homebrew/bin/fish` if it's not
   already your login shell.
4. `conf.d/10-login.fish` sources `brew shellenv` and wires up
   Homebrew-specific things (ImageMagick, cask install dir) automatically —
   nothing to configure by hand there.
5. Docker Desktop, if installed, patches the top of `config.fish` itself on
   install/reinstall; that block is already guarded to only run on Darwin.

## CachyOS-specific

1. fish is already the default shell, no `chsh` needed.
2. Install fisher manually (no Homebrew tap for it):
   ```fish
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
   fisher install jorgebucaran/fisher
   fisher update
   ```
3. `sudo pacman -S gitleaks` (in `extra`).
4. Optional tools are in `extra`/AUR under the same or similar names:
   `eza`, `bat`, `ripgrep`, `fd`, `dust`, `duf`, `procs`, `bottom`, `sd`,
   `git-delta`, `jq`, `shellcheck`, `hyperfine`, `tokei`.
5. Homebrew (Linuxbrew) is optional; `conf.d/10-login.fish` checks
   `/home/linuxbrew/.linuxbrew/bin/brew` and no-ops cleanly if it's absent.
6. VS Code shell integration is auto-detected for `.deb`/`.rpm`-style
   installs (`/usr/share/code/...`); adjust the path in `config.fish` if
   yours lives elsewhere (e.g. a Flatpak or AppImage install).
