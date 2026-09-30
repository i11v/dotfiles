function deploy --description 'Start and monitor a service deployment workflow'
    argparse 'service=' 'branch=' 'workflow=' 'environment=' -- $argv
    or return

    if test (count $argv) -ne 0; or not set -q _flag_service; or not set -q _flag_branch; or not set -q _flag_workflow
        echo 'Usage: deploy --service <service> --branch <branch> --workflow <workflow> [--environment <environment>]' >&2
        return 2
    end

    set -l environment Staging
    if set -q _flag_environment
        set environment $_flag_environment
    end

    set -l run_url (gh workflow run $_flag_workflow -f "app=$_flag_service" -f "environment=$environment" --ref $_flag_branch)
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
