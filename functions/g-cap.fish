function g-cap --description "Git add all, commit, and push"
    git add .
    git commit -m "$argv"
    git push origin (git branch --show-current)
end
