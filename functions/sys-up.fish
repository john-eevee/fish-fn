function sys-up --description "Update CachyOS/Arch System"
    if type -q paru
        paru -Syu
    else
        sudo pacman -Syu
    end
end
