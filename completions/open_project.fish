# Completion for open_project: list project directories in common search locations
complete -c open_project -f -a "(for d in $HOME/projects $HOME/Projects $HOME/work $HOME/Work $HOME/code $HOME/Code; test -d $d; ls -1 -d $d/* 2>/dev/null; end)" -d "Project directory"
