set PATH $HOME/.rbenv/shims $HOME/bin $PATH
set -x JAVA_HOME (/usr/libexec/java_home)
rbenv init - | source

# Aliases
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gpl='git pull'
alias gps='git push'
alias gpsu='git push -u origin HEAD'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gr!='git reset --hard HEAD'
alias gcl='git clean -fd'
alias gre='git rebase'
alias grec='git rebase --continue'
alias gres='git rebase --skip'
alias grea='git rebase --abort'
alias gmt='git mergetool'

