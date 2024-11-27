# =============================================================================
#                           BASH CONFIGURATION
# =============================================================================
# Structure:
#   1. Basic Settings
#   2. Shell Options
#   3. Bash-specific Aliases
#   4. Bash-specific Functions
#   5. External Tools
#   6. Final Initialization
# =============================================================================

# --------------------------- 1. Basic Settings -------------------------------
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source common shell configurations
if [ -f "$HOME/.shell_common" ]; then
    . "$HOME/.shell_common"
else
    echo "~/.shell_common not found. Would you like to create a symbolic link from ~/repos/dotfiles? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        ln -s "$HOME/repos/dotfiles/.shell_common" "$HOME/.shell_common"
        . "$HOME/.shell_common"
    fi
fi

# Check for .bash_profile
if [ ! -f "$HOME/.bash_profile" ]; then
    echo "~/.bash_profile not found. Would you like to create a symbolic link from ~/repos/dotfiles? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        ln -s "$HOME/repos/dotfiles/.bash_profile" "$HOME/.bash_profile"
    fi
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

# Readline key bindings
bind '"jk":vi-movement-mode'

# --------------------------- 3. Bash-specific Aliases ---------------------
alias eb="vi ~/.bashrc"
alias sb="source ~/.bashrc"

# --------------------------- 4. Bash-specific Functions ---------------------
# Ranger CD function
ranger_cd() {
    # First check if ranger exists
    if ! command -v ranger &> /dev/null; then
        # Detect OS
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            VERSION=$VERSION_ID
        elif [ -f /etc/redhat-release ]; then
            OS="centos"
            VERSION=$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)
        else
            OS=$(uname -s)
        fi

        echo "ranger is not installed. Would you like to install it? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            case $OS in
                "centos"|"rhel")
                    if [ "$VERSION" -ge 8 ]; then
                        sudo dnf install ranger
                    else
                        sudo yum install epel-release
                        sudo yum install ranger
                    fi
                    ;;
                "ubuntu"|"debian")
                    sudo apt-get update && sudo apt-get install ranger
                    ;;
                "arch")
                    sudo pacman -S ranger
                    ;;
                *)
                    echo "Unsupported operating system: $OS"
                    return 1
                    ;;
            esac
        else
            echo "ranger is required for this function"
            return 1
        fi
    fi

    local temp_file="$(mktemp)"
    ranger --choosedir="$temp_file" "$@"
    if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" != "$(pwd)" ]; then
        cd "$(cat "$temp_file")"
    fi
    rm -f "$temp_file"
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

# Check and update Neovim version
check_nvim_version() {
    if ! command -v nvim &> /dev/null; then
        echo "Neovim is not installed. Would you like to install it? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            case $OS in
                "ubuntu"|"debian")
                    sudo add-apt-repository ppa:neovim-ppa/unstable
                    sudo apt-get update
                    sudo apt-get install neovim
                    ;;
                "centos"|"rhel")
                    sudo yum install -y epel-release
                    sudo yum install -y neovim python3-neovim
                    ;;
                "arch")
                    sudo pacman -S neovim
                    ;;
                *)
                    echo "Would you like to clone and build Neovim from source? (y/n)"
                    read -r build_answer
                    if [ "$build_answer" = "y" ]; then
                        cd "$HOME/repos/neovim" 2>/dev/null || {
                            mkdir -p "$HOME/repos"
                            cd "$HOME/repos"
                            git clone https://github.com/neovim/neovim
                            cd neovim
                        }
                        git pull
                        make clean
                        make CMAKE_BUILD_TYPE=Release
                        sudo make install
                        cd "$OLDPWD"
                        new_version=$(nvim --version | head -n1 | cut -d ' ' -f2)
                        echo "Updated Neovim version: $new_version"
                        
                        echo "Would you like to clone young010101/nvim configuration? (y/n)"
                        read -r config_answer
                        if [ "$config_answer" = "y" ]; then
                            if [ -d "$HOME/.config/nvim" ]; then
                                echo "Backing up existing nvim configuration..."
                                mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
                            fi
                            git clone https://github.com/young010101/nvim.git "$HOME/.config/nvim"
                            echo "Neovim configuration has been cloned to ~/.config/nvim"
                        fi
                    else
                        echo "Please update Neovim manually for your system"
                        return 1
                    fi
                    ;;
            esac
        fi
    else
        current_version=$(nvim --version | head -n1 | cut -d ' ' -f2)
        echo "Current Neovim version: $current_version"
        echo "Would you like to update to the latest version? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            case $OS in
                "ubuntu"|"debian")
                    sudo apt-get update
                    sudo apt-get install --only-upgrade neovim
                    ;;
                "centos"|"rhel")
                    sudo yum update neovim
                    ;;
                "arch")
                    sudo pacman -Syu neovim
                    ;;
                *)
                    echo "Would you like to clone and build Neovim from source? (y/n)"
                    read -r build_answer
                    if [ "$build_answer" = "y" ]; then
                        cd "$HOME/repos/neovim" 2>/dev/null || {
                            mkdir -p "$HOME/repos"
                            cd "$HOME/repos"
                            git clone https://github.com/neovim/neovim
                            cd neovim
                        }
                        git pull
                        make clean
                        make CMAKE_BUILD_TYPE=Release
                        sudo make install
                        cd "$OLDPWD"
                        new_version=$(nvim --version | head -n1 | cut -d ' ' -f2)
                        echo "Updated Neovim version: $new_version"
                        
                        echo "Would you like to clone young010101/nvim configuration? (y/n)"
                        read -r config_answer
                        if [ "$config_answer" = "y" ]; then
                            if [ -d "$HOME/.config/nvim" ]; then
                                echo "Backing up existing nvim configuration..."
                                mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
                            fi
                            git clone https://github.com/young010101/nvim.git "$HOME/.config/nvim"
                            echo "Neovim configuration has been cloned to ~/.config/nvim"
                        fi
                    else
                        echo "Please update Neovim manually for your system"
                        return 1
                    fi
                    ;;
            esac
        fi
    fi
}

# --------------------------- 5. External Tools ---------------------------
# API Keys
if [ ! -f "$HOME/.api_keys" ]; then
    echo "Would you like to create $HOME/.api_keys? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        touch "$HOME/.api_keys"
        echo "Created $HOME/.api_keys"
    fi
fi
[ -f "$HOME/.api_keys" ] && source "$HOME/.api_keys"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if ! command -v fzf >/dev/null; then
    echo "FZF is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        echo "Installing FZF from git..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
fi

# Optional FZF configurations
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Cargo and Rust
if ! command -v cargo >/dev/null; then
    echo "Rust/Cargo is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        if command -v mamba >/dev/null; then
            mamba install rust
        else
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        fi
    fi
fi
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Check and install diff-so-fancy if npm exists
if command -v npm >/dev/null && ! command -v diff-so-fancy >/dev/null; then
    echo "diff-so-fancy is not installed but npm is available. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        npm install -g diff-so-fancy
        # Configure git to use diff-so-fancy
        git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
        git config --global interactive.diffFilter "diff-so-fancy --patch"
    fi
fi

# --------------------------- 6. Final Initialization -------------------
# Starship prompt
if command -v starship >/dev/null; then
    eval "$(starship init bash)"
else
    echo "Starship prompt is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        curl -sS https://starship.rs/install.sh | sh
        eval "$(starship init bash)"
    fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/data/users/cyang/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/data/users/cyang/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/data/users/cyang/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/data/users/cyang/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/data/users/cyang/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/data/users/cyang/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# Mamba initialization
# Check if mamba exists and initialize
if ! command -v mamba >/dev/null; then
    echo "Mamba is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
        bash Miniforge3-$(uname)-$(uname -m).sh
        rm Miniforge3-$(uname)-$(uname -m).sh
    fi
else
    echo "Mamba is installed. Initializing..."
fi

