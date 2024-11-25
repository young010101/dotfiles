# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ===== Shell Options =====
set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s globstar

# History configuration
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000

# ===== Aliases =====
alias nv="nvidia-smi"
alias wnv="watch -n 0.5 -d nvidia-smi"
alias cdcy="cd $data_PATH"
alias eb="vi ~/.bashrc"
alias sb="source ~/.bashrc"
alias vi=nvim

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# ===== Functions =====
# Ranger CD function
ranger_cd() {
    local temp_file="$(mktemp)"
    ranger --choosedir="$temp_file" "$@"
    if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" != "$(pwd)" ]; then
        cd "$(cat "$temp_file")"
    fi
    rm -f "$temp_file"
}

# The Art of Command Line function
taocl() {
    local local_readme="$HOME/repos/the-art-of-command-line/README.md"
    local remote_readme="https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md"

    if [[ "$1" == "-r" ]]; then
        content=$(curl -s "$remote_readme")
    else
        [[ -f "$local_readme" ]] && content=$(cat "$local_readme") || { echo "Error: Local README.md not found" >&2; return 1; }
    fi

    echo "$content" |
        sed '/cowsay[.]png/d' |
        pandoc -f markdown -t html |
        xmlstarlet fo --html --dropdtd |
        xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
        xmlstarlet unesc | fmt -80 | iconv -t US
}

# ===== Source Additional Configurations =====
# API Keys
[ -f "$HOME/.api_keys" ] && source "$HOME/.api_keys"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Starship prompt
command -v starship >/dev/null && eval "$(starship init bash)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Mamba initialization
if __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup

