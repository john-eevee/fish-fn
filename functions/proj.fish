function proj --description "Open a project in the current editor"


    # defaults
    set -l search_paths $HOME/projects $HOME/Projects \
      $HOME/work $HOME/Work  $HOME/code $HOME/Code

    $count_args = count $argv
    if test $count_args -gt 0
        log "Using custom search paths: $argv"
        set search_paths $argv
    end

    # Catppuccin Mocha color palette
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

    set -l fzf_opts \
    --reverse \
    --border="rounded" \
    --prompt="Go to > " \
    --pointer=">" \
    --marker=">" \
    --height=40% \
    --color="bg+:$color02,bg:$color00,spinner:$color06,hl:$color08" \
    --color="fg:$color05,header:$color08,info:$color0E,pointer:$color06" \
    --color="marker:$color06,fg+:$color05,prompt:$color0E,hl+:$color08" \
    --preview="eza --tree --level=2 --icons --git --group-directories-first --color=always {1}" \
    --preview-window="right:60%:border-left"

    set -l valid_paths
    for path in $search_paths
        if test -d $path
            set valid_paths $valid_paths $path
        end
    end

    if test (count $valid_paths) -eq 0
        set valid_paths $HOME
    end

    set -l result (fd --type d --hidden --glob ".git" $valid_paths --exec dirname | fzf $fzf_opts)
    if test $EDITOR = ""
        set EDITOR "code"  # Default to VSCode if EDITOR is not set
    end

    if test -n "$result"
        cd $result
        # mise is hooked on cd
        post_project_cd
        $EDITOR .
        log -l info "Opened project at $result in $EDITOR"
    end
end


function post_project_cd --description "Actions to perform after changing to a project directory"
    set -l project_type (get_project_type)
    switch $project_type
    case node
       on_node_callback
    case java-maven
        on_java_callback
    case java-gradle
        on_java_callback
    case python
        on_python_callback
    case elixir
        on_elixir_callback
    case flutter
        on_flutter_callback
    case '*'
       # No specific actions for unknown project types
end


function get_project_type --description "Determine the type of project in the current directory"
    set -l project_type "unknown"
    if test-f "package.json"
        set project_type "node"
    else if test -f "pom.xml"
        set project_type "java-maven"
    else if test -f "build.gradle" -o -f "build.gradle.kts"
        set project_type "java-gradle"
    else if test -f "setup.py" -o -f "pyproject.toml"
        set project_type "python"
    else if test -f "mix.exs"
        set project_type "elixir"
      else if test -f "pubspec.yaml"
        set project_type "flutter"
    else
        set project_type "unknown"
    end

    return $project_type
end
