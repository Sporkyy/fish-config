# ~/.config/fish/tide-theme.fish
# Snapshot of the tide prompt configuration, kept in git because
# fish_variables itself is gitignored (see .gitignore for why).
#
# Apply it on a fresh clone, after `fisher update` has installed tide:
#   source tide-theme.fish
#
# These are universal variables, so sourcing once is enough — they persist
# into fish_variables and survive restarts. Running `tide configure` later
# overwrites them; re-snapshot with:
#   ./tide-theme-dump.fish > tide-theme.fish
#
# Only durable tide_* settings are captured here. The _tide_prompt_* render
# cache and _tide_left_items/_tide_right_items are derived by tide at
# runtime, so they are deliberately left out.

set -U tide_aws_bg_color yellow
set -U tide_aws_color brblack
set -U tide_aws_icon 
set -U tide_bun_bg_color white
set -U tide_bun_color black
set -U tide_bun_icon 󰳓
set -U tide_character_color brgreen
set -U tide_character_color_failure brred
set -U tide_character_icon ❯
set -U tide_character_vi_icon_default ❮
set -U tide_character_vi_icon_replace ▶
set -U tide_character_vi_icon_visual V
set -U tide_cmd_duration_bg_color yellow
set -U tide_cmd_duration_color black
set -U tide_cmd_duration_decimals 0
set -U tide_cmd_duration_icon 
set -U tide_cmd_duration_threshold 3000
set -U tide_context_always_display false
set -U tide_context_bg_color brblack
set -U tide_context_color_default yellow
set -U tide_context_color_root yellow
set -U tide_context_color_ssh yellow
set -U tide_context_hostname_parts 1
set -U tide_crystal_bg_color brwhite
set -U tide_crystal_color black
set -U tide_crystal_icon 
set -U tide_direnv_bg_color bryellow
set -U tide_direnv_bg_color_denied brred
set -U tide_direnv_color black
set -U tide_direnv_color_denied black
set -U tide_direnv_icon ▼
set -U tide_distrobox_bg_color brmagenta
set -U tide_distrobox_color black
set -U tide_distrobox_icon 󰆧
set -U tide_docker_bg_color blue
set -U tide_docker_color black
set -U tide_docker_default_contexts default colima
set -U tide_docker_icon 
set -U tide_elixir_bg_color magenta
set -U tide_elixir_color black
set -U tide_elixir_icon 
set -U tide_gcloud_bg_color blue
set -U tide_gcloud_color black
set -U tide_gcloud_icon 󰊭
set -U tide_git_bg_color green
set -U tide_git_bg_color_unstable yellow
set -U tide_git_bg_color_urgent red
set -U tide_git_color_branch black
set -U tide_git_color_conflicted black
set -U tide_git_color_dirty black
set -U tide_git_color_operation black
set -U tide_git_color_staged black
set -U tide_git_color_stash black
set -U tide_git_color_untracked black
set -U tide_git_color_upstream black
set -U tide_git_icon 
set -U tide_git_truncation_length 24
set -U tide_git_truncation_strategy 
set -U tide_go_bg_color brcyan
set -U tide_go_color black
set -U tide_go_icon 
set -U tide_java_bg_color yellow
set -U tide_java_color black
set -U tide_java_icon 
set -U tide_jobs_bg_color brblack
set -U tide_jobs_color green
set -U tide_jobs_icon 
set -U tide_jobs_number_threshold 1000
set -U tide_kubectl_bg_color blue
set -U tide_kubectl_color black
set -U tide_kubectl_icon 󱃾
set -U tide_left_prompt_frame_enabled false
set -U tide_left_prompt_items vi_mode os pwd git
set -U tide_left_prompt_prefix 
set -U tide_left_prompt_separator_diff_color 
set -U tide_left_prompt_separator_same_color 
set -U tide_left_prompt_suffix 
set -U tide_nix_shell_bg_color brblue
set -U tide_nix_shell_color black
set -U tide_nix_shell_icon 
set -U tide_node_bg_color green
set -U tide_node_color black
set -U tide_node_icon 
set -U tide_os_bg_color white
set -U tide_os_color black
# Keep the OS icon selected by Tide on this machine.
if functions -q _tide_detect_os
    _tide_detect_os | read -l --line os_icon os_color os_bg_color
    set -U tide_os_icon "$os_icon"
end
set -U tide_php_bg_color blue
set -U tide_php_color black
set -U tide_php_icon 
set -U tide_private_mode_bg_color brwhite
set -U tide_private_mode_color black
set -U tide_private_mode_icon 󰗹
set -U tide_prompt_add_newline_before false
set -U tide_prompt_color_frame_and_connection brblack
set -U tide_prompt_color_separator_same_color brblack
set -U tide_prompt_icon_connection ' '
set -U tide_prompt_min_cols 34
set -U tide_prompt_pad_items true
set -U tide_prompt_transient_enabled true
set -U tide_pulumi_bg_color yellow
set -U tide_pulumi_color black
set -U tide_pulumi_icon 
set -U tide_pwd_bg_color blue
set -U tide_pwd_color_anchors brwhite
set -U tide_pwd_color_dirs brwhite
set -U tide_pwd_color_truncated_dirs white
set -U tide_pwd_icon 
set -U tide_pwd_icon_home 
set -U tide_pwd_icon_unwritable 
set -U tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig
set -U tide_python_bg_color brblack
set -U tide_python_color cyan
set -U tide_python_icon 󰌠
set -U tide_right_prompt_frame_enabled false
set -U tide_right_prompt_items status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig time
set -U tide_right_prompt_prefix 
set -U tide_right_prompt_separator_diff_color 
set -U tide_right_prompt_separator_same_color 
set -U tide_right_prompt_suffix 
set -U tide_ruby_bg_color red
set -U tide_ruby_color black
set -U tide_ruby_icon 
set -U tide_rustc_bg_color red
set -U tide_rustc_color black
set -U tide_rustc_icon 
set -U tide_shlvl_bg_color yellow
set -U tide_shlvl_color black
set -U tide_shlvl_icon 
set -U tide_shlvl_threshold 1
set -U tide_status_bg_color black
set -U tide_status_bg_color_failure red
set -U tide_status_color green
set -U tide_status_color_failure bryellow
set -U tide_status_icon ✔
set -U tide_status_icon_failure ✘
set -U tide_terraform_bg_color magenta
set -U tide_terraform_color black
set -U tide_terraform_icon 󱁢
set -U tide_time_bg_color white
set -U tide_time_color black
set -U tide_time_format '%T'
set -U tide_toolbox_bg_color magenta
set -U tide_toolbox_color black
set -U tide_toolbox_icon 
set -U tide_vi_mode_bg_color_default white
set -U tide_vi_mode_bg_color_insert cyan
set -U tide_vi_mode_bg_color_replace green
set -U tide_vi_mode_bg_color_visual yellow
set -U tide_vi_mode_color_default black
set -U tide_vi_mode_color_insert black
set -U tide_vi_mode_color_replace black
set -U tide_vi_mode_color_visual black
set -U tide_vi_mode_icon_default D
set -U tide_vi_mode_icon_insert I
set -U tide_vi_mode_icon_replace R
set -U tide_vi_mode_icon_visual V
set -U tide_zig_bg_color yellow
set -U tide_zig_color black
set -U tide_zig_icon 
