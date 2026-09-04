# ~/.config/fish/conf.d/00-env.fish
# Environment variables loaded for every fish invocation, interactive or not.
# Keep this file minimal so non-interactive commands remain lightweight.

# MARK: ARCHFLAGS
# Set the build architecture on Apple Silicon Macs.
if test (uname) = Darwin; and test (uname -m) = arm64
    set -gx ARCHFLAGS '-arch arm64'
end
