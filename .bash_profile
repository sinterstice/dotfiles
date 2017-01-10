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
export workspace_client=$workspace/client
export GITHUB_HOST=github.va.opower.it
export POSE_USER=dj.madeira
export newrelic__enable=false 
export server__https=8082
export GIT_USER=dj.madeira
export DOCKER_BASH_SKIP_ENV_CHECK=true

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
alias mcist="mvn -Dpmd.skip=true -Dmaven.test.skip.exec=true -DskipTests=true -Dcheckstyle.skip=true clean install"
alias bim="vim"
alias flow="haxelib run flow"
alias vi="vim"
alias vibp="vim ~/.bash_profile && source ~/.bash_profile"
alias uxwm="npm i -g x-web-maestro"
alias curljson="curl -H 'Accept: application/json' -H 'Content-Type: application/json'"
alias op_get_dev_keys="curl http://dev-synapse-1001.va.opower.it:8999/apis/authorization-v1/oauth2/token -XPOST -H 'Authorization: Basic MDZmNmZiMzgtYTVjMS00NDIxLWFhOTYtNzhlNGJhMDUwYWQ2OmYzYTNhMzlkLWJkZDQtNDA0YS1iYWE0LWI2Y2MxYzNmOTlkMA==' -d 'grant_type=client_credentials'"

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
  git_get_current_branch
  git push dj-madeira $CURR_BRANCH
}

function gfpr {
  git_get_current_branch
  git checkout master
  git fetch origin pull/$1/head:$2
  git checkout $CURR_BRANCH
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
  test__skipStaticAnalysis=true test__retry=false test__files=$1 npm test
}

function hello_it {
    rm -rf ./node_modules ./build ./dist ~/.x-web-maestro
    npm cache clean
    npm i
    #npm i -g x-web-maestro x-web-get-client-theme
}

function dbro_docker_port {
    bind_port compose_synapselite_1 8998
    bind_port compose_mock_1 3000
    bind_port compose_astro_1 8080
    bind_port compose_dbro_1 5555
}

function squashbump {
    if [ -z $1 ]; then 
        return;
    fi
    git rebase -i $1

    # Scary
    while [ $(git status | grep "interactive rebase in progress;" -c) == "1" ]; do
        awk '\
        BEGIN { print_next_line=1 } \
        $1 ~ /<<<<<<</ { print_next_line=0; next } \
        $1 ~ /=======/ { print_next_line=0; next } \
        $1 ~ />>>>>>>/ { next } \
        $1 == "\"version\":" { if ( matched_version != 1 ) { sub("-0", ""); print $0; matched_version=1 } } \
        { if (print_next_line) print; else print_next_line=1 } \
        ' package.json > tmp_package.json
        mv tmp_package.json package.json
        git add package.json
        git rebase --continue
    done
}

function jenkunfinished {
    for TESTNAME in $(awk -F'"' '/"test\/browser\/[a-z0-9-]+\.js"/ { print $2 }' $1); do
        if (( $(grep -c $TESTNAME $1) < 5 )); then
            echo $TESTNAME;
        fi;
    done
}

#eval $(docker-machine env dev)
source <(npm completion)
source ~/techops.bash/techops.bash
source ~/opower/docker.bash/docker.bash
source ~/opower/docker.bash/docker-tunnel.bash 
