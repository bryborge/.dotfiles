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

NO_COLOR=$'\[\e[0m\]'
RED=$'\[\e[0;31m\]'
GREEN=$'\[\e[0;32m\]'
YELLOW=$'\[\e[0;33m\]'
BLUE=$'\[\e[0;34m\]'
PURPLE=$'\[\e[0;35m\]'
CYAN=$'\[\e[0;36m\]'

BOLD_RED=$'\[\e[1;31m\]'
BOLD_GREEN=$'\[\e[1;32m\]'
BOLD_YELLOW=$'\[\e[1;33m\]'
BOLD_BLUE=$'\[\e[1;34m\]'
BOLD_PURPLE=$'\[\e[1;35m\]'
BOLD_CYAN=$'\[\e[1;36m\]'

if [ -f ~/.gitprompt ]; then
    . ~/.gitprompt
fi

if [ -f ~/.gitcompletion ]; then
    . ~/.gitcompletion
fi

# NODE (Fast Node Manager)

if [ -d "$HOME/.local/share/fnm" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env --shell bash)"
fi

# PROMPT

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_DESCRIBE_STYLE="default"
export GIT_PS1_SHOWCOLORHINTS=true

PROMPT_COMMAND=set_bash_prompt

function set_bash_prompt() {
    PS1="\n$(get_venv_name_with_color)${BOLD_YELLOW}\w${BOLD_CYAN}$(__git_ps1 " %s")${BOLD_CYAN}\n${BOLD_PURPLE}(\t)${NO_COLOR} $ "
}

function get_venv_name_with_color() {
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        echo "${BOLD_PURPLE}(${VIRTUAL_ENV##*/})${NO_COLOR} "
    fi
}

. "$HOME/.local/bin/env"
