# fnm
eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"

# uv
. "$HOME/.local/bin/env"

# rust
. "$HOME/.cargo/env"

eval "$(zoxide init zsh)"
