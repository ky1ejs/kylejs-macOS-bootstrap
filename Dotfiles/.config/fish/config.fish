set PATH $HOME/.rbenv/shims $HOME/.jenv/bin $HOME/bin /usr/local/lib/node_modules /Applications/IntelliJ IDEA.app/Contents/MacOS $PATH

eval (/opt/homebrew/bin/brew shellenv)

# jenv
status --is-interactive; and source (jenv init -|psub)

# pyenv
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

set -g theme_vcs_ignore_paths $HOME/Developer/spotify/client-android $HOME/Developer/spotify/client-ios
set GPG_TTY = (tty)

# starship
starship init fish | source

# fnm
fnm env | source
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"


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
alias gfu='git fetch upstream -p'
alias grup='git reset --hard upstream/master && git push -f origin master'
alias brew="env PATH=(string replace (pyenv root)/shims '' \"\$PATH\") brew"
alias npex='npm run-script env --'
alias docker-stop-all='docker stop $(docker ps -a -q)'
alias pn=pnpm

# Created by `pipx` on 2022-08-31 13:10:32
set PATH $PATH /Users/kylejs/.local/bin

# SPT CONFIG BEGIN
function spt; fish -c 'cd "$(git rev-parse --show-toplevel)" && ./tools/sptcli/src/sptcli.py $argv'; end
# SPT CONFIG END
fish_add_path --move --path /opt/spotify-devex/bin
