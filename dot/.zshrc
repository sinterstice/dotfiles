# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle :compinstall filename '/home/alice/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd extendedglob notify

# User configuration
bindkey -e
export KEYTIMEOUT=1

export QT_LOGGING_RULES="*.debug=true; qt.*.debug=false"

## Misc
export GOPATH=$HOME/go
export GOROOT=/usr/lib/go
export PYTHONPATH=/usr/lib/python3.10/site-packages
export NVM_DIR=~/.nvm
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/

## Path mods
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH="$PATH:$HOME/golang/bin"
export PATH="$PYTHONPATH:$PATH"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting 
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/repos/multitasking/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/var/lib/flatpak/exports/bin"

export SYSTEMD_PAGER=less

# source <(npm completion)
#
# . $PYTHONPATH/powerline/bindings/zsh/powerline.zsh

# Aliases
alias vi="vim"
alias bim="vim"
alias nv="nvim"

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

alias pacs="sudo pacman -Syu"
alias yays="yay -Syu"

# FZF options
set rtp+=/usr/bin/fzf
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

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

alias pacq="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/alice/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/alice/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/alice/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/alice/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/alice/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/alice/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/alice/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/alice/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
