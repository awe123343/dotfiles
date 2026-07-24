# ~/.zshenv
# This file is sourced for ALL shells (interactive, non-interactive, login, non-login)
# Keep it minimal! Heavy initialization should go in ~/.zshrc
#
# Note: Environment variables for scripts/cronjobs should be set in the script itself
# or via launchd EnvironmentVariables, not here.

# Homebrew PATH must live here, not ~/.zshrc: `ssh host 'cmd'` runs a
# non-interactive, non-login shell that reads only /etc/zshenv and this file.
# Without it, mosh fails at startup because it invokes bare `mosh-server`.
# typeset -U keeps PATH deduped across nested shells.
typeset -U path PATH
path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
