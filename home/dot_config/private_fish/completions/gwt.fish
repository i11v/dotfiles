# Disable file completion for gwt
complete -c gwt -f

# Complete with "cleanup" only if user has started typing it
complete -c gwt -n "__fish_is_first_arg" -a "cleanup" -d "Remove a worktree"

# Complete with branches that have worktrees as first argument
complete -c gwt -n "__fish_is_first_arg; and not __fish_seen_subcommand_from cleanup" -a "(git worktree list | tail -n +2 | awk '{print \$3}' | string trim -c '[]')" -d "Worktree branch"

# Complete with branches that have worktrees after "cleanup"
complete -c gwt -n "__fish_seen_subcommand_from cleanup" -a "(git worktree list | tail -n +2 | awk '{print \$3}' | string trim -c '[]')" -d "Worktree branch"

# Add --no-cd flag completion
complete -c gwt -l no-cd -d "Don't change directory after creating worktree"

