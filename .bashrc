# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# ===== Environment Variables =====
export EDITOR=vim
export XDG_CONFIG_HOME="$HOME/.config"
export data_PATH="/data/users/cyang"

# Base paths
export my_python_PATH="$data_PATH/bin/python"

# ===== Path Configuration =====
paths=(
	"$HOME/.local/bin"
	"$HOME/local/bin"
	"$HOME/local/gcc-11.3/bin"
	"${Matlab_PATH}"
	"${mricron_PATH}"
	"${CAMINO_PATH}"
)

# Add paths to PATH
for p in "${paths[@]}"; do
	[[ -d "$p" ]] && PATH="$p:$PATH"
done

# ===== Library Paths =====
lib_paths=(
	"$HOME/local/lib64"
	"$HOME/local/lib"
	"$HOME/local/gcc-11.3/lib64"
	# "$data_PATH/anaconda3/envs/sga/lib"
)

# Add library paths
for lib in "${lib_paths[@]}"; do
	[[ -d "$lib" ]] && LD_LIBRARY_PATH="$lib:$LD_LIBRARY_PATH"
done

# PKG_CONFIG configuration
export PKG_CONFIG_PATH="$my_local_PATH/lib64/pkgconfig:$my_local_PATH/lib/pkgconfig"

# ===== Application Specific =====
# Matlab
export Matlab_PATH="/data/users/cyang/MATLAB/R2024a/bin"

# MRICron
export mricron_PATH="/opt/mricron"

# Camino
export CAMINO_PATH="/opt/camino/bin"
export MANPATH="/opt/camino/man:$MANPATH"

# Python
export PYTHONPATH="$PYTHONPATH:$my_python_PATH"
export HF_ENDPOINT="https://hf-mirror.com"

# API Keys
if [ -f "$HOME/.api_keys" ]; then
    source "$HOME/.api_keys"
fi

# ===== Aliases =====
alias nv="nvidia-smi"
alias wnv="watch -n 0.5 -d nvidia-smi"
alias cdcy="cd $data_PATH"
alias eb="vi ~/.bashrc"
alias sb="source ~/.bashrc"

# Add alias for nvim
alias vi=nvim

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

# ===== Shell Options =====
set -o vi

# ===== Initialization =====
# Start in data_PATH when in home directory
# [[ "$PWD" = "$HOME" ]] && cd "$data_PATH"

# Source additional configurations
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
eval "$(starship init bash)"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Mamba initialization
export MAMBA_EXE="$data_PATH/anaconda3/bin/mamba"
export MAMBA_ROOT_PREFIX="$data_PATH/anaconda3"
if __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"; then
	eval "$__mamba_setup"
else
	alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup

