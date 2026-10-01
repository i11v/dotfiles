function deploy --description 'Start and monitor a service deployment workflow'
    argparse 'service=' 'branch=' 'workflow=' 'environment=' -- $argv
    or return

    if test (count $argv) -ne 0; or not set -q _flag_service; or not set -q _flag_workflow
        echo 'Usage: deploy --service <service> --workflow <workflow> [--branch <branch>] [--environment <environment>]' >&2
        return 2
    end

    set -l branch
    if set -q _flag_branch
        set branch $_flag_branch
    else
        set branch (git branch --show-current 2>/dev/null)
        if test $status -ne 0; or test -z "$branch"
            echo 'deploy: could not determine the current branch; pass --branch <branch>' >&2
            return 2
        end
    end

    set -l environment Staging
    if set -q _flag_environment
        set environment $_flag_environment
    end

    set -l run_url (gh workflow run $_flag_workflow -f "app=$_flag_service" -f "environment=$environment" --ref $branch)
    or return

    set -l run_id (string replace -r '.*/' '' -- $run_url[-1])
    if not string match -rq '^[0-9]+$' -- $run_id
        echo "deploy: could not determine the workflow run ID from: $run_url" >&2
        return 1
    end

    while true
        clear
        date
        gh run view $run_id
        sleep 60
    end
end
