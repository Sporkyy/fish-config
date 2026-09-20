# Incorporate the useful parts of CachyOS's preset without loading its
# competing aliases, greeting, key bindings or universal PATH mutations.
if test (uname) = Linux; and test -r /usr/share/cachyos-fish-config/cachyos-config.fish
    if test -r "$HOME/.fish_profile"
        source "$HOME/.fish_profile"
    end
    if test -d "$HOME/Applications/depot_tools"
        fish_add_path --global --path --append "$HOME/Applications/depot_tools"
    end

    # Preserve an explicitly chosen pager and fall back when tools are absent.
    if not set -q MANPAGER; and command -q col; and command -q bat
        set -gx MANROFFOPT -c
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    end

    if status is-interactive
        # The packaged done.fish uses `exit` in noninteractive shells.
        set -q __done_min_cmd_duration; or set -g __done_min_cmd_duration 10000
        set -q __done_notification_urgency_level; or set -g __done_notification_urgency_level low
        if test -r /usr/share/cachyos-fish-config/conf.d/done.fish
            source /usr/share/cachyos-fish-config/conf.d/done.fish
        end

        abbr -a update 'sudo cachyos-rate-mirrors && sudo pacman -Syu'
        abbr -a mirror 'sudo cachyos-rate-mirrors'
        abbr -a grubup 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
        abbr -a hw 'hwinfo --short'
        abbr -a big "expac -H M '%m\t%n' | sort -h | nl"
        abbr -a gitpkg 'pacman -Qq | string match -r -- "-git$" | count'
        abbr -a cleanup 'set -l orphans (pacman -Qtdq); if test (count $orphans) -gt 0; sudo pacman -Rns $orphans; end'
        abbr -a jctl 'journalctl -p 3 -xb'
        abbr -a rip "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
        abbr -a psmem 'ps auxf | sort -nr -k 4'
        abbr -a psmem10 'ps auxf | sort -nr -k 4 | head -10'
        abbr -a tarnow 'tar -acf'
        abbr -a untar 'tar -zxvf'
    end
end
