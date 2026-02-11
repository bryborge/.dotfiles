# If not running interactively, bail.
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export SAVEHIST=100000

shopt -s histappend

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

NO_COLOR=$(echo -en '\033[00m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
YELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')

BOLD_RED=$(echo -en '\033[31;01m')
BOLD_GREEN=$(echo -en '\033[32;01m')
BOLD_YELLOW=$(echo -en '\033[33;01m')
BOLD_BLUE=$(echo -en '\033[34;01m')
BOLD_PURPLE=$(echo -en '\033[35;01m')
BOLD_CYAN=$(echo -en '\033[36;01m')

if [ -f ~/.gitprompt ]; then
    . ~/.gitprompt
fi

if [ -f ~/.gitcompletion ]; then
    . ~/.gitcompletion
fi

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_DESCRIBE_STYLE="default"
export GIT_PS1_SHOWCOLORHINTS=true

PROMPT_COMMAND=set_bash_prompt

function set_bash_prompt() {
    PS1="\n$(get_venv_name_with_color)${BOLD_YELLOW}\w${BOLD_CYAN}$(__git_ps1 " [%s")${BOLD_CYAN}]\n${BOLD_PURPLE}(\t)${NO_COLOR} $ "
}

function get_venv_name_with_color() {
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        echo "${BOLD_PURPLE}(${VIRTUAL_ENV##*/})${NO_COLOR} "
    fi
}
