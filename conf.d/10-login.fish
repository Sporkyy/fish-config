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

    if test -n "$brew_bin"
        "$brew_bin" shellenv | source

        # Install casks to ~/Applications (macOS only; casks don't exist on Linuxbrew)
        if test (uname) = Darwin
            set -gx HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications"
        end

        # MARK: ImageMagick ($HOMEBREW_PREFIX comes from the shellenv sourced above)
        set -gx MAGICK_HOME "$HOMEBREW_PREFIX/opt/imagemagick"
        if test -d "$MAGICK_HOME"
            fish_add_path $MAGICK_HOME/bin
        end
    end

    # MARK: Default permissions for new files (optional hardening)
    umask 022

    # Created by `pipx`
    fish_add_path $HOME/.local/bin

    # Added by LM Studio CLI (lms)
    fish_add_path $HOME/.cache/lm-studio/bin

    # Lando
    fish_add_path $HOME/.lando/bin

    # MARK: Docker completions
    if not contains "$HOME/.docker/completions" $fish_complete_path
        set -ga fish_complete_path "$HOME/.docker/completions"
    end
end
