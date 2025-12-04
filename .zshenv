# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# fnm
eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"

# uv
. "$HOME/.local/bin/env"

# rust
. "$HOME/.cargo/env"

eval "$(zoxide init zsh)"

# Go
export GOPATH="$HOME/Dev/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
