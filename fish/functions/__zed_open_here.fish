function __zed_open_here --description 'Open the current directory in Zed'
    zed $PWD
    commandline -f repaint
end
