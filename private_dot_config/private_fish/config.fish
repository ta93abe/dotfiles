set fish_greeting

set -gx PATH /usr/local/go/bin $PATH
set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx PATH "$HOME/.pub-cache/bin" $PATH
set -gx DENO_INSTALL "$HOME/.deno"
set -gx PATH "$DENO_INSTALL/bin" $PATH
set -gx PATH /usr/local/bin $PATH
set -gx PATH /usr/bin $PATH
set -gx PATH $HOME/flutter/bin $PATH
set -gx PATH $HOME/.progate/bin $PATH
set -gx BUN_INSTALL "$HOME/.bun"
set -gx PATH "$BUN_INSTALL/bin" $PATH

if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (/opt/homebrew/bin/brew shellenv)
end


function ghq_peco_repo
    set selected_repository (ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_repository" ]
        cd $selected_repository
        echo "$selected_repository"
        commandline -f repaint
    end
end

function fish_user_key_bindings
    bind \cf ghq_peco_repo
end

if status --is-interactive
    abbr --add --global cat "bat"
    abbr --add --global mkdir "mkdir -p"
    abbr --add --global ls "lsd -la"
    abbr --add --global vi "nvim"
    abbr --add --global vim "nvim"
    abbr --add --global view "nvim -R"
    abbr --add --global python "python3"
    abbr --add --global brave "open -a Brave\ Browser.app --args --new-window"
    abbr --add --global f "fvm flutter"
    abbr --add --global d "fvm dart"

    zoxide init fish | source
    mcfly init fish | source
    starship init fish | source
end


