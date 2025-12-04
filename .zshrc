# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# ============================================================================
# Zim Framework (migrated from oh-my-zsh)
# ============================================================================

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Use emacs keybindings (must be before zim init)
bindkey -e

# Homebrew (must be before zim init for plugins to find commands)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# macOS uses gdircolors (required by zsh-dircolors-solarized)
(( $+commands[gdircolors] )) && alias dircolors='gdircolors'

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh


# ============================================================================
# Environment Variables (merged from .zshenv and .zprofile)
# ============================================================================

# export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_ROOT=/usr/local/share/dotnet
export PATH=$PATH:$DOTNET_ROOT:$HOME/.dotnet/tools/:$DOTNET_ROOT/tools

export LANG="en_US.UTF-8"
export KUBE_EDITOR="nvim"
export EDITOR="nvim" # Used by oh-my-tmux
export FZF_DEFAULT_OPTS=" \
--tmux \
--height 50% \
--reverse \
--border"
# fzf integration is handled by zim fzf module

# Ruby
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# source $(dirname $(gem which colorls))/tab_complete.sh

export PATH=/Applications/Ghostty.app/Contents/MacOS:$PATH

export PATH=/Applications/IntelliJ\ IDEA.app/Contents/MacOS:$PATH

# Go
export GOPATH="$HOME/Dev/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOPATH/bin:$PATH"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v25)
export PATH=$JAVA_HOME/bin:$PATH

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Rust/Cargo
. "$HOME/.cargo/env"

# uv
. "$HOME/.local/bin/env"

# fnm
eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"

# zoxide - handled by zim module

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Terminal - TERM is set by:
#   - tmux: via `set -g default-terminal "tmux-256color"` in ~/.tmux.conf.local
#   - Outside tmux: by the terminal emulator (Ghostty, iTerm2, etc.)

# ============================================================================
# Aliases
# ============================================================================

alias vi='nvim'
alias vim='nvim'
alias cls='clear'
alias ssh='TERM=${TERM/xterm-ghostty/xterm-256color} ssh'

alias ls='eza'
alias lc='lsd -l --group-directories-first'
alias lca='lsd -Al --group-directories-first'
alias lct='lsd --tree --group-directories-first'
alias l='eza -lg --icons --group-directories-first --sort=name --time-style=long-iso'
alias la='eza -alg --icons --group-directories-first --sort=name --time-style=long-iso'
alias lt='eza -lg --icons --group-directories-first --sort=name --time-style=long-iso --tree'

# ============================================================================
# Powerlevel10k
# ============================================================================

POWERLEVEL9K_MODE="nerdfont-complete"
# Customise the Powerlevel9k prompts
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon ssh dir vcs status newline)
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user ssh dir vcs status newline)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(pyenv command_execution_time time)
# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Plugin Configuration
# ============================================================================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

function jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  export PATH=$JAVA_HOME/bin:$PATH
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Key Bindings
bindkey "^U" backward-kill-line
