function codex --wraps codex --description 'Run Codex with the preferred model and reasoning effort'
    set --local model_args --model gpt-5.6-sol

    for arg in $argv
        switch $arg
            case -m '--model' '-m*' '--model=*'
                set model_args
                break
        end
    end

    command codex $model_args -c 'model_reasoning_effort="high"' $argv
end
