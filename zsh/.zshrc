# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
# zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::asdf

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias jj='j ..'
alias jjj='j ../..'
alias v='nvim'
alias vz='nvim ~/.zshrc'
alias c='clear'
alias ts='tmux source ~/.config/tmux/tmux.conf'
alias sz='source ~/.zshrc'
alias ca='cursor-agent'

alias us='ASDF_NODEJS_VERSION=10.15.2 npm --prefix $HOME/dev/intern/uranus/app/vue start'
alias uw='ASDF_NODEJS_VERSION=10.15.2 npm --prefix $HOME/dev/intern/uranus/app/vue run watch'

# Path
export PATH="$HOME/.local/share/bob/nvim-bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$HOME/bin:$HOME/.composer/vendor/bin:$PATH"
export XDG_CONFIG_HOME=$HOME/.config
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
export EDITOR=nvim

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd j zsh)"
eval "$(starship init zsh)"

export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/Users/fre_nguyen_s/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/fre_nguyen_s/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#002c38 \
  --color=bg:#001419 \
  --color=border:#063540 \
  --color=fg:#9eabac \
  --color=gutter:#001419 \
  --color=header:#c94c16 \
  --color=hl+:#c94c16 \
  --color=hl:#c94c16 \
  --color=info:#637981 \
  --color=marker:#c94c16 \
  --color=pointer:#c94c16 \
  --color=prompt:#c94c16 \
  --color=query:#9eabac:regular \
  --color=scrollbar:#063540 \
  --color=separator:#063540 \
  --color=spinner:#c94c16 \
"
