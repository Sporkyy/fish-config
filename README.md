# fish config

Shared fish configuration for my MacBook Pro, Intel Mac Mini and CachyOS
gaming PC.

## What syncs

- `config.fish`: interactive abbreviations, prompt and terminal integrations.
- `conf.d/00-env.fish`: architecture, tool paths and Docker completions.
- `conf.d/10-login.fish`: Homebrew environment and login permissions.
- `conf.d/20-cachyos.fish`: guarded CachyOS notifications, pager and shortcuts.
- `conf.d/uv.env.fish`: optional environment from uv's standalone installer.
- `functions/`: shared helpers, including `brewup` and `php-cs-fixer`.
- `fish_plugins`: Fisher and Tide plugin manifest.
- `tide-theme.fish`: saved prompt settings, applied explicitly on each host.
- `tide-colors.fish`: Quoin color overrides, restored at interactive startup.
- `.githooks/pre-push`: scans outgoing commits with gitleaks when installed.

`conf.d/99-local.fish` and `fish_variables` are ignored by Git. The former
holds each machine's preferences; the latter holds universal variables,
plugin state and prompt caches. Plugins installed by Fisher are also ignored.
Pulling config does not install tools, update plugins or apply the saved theme.

## Set up a new machine

Back up any existing `~/.config/fish` first. Install fish using the machine's
package manager (on a Mac, see [which one](#package-manager)), then clone this
repository there. From fish:

```fish
cd ~/.config/fish
git config core.hooksPath .githooks
if not type -q fisher
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
end
fisher update
source tide-theme.fish
# Only copy the template if no local settings file exists yet.
test -e conf.d/99-local.fish; or cp conf.d/99-local.fish.example conf.d/99-local.fish
```

In VS Code, the "Enable gitleaks pre-push hook" task runs the same
`core.hooksPath` setting. Edit the local file for that machine, then open a
new terminal. Install a
Nerd Font and select it in the terminal for Tide's icons. To change the login
shell, add the installed fish executable to `/etc/shells` if needed, then use
that same path with `chsh -s`.

## Sync existing machines

Commit intended shared changes before pulling. Use `git pull --ff-only` for
a routine update; if histories diverge, review and merge the changes instead
of resetting either machine. Then open a new terminal to load all startup
files. The `reload` abbreviation only reloads `config.fish`.

Run `fisher update` on the Macs when you want to refresh plugins; CachyOS
updates Tide through its package instead. To adopt the shared
prompt snapshot, run `source tide-theme.fish`, then `exec fish` in each open
shell. After changing the prompt with
`tide configure`, save it with `./tide-theme-dump.fish > tide-theme.fish`.
The OS icon is detected on the destination host.

Quoin's five color overrides live separately in `tide-colors.fish`. Interactive
startup reapplies them when Tide is installed, writing only changed values.
A reinstall or `tide configure` can replace colors in the current shell; the
next shell restores them. To restore immediately, run:

```fish
source ~/.config/fish/tide-colors.fish
tide reload
```

The full theme snapshot also loads this overlay, and the dump script leaves
these five colors out of snapshots. Prompt layout, icons and other settings
remain in `tide-theme.fish` and are still applied explicitly.

Use Quoin's matching terminal palette in iTerm2 and Alacritty. The standalone
overlay is generated in the Quoin project as `themes/tide/quoin.fish`. After
changing Quoin's palette, run `make gen` there and copy that artifact to this
repository's `tide-colors.fish`. Commit the refreshed copy with the shared Fish
configuration. Shell startup needs no Quoin checkout or network access.

The `git-reset-*` helpers deliberately discard changes. In particular,
`git-reset-scorched` also deletes ignored local settings, universal variables
and installed plugins. It is not a sync command.

## macOS

### Package manager

Use Homebrew on Apple Silicon Macs and MacPorts on Intel Macs, such as the
Mac Mini. Homebrew moved Intel macOS to its unsupported Tier 3 in September
2026, with no CI and no new prebuilt bottles, and plans to stop running on
Intel Macs entirely from September 2027.

On an Intel Mac, install Xcode's command line tools and the MacPorts package
for that macOS version from macports.org, then install fish and the tools:

```fish
sudo port selfupdate
sudo port install fish gitleaks
```

The MacPorts login shell is `/opt/local/bin/fish`. Update ports with the
`portup` abbreviation and list requested ports with `portinfo`. `macchina` has
no port, so skip it. An existing Intel Homebrew under `/usr/local` can stay
during the move, since MacPorts comes first in PATH; uninstall it once its
tools are replaced. The `bash` abbreviation uses MacPorts bash
(`sudo port install bash`) before Homebrew's. `brewup`, `brewinfo`, the
Homebrew PHP used
by `php-cs-fixer`, ImageMagick's `MAGICK_HOME` and the cask settings below
apply only where Homebrew is installed.

### Paths and tools

Homebrew is detected through PATH or its standard Apple Silicon and Intel
prefixes. MacPorts uses `/opt/local`. Tool paths are available to login and
non-login shells, including VS Code tasks. User tool directories come first,
then MacPorts, then Homebrew when both are present. Missing directories and
optional tools are skipped.

Common optional tools include `eza`, `bat`, `ripgrep`, `fd`, `dust`, `duf`,
`procs`, `bottom`, `sd`, `git-delta`, `jq`, `shellcheck`, `hyperfine`, `tokei`,
`zoxide`, `fzf`, `macchina` and `gitleaks`. Install only what you use through
the host's package manager. `zoxide` supplies `z` and `zi` shortcuts.

### Homebrew casks

Casks are a Homebrew feature, so this applies to Apple Silicon Macs; on an
Intel Mac, install apps from their vendors instead. Casks default to Homebrew's `/Applications`. Only the Mac that needs home
folder installs should enable this in ignored `conf.d/99-local.fish`:

```fish
if test (uname) = Darwin
    set -gx HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications"
end
```

Docker Desktop on that Mac belongs in `/Applications`. Use an explicit
`--appdir=/Applications` when installing its cask and the account's normal
admin approval process. Homebrew records installation directories per cask;
changing the default does not move existing apps. The `sudo` helper invokes
PrivilegesCLI when installed, then runs system sudo.

### Apps

VS Code is detected under both `~/Applications` and `/Applications`.
Docker Desktop may rewrite its PATH block in `config.fish`; review that diff
before committing, retaining the portable `$HOME` path and Darwin guard.

## CachyOS

Follow the new-machine steps after installing fish and the desired tools.
Check the installed login shell rather than assuming fish is already active.
Homebrew is optional; the config also recognizes Linuxbrew's standard prefix.
macOS architecture settings, Docker Desktop paths and cask preferences are
not enabled by the shared config on Linux.

VS Code integration checks common `/usr/share` and `/usr/lib` locations,
then asks `code` for its integration path if available.

The original device config only sourced the packaged CachyOS preset.
`20-cachyos.fish` selectively incorporates it when that package is present:
long-command notifications (10 seconds, low urgency), the bat man-page pager,
optional `~/.fish_profile` and depot_tools path, and package/system shortcuts.
`~/.local/bin` and `~/.cargo/bin` are already handled by `00-env.fish`.
Fastfetch is the login banner when macchina is unavailable; VS Code and
Copilot sessions skip it, as do nested non-login shells.

Shared abbreviations take precedence over the preset's competing aliases.
The preset's literal `!`/`$` key bindings, timestamped history wrapper,
`copy`/`backup` helpers, `apt` aliases and pacman lock-deletion shortcut are
not imported. `cleanup` checks for orphaned packages before invoking pacman.
The original `fish-ONDEVICE` directory remains the backup.

CachyOS supplies Pure and Fisher system-wide on this PC. Tide is now installed
system-wide under `/etc/fish`, and the saved shared theme has been applied
to this user's universal variables. Tide takes precedence over vendor Pure.
The `fish-tide` package builds the same `plttn/tide` v7 fork that the Macs
install through `fish_plugins`, so update it with pacman. Skip `fisher update`
on this PC: Fisher would install a second copy in `~/.config/fish` that
shadows the package, and Tide's install handler would reset the prompt to its
defaults until `tide-theme.fish` is sourced again.
The `fish-tide` 7.2 upgrade renamed the `git`/`jj` prompt items to `vcs`, but
its package install script does not run Fisher's update migration. The shared
config emits Tide's update event once whenever `tide --version` changes,
tracked in the universal `_tide_config_version`; this works on both Tide v6
and v7. The saved theme keeps the v6 `git` name, includes the
v7 `tide_jj_*` colors, and migrates itself when sourced on v7; the dump script
writes `vcs` back as `git`. Open a new terminal or run `exec fish` after an
upgrade or after applying the theme to reload the prompt in each open shell.
The existing Pure universal settings are identical in the two directories;
the original notification preferences are restored locally. Its universal
`fish_user_paths` entry is redundant with the shared portable PATH setup.

## Validation

Run `python3 -m unittest discover -s tests` for isolated Tide color persistence
checks. They require Fish and use a temporary configuration directory without
changing the live universal variables. Parse changed Fish files with
`fish --no-config --no-execute FILE`, then run `git diff --check`.
