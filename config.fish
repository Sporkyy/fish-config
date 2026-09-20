# The following lines were added by Docker Desktop to add commands to your PATH.
# Docker Desktop is macOS/Windows-only; CachyOS installs docker via pacman
# with no equivalent ~/.docker/bin shim.
if test (uname) = Darwin
    fish_add_path --global --path --append "$HOME/.docker/bin"
end
# End of Docker Desktop section.

# ~/.config/fish/config.fish
# Interactive-shell setup for abbreviations and terminal integrations.
# Environment and login-shell setup live in conf.d/00-env.fish and
# conf.d/10-login.fish.

if status is-interactive

    # MARK: OS detection (macOS vs Linux, for cross-platform sections below)
    set -l os (uname)

    # MARK: Colors!
    set -gx CLICOLOR 1
    set -gx COLORTERM truecolor

    # MARK: Agent/Copilot sessions
    # Automated terminals get a minimal prompt instead of tide: the Nerd Font
    # glyphs and multi-line frame render as garbage in captured output, and
    # the welcome banner is pure noise there.
    set -l agent_session false
    if set -q COPILOT; and string match -qir '^(1|true|yes|on)$' -- "$COPILOT"
        set agent_session true
    end

    if test "$agent_session" = true
        function fish_prompt
            echo -n (prompt_pwd)'$ '
        end
    end

    # MARK: Welcome message (macchina)
    # Login shells only, so nested/subshells don't reprint the banner. Skipped
    # in VS Code and agent terminals where it's just startup noise.
    if status is-login; and test "$agent_session" = false
        if test "$TERM_PROGRAM" != vscode
            if type -q macchina
                macchina
            else if test "$os" = Linux; and test -r /usr/share/cachyos-fish-config/cachyos-config.fish; and type -q fastfetch
                fastfetch
            end
        end
    end

    # MARK: Abbreviations
    # abbr expands to the real command in your history, unlike alias.

    # Use Homebrew bash instead of macOS system bash
    if test "$os" = Darwin
        for bash_bin in /opt/homebrew/bin/bash /usr/local/bin/bash
            if test -x "$bash_bin"
                abbr -a bash "$bash_bin"
                break
            end
        end
    end

    # Directory Navigation
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
    abbr -a ...... 'cd ../../../../..'
    abbr -a ....... 'cd ../../../../../..'
    abbr -a ........ 'cd ../../../../../../..'

    # File Listing (eza with fallback to macOS ls)
    if type -q eza
        abbr -a ls 'eza --icons --group-directories-first'
        abbr -a la 'eza -a --icons --group-directories-first'
        abbr -a ll 'eza -l --icons --group-directories-first --git'
        abbr -a lal 'eza -la --icons --group-directories-first --git'
        abbr -a lla 'eza -la --icons --group-directories-first --git'
        abbr -a lt 'eza -T --icons --group-directories-first --level=2'
        abbr -a lta 'eza -T -a --icons --group-directories-first --level=2'
        abbr -a lsize 'eza -la --icons --sort=size --reverse'
    else if test "$os" = Darwin
        # BSD ls: -G enables color
        abbr -a ls 'ls -G'
        abbr -a la 'ls -A'
        abbr -a ll 'ls -lh'
        abbr -a lal 'ls -Alh'
        abbr -a lt 'ls -R'
    else
        # GNU ls: --color=auto enables color
        abbr -a ls 'ls --color=auto'
        abbr -a la 'ls -A'
        abbr -a ll 'ls -lh'
        abbr -a lal 'ls -Alh'
        abbr -a lt 'ls -R'
    end

    # bat - cat with syntax highlighting and git integration
    if type -q bat
        abbr -a cat 'bat --paging=never'
        abbr -a catt 'bat --paging=always'
        abbr -a bathelp 'bat --list-themes'
    end

    # ripgrep - faster grep with better defaults
    if type -q rg
        abbr -a rg 'rg --smart-case'
        abbr -a rgf 'rg --files-with-matches'
        abbr -a rgi 'rg --ignore-case'
    end

    # tldr - simplified man pages
    if type -q tldr
        abbr -a help tldr
    end

    # fd - faster, user-friendly find alternative
    if type -q fd
        abbr -a fnd fd
        abbr -a fdf 'fd --type f'
        abbr -a fdd 'fd --type d'
    end

    # dust - more intuitive du with tree view
    if type -q dust
        abbr -a du dust
        abbr -a dud 'dust -d 1'
    else
        abbr -a du 'du -h'
        abbr -a duh 'du -h -d 1 | sort -h'
    end

    # duf - better df with colorful output
    if type -q duf
        abbr -a df duf
    else
        abbr -a df 'df -h'
    end

    # procs - modern ps replacement
    if type -q procs
        abbr -a ps procs
        abbr -a pst 'procs --tree'
        abbr -a psw 'procs --watch'
    end

    # bottom - better top/htop
    if type -q btm
        abbr -a top btm
        abbr -a htop btm
    end

    # sd - simpler sed alternative
    if type -q sd
        abbr -a sdr sd
    end

    # delta - beautiful git diff viewer (configured in ~/.gitconfig; this is for manual use)
    if type -q delta
        abbr -a diff delta
    end

    # Additional useful tools
    if type -q jq
        abbr -a jqp 'jq -C | less -R'
    end
    if type -q shellcheck
        abbr -a sc shellcheck
    end
    if type -q hyperfine
        abbr -a bench hyperfine
    end
    if type -q tokei
        abbr -a loc tokei
    end

    # File Operations
    abbr -a mkdir 'mkdir -p'
    abbr -a cp 'cp -i'
    abbr -a mv 'mv -i'
    abbr -a rm 'rm -i'
    abbr -a rmdir 'rmdir -p'

    # Search fallback
    abbr -a grep 'grep --color=auto'
    if not type -q fd
        abbr -a ff 'find . -name'
    end

    # Network & Web
    abbr -a myip 'curl -s ifconfig.me'
    if test "$os" = Darwin
        abbr -a localip 'ipconfig getifaddr en0'
        abbr -a flushdns 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
    else
        abbr -a localip "ip -4 addr show scope global | awk '/inet/{print \$2}' | cut -d/ -f1 | head -n1"
        # No flushdns abbr on Linux: the right command depends on the
        # resolver in use (systemd-resolved vs nscd vs dnsmasq, etc).
    end
    abbr -a serve 'python3 -m http.server 8000'

    # File & Directory
    if test "$os" = Darwin
        abbr -a o 'open .'
    else
        abbr -a o 'xdg-open .'
    end
    abbr -a path 'echo $PATH | tr " " "\n"'
    abbr -a take mkcd

    # Fish config shortcuts
    abbr -a reload 'source ~/.config/fish/config.fish'
    abbr -a fishconfig 'code ~/.config/fish/config.fish'
    # On Linux, a packaged VS Code install already puts `code` on PATH; this
    # override is only needed on macOS where the .app bundle isn't.
    if test "$os" = Darwin
        # Hosts that set the cask appdir keep VS Code in ~/Applications, so
        # probe both locations rather than assuming one
        set -l vscode_bin "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        if not test -x "$vscode_bin"
            set vscode_bin "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        end
        if test -x "$vscode_bin"
            abbr -a code (string escape -- "$vscode_bin")
        end
    end

    # Git Shortcuts
    abbr -a g git
    abbr -a gs 'git status'
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gc 'git commit'
    abbr -a gcm 'git commit -m'
    abbr -a gp 'git push'
    abbr -a gl 'git pull'
    abbr -a gd 'git diff'
    abbr -a gsw 'git switch'
    abbr -a grs 'git restore'
    abbr -a gb 'git branch'
    abbr -a glog 'git log --oneline --graph --decorate -10'
    abbr -a glgg 'git log --graph --max-count=5'
    abbr -a glgga 'git log --graph --decorate --all'

    # git-absorb - automatically fixup commits
    if type -q git-absorb
        abbr -a gabs 'git absorb'
        abbr -a gabsr 'git absorb --and-rebase'
    end

    # Homebrew (macOS by default; also works if the user has Linuxbrew installed)
    if type -q brew
        abbr -a brewinfo 'brew leaves | xargs brew desc --eval-all'
    end

    # MacPorts (macOS; alternative to Homebrew, e.g. on Intel Macs)
    if type -q port
        abbr -a portup 'sudo port selfupdate && sudo port upgrade outdated'
        abbr -a portinfo 'port installed requested'
    end

    # Docker
    abbr -a d docker
    abbr -a dc 'docker compose'
    abbr -a dps 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
    abbr -a dstopall 'docker stop (docker ps -q)'
    abbr -a dprune 'docker system prune -af'

    # GitHub Copilot (via the gh CLI)
    if type -q gh
        abbr -a ghcs 'gh copilot suggest'
        abbr -a ghce 'gh copilot explain'
        abbr -a cps 'gh copilot suggest'
        abbr -a cpe 'gh copilot explain'
    end

    # Python shortcuts
    abbr -a py python3
    abbr -a pip pip3

    # MARK: Tide prompt
    # Installed/configured via fisher; see IlanCosman/tide. Run `tide configure`
    # to redo the wizard.

    # MARK: iTerm2 Shell Integration
    if test "$TERM_PROGRAM" = "iTerm.app"; and test -f "$HOME/.iterm2_shell_integration.fish"
        source "$HOME/.iterm2_shell_integration.fish"
    end

    # MARK: VSCode Shell Integration
    if test "$TERM_PROGRAM" = vscode
        set -l vscode_shell_integration
        set -l vscode_shell_integration_candidates
        if test "$os" = Darwin
            set vscode_shell_integration_candidates \
                "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish" \
                "$HOME/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish" \
                "/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish" \
                "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish"
        else
            # Common Linux package locations, including Arch packages.
            set vscode_shell_integration_candidates \
                "/usr/share/code/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish" \
                "/usr/share/code-insiders/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish" \
                "/usr/lib/code/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish" \
                "/usr/lib/code-insiders/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish"
        end

        for vscode_shell_integration in $vscode_shell_integration_candidates
            if test -f "$vscode_shell_integration"
                break
            end
        end
        # Hardcoded paths are the fast path (no Electron launch). Fall back to
        # the official locator for Flatpak/AppImage/non-standard installs.
        if not test -f "$vscode_shell_integration"; and command -q code
            set vscode_shell_integration (code --locate-shell-integration-path fish 2>/dev/null)
        end
        test -f "$vscode_shell_integration"; and source "$vscode_shell_integration"
    end

    # MARK: Zoxide (smarter cd)
    # Use `z <dir>` to jump to frequently visited directories and `zi` to pick
    # interactively.
    if type -q zoxide
        zoxide init fish | source
    end

    # MARK: fzf (fuzzy finder)
    # Ctrl+T find files, Ctrl+R search history, Alt+C cd into a directory.
    if type -q fzf
        fzf --fish | source
        # Back fzf with fd when available: respects .gitignore and is faster
        # than the default find-based walker.
        if type -q fd
            set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
            set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
            set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
        end
    end

    # MARK: Config reload hook
    # `set _reload_config 1` from anywhere re-sources this file, which is how
    # editors/scripts can pick up config changes without restarting the shell.
    function reload-config --on-variable _reload_config
        source ~/.config/fish/config.fish
    end

    # MARK: RVM
    # RVM has no official fish support. If you need Ruby version switching,
    # use rbenv/chruby/asdf (all have first-class fish integration) instead
    # of trying to source RVM's bash script here.

end
