# ==================== COLOR THEME: SOLARIZED OSAKA ====================
# Color Palette
set -l foreground 839395
set -l selection 1a6397
set -l base01 576d74
set -l red db302d
set -l orange c94c16
set -l yellow b28500
set -l green 849900
set -l purple 6d71c4
set -l cyan 29a298
set -l pink d23681

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $base01
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $base01

# Completion Pager Colors
set -g fish_pager_color_progress $base01
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $base01
set -g fish_pager_color_selected_background --background=$selection

if status --is-login
    # ==================== PATH CONFIGURATION ====================
    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path ~/.local/bin
    fish_add_path ~/bin
    fish_add_path /opt/homebrew/opt/mysql@8.0/bin

    # ==================== ENVIRONMENT VARIABLES ====================
    set -gx XDG_CONFIG_HOME ~/.config
    set -gx EDITOR nvim
    set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
    set -gx EZA_CONFIG_DIR "$XDG_CONFIG_HOME/eza"
    set -gx LC_TIME=ja_JP.UTF-8
    # FZF configuration
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --border=none \
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
end

if status --is-interactive
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

    fastfetch
end
