# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/djmadeira/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="amuse"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git,
  brew,
  docker,
  gradle,
  npm,
  osx,
  vi-mode,
  yarn
)

source $ZSH/oh-my-zsh.sh

# User configuration
bindkey -v
export KEYTIMEOUT=1

## Misc
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PYTHONPATH=/usr/local/lib/python3.6/site-packages
export NVM_DIR=~/.nvm
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config

## Path mods
## I hate everything
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:/usr/local/jmeter/bin"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH="$PATH:$HOME/golang/bin"
export PATH="$PYTHONPATH:$PATH"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting 
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/repos/multitasking/bin"

source ~/.private_vars
source $(brew --prefix nvm)/nvm.sh
source <(npm completion)
. $PYTHONPATH/powerline/bindings/zsh/powerline.zsh

# Aliases
alias mci="mvn clean install"
alias vi="vim"
alias bim="vim"
alias nv="nvim"
alias bp="source ~/.bash_profile"

# Git aliases
alias gcm="git commit"
alias gad="git add"
alias gpu="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gst="git status"
alias gbr="git branch"
alias grm="git rm"
alias grb="git rebase"
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias grs="git reset"
alias gmr="git merge"
alias gdf="git diff"
alias gcp="git cherry-pick"
alias gcl="git clean"

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
		if [ "" == `git remote | grep dmadeira` ] 
		then
			REMOTE="origin"
		else
			REMOTE="dmadeira"
		fi
	else 
		REMOTE=$1
	fi
	git_get_current_branch
	git push $REMOTE $CURR_BRANCH
}

# Thanks Thomas Marshall!
function gmpr {
	  repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*github.medallia.com[:/]\(.*\)\.git.*/\1/"`
	  branch=`git name-rev --name-only HEAD`
	  echo "... creating pull request for branch \"$branch\" in \"$repo\""
	  open https://github.medallia.com/$repo/pull/new/$branch
}

function gfpr {
	git checkout master
	git fetch origin pull/$1/head:$2
	git checkout $2
}

# Bulk delete git branches
# Pass branches you want to KEEP as arguments, script deletes the rest
# Will ask you for confirmation before deleting
function gdbr {
	local ALWAYS_IGNORE="master *"
	local DELETE_BRANCHES=$(git branch | awk -v IGNORE_WORDS="$ALWAYS_IGNORE $*" '
	BEGIN { split(IGNORE_WORDS, IGNORE, " ") }
	{ FOUND=0; for(I in IGNORE) { if($1 == IGNORE[I]) { FOUND=1; break } } if(FOUND==0) print $1; }
	')
	if [[ -z "$DELETE_BRANCHES" ]]
	then
		echo "No branches to delete"
		return
	fi
	read -p "Are you sure you want to delete these branches? (y/n) 
	$DELETE_BRANCHES" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		git branch -D $DELETE_BRANCHES
	fi
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

function cdrr {
	cd ~/repos/reporting
}

# FZF options
set rtp+=/usr/local/opt/fzf
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'


# Medallia stuff
alias d1qa="d1 --baseUrl ec2-54-241-34-79.us-west-1.compute.amazonaws.com:8080"
alias sb="SKIP_REBUILD=1"
alias sr="SKIP_TEST_RETRY=1"
alias rf="REPLACE_FIXTURES=1"
alias dh="DISABLE_HEADLESS=1"
alias yt="yarn test"
alias ys="yarn start"
alias een="EXPRESS_ENV_NAME"
alias sf="--testPathIgnorePatterns='functional'"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
