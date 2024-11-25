# ~/.profile: executed by the command interpreter for login shells

# ===== Environment Variables =====
export EDITOR=vim
export XDG_CONFIG_HOME="$HOME/.config"
export data_PATH="/data/users/cyang"

# GCC configuration
export CC="$HOME/local/gcc-11.3/bin/gcc"
export CXX="$HOME/local/gcc-11.3/bin/g++"

# Base paths
export my_python_PATH="$data_PATH/bin/python"

# Application Paths
export Matlab_PATH="/data/users/cyang/MATLAB/R2024a/bin"
export mricron_PATH="/opt/mricron"
export CAMINO_PATH="/opt/camino/bin"
export MANPATH="/opt/camino/man:$MANPATH"

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
)

# Add library paths
for lib in "${lib_paths[@]}"; do
    [[ -d "$lib" ]] && LD_LIBRARY_PATH="$lib:$LD_LIBRARY_PATH"
done

# PKG_CONFIG configuration
export PKG_CONFIG_PATH="$my_local_PATH/lib64/pkgconfig:$my_local_PATH/lib/pkgconfig"

# Python configuration
export PYTHONPATH="$PYTHONPATH:$my_python_PATH"
export HF_ENDPOINT="https://hf-mirror.com"

# Mamba configuration
export MAMBA_EXE="$data_PATH/anaconda3/bin/mamba"
export MAMBA_ROOT_PREFIX="$data_PATH/anaconda3"

# If running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
