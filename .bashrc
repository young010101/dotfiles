# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# for anaconda
# anaconda_PATH=/home/centos/anaconda3/bin
# conda_base="source ${anaconda_PATH}/activate"
# source ${anaconda_PATH}/activate
# conda activate pt
# export PATH=/opt/anaconda3-2021.11/bin/:$PATH

# for freesurfer
export FREESURFER_HOME=/usr/local/freesurfer/7.3.2-1
export SUBJECTS_DIR=$FREESURFER_HOME/subjects
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# for fsl
export FSLDIR=/opt/fsl
source $FSLDIR/etc/fslconf/fsl.sh 

# for matlab
export Matlab_PATH=/opt/R2020a/bin
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
export data_PATH=/data/users/cyang
export my_python_PATH=$data_PATH/bin/python
export my_bin_PATH=$data_PATH/bin
export my_local_PATH=$data_PATH/usr/local
export PATH=$my_bin_PATH:$PATH
export PATH=$my_local_PATH:$PATH
export PATH=$my_local_PATH/bin:$PATH
export PYTHONPATH=$my_python_PATH
# export DISPLAY="121.0.0.1:10.0"

# GPU caheck
alias nv="nvidia-smi"
alias wnv="watch -n 0.5 -d nvidia-smi"

alias vi=nvim.appimage
alias cdcy="cd $data_PATH"
alias bashrc="vi ~/.bashrc"
alias sbashrc="source ~/.bashrc"

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('$my_bin_PATH/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "$my_bin_PATH/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "$my_bin_PATH/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="$my_bin_PATH/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cyang/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cyang/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/cyang/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/cyang/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate pt

set -o vi
