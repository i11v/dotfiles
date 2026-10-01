#!/usr/bin/env fish

set -g deploy_file (path resolve (status dirname)/../home/dot_config/private_fish/functions/deploy.fish)
set -g failures 0

function run_deploy --argument-names test_name current_branch expected_ref
    set -l output (env DEPLOY_FILE=$deploy_file CURRENT_BRANCH=$current_branch EXPECTED_REF=$expected_ref fish -c '
        function git
            if test "$argv[1]" = branch; and test "$argv[2]" = --show-current
                string escape -- $CURRENT_BRANCH
                return 0
            end

            return 1
        end

        function gh
            if test "$argv[1]" = workflow; and test "$argv[2]" = run
                set -l ref_index (contains -i -- --ref $argv)
                if test -z "$ref_index"
                    echo "missing --ref" >&2
                    return 1
                end

                set -l actual_ref $argv[(math $ref_index + 1)]
                if test "$actual_ref" != "$EXPECTED_REF"
                    echo "expected --ref $EXPECTED_REF, got $actual_ref" >&2
                    return 1
                end

                echo https://github.com/example/repository/actions/runs/123
                return 0
            end

            return 0
        end

        function clear
        end

        function date
        end

        function sleep
            exit 0
        end

        source $DEPLOY_FILE
        deploy $argv
    ' -- $argv[4..-1] 2>&1)

    if test $status -ne 0
        echo "not ok - $test_name"
        string join \n -- $output | string collect
        set failures (math $failures + 1)
        return
    end

    echo "ok - $test_name"
end

run_deploy 'uses the current branch when --branch is omitted' feature/current feature/current --service api --workflow deploy.yml
run_deploy 'prefers an explicit --branch' feature/current release/next --service api --workflow deploy.yml --branch release/next

set -l detached_output (env DEPLOY_FILE=$deploy_file CURRENT_BRANCH= fish -c '
    function git
        return 0
    end

    function gh
        echo "gh should not be called" >&2
        return 1
    end

    source $DEPLOY_FILE
    deploy --service api --workflow deploy.yml
' 2>&1)
set -l detached_status $status

if test $detached_status -ne 2; or not string match -q '*--branch*' -- $detached_output
    echo 'not ok - requires --branch in detached HEAD state'
    string join \n -- $detached_output | string collect
    set failures (math $failures + 1)
else
    echo 'ok - requires --branch in detached HEAD state'
end

exit $failures
