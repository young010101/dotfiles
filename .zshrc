# =============================================================================
#                        SIMPLIFIED ZSH CONFIGURATION
# =============================================================================

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins (only if they exist)
plugins=(git)
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && plugins+=(zsh-autosuggestions)

# Source Oh My Zsh if it exists
[ -d "$ZSH" ] && source $ZSH/oh-my-zsh.sh

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# Essential history options
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Source common configurations if they exist
[ -f "$HOME/.shell_common" ] && . "$HOME/.shell_common"

# Basic aliases
alias ez="vi ~/.zshrc"
alias sz="source ~/.zshrc"

# External tools (only if installed)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
# command -v starship >/dev/null && eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"

# Homebrew
[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# nnn file manager
if command -v nnn >/dev/null; then
    [ -f ~/.config/nnn/nnn.conf ] && source ~/.config/nnn/nnn.conf
    n() {
        [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ] && echo "nnn is already running" && return
        export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
        nnn "$@"
        [ -f "$NNN_TMPFILE" ] && . "$NNN_TMPFILE" && rm -f "$NNN_TMPFILE" > /dev/null
    }
fi

# Local environment
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Auto-start X on tty1
# [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && exec startx

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export DASHSCOPE_API_KEY=sk-9bb987192a624d20b71705b248b57f49
