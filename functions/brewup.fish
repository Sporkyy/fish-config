function brewup --description 'Update Homebrew packages and recover from Fish upgrades'
    if not type -q brew
        echo 'brewup: Homebrew is not installed' >&2
        return 127
    end

    command brew update; and command brew upgrade; and command brew cleanup
    set -l brew_status $status

    # Tide captures the running Fish executable path. If Homebrew removed that
    # version during cleanup, replace this process before Tide draws the prompt.
    if test $brew_status -eq 0; and not test -x (status fish-path)
        set -l current_fish (command -s fish)
        if test -x "$current_fish"
            exec "$current_fish"
        end
    end

    return $brew_status
end
