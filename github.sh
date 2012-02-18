
# Some handy git aliases to be sourced into your .profile

alias gits='git status'

# preview bulk addition
alias gitadde='git ls-files -o --exclude-standard'

# bulk addition
alias gitadd='git ls-files -z -o --exclude-standard | xargs -0 git add'

# preview bulk removal
alias gitreme='git ls-files -d --exclude-standard'

# bulk removal
alias gitrem='git ls-files -z -d --exclude-standard | xargs -0 git rm'

# commit and push with an optional commit message
# (won't work for the very first commit where you first have to specify target/branch)
function gitcom() {
        comment="$*"
        if [ -z "$comment" ]; then comment='update'; fi;
        git commit -a -m "$comment" && git push;
}