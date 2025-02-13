source ~/.config/fish/alias.fish


# Configure Jump
status --is-interactive; and source (jump shell fish | psub)

set -g fish_greeting

set -gx EDITOR nvim
set -Ux TERMINAL alacritty

# Remove the virtualenv prompt from fish config, will be in starship
set -Ux VIRTUAL_ENV_DISABLE_PROMPT 1

# --------- fzf
# https://github.com/PatrickF1/fzf.fish#configuration

# Change Search History's date time format
set fzf_history_time_format %d-%m-%y

set fzf_preview_dir_cmd eza --all --color=always
set -g fzf_fd_opts "--hidden --exclude .git"

fzf_configure_bindings --history=\ch --directory=\cf --git_log=\cg --git_status=\cs --processes=\cp --variables=\cv

# Fzf for files
function fzf_vim
    set file (fzf --preview 'bat --color=always {}' --height=40%)
    if test -n "$file"
        $EDITOR "$file"
    end
end

for mode in insert default visual normal
    bind -M $mode \cr fzf_vim
end


# Enable vi-mode
#fish_vi_key_bindings

# Bind Ctrl + Space for all relevant modes
bind -M default -k nul accept-autosuggestion
bind -M insert -k nul accept-autosuggestion
bind -M visual -k nul accept-autosuggestion

# Custom Keybind
#bind -M insert \cA beginning-of-line
#bind -M insert \cE end-of-line
for mode in insert default visual
    bind -M $mode \ca beginning-of-line
    bind -M $mode \ce end-of-line
    #bind -M $mode \cp up-or-search
    #bind -M $mode \cn down-or-search
    bind -M $mode \cj execute
end

# colorscheme
#!/usr/bin/fish

# Kanagawa Fish shell theme
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# Pyenv setup
# Set up pyenv and pyenv-virtualenv
set -x PYENV_ROOT "$HOME/.pyenv"
set -x PATH "$PYENV_ROOT/bin" $PATH

# Initialize pyenv without rehashing for faster startup
eval (pyenv init - --no-rehash | source)
eval (pyenv virtualenv-init - | source)
##set -Ux PYENV_ROOT $HOME/.pyenv
#fish_add_path $PYENV_ROOT/bin
#
## pyenv
#if type -q pyenv
#    set -Ux PYENV_ROOT $HOME/.pyenv
#    set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
#    status --is-interactive; and pyenv init --path | source
#    status --is-interactive; and pyenv init - | source
#    status --is-interactive; and pyenv virtualenv-init - | source
#end
# starship
starship init fish | source
