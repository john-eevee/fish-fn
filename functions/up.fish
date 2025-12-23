function up --description "Go up N directories"
    set -l levels $argv[1]
    if test -z "$levels"
        set levels 1
    end
    set -l d ""
    for i in (seq $levels)
        set d "../$d"
    end
    cd $d
end
