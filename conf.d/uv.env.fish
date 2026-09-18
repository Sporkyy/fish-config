# ~/.config/fish/conf.d/uv.env.fish
# Sources the env file uv's standalone installer drops in ~/.local/bin.
# Guarded on readability, so it no-ops cleanly on machines without uv
# (or where uv came from a package manager and wrote no env.fish).

if test -r "$HOME/.local/bin/env.fish"
    source "$HOME/.local/bin/env.fish"
end
