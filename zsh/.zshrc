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
alias zz='z ..'
alias zzz='z ../..'
alias v='nvim'
alias vz='nvim ~/.zshrc'
alias c='clear'
alias ts='tmux source ~/.config/tmux/tmux.conf'
alias sz='source ~/.zshrc'
alias ca='cursor-agent'

# alias phpstan='docker run -v $PWD:/app --rm ghcr.io/phpstan/phpstan'

alias us='cd $HOME/dev/intern/uranus/app/vue && ASDF_NODEJS_VERSION=10.15.2 npm start'
alias uw='cd $HOME/dev/intern/uranus/app/vue && ASDF_NODEJS_VERSION=10.15.2 npm run watch'

# Path
export PATH="$HOME/.local/share/bob/nvim-bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$HOME/bin:$PATH"

XDG_CONFIG_HOME=$HOME/.config
STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


