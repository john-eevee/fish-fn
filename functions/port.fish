function port --description "Check what is running on a specific port"
    lsof -i tcp:$argv[1]
end
