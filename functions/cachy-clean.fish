function cachy-clean --description "Clean pacman cache, keep last 2 versions"
    # requires pacman-contrib package usually
    if type -q paccache
        sudo paccache -r -k 2
        log "Package cache cleaned (kept last 2 versions)."
    else
        log "Please install 'pacman-contrib' to use paccache."
    end
end
