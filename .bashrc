# Basic shell settings
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# History
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000

# Shell options
set -o vi
shopt -s histappend
shopt -s checkwinsize
bind '"jk":vi-movement-mode'

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias eb="vi ~/.bashrc"
alias sb="source ~/.bashrc"

# Enhanced cd
cd() {
    builtin cd "$@" && ls
}

# Environment
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Conda
__conda_setup="$('/home/cyang/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cyang/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/cyang/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/cyang/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

[ -f "/home/cyang/miniforge3/etc/profile.d/mamba.sh" ] && . "/home/cyang/miniforge3/etc/profile.d/mamba.sh"

# Prompt
if command -v starship >/dev/null; then
    eval "$(starship init bash)"
fi

# Final sourcing
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export DASHSCOPE_API_KEY=sk-9bb987192a624d20b71705b248b57f49