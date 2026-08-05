function take --description 'mkdir + cd, or clone/extract + cd'
    if test (count $argv) -eq 0
        echo "take: missing argument" >&2
        return 1
    end

    set -l target $argv[1]

    switch $target
        case 'http://*.git' 'https://*.git' 'git@*:*' 'ssh://*.git' 'git://*'
            set -l name (basename $target .git)
            git clone $target $name; or return
            cd $name
        case '*.tar.gz' '*.tgz' '*.tar.bz2' '*.tbz2' '*.tar.xz' '*.txz' '*.tar'
            set -l file
            switch $target
                case 'http://*' 'https://*' 'ftp://*'
                    set file (basename $target)
                    curl -fL -o $file $target; or return
                case '*'
                    set file $target
            end
            set -l name (string replace -r '\.(tar\.gz|tgz|tar\.bz2|tbz2|tar\.xz|txz|tar)$' '' (basename $file))
            mkdir -p $name; or return
            tar xf $file -C $name --strip-components=1; or return
            cd $name
        case '*'
            mkdir -p $target; or return
            cd $target
    end
end
