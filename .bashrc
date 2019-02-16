#
# ~/.bashrc
#

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	startx &> /dev/null
	exit
fi

source /usr/share/bash-completion/bash_completion

set -o vi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export BASE00=\#00002a #background
export BASE01=\#2e2f30 #lighter background
export BASE02=\#30305a #selection background
export BASE03=\#50507a #comments, invisibles, line highlighting
export BASE04=\#b0b0da #dark foreground
export BASE05=\#d0d0fa #default foreground
export BASE06=\#e0e0ff #light foreground
export BASE07=\#f5f5ff #light background
export BASE08=\#ff4242 #red       variables

export BASE09=\#fc8d28 #orange    integers, booleans, constants
export BASE0A=\#f3e877 #yellow    classes
export BASE0B=\#59f176 #green     strings
export BASE0C=\#0ef0f0 #aqua      support, regular expressions
export BASE0D=\#66b0ff #blue      functions, methods
export BASE0E=\#f10596 #purple    keywords, storage, selector
export BASE0F=\#f003ef #          deprecated, opening/closing embedded language tags

export EDITOR=nvim

BASE16_SHELL=$HOME/.base16-manager/chriskempson/base16-shell/
[ -n "$PS1" ] && \
    [ -s $BASE16_SHELL/profile_helper.sh ] && \
        eval "$($BASE16_SHELL/profile_helper.sh)"

export PATH="/usr/bin:$PATH"
export PATH="$HOME/bin:$PATH"

source $HOME/.colors

alias nv=nvim
alias ':q'=exit

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk

shopt -s autocd

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PROMPT_DIRTRIM=2
PS1='\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 2)\]$(parse_git_branch)\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]'
