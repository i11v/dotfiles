if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    # Set up fzf key bindings
    fzf --fish | source
end

fish_add_path /opt/homebrew/bin
fish_add_path "$HOME/.local/bin"

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Added by Raindrop installer
fish_add_path "$HOME/.raindrop/bin"
# End Raindrop installer
