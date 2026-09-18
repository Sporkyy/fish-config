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

# MARK: Tool paths
# Rebuild the same priority in login, non-login, and nested shells without
# saving machine paths to universal fish_user_paths on every startup.
set -l prefixes
switch (uname)
    case Darwin
        set prefixes /opt/local /opt/homebrew /usr/local
    case Linux
        set prefixes /home/linuxbrew/.linuxbrew /usr/local
end
set -l preferred "$HOME/.local/bin" "$HOME/.cargo/bin" \
    "$HOME/.cache/lm-studio/bin" "$HOME/.lando/bin"
if test (uname) = Darwin
    set -a preferred "$HOME/.docker/bin"
end
for prefix in $prefixes
    set -a preferred $prefix/bin $prefix/sbin
end
set -l ordered
for dir in $preferred
    if test -d "$dir"; and not contains -- "$dir" $ordered
        set -a ordered "$dir"
    end
end
for dir in $PATH
    # Normalize trailing slashes so inherited entries do not duplicate ours.
    set dir (string replace -r '([^/])/+$' '$1' -- "$dir")
    if not contains -- "$dir" $ordered
        set -a ordered "$dir"
    end
end
set -gx PATH $ordered

# An empty MANPATH entry keeps the system's default manual search paths.
if test (uname) = Darwin; and test -d /opt/local/share/man
    if not contains -- /opt/local/share/man $MANPATH
        if not set -q MANPATH[1]
            set -gx MANPATH /opt/local/share/man ''
        else
            set -gx MANPATH /opt/local/share/man $MANPATH
        end
    end
end

# Docker completions are also needed by interactive non-login shells.
if test (uname) = Darwin; and test -d "$HOME/.docker/completions"
    if not contains -- "$HOME/.docker/completions" $fish_complete_path
        set -ga fish_complete_path "$HOME/.docker/completions"
    end
end
