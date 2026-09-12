# ~/.config/fish/conf.d/10-login.fish
# Equivalent of ~/.zprofile: login-shell env setup (Homebrew, PATH, umask).
# fish sources all of conf.d/*.fish on every start; the `status is-login`
# guard reproduces zsh's login-only scoping.

if status is-login
    # MARK: Homebrew (macOS default prefix; Linuxbrew uses /home/linuxbrew/.linuxbrew)
    set -l brew_bin /opt/homebrew/bin/brew
    if test (uname) = Linux
        set brew_bin /home/linuxbrew/.linuxbrew/bin/brew
    end
    if test -x "$brew_bin"
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

    # MARK: MacPorts (macOS only; alternative to Homebrew on machines where
    # Homebrew has dropped support, e.g. Intel Macs stuck below macOS 26)
    if test (uname) = Darwin; and test -d /opt/local/bin
        fish_add_path --move --path /opt/local/bin /opt/local/sbin
        if not set -q MANPATH; or not contains /opt/local/share/man $MANPATH
            set -gx MANPATH /opt/local/share/man $MANPATH
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

    # cargo install (no ~/.cargo/env to source since rust came from a system
    # package manager rather than rustup)
    fish_add_path $HOME/.cargo/bin

    # MARK: Docker completions
    if not contains "$HOME/.docker/completions" $fish_complete_path
        set -ga fish_complete_path "$HOME/.docker/completions"
    end
end
