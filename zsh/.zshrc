# ============================================================================
# SYSTEM INITIALIZATION
# ============================================================================
# Initialize Homebrew on macOS (Apple Silicon)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# XDG Base Directory Specification
export XDG_CONFIG_HOME=$HOME/.config

# Editor configuration
export EDITOR=nvim

# PATH configuration
export PATH="$HOME/.local/share/bob/nvim-bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$HOME/bin:$HOME/.composer/vendor/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"


# ============================================================================
# ZINIT PLUGIN MANAGER
# ============================================================================
# Set the directory for zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it doesn't exist
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# ============================================================================
# ZSH PLUGINS
# ============================================================================
# Syntax highlighting and autocompletion plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

# Zsh vi mode configuration
ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# Oh My Zsh snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::asdf

# Load completions
autoload -Uz compinit && compinit

# Replay zinit cd commands
zinit cdreplay -q

# ============================================================================
# ZSH OPTIONS AND SETTINGS
# ============================================================================
# History configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:j:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ============================================================================
# ALIASES
# ============================================================================
# General aliases
alias ls='eza'
alias la='eza -lao'
alias v='nvim'
alias c='clear'

# Navigation aliases (using zoxide)
alias ..='cd ..'
alias ...='cd ../..'

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# SHELL INTEGRATIONS
# ============================================================================
# FZF (fuzzy finder) integration
source <(fzf --zsh)

# Zoxide (smart cd)
eval "$(zoxide init --cmd cd zsh)"
