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

# Keep Quoin's managed colors in the generated overlay, even after a reset.
set -l quoin_colors tide_aws_color tide_jobs_bg_color tide_pwd_bg_color \
    tide_python_bg_color tide_status_bg_color_failure
for name in (set -nU | string match 'tide_*' | sort)
    contains -- $name $quoin_colors; and continue
    # The OS icon belongs to the destination machine, not this snapshot.
    if test "$name" = tide_os_icon
        echo '# Keep the OS icon selected by Tide on this machine.'
        echo 'if functions -q _tide_detect_os'
        echo '    _tide_detect_os | read -l --line os_icon os_color os_bg_color'
        echo '    set -U tide_os_icon "$os_icon"'
        echo 'end'
        continue
    end
    set -l vals
    for v in $$name
        # Tide v7 renamed git to vcs; keep the shared snapshot v6-compatible.
        if string match -q 'tide_*_prompt_items' -- $name; and test "$v" = vcs
            set v git
        end
        set -a vals (string escape -- $v)
    end
    echo "set -U $name $vals"
end

echo
echo '# Run the installed Tide'"'"'s upgrade handler right away so open v7 shells'
echo '# never render the v6 git name. Tide v6'"'"'s handler leaves git in place.'
echo 'emit _tide_init_update'
echo
echo '# Quoin'"'"'s generated color overrides are kept separate from this snapshot.'
echo 'if test -r (status dirname)/tide-colors.fish'
echo '    source (status dirname)/tide-colors.fish'
echo 'end'
