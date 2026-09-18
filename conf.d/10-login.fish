# ~/.config/fish/conf.d/10-login.fish
# Login-shell environment setup for Homebrew, PATH, and default permissions.
# Fish sources every conf.d file at startup, so keep login-only work guarded.

if status is-login
    # MARK: Homebrew
    # Check the standard Apple Silicon, Intel macOS, and Linuxbrew prefixes.
    set -l brew_bin (command -s brew 2>/dev/null)
    if test -z "$brew_bin"
        for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
            if test -x $candidate
                set brew_bin $candidate
                break
            end
        end
    end
    if test -x "$brew_bin"
        # Supplies HOMEBREW_PREFIX/CELLAR/REPOSITORY plus MANPATH and INFOPATH,
        # which interactive work wants. PATH itself comes from 00-env.fish so
        # that non-login shells get it too.
        "$brew_bin" shellenv | source

        # `brew shellenv` prepends its bin/sbin without checking, duplicating
        # what 00-env.fish already added (plus /usr/local/bin from /etc/paths on
        # Intel). Keep the first occurrence of each entry.
        set -l deduped
        for dir in $PATH
            contains -- $dir $deduped; or set -a deduped $dir
        end
        set -gx PATH $deduped

        # Cask install dir is per-host, so it lives in 99-local.fish instead of
        # here — anything in a tracked file would apply on every macOS machine
        # (see conf.d/99-local.fish.example)

        # MARK: ImageMagick ($HOMEBREW_PREFIX comes from the shellenv sourced above)
        set -gx MAGICK_HOME "$HOMEBREW_PREFIX/opt/imagemagick"
        if test -d "$MAGICK_HOME"
            fish_add_path $MAGICK_HOME/bin
        end
    end

    # MARK: MacPorts
    # PATH and MANPATH for /opt/local are set in 00-env.fish instead: non-login
    # shells (VS Code tasks) need them too, and `fish_add_path --path` would
    # only have affected the shell that ran it.

    # MARK: Default permissions for new files (optional hardening)
    umask 022

    # Created by `pipx`
    fish_add_path $HOME/.local/bin

    # Added by LM Studio CLI (lms)
    fish_add_path $HOME/.cache/lm-studio/bin

    # Lando
    fish_add_path $HOME/.lando/bin

    # cargo install (no ~/.cargo/env to source since rust came from a system
    # package manager rather than rustup)
    fish_add_path $HOME/.cargo/bin

    # MARK: Docker completions
    if not contains "$HOME/.docker/completions" $fish_complete_path
        set -ga fish_complete_path "$HOME/.docker/completions"
    end
end
