# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_hist
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd nomatch
bindkey -v
bindkey '^R' history-incremental-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jp/.zshrc'

export PATH="/usr/bin:$PATH"

# powerline-daemmon -q
. /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh

autoload -Uz promptinit
promptinit

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' menu select

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	startx &> /dev/null
	exit
fi

bindkey "\e[3~" delete-char
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

BASE16_SHELL=$HOME/.base16-manager/chriskempson/base16-shell/

[ -n "$PS1" ] && \
    [ -s $BASE16_SHELL/profile_helper.sh ] && \
        eval "$($BASE16_SHELL/profile_helper.sh)"

export BASE00=\#002b36 #background
export BASE01=\#073642 #lighter background
export BASE02=\#586e75 #selection background
export BASE03=\#657b83 #comments, invisibles, line highlighting
export BASE04=\#839496 #dark foreground
export BASE05=\#93a1a1 #default foreground
export BASE06=\#eee8d5 #light foreground
export BASE07=\#fdf6e3 #light background
export BASE08=\#dc322f #red       variables

export BASE09=\#cb4b16 #orange    integers, booleans, constants
export BASE0A=\#b58900 #yellow    classes
export BASE0B=\#859900 #green     strings
export BASE0C=\#2aa198 #aqua      support, regular expressions
export BASE0D=\#268bd2 #blue      functions, methods
export BASE0E=\#6c71c4 #purple    keywords, storage, selector
export BASE0F=\#d33682 #          deprecated, opening/closing embedded language tags

export EDITOR=nvim

alias i3lock='i3lock -u -i $HOME/Pictures/X-Wings.png'
alias ':quit'='exit'
alias ':q'='exit'
alias po='poweroff'

PROMPT_DIRTRIM=2
# PS1="\A-\u@\h \w \$ "

