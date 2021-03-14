# Windows related
alias windoc="cd /mnt/c/Users/gabri/Documents"

# Alias Management related
alias srcbash="source ~/.bashrc"
alias edalias="nano ~/.bash_aliases"
alias lsalias="cat ~/.bash_aliases"

# Terminal related
alias clc="clear"
alias cls="clear"
alias ..="cd .."
alias ...="cd ../.."

# Git Related
alias gst="git status"
alias gc="git commit"
alias gcm="git commit -m"
alias gpl="git pull"
alias gp="git push"
alias gf="git fetch"
alias gfp="git fetch -p" 
alias glsb="git branch -la"
alias gbd="git branch -d"
alias gshls="git stash list"
alias gshp="git stash pop"

untouchableBranches="master|devel|staging"
alias gvmb="gfp && git branch --merged | grep -Ev '$untouchableBranches' >/tmp/merged-branches-$(basename $PWD) && nano /tmp/merged-branches-$(basename $PWD)"
alias gdelmb="echo '=> This command will show a list of branches and remove them from local remote...' && read -p '=> Press enter to continue...' && nano /tmp/merged-branches-$(basename $PWD) && xargs git branch -d </tmp/merged-branches-$(basename $PWD) && rm /tmp/merged-branches-$(basename $PWD)"
alias setdighedrepo="git config --local --replace-all core.sshcommand 'ssh -i /home/gbrl18/.ssh/id_ed25519_digheontech_gitlab' && \\
                     git config --local --replace-all user.email gsantiago@digheontech.com && \\
                     git config --local --replace-all user.name 'Gabriel S. Santiago'"

# Python related
alias py="python3"

# DBMS Related
alias mqlrs="sudo service mysql restart"

# code workspaces related
. ~/.workspaces_manager.sh
