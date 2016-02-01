[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source ~/.private_vars
source ~/.git-completion.bash

# Raise max file limit
ulimit -n 65536
ulimit -u 2048

# Env vars
export HISTCONTROL=ignoredups

## Opower
export workspace="$HOME/opower"
export GITHUB_HOST=github.va.opower.it
export POSE_USER=dj.madeira
export newrelic__enable=false 
export server__https=8082
export GIT_USER=dj.madeira

## Path mods
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:/usr/local/jmeter/bin"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$HOME/golang/bin
export PATH=$PATH:$PYTHONPATH
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting 

## Misc
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
export JMETER_HOME=/usr/local/jmeter
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Powerline
. $PYTHONPATH/powerline/bindings/bash/powerline.sh

# Aliases
alias mci="mvn clean install"
alias mcist="mvn -Dmaven.test.skip.exec=true clean install"
alias bim="vim"
alias flow="haxelib run flow"
alias vi="vim"
alias vibp="vim ~/.bash_profile && source ~/.bash_profile"
alias curljson="curl -H 'Accept: application/json' -H 'Content-Type: application/json'"

# Git aliases
alias gcm="git commit"
__git_complete gcm _git_commit
alias gad="git add"
__git_complete gad _git_add
alias gpu="git push"
__git_complete gpu _git_push
alias gpl="git pull"
__git_complete gpl _git_pull
alias gco="git checkout"
__git_complete gco _git_checkout
alias gst="git status"
__git_complete gst _git_status
alias gbr="git branch"
__git_complete gbr _git_branch
alias grm="git rm"
__git_complete grm _git_rm
alias grb="git rebase"
__git_complete grb _git_rebase
alias glg="git log"
__git_complete glg _git_log
alias grs="git reset"
__git_complete glg _git_log
alias gmr="git merge"
__git_complete gmr _git_merge
alias gdf="git diff"
__git_complete gdf _git_diff

function git_get_current_branch {
    CURR_BRANCH=$(git symbolic-ref --short HEAD)
}

function gplom {
  git_get_current_branch
  git checkout master
  git pull origin master
  git checkout $CURR_BRANCH
}

function gpucb {
  git_get_current_branch
  git push dj-madeira $CURR_BRANCH
}

function docker-up {
  docker-machine start default
  eval $(docker-machine env default)
}

# Job control aliases
alias kterm="kill -s SIGTERM"
alias kquit="kill -s SIGQUIT"

function mkcd {
  mkdir -p $1
  cd $1
}

function xwtest {
  test__unit=$1 test__browser=$2 test__retry=$3 npm test
}

source <(npm completion)

