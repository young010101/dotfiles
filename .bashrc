# .bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# for anaconda
#anaconda_PATH=/home/centos/anaconda3/bin
#conda_base="source ${anaconda_PATH}/activate"
# source ${anaconda_PATH}/activate
# conda activate pt
# export PATH=/opt/anaconda3-2021.11/bin/:$PATH

# for freesurfer
# export FREESURFER_HOME=/usr/local/freesurfer/7.3.2-1
# export SUBJECTS_DIR=$FREESURFER_HOME/subjects
# source $FREESURFER_HOME/SetUpFreeSurfer.sh

# for fsl
# export FSLDIR=/opt/fsl
# source $FSLDIR/etc/fslconf/fsl.sh 

# for matlab
export Matlab_PATH=/opt/R2020a/bin
export Matlab_PATH=/data/users/cyang/MATLAB/R2024a/bin
export PATH=${Matlab_PATH}:$PATH

# for mricron
export mricron_PATH=/opt/mricron
export PATH=${mricron_PATH}:$PATH

# for cuda
# export CUDA_PATH=/usr/local/cuda-10.2/bin
# export PATH=${CUDA_PATH}:$PATH
# export LD_LIBRARY_PATH=/usr/lcoal/cuda-10.1/lib64:$LD_LIBRARY_PATH
# export CUDA_PATH=$HOME/.conda/envs/pt/bin
# export PATH=${CUDA_PATH}:$PATH
# export LD_LIBRARY_PATH=$HOME/.conda/envs/pt/lib:$LD_LIBRARY_PATH

# for gcc8
#source /opt/rh/devtoolset-8/enable

# for camino
export CAMINO_PATH=/opt/camino/bin
export MANPATH=/opt/camino/man:$MANPATH
export PATH=${CAMINO_PATH}:$PATH

# for cyang
. "$HOME/.cargo/env"
export EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config
export data_PATH=/data/users/cyang
export my_python_PATH=$data_PATH/bin/python
export my_bin_PATH=$data_PATH/bin
export my_local_PATH=$data_PATH/usr/local
export PATH=$my_bin_PATH:$PATH
export PATH=$my_local_PATH:$PATH
export PATH=$my_local_PATH/bin:$PATH
export PYTHONPATH="$PYTHONPATH:$my_python_PATH"
export XAI_API_KEY="xai-pgboaiRfBgq40IPxMfQE18EqJcG1aR2BuEhILNM3iO2R8r9TsoT6NsGaJhtFoIfalGvEWSdHIekZD1g2"
# export DISPLAY="121.0.0.1:10.0"
#export PATH=$data_PATH/bin/gcc-9.3.0/bin:$PATH
export PATH=/data/users/cyang/bin/gcc-11.3/bin:$PATH
export LD_LIBRARY_PATH=/data/users/cyang/bin/gcc-11.3/lib64:$LD_LIBRARY_PATH

export PATH="$HOME/.local/bin:$PATH"

export PKG_CONFIG_PATH=$data_PATH/local/lib64/pkgconfig
export LD_LIBRARY_PATH=$data_PATH/local/lib64:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$data_PATH/local/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$data_PATH/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/data/users/cyang/anaconda3/envs/sga/lib:$LD_LIBRARY_PATH
export PATH=$data_PATH/local/bin:$PATH
eval "$(starship init bash)"


# GPU caheck
alias nv="nvidia-smi"
alias wnv="watch -n 0.5 -d nvidia-smi"

#alias vi=nvim.appimage
alias cdcy="cd $data_PATH"
alias bashrc="vi ~/.bashrc"
alias sbashrc="source ~/.bashrc"


set -o vi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
export HF_ENDPOINT=https://hf-mirror.com
export PATH="$PATH:/opt/nvim/"

function taocl() {
  # 定义本地和远程README.md的路径
  local local_readme="$data_PATH/repos/the-art-of-command-line/README.md"
  local remote_readme="https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md"

  # 检查是否传入 -r 选项来使用远程文件
  if [[ "$1" == "-r" ]]; then
    # 从远程获取 README.md
    content=$(curl -s "$remote_readme")
  else
    # 从本地获取 README.md（如果文件不存在则报错）
    if [[ -f "$local_readme" ]]; then
      content=$(cat "$local_readme")
    else
      echo "Error: Local README.md not found at $local_readme" >&2
      return 1
    fi
  fi

  # 处理内容
  # curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
  echo "$content" |
    sed '/cowsay[.]png/d' |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80 | iconv -t US
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

ranger_cd() {
    local temp_file="$(mktemp)"
    ranger --choosedir="$temp_file" "$@"
    if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" != "$(pwd)" ]; then
        cd "$(cat "$temp_file")"
    fi
    rm -f "$temp_file"
}

if [ "$PWD" = "$HOME" ]; then
    cd $data_PATH
fi

export PATH=$PATH:$data_PATH/bin/async-profiler

#source $data_PATH/repos/dotfiles/scripts/conda_source

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/data/users/cyang/anaconda3/bin/mamba';
export MAMBA_ROOT_PREFIX='/data/users/cyang/anaconda3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

