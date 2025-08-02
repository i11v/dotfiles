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
        set branch_name $argv[2]
        set worktree_info (_get_worktree_info $branch_name)
        set worktree_path $worktree_info[2]
        
        # Remove the worktree
        git worktree remove $worktree_path
        and echo "Removed worktree: $worktree_path"
        
        return
    end
    
    # Original worktree creation logic
    argparse 'no-cd' -- $argv
    or return
    
    set branch_name $argv[1]
    set worktree_info (_get_worktree_info $branch_name)
    set worktree_name $worktree_info[1]
    set worktree_path $worktree_info[2]
    
    git worktree add $worktree_path $branch_name
    
    # Change directory unless --no-cd flag is passed
    if not set -q _flag_no_cd
        cd $worktree_path
    end
end

