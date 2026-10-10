# ~/.zprofile
# This file is sourced for LOGIN shells only (before ~/.zshrc)
# Most configurations should be in ~/.zshrc instead.
#
# Note: On macOS, Terminal.app opens login shells, but VS Code/Ghostty may not.
# For consistent behavior, put everything in ~/.zshrc.

# fnm-shim: Node for GUI apps; deferred fnm env in .zshrc still takes precedence in terminals
export PATH="$HOME/.local/share/fnm-shim/bin:$PATH"
