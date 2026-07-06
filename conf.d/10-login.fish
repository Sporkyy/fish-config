# ~/.config/fish/conf.d/10-login.fish
# Equivalent of ~/.zprofile: login-shell env setup (Homebrew, PATH, umask).
# fish sources all of conf.d/*.fish on every start; the `status is-login`
# guard reproduces zsh's login-only scoping.

if status is-login
    # MARK: Homebrew
    if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv | source
    end

    # Mercer-specific: Install casks to ~/Applications
    set -gx HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications"

    # MARK: Default permissions for new files (optional hardening)
    umask 022

    # MARK: ImageMagick
    set -gx MAGICK_HOME /opt/homebrew/opt/imagemagick
    fish_add_path $MAGICK_HOME/bin

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
