# Project context

This repository is the user's live `~/.config/fish` directory, shared between
macOS (Intel and Apple Silicon) and CachyOS Linux. Changes can affect the next
shell startup. Read [README.md](README.md) for setup and host-specific details.

## File map

- `config.fish`: interactive abbreviations, Tide compatibility, terminal
  integrations, zoxide and fzf.
- `conf.d/00-env.fish`: environment and portable tool paths for all shells.
- `conf.d/10-login.fish`: login-only Homebrew setup and permissions.
- `conf.d/20-cachyos.fish`: selected CachyOS integrations and shortcuts.
- `conf.d/uv.env.fish`: optional uv environment setup.
- `functions/`: autoloaded Fish helpers, one function per matching filename.
- `fish_plugins`: Fisher plugin manifest; currently Fisher and Tide v6.
- `tide-theme.fish`: shared snapshot of durable Tide settings.
- `tide-theme-dump.fish`: regenerates that snapshot from this host's settings.
- `.githooks/pre-push`: scans outgoing commits with gitleaks when installed.

## Change guidelines

- Keep changes portable. Guard OS-specific code, optional commands and paths;
  use `$HOME` instead of hardcoded user directories.
- Keep interactive work inside `status is-interactive` and login-only work
  inside `status is-login`. Noninteractive shells should remain quiet and fast.
- Prefer abbreviations for command shortcuts, following the existing style.
- Keep machine-specific settings in ignored `conf.d/99-local.fish`; its
  tracked template is `conf.d/99-local.fish.example`.
- `fish_variables` and its temporary files contain local universal variables,
  plugin state and prompt caches. Do not commit them or edit them by hand.
- Fisher-managed plugin files are ignored. Modify shared configuration rather
  than vendoring or editing installed plugins or files under `/etc/fish`.
- Preserve existing uncommitted work and keep fixes scoped to the request.
  The `git-reset-*` helpers discard work; do not use them for routine sync.

## Tide compatibility

Macs use Fisher's Tide v6; this CachyOS host uses the system `fish-tide` package
under `/etc/fish`. Tide v7 renamed the `git`/`jj` prompt items to `vcs`.
`config.fish` calls `_tide_migrate_vcs_prompt_items` only when available because
package upgrades skip Fisher's migration event. Preserve this v6/v7 guard.
The saved theme still uses v6 item names and migrates on the next interactive
startup on v7. Pulling this repository does not install plugins or apply themes.

## Validation

There is no build step or automated test suite. Parse each changed Fish file
without loading startup configuration, for example:

```sh
fish --no-config --no-execute config.fish
git diff --check
```

For behavior changes, verify the affected shell mode (interactive,
noninteractive or login). Startup and theme scripts can write universal
variables; use a temporary `XDG_CONFIG_HOME` with copied settings for isolated
reproduction. Report which host was tested and any untested OS behavior.

Open a new terminal or use `exec fish` to reload all startup files and prompt
functions. The `reload` abbreviation only sources `config.fish`.
