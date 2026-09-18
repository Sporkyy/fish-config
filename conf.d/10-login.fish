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
        # Keep the package-manager priority established in 00-env.fish while
        # loading Homebrew's other environment variables.
        set -l startup_path $PATH
        "$brew_bin" shellenv | source
        set -gx PATH $startup_path

        # Cask install dir is per-host, so it lives in 99-local.fish instead of
        # here; anything in a tracked file would apply on every macOS machine
        # (see conf.d/99-local.fish.example)

        # MARK: ImageMagick ($HOMEBREW_PREFIX comes from the shellenv sourced above)
        set -gx MAGICK_HOME "$HOMEBREW_PREFIX/opt/imagemagick"
        if test -d "$MAGICK_HOME"
            fish_add_path --global --path --append "$MAGICK_HOME/bin"
        end
    end

    # MARK: MacPorts
    # PATH and MANPATH for /opt/local are set in 00-env.fish instead: non-login
    # shells (VS Code tasks) need them too, and `fish_add_path --path` would
    # only have affected the shell that ran it.

    # MARK: Default permissions for new files (optional hardening)
    umask 022

end
