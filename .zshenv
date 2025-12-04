# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/bin:$PATH"

# fnm
eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

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
