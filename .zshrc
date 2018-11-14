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
. /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

autoload -Uz promptinit
promptinit

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

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

source $HOME/.zsh_colors

export EDITOR=nvim

export LOCKER='/home/jp/Documents/Code/glitchlock/glitchlock'
alias lock='$LOCKER'

alias nv=nvim
#alias i3lock='i3lock -u -i $HOME/Pictures/X-Wings.png'
alias ':q'='exit'
alias 'FIND'='grep -rn . -e'

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk

export CVS_RSH=ssh
export CVSROOT=:ext:ist189482@ss01:/afs/ist.utl.pt/groups/leic-po/po18/cvs/010
export CLASSPATH=/usr/share/java/po-uuilib.jar:~/po/project/sth-core/sth-core.jar

PROMPT_DIRTRIM=2
# PS1="\A-\u@\h \w \$ "

