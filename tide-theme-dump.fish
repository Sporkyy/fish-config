#!/usr/bin/env fish
# Re-snapshot the current tide prompt config into tide-theme.fish:
#   ./tide-theme-dump.fish > tide-theme.fish
#
# Run this after `tide configure` to capture the new look in git.
# Emits only durable tide_* universal variables; the _tide_prompt_* render
# cache and _tide_left_items/_tide_right_items are derived at runtime and
# intentionally skipped.

echo '# ~/.config/fish/tide-theme.fish'
echo '# Snapshot of the tide prompt configuration, kept in git because'
echo '# fish_variables itself is gitignored (see .gitignore for why).'
echo '#'
echo '# Apply it on a fresh clone, after `fisher update` has installed tide:'
echo '#   source tide-theme.fish'
echo '#'
echo '# These are universal variables, so sourcing once is enough — they persist'
echo '# into fish_variables and survive restarts. Running `tide configure` later'
echo '# overwrites them; re-snapshot with:'
echo '#   ./tide-theme-dump.fish > tide-theme.fish'
echo '#'
echo '# Only durable tide_* settings are captured here. The _tide_prompt_* render'
echo '# cache and _tide_left_items/_tide_right_items are derived by tide at'
echo '# runtime, so they are deliberately left out.'
echo

for name in (set -nU | string match 'tide_*' | sort)
    set -l vals
    for v in $$name
        set -a vals (string escape -- $v)
    end
    echo "set -U $name $vals"
end
