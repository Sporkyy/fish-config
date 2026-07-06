# ~/.config/fish/conf.d/00-env.fish
# Equivalent of ~/.zshenv: runs for every fish invocation, interactive or not.
# Keep minimal — same rationale as the zsh version.

# MARK: ARCHFLAGS
# Set architecture for Apple Silicon/M1
set -gx ARCHFLAGS '-arch arm64'
