function d-psql --description "Connect to a running Postgres container via psql"
    set -l container_name $argv[1]

    # If no name provided, try to find a likely candidate
    if test -z "$container_name"
        set container_name (docker ps --format "{{.Names}}" | grep -E "postgres|db" | head -n 1)
    end

    if test -n "$container_name"
        echo "Connecting to database in container: $container_name..."
        # Assumes user 'postgres'. Change -U if you use a different default.
        docker exec -it $container_name psql -U postgres
    else
        log "No Postgres container found. Please specify a container name."
    end
end
