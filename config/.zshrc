# If not running interactively, bail.
[[ $- != *i* ]] && return

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

export HISTSIZE=100000
export SAVEHIST=100000

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

if [ -f ~/.gitprompt ]; then
    . ~/.gitprompt
fi

if [ -f ~/.gitcompletion ]; then
    . ~/.gitcompletion
fi

# PYTHON

if [ -f "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
fi

# PROMPT

autoload -Uz vcs_info

zstyle ':vcs_info:git*' formats "%B%F{cyan}[%F{green}%b%f%m%u%c%a%F{cyan}]"
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %F{red}✚%f'
zstyle ':vcs_info:*' unstagedstr ' %F{red}*%f'

precmd() {
    print
    vcs_info
    print -P "%B%F{yellow}%~%f%b ${vcs_info_msg_0_}"
}

PROMPT="%B%F{magenta}(%*)%f %(!.#.$)%b "
