function wipeavd --description "Launch emulator with user data wiped"
    log -l warn "Wiping AVD user data is irreversible. Ensure you have backups of any important data."
    set -l target_avd (emulator -list-avds | fzf --header="SELECT AVD TO WIPE")

    if test -n "$target_avd"
        read -P "Are you sure you want to wipe $target_avd? (y/N) " confirm
        if test "$confirm" = "y"
            nohup emulator -avd "$target_avd" -wipe-data > /dev/null 2>&1 &
            disown
            _may_start_avd "$target_avd"
        else
            log "Cancelled."
        end
    end
end

function _may_start_avd --description "Prompt to start AVD after wiping data"
    read -P "Do you want to start the AVD now? (y/N) " start_confirm
    if test "$start_confirm" = "y"
        nohup emulator -avd "$argv[1]" > /dev/null 2>&1 &
        disown
        log "Started AVD $argv[1]."
    else
        log "You can start the AVD later using: emulator -avd $argv[1]"
    end
end
