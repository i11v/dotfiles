function gwt
    # Helper function to get worktree name from branch
    function _get_worktree_info
        set branch_name $argv[1]
        set current_dir (basename (pwd))
        set meaningful_part (string split "/" $branch_name)[-1]
        set worktree_name "$current_dir"_"$meaningful_part"
        set worktree_path "../$worktree_name"

        # Return both name and path
        echo $worktree_name
        echo $worktree_path
    end

    # Check if first argument is "cleanup"
    if test "$argv[1]" = "cleanup"
        # Remove "cleanup" from argv and parse the rest
        set -e argv[1]
        argparse 'f/force' -- $argv
        or return

        if test (count $argv) -lt 1
            # No branch name provided - cleanup current worktree
            set current_branch (git branch --show-current)
            if test -z "$current_branch"
                echo "Error: Not on a branch or branch name required"
                echo "Usage: gwt cleanup <branch-name>"
                return 1
            end

            # Get the main worktree path (first line from worktree list)
            set main_worktree (git worktree list | head -1 | awk '{print $1}')
            set current_path (pwd)

            # Change to main worktree
            cd $main_worktree

            # Remove the worktree with --force flag if provided
            if set -q _flag_force
                git worktree remove --force $current_path
            else
                git worktree remove $current_path
            end
            and echo "Removed worktree: $current_path"

            return
        end

        set branch_name $argv[1]
        set worktree_info (_get_worktree_info $branch_name)
        set worktree_path $worktree_info[2]

        # Verify the worktree exists
        if not test -d $worktree_path
            echo "Error: No worktree found at '$worktree_path' for branch '$branch_name'"
            echo ""
            echo "Existing worktrees:"
            git worktree list
            return 1
        end

        # Remove the worktree with --force flag if provided
        if set -q _flag_force
            git worktree remove --force $worktree_path
        else
            git worktree remove $worktree_path
        end
        and echo "Removed worktree: $worktree_path"

        return
    end

    # Original worktree creation logic
    argparse 'no-cd' -- $argv
    or return

    # Check if branch name was provided
    if test (count $argv) -lt 1
        echo "Error: Branch name required"
        echo "Usage: gwt <branch-name>"
        echo "       gwt cleanup <branch-name>"
        echo ""
        echo "Existing worktrees:"
        git worktree list
        return 1
    end

    set branch_name $argv[1]
    set worktree_info (_get_worktree_info $branch_name)
    set worktree_name $worktree_info[1]
    set worktree_path $worktree_info[2]

    # Check if worktree already exists
    if test -d $worktree_path
        echo "Worktree already exists at $worktree_path"
        # Change directory unless --no-cd flag is passed
        if not set -q _flag_no_cd
            cd $worktree_path
            echo "Changed to existing worktree"
        end
        return 0
    end

    # Fetch latest changes from remote
    echo "Fetching latest changes..."
    git fetch

    # Try to add worktree, first as local branch, then as remote branch, then create new
    if not git worktree add $worktree_path $branch_name 2>/dev/null
        # If that fails, try with origin/ prefix and -b flag to create tracking branch
        if not git worktree add -b $branch_name $worktree_path "origin/$branch_name" 2>/dev/null
            # If that also fails, create a new branch
            echo "Branch '$branch_name' not found. Creating new branch..."
            if not git worktree add -b $branch_name $worktree_path 2>/dev/null
                echo "Error: Failed to create worktree with branch '$branch_name'"
                return 1
            end
        end
    end

    # Change directory unless --no-cd flag is passed
    if not set -q _flag_no_cd
        cd $worktree_path
    end
end
