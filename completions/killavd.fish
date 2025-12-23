# Completion for killavd: suggest connected emulator device IDs (via adb)
complete -c killavd -f -a "(adb devices | awk '/emulator-/{print $1}' 2>/dev/null)" -d "Emulator device id (e.g., emulator-5554)"
