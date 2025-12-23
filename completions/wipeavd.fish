# Completion for wipeavd: suggest available AVDs
complete -c wipeavd -f -a '(emulator -list-avds 2>/dev/null)' -d 'AVD name to wipe'
