# Completion for watcher: flags and path suggestions
complete -c watcher -n 'not __fish_watcher_seen_separator' -s c -l clear   -d "Clear the screen before executing the command"
complete -c watcher -n 'not __fish_watcher_seen_separator' -s r -l restart -d "Kill and restart a long-running process"
complete -c watcher -n 'not __fish_watcher_seen_separator' -s z -l oneshot -d "Execute once on the first change, then exit"
complete -c watcher -n 'not __fish_watcher_seen_separator' -s d -l dirs    -d "Watch for directory updates (file add/delete) only"
complete -c watcher -n 'not __fish_watcher_seen_separator' -s h -l help    -d "Show help message"

# Offer completions only after the '--' separator: placeholder and commands
function __fish_watcher_seen_separator
    for t in (commandline -opc)
        if test "$t" = '--'
            return 0
        end
    end
    return 1
end

# Reference to the changed file placeholder, only after '--'
complete -c watcher -n '__fish_watcher_seen_separator' -a '/_' -d "Reference to the changed file"

# Suggest commands (functions and executables in $PATH) after '--'
complete -c watcher -n '__fish_watcher_seen_separator' -a '(functions -n; for d in (string split ":" $PATH); for f in (ls -1 $d 2>/dev/null); test -x "$d/$f"; and echo $f; end; end | sort -u)' -d "Command to run"

# Suggest directories to watch (prefer fd if available, fallback to listing directories)
complete -c watcher -n 'not __fish_watcher_seen_separator' -a '(fd --type d 2>/dev/null || ls -d */ 2>/dev/null)' -d "Paths to watch"
