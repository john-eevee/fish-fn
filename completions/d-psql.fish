# Completion for d-psql: suggest running container names (prefer postgres/db)
complete -c d-psql -f -a "(docker ps --format '{{.Names}}' 2>/dev/null | grep -E 'postgres|db' || docker ps --format '{{.Names}}' 2>/dev/null)" -d "Running container name"
