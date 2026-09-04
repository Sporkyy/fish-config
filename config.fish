# The following lines were added by Docker Desktop to add commands to your PATH.
# Docker Desktop is macOS/Windows-only; CachyOS installs docker via pacman
# with no equivalent ~/.docker/bin shim.
if test (uname) = Darwin
    fish_add_path $HOME/.docker/bin
end
# End of Docker Desktop section.

# ~/.config/fish/config.fish
# Equivalent of ~/.zshrc: interactive-shell setup (prompt, aliases, integrations).
# fish has no separate instant-prompt cache to fight with, so this is simpler
# than the zsh version — no ordering landmines, just gate interactive-only
# stuff behind `status is-interactive`. Homebrew/PATH/env setup that used to
# live at the top of this file has moved to conf.d/00-env.fish and
# conf.d/10-login.fish (the zshenv/zprofile equivalents).

if status is-interactive

    # MARK: OS detection (macOS vs Linux, for cross-platform sections below)
    set -l os (uname)

    # MARK: Colors!
    set -gx CLICOLOR 1
    set -gx COLORTERM truecolor

    # MARK: Welcome message (macchina)
    # Skip in VS Code terminals where shell integration + short-lived nested
    # shells make startup noise more likely (mirrors the zsh guard).
    if test "$TERM_PROGRAM" != vscode; and type -q macchina
        macchina
    end

    # MARK: History / options notes
    # fish's history is unlimited, deduped, and shared across sessions by
    # default (no HISTSIZE/SAVEHIST/SHARE_HISTORY equivalent needed).
    # AUTO_CD: fish already does implicit cd when you type a bare directory.
    # AUTO_PUSHD: fish tracks directory history natively — use `prevd`/`nextd`
    # (bound to Alt+Left/Alt+Right) or `dirh` instead of a pushd/popd stack.
    # CORRECT / autosuggestions / syntax highlighting: all built into fish,
    # no zsh-autosuggestions / zsh-syntax-highlighting plugins needed.
    # EXTENDED_GLOB / NULL_GLOB: fish's globbing differs from zsh's and has
    # no direct equivalent; revisit only if a specific alias/function breaks.

    # MARK: Aliases -> abbreviations
    # abbr expands to the real command in your history, unlike alias.

    # Use Homebrew bash instead of macOS system bash
    if test "$os" = Darwin; and test -x /opt/homebrew/bin/bash
        abbr -a bash /opt/homebrew/bin/bash
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
        abbr -a ls 'eza --icons'
        abbr -a la 'eza -a --icons'
        abbr -a ll 'eza -l --icons --git'
        abbr -a lal 'eza -la --icons --git'
        abbr -a lt 'eza -T --icons --level=2'
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

    # Fish config shortcuts (config.fish is fish's ~/.zshrc equivalent)
    abbr -a reload 'source ~/.config/fish/config.fish'
    abbr -a fishconfig 'code ~/.config/fish/config.fish'
    # On Linux, a packaged VS Code install already puts `code` on PATH; this
    # override is only needed on macOS where the .app bundle isn't.
    if test "$os" = Darwin
        abbr -a code '~/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
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
        abbr -a brewup 'brew update && brew upgrade && brew cleanup'
        abbr -a brewinfo 'brew leaves | xargs brew desc --eval-all'
    end

    # Docker
    abbr -a d docker
    abbr -a dc 'docker compose'
    abbr -a dps 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
    abbr -a dstopall 'docker stop (docker ps -q)'
    abbr -a dprune 'docker system prune -af'

    # GitHub Copilot
    abbr -a ghcs 'gh copilot suggest'
    abbr -a ghce 'gh copilot explain'

    # Misc carried over from previous fish setup
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
        if test "$os" = Darwin
            set -l vscode_shell_integration "/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish"
            if not test -f "$vscode_shell_integration"
                set vscode_shell_integration "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish"
            end
        else
            # Common Linux package locations (.deb/.rpm and Insiders builds)
            set -l vscode_shell_integration "/usr/share/code/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish"
            if not test -f "$vscode_shell_integration"
                set vscode_shell_integration "/usr/share/code-insiders/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration.fish"
            end
        end
        test -f "$vscode_shell_integration"; and source "$vscode_shell_integration"
    end

    # MARK: RVM
    # RVM has no official fish support. If you need Ruby version switching,
    # use rbenv/chruby/asdf (all have first-class fish integration) instead
    # of trying to source RVM's bash script here.

end
