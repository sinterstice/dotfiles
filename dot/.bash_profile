source ~/.private_vars
source ~/.git-completion.bash

# Env vars
export HISTCONTROL=ignoredups # When going through command history, ignore the same command run multiple times in a row

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
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
export NVM_DIR=~/.nvm
export EDITOR=vim

# Powerline
. $PYTHONPATH/powerline/bindings/bash/powerline.sh
export XDG_CONFIG_HOME=~/.config

# Aliases
alias mci="mvn clean install"
alias mcist="mvn -Dpmd.skip=true -Dmaven.test.skip.exec=true -DskipTests=true -Dcheckstyle.skip=true clean install"
alias bim="vim"
alias vibp="vim ~/.bash_profile && source ~/.bash_profile"

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
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
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
  if [ -z $1 ]
  then
	  REMOTE="origin"
  else 
	  REMOTE=$1
  fi
  git_get_current_branch
  git push $REMOTE $CURR_BRANCH
}

function gfpr {
  set -e
  git checkout master
  git fetch origin pull/$1/head:$2
  git checkout $2
}

# Job control aliases
alias kterm="kill -s SIGTERM"
alias kquit="kill -s SIGQUIT"

function mkcd {
  mkdir -p $1
  cd $1
}

function ptouch {
	mkdir -p `dirname $1`
	touch $1
}

# Fix output issues
function st {
	stty sane
}

source $(brew --prefix nvm)/nvm.sh
source <(npm completion)
[[ -r ~/.bashrc ]] && . ~/.bashrc
