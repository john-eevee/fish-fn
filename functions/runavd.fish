function runavd --description "Select and launch an Android Emulator"
    # Check if emulator command exists
    if not type -q emulator
        echo "Error: 'emulator' command not found. Check your Android SDK PATH."
        return 1
    end

    argparse "c/coldboot" -- $argv

    set -l target_avd ""
    set -l is_coldboot (test -z _flag_coldboot)

    # Use FZF if available for a nice menu
    if type -q fzf
        set target_avd (emulator -list-avds | fzf --header="Select an AVD to launch")
    else
        # Fallback: List them and ask user to type
        echo "Available AVDs:"
        emulator -list-avds
        echo ""
        read -P "Type the name of the AVD to launch: " target_avd
    end

    if test -n "$target_avd"
        echo "Booting $target_avd..."
        # Launch detached from shell, hiding output
        if $is_coldboot
            nohup emulator -avd "$target_avd" -no-snapshot-load > /dev/null 2>&1 &
        else
        nohup emulator -avd "$target_avd" > /dev/null 2>&1 &
        disown
    else
        echo "No AVD selected."
    end
end
