# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# Zim Framework
# ============================================================================

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Use emacs keybindings (must be before zim init)
bindkey -e

# Homebrew (must be before zim init for plugins to find commands)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# macOS uses gdircolors (required by zsh-dircolors-solarized)
# Use function instead of alias (aliases don't work in scripts/functions)
if (( $+commands[gdircolors] )); then
  dircolors() { gdircolors "$@" }
fi

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

# History settings (Override Zim defaults)
HISTSIZE=1000000
SAVEHIST=1000000

# ============================================================================
# Environment Variables
# ============================================================================

export DEV_DIR="$HOME/Dev"

# export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_ROOT=/usr/local/share/dotnet
export PATH=$PATH:$DOTNET_ROOT:$HOME/.dotnet/tools/:$DOTNET_ROOT/tools

export LANG="en_US.UTF-8"
export KUBE_EDITOR="nvim"
export EDITOR="nvim" # Used by oh-my-tmux
# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS=" \
--tmux \
--height 50% \
--reverse \
--border \
--bind '?:toggle-preview' \
--preview-window=right:50%"

export FZF_CTRL_T_OPTS=" \
--preview 'bat \
  --color=always \
  --style=numbers \
  --line-range :500 {} 2>/dev/null || cat {}'"

export FZF_ALT_C_OPTS=" \
--preview 'eza \
  --tree \
  --color=always \
  --icons {} 2>/dev/null || ls -la {}'"

# fzf keybindings and completion (deferred)
zsh-defer eval "$(fzf --zsh)"

# Ruby
# if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  # export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  # export PATH=`gem environment gemdir`/bin:$PATH
# fi

export PATH=/Applications/Ghostty.app/Contents/MacOS:$PATH
export PATH=/Applications/IntelliJ\ IDEA.app/Contents/MacOS:$PATH
# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"

# Go
export GOPATH="$DEV_DIR/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOPATH/bin:$PATH"

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

# Completions cache directory
ZSH_COMPLETIONS_CACHE="$HOME/.cache/zsh/completions"
[[ -d "$ZSH_COMPLETIONS_CACHE" ]] || mkdir -p "$ZSH_COMPLETIONS_CACHE"

# fnm (env deferred, completions cached)
function _setup_fnm() {
  # Completions: source cache, regenerate in background
  [[ -f "$ZSH_COMPLETIONS_CACHE/_fnm" ]] && source "$ZSH_COMPLETIONS_CACHE/_fnm"
  fnm completions --shell zsh >| "$ZSH_COMPLETIONS_CACHE/_fnm" &|
  # Env: must eval each time (node version can change)
  eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"
}
(( $+commands[fnm] )) && zsh-defer _setup_fnm

# zoxide (deferred)
zsh-defer eval "$(zoxide init zsh)"

# uv/uvx (completions cached, regenerate in background)
function _setup_uv() {
  [[ -f "$ZSH_COMPLETIONS_CACHE/_uv" ]] && source "$ZSH_COMPLETIONS_CACHE/_uv"
  [[ -f "$ZSH_COMPLETIONS_CACHE/_uvx" ]] && source "$ZSH_COMPLETIONS_CACHE/_uvx"
  uv generate-shell-completion zsh >| "$ZSH_COMPLETIONS_CACHE/_uv" &|
  uvx --generate-shell-completion zsh >| "$ZSH_COMPLETIONS_CACHE/_uvx" &|
}
(( $+commands[uv] )) && zsh-defer _setup_uv

# ============================================================================
# Aliases & Configuration
# ============================================================================

alias vi='nvim'
alias vim='nvim'
alias cls='clear'
alias ssh='TERM=${TERM/xterm-ghostty/xterm-256color} ssh'
alias w1='watch -n 1 '

alias ls='eza'
_eza_opts="\
--icons \
--group-directories-first \
--sort=name \
--time-style=long-iso \
--hyperlink"
alias l="eza -lg $_eza_opts"
alias la="eza -alg $_eza_opts"
alias lt="eza -lg $_eza_opts --tree --level=2"

_lsd_opts="\
--group-directories-first \
--hyperlink=auto"
alias lc="lsd -l $_lsd_opts"
alias lca="lsd -Al $_lsd_opts"
alias lct="lsd --tree --depth=2 $_lsd_opts"

# Powerlevel10k (legacy p9k config, overridden by ~/.p10k.zsh if exists)
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon ssh dir vcs status newline)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(pyenv command_execution_time time)

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# Google Cloud SDK
if [ -f "$DEV_DIR/google-cloud-sdk/path.zsh.inc" ]; then
  . "$DEV_DIR/google-cloud-sdk/path.zsh.inc"
fi
# gcloud completion (deferred - slow)
if [ -f "$DEV_DIR/google-cloud-sdk/completion.zsh.inc" ]; then
  zsh-defer . "$DEV_DIR/google-cloud-sdk/completion.zsh.inc"
fi

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

# OrbStack (deferred)
zsh-defer source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# ============================================================================
# Key Bindings
# ============================================================================

bindkey "^U" backward-kill-line
# Fix accidental Ctrl/Shift + Enter
bindkey '\e[27;2;13~' accept-line  # Shift+Enter
bindkey '\e[27;5;13~' accept-line  # Ctrl+Enter
bindkey '\e[27;6;13~' accept-line  # Ctrl+Shift+Enter
bindkey '\e[109;5u' accept-line    # Ctrl+m

# History search based on prefix (Up/Down arrows)
# Plugin: zsh-history-substring-search
# These must be bound AFTER the plugin is loaded (which happens in ~/.zimrc)
# Fix for multiline commands: check if the buffer has newlines.
# If so, use default up-line behavior to navigate within the multiline buffer.
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
fi
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey "${terminfo[kcud1]}" history-substring-search-down
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Set HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE to eliminate duplicates
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Make Ctrl+W stop at special chars (like bash/oh-my-zsh)
WORDCHARS=''

# Disable paste highlight (white background)
zle_highlight=('paste:none')
