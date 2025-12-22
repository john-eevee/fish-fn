function proj --description "Open a project in the current editor"
    # 1. SETTINGS
    # Where do you keep your projects? Add more paths here if needed.
    # We look for folders in ~/Projects, ~/dev, ~/workspace, or just subfolders of Home.
    set -l search_paths ~/Projects ~/dev ~/code ~/workspace

    # 2. DEFINING COLORS (Catppuccin Mocha)
    set -l color00 '#1e1e2e' # Base
    set -l color01 '#181825' # Mantle
    set -l color02 '#313244' # Surface0
    set -l color03 '#45475a' # Surface1
    set -l color04 '#585b70' # Surface2
    set -l color05 '#cdd6f4' # Text
    set -l color06 '#f5e0dc' # Rosewater
    set -l color07 '#b4befe' # Lavender
    set -l color08 '#f38ba8' # Red
    set -l color09 '#fab387' # Peach
    set -l color0A '#f9e2af' # Yellow
    set -l color0B '#a6e3a1' # Green
    set -l color0C '#94e2d5' # Teal
    set -l color0D '#89b4fa' # Blue
    set -l color0E '#cba6f7' # Mauve
    set -l color0F '#f2cdcd' # Flamingo

    # 3. FZF OPTIONS
    # - Layout: Reverse (top-down) with a border
    # - Preview: Uses 'eza' to show a tree with icons and git status
    set -l fzf_opts \
    --reverse \
    --border="rounded" \
    --prompt="Go to > " \
    --pointer="aa" \
    --marker=">" \
    --height=40% \
    --color="bg+:$color02,bg:$color00,spinner:$color06,hl:$color08" \
    --color="fg:$color05,header:$color08,info:$color0E,pointer:$color06" \
    --color="marker:$color06,fg+:$color05,prompt:$color0E,hl+:$color08" \
    --preview="eza --tree --level=2 --icons --git --group-directories-first --color=always {1}" \
    --preview-window="right:60%:border-left"

    # Check which search paths actually exist to avoid errors
    set -l valid_paths
    for path in $search_paths
        if test -d $path
            set valid_paths $valid_paths $path
        end
    end

    # If no project folders exist, fallback to Home (depth 1)
    if test (count $valid_paths) -eq 0
        set valid_paths $HOME
    end

    # Run the search
    set -l result (fd --type d --hidden --glob ".git" $valid_paths --exec dirname | fzf $fzf_opts)

    if test $EDITOR = ""
        set EDITOR "code"  # Default to VSCode if EDITOR is not set
    end
    # 5. ACTION
    if test -n "$result"
        # Navigate to the directory
        cd $result

        # 'mise' is hooked into fish, so the 'cd' above automatically triggers the env switch.

        # Open EDITOR
        $EDITOR .

        # Clear screen and print success
        commandline -f repaint
        echo -e "\n\033[0;32mOpened project: $result\033[0m"
    end
end
