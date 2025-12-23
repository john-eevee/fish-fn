function log --description 'Log a message with a timestamp on the given level'
    set -l help "Simple logger with levels and a global severity filter.

    Usage:
    log [-l|--level LEVEL] <message>

    Options:
    -l LEVEL, --level LEVEL   Set the log level (debug, info, warn, error, fatal).
                              Default is 'debug'.

    -h, --help                Show this help message.

    Environment Variable:
    LOG_LEVEL                 Set the global log level threshold (see --level).
                              Messages below this level will not be printed.


    Examples:
    log -l info This is an informational message.
    log --level error An error occurred.
    set -gx LOG_LEVEL warn; log This debug message will not be shown.
    "

    # Default log level is 'debug'
    set -l level debug

    # Parse optional switches. Support:
    #  -l LEVEL | --level LEVEL  -> set the message level
    #  -h | --help               -> show usage
    while test (count $argv) -gt 0
        switch $argv[1]
            case -l --level
                if test (count $argv) -lt 2
                    echo "Usage: log [-l|--level LEVEL] <message>"
                    return 1
                end
                set level $argv[2]
                set argv $argv[3..-1]
            case -h --help
                echo "$help"
                return 0
            case '*'
                break
        end
    end

    if test (count $argv) -eq 0
        echo "$help"
        return 1
    end

    set -l timestamp (date "+%Y-%m-%d %H:%M:%S")
    set -l message (string join " " $argv)

    # Normalize and validate level
    set level (string lower $level)
    switch $level
        case debug info warn error fatal
            # valid
        case '*'
            echo "Invalid log level: $level"
            echo "Valid levels: debug, info, warn, error, fatal"
            return 1
    end

    # Map message level to numeric rank (declare local var first)
    set -l msg_rank
    switch $level
        case debug
            set msg_rank 0
        case info
            set msg_rank 1
        case warn
            set msg_rank 2
        case error
            set msg_rank 3
        case fatal
            set msg_rank 4
    end

    # Map level to color
    set -l reset (set_color normal)
    set -l color
    switch $level
        case debug
            set color (set_color brcyan)
        case info
            set color (set_color green)
        case warn
            set color (set_color yellow)
        case error
            set color (set_color red)
        case fatal
            set color (set_color brred)
        case '*'
            set color (set_color normal)
    end

    # Determine threshold rank from LOG_LEVEL (defaults to debug)
    if set -q LOG_LEVEL
        set threshold_level (string lower -- $LOG_LEVEL)
    else
        set threshold_level debug
    end

    # threshold_rank already declared at top
    switch $threshold_level
        case debug
            set threshold_rank 0
        case info
            set threshold_rank 1
        case warn
            set threshold_rank 2
        case error
            set threshold_rank 3
        case fatal
            set threshold_rank 4
        case '*'
            echo "Invalid LOG_LEVEL: $LOG_LEVEL; defaulting to debug" >&2
            set threshold_rank 0
    end



    # Only print if message rank >= threshold rank
    if test $msg_rank -lt $threshold_rank
        return 0
    end
    printf "%s [%s%s%s] %s\n" $timestamp $color (string upper $level) $reset $message
end
