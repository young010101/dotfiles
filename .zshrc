# =============================================================================
#                           ZSH CONFIGURATION
# =============================================================================
# Structure:
#   1. Oh-My-Zsh Configuration
#   2. Basic Settings
#   3. Shell Options
#   4. Common Configuration
#   5. Zsh-specific Aliases
#   6. Zsh-specific Functions
#   7. External Tools
#   8. Final Initialization
# =============================================================================

# --------------------------- 1. Oh-My-Zsh Configuration -------------------
# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
fi

export ZSH="$HOME/.oh-my-zsh"

# zsh-autosuggestions plugin installation check
ZSH_AUTOSUGGESTIONS_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGESTIONS_PATH" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_PATH"
fi

plugins=(
    git
    zsh-autosuggestions
    web-search
    aliases
)

source $ZSH/oh-my-zsh.sh

# --------------------------- 2. Basic Settings -------------------------------
# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

# History options
setopt BANG_HIST                 # Treat the '!' character specially during expansion
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt HIST_VERIFY               # Don't execute immediately upon history expansion
setopt HIST_BEEP                 # Beep when accessing nonexistent history

# --------------------------- 3. Shell Options ----------------------------
# Vi mode
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# --------------------------- 4. Common Configuration --------------------
# Source common shell configurations
if [ -f "$HOME/.shell_common" ]; then
    . "$HOME/.shell_common"
fi

# --------------------------- 5. Zsh-specific Aliases --------------------
alias ez="vi ~/.zshrc"
alias sz="source ~/.zshrc"

# --------------------------- 6. Zsh-specific Functions -----------------
# FZF history search
fh() {
   print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

## FZF file selection
#f() {
#    # Check if fd is installed
#    if ! command -v fd >/dev/null; then
#        echo "fd command not found. Would you like to install it? (y/n)"
#        read -r answer
#        if [ "$answer" = "y" ]; then
#            if command -v pacman >/dev/null; then
#                sudo pacman -S fd
#            elif command -v apt-get >/dev/null; then
#                sudo apt-get install fd-find
#            elif command -v dnf >/dev/null; then
#                sudo dnf install fd-find
#            else
#                echo "Could not determine package manager. Please install fd manually."
#                return 1
#            fi
#        else
#            return 1
#        fi
#    fi
#    
#    sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
#    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
#}
#
#fm() f "$@" --max-depth 1

# Process management
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Man page functions
fman() {
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
}

# Flatpak management
fzf-flatpak-install-widget() {
    flatpak remote-ls flathub --cached --columns=app,name,description \
    | awk -v cyn=$(tput setaf 6) -v blu=$(tput setaf 4) -v bld=$(tput bold) -v res=$(tput sgr0) \
    '{
        app_info=""; 
        for(i=2;i<=NF;i++){
            app_info=cyn app_info" "$i 
        };
        print blu bld $2" -" res app_info "|" $1
    }' \
    | column -t -s "|" -R 3 \
    | fzf \
        --ansi \
        --with-nth=1.. \
        --prompt="Install > " \
        --preview-window "nohidden,40%,<50(down,50%,border-rounded)" \
        --preview "flatpak --system remote-info flathub {-1}" \
        --bind "enter:execute(flatpak install flathub {-1})"
    zle reset-prompt
}

# --------------------------- 7. External Tools -------------------------
# Fasd configuration (if installed)
if command -v fasd >/dev/null; then
    eval "$(fasd --init auto)"
    fasd_cache="$HOME/.fasd-init-zsh"
    if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
        fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
    fi
    source "$fasd_cache"
    unset fasd_cache
else
    echo "fasd not found. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        if command -v pacman >/dev/null; then
            sudo pacman -S fasd
        elif command -v apt-get >/dev/null; then
            sudo apt-get install fasd
        elif command -v dnf >/dev/null; then
            sudo dnf install fasd
        else
            echo "Could not determine package manager. Please install fasd manually."
        fi
    fi
fi

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh  # Changed from .fzf.bash to .fzf.zsh

# Pacman/Yay helpers (only if yay is installed)
if command -v yay >/dev/null; then
    function in() {
        yay -Slq | fzf -q "$1" -m --preview 'yay -Si {1}'| xargs -ro yay -S
    }

    function re() {
        yay -Qq | fzf -q "$1" -m --preview 'yay -Qi {1}' | xargs -ro yay -Rns
    }
fi

# --------------------------- 8. Final Initialization ------------------
# Starship prompt
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    echo "Starship prompt is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        curl -sS https://starship.rs/install.sh | sh
        eval "$(starship init zsh)"
    fi
fi

# Start X if not running and on tty1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi

# Source broot if it exists
BROOT_PATH="$HOME/.config/broot/launcher/bash/br"
[ -f "$BROOT_PATH" ] && source "$BROOT_PATH"

# Mamba initialization (only if MAMBA_EXE is set)
if [ -n "$MAMBA_EXE" ] && [ -f "$MAMBA_EXE" ]; then
    if __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"
    fi
    unset __mamba_setup
fi

# Key bindings (only if the widgets exist)
(( $+widgets[fzf-man-widget] )) && bindkey '^h' fzf-man-widget
(( $+widgets[fzf-flatpak-install-widget] )) && bindkey '^[f^[i' fzf-flatpak-install-widget
(( $+widgets[fzf-flatpak-uninstall-widget] )) && bindkey '^[f^[u' fzf-flatpak-uninstall-widget
(( $+widgets[fzf-locate-widget] )) && bindkey '\ei' fzf-locate-widget
