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
alias ez="hx ~/.zshrc"
alias sz="source ~/.zshrc"

# External tools (only if installed)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
# command -v starship >/dev/null && eval "$(starship init zsh)"
eval "$(atuin init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"
[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=/opt/nvim-linux-x86_64/bin:$PATH
export PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH
# export PATH=$PATH:$(go env GOPATH)/bin  # !! already in $PATH !

# bart
export BART_TOOLBOX_PATH=/home/cyang/repos/bart
export PATH=$BART_TOOLBOX_PATH:$PATH
export PATH=/home/cyang/repos/view:$PATH

export DASHSCOPE_API_KEY=sk-9bb987192a624d20b71705b248b57f49
