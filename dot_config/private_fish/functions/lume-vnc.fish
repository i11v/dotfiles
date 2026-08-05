function lume-vnc --description "Open VNC connection to a lume VM"
    set -l vm_name $argv[1]
    if test -z "$vm_name"
        echo "Usage: lume-vnc <vm-name>"
        return 1
    end

    set -l vnc_addr (lume ls 2>/dev/null | awk -v name="$vm_name" '$1 == name {print $NF}')

    if test -z "$vnc_addr" -o "$vnc_addr" = "-"
        echo "No VNC address found for '$vm_name'"
        return 1
    end

    open "$vnc_addr"
end
