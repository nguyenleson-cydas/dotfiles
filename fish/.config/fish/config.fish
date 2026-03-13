# ==================== PATH CONFIGURATION ====================
fish_add_path ~/.local/share/bob/nightly/bin
fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path /opt/homebrew/opt/mysql@8.0/bin

# ==================== ENVIRONMENT VARIABLES ====================
set -gx XDG_CONFIG_HOME ~/.config
set -gx EDITOR nvim
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
set -gx EZA_CONFIG_DIR "$XDG_CONFIG_HOME/eza"
set -gx LC_TIME ja_JP.UTF-8

# ==================== ASDF CONFIGURATION CODE  ====================

if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

set -g fish_key_bindings fish_vi_key_bindings

# ==================== TOOL INITIALIZATION ====================
# Initialize tools (order matters)
starship init fish | source
fzf --fish | source
zoxide init fish | source

# ==================== ABBREVIATIONS ====================
abbr -a ls 'eza'
abbr -a la 'eza -lao'
abbr -a v 'nvim'
abbr -a c 'clear'
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
