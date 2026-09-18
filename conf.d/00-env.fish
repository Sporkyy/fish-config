# ~/.config/fish/conf.d/00-env.fish
# Environment variables loaded for every fish invocation, interactive or not.
# Keep this file minimal so non-interactive commands remain lightweight.

# MARK: ARCHFLAGS
# Match the host architecture. These dotfiles are shared across Intel and
# Apple Silicon Macs, so a hardcoded -arch breaks native extension builds
# (pip, gem) on whichever machine it does not match.
if test (uname) = Darwin
    switch (uname -m)
        case arm64
            set -gx ARCHFLAGS '-arch arm64'
        case x86_64
            set -gx ARCHFLAGS '-arch x86_64'
    end
end

# MARK: Package-manager prefixes (Homebrew and MacPorts)
# PATH only, and deliberately here rather than in 10-login.fish: /opt/local/bin
# and /opt/homebrew/bin are absent from /etc/paths (only Intel Homebrew's
# /usr/local/bin is listed there), so non-login shells - VS Code task shells run
# `fish -c`, for one - would otherwise see no node, npm, or port at all. This
# mirrors ~/.zshenv, which does the same for zsh.
# Order is priority, MacPorts before Homebrew. $HOME/.local is the pipx and
# `pip --user` target on every OS. Existence-checked, so this is a no-op where a
# prefix is absent, and idempotent, so re-sourcing is safe.
set -l prefixes /opt/local /opt/homebrew /usr/local $HOME/.local
if test (uname) = Linux
    set -a prefixes /home/linuxbrew/.linuxbrew
end
set -l additions
for prefix in $prefixes
    for dir in $prefix/bin $prefix/sbin
        if test -d $dir; and not contains -- $dir $PATH; and not contains -- $dir $additions
            set -a additions $dir
        end
    end
end
if set -q additions[1]
    set -gx PATH $additions $PATH
end

# MANPATH for MacPorts; Homebrew's `shellenv` supplies its own in 10-login.fish.
if test (uname) = Darwin; and test -d /opt/local/share/man
    if not set -q MANPATH; or not contains /opt/local/share/man $MANPATH
        set -gx MANPATH /opt/local/share/man $MANPATH
    end
end
