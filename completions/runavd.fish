# Completion for runavd: coldboot flag and available AVD names
complete -c runavd -s c -l coldboot -d 'Launch emulator with cold boot (no snapshot)'
complete -c runavd -f -a '(emulator -list-avds 2>/dev/null)' -d 'AVD name'
