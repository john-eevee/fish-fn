function killavd --description "Kill a running emulator instance"
    # List connected devices that are emulators
    set -l devices (adb devices | grep "emulator-" | cut -f1)

    if test -z "$devices"
        echo "No running emulators found."
        return
    end

    if type -q fzf
        set target (string split " " $devices | fzf --header="Select Emulator to Kill")
    else
        echo "Running Emulators: $devices"
        read -P "Type device ID (e.g., emulator-5554): " target
    end

    if test -n "$target"
        echo "Stopping $target..."
        adb -s $target emu kill
    end
end
