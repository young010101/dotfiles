# =============================================================================
#                           BASH CONFIGURATION
# =============================================================================
# Structure:
#   1. Basic Settings
#   2. Shell Options
#   3. Aliases
#   4. Functions
#   5. External Tools
#   6. Final Initialization
# =============================================================================

# --------------------------- 1. Basic Settings -------------------------------
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000

# --------------------------- 2. Shell Options ------------------------------
set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s globstar

# --------------------------- 3. Aliases ----------------------------------
# System monitoring
alias nv="nvidia-smi"
alias wnv="watch -n 0.5 -d nvidia-smi"
alias ports='netstat -tulanp'
alias mem='free -h'
alias df='df -h'

# Navigation
alias cdcy="cd $data_PATH"
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Development
alias vi=nvim
alias eb="vi ~/.bashrc"
alias sb="source ~/.bashrc"
alias py='python'
alias pip='python -m pip'
alias activate='source activate'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# --------------------------- 4. Functions --------------------------------
# Ranger CD function
ranger_cd() {
    local temp_file="$(mktemp)"
    ranger --choosedir="$temp_file" "$@"
    if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" != "$(pwd)" ]; then
        cd "$(cat "$temp_file")"
    fi
    rm -f "$temp_file"
}

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"      ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Enhanced cd command
cd() {
    builtin cd "$@" && ls
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

# Git branch in prompt (fallback if starship isn't available)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# --------------------------- 5. External Tools ---------------------------
# API Keys
[ -f "$HOME/.api_keys" ] && source "$HOME/.api_keys"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --------------------------- 6. Final Initialization -------------------
# Starship prompt
command -v starship >/dev/null && eval "$(starship init bash)"

# Mamba initialization
if __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup

