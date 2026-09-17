# fish config

Personal fish config, shared between macOS and CachyOS. Meant to be cloned
straight into `~/.config/fish`.

## Layout

- `config.fish` — interactive-shell setup (prompt, abbreviations, tool
  integrations). OS-specific bits are guarded by `set -l os (uname)` checks.
- `conf.d/00-env.fish` — runs on every fish invocation (env vars only).
- `conf.d/10-login.fish` — login-shell setup (Homebrew, PATH, umask).
- `conf.d/uv.env.fish` — sources uv's `~/.local/bin/env.fish` when present.
- `conf.d/99-local.fish` — **not tracked**: machine-local settings (personal
  paths, account names, per-host overrides such as the Homebrew cask appdir).
  Copy `99-local.fish.example` to `99-local.fish` and edit the copy; the repo
  is public, so nothing personal belongs in a tracked file.
- `fish_plugins` — fisher's plugin manifest (currently just fisher + tide).
- `fish_variables` — **not tracked**, see below.
- `tide-theme.fish` — tracked snapshot of the tide prompt config, since
  `fish_variables` isn't tracked. Source it once on a fresh clone.
- `tide-theme-dump.fish` — regenerates the above after `tide configure`.
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
machines. That means a fresh clone starts with no plugins installed and an
empty `fish_user_paths` — expected, not broken. Finish setup with:

```fish
fisher update              # installs the plugins listed in fish_plugins
source tide-theme.fish     # restores the saved tide prompt
cp conf.d/99-local.fish.example conf.d/99-local.fish   # then edit it
```

`fisher update` is not optional: without it there is no `fish_prompt`
function on disk and you get fish's plain default prompt, no matter what
`tide-theme.fish` has set.

`source tide-theme.fish` replaces running `tide configure` — it restores the
exact saved theme instead of walking the wizard. If you *do* rerun the wizard
and want to keep the result, re-snapshot it:

```fish
./tide-theme-dump.fish > tide-theme.fish
```

The snapshot holds only the durable `tide_*` settings; the `_tide_prompt_*`
render cache and `_tide_left_items`/`_tide_right_items` are rebuilt by tide
at startup, so they're deliberately left out.

## macOS-specific

Two package manager paths are supported, both auto-detected — no config
edits needed either way:

### Homebrew (Apple Silicon)

1. Install [Homebrew](https://brew.sh) if you haven't.
2. `brew install fish gitleaks` (add `zoxide`, `fzf`, `eza`, `bat`,
   `ripgrep`, `fd`, `dust`, `duf`, `procs`, `bottom`, `sd`, `git-delta`,
   `jq`, `shellcheck`, `hyperfine`, `tokei`, `macchina` as wanted —
   everything referencing them is guarded with `type -q`, so skipping any of
   them just skips that abbreviation or integration).
3. Add fish to `/etc/shells` and `chsh -s /opt/homebrew/bin/fish` if it's not
   already your login shell.
4. `conf.d/10-login.fish` sources `brew shellenv` and wires up
   Homebrew-specific things (ImageMagick, PATH) automatically — nothing to
   configure by hand there.
5. Cask install dir is per-host, so no tracked file sets it. To put casks in
   `~/Applications` instead of `/Applications`, copy `99-local.fish.example`
   to `99-local.fish` and uncomment the `HOMEBREW_CASK_OPTS` block there.
   Hosts without that line keep installing casks to `/Applications`.
   Turning it off later doesn't move casks that are already installed, and
   `brew reinstall` won't relocate them: Homebrew records the resolved appdir
   per cask in `Caskroom/<token>/.metadata/config.json` and reuses it. Move
   one with `brew uninstall --cask <token>` then `brew install --cask <token>`.
6. Docker Desktop, if installed, patches the top of `config.fish` itself on
   install/reinstall; that block is already guarded to only run on Darwin.

### MacPorts (Intel — Homebrew has dropped support for older Intel macOS)

1. Install [MacPorts](https://www.macports.org) if you haven't.
2. `sudo port install fish gitleaks` (add `zoxide`, `fzf`, `eza`, `bat`,
   `ripgrep`, `fd`, `dust`, `duf`, `procs`, `bottom`, `sd`, `git-delta`,
   `jq`, `shellcheck`, `hyperfine`, `tokei`, `tealdeer` (provides the `tldr`
   binary) as wanted — same `type -q` guarding as the Homebrew list.
   `macchina` isn't packaged in MacPorts; `cargo install macchina` works
   since `rust`/`cargo` are MacPorts ports.
3. Add fish to `/etc/shells` and `chsh -s /opt/local/bin/fish` if it's not
   already your login shell.
4. `conf.d/10-login.fish` adds `/opt/local/bin` and `/opt/local/sbin` to PATH
   and `/opt/local/share/man` to MANPATH automatically — nothing to
   configure by hand there.
5. Homebrew-specific bits (ImageMagick's `MAGICK_HOME`) are gated on `brew`
   being present, so they simply no-op under MacPorts.

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
   `zoxide`, `fzf`, `eza`, `bat`, `ripgrep`, `fd`, `dust`, `duf`, `procs`,
   `bottom`, `sd`, `git-delta`, `jq`, `shellcheck`, `hyperfine`, `tokei`,
   `macchina`.
5. Homebrew (Linuxbrew) is optional; `conf.d/10-login.fish` checks
   `/home/linuxbrew/.linuxbrew/bin/brew` and no-ops cleanly if it's absent.
6. VS Code shell integration is auto-detected for `.deb`/`.rpm`-style
   installs (`/usr/share/code/...`); adjust the path in `config.fish` if
   yours lives elsewhere (e.g. a Flatpak or AppImage install).
