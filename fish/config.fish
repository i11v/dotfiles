if status is-interactive
    starship init fish | source
    fzf --fish | source
end

fish_add_path /opt/homebrew/bin
fish_add_path "$HOME/.local/bin"

# Similarweb Tools
fish_add_path "$HOME/.dotnet/tools"

# IntelliJ IDEA
fish_add_path "/Applications/IntelliJ IDEA.app/Contents/MacOS"

# Environment variables
set -x JQ_LIBRARY_PATH $HOME/.jq

