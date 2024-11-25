#!/bin/bash

if [ ! -d "$data_PATH" ]; then
    echo "data_PATH is not set"
    exit 1
fi

if [ ! -d "$data_PATH/notes" ]; then
    git clone git@github.com:young010101/notes.git $data_PATH/notes
fi

# Create symbolic links with error checking
create_symlink() {
    local src="$1"
    local dest="$2"
    
    # Check if destination already exists
    if [ -e "$dest" ]; then
        echo "Warning: $dest already exists, skipping..."
        return
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"
    
    # Create the symlink
    if ln -s "$src" "$dest"; then
        echo "Created symlink: $dest -> $src"
    else
        echo "Error: Failed to create symlink for $dest"
    fi
}

# Ensure usr/local exists with proper structure
mkdir -p "$data_PATH/usr/local"/{bin,lib,lib64,share,include,etc,src,libexec,sbin,var}

# Create local symlinks
create_symlink "$data_PATH/usr/local" "$HOME/local"
create_symlink "$data_PATH/usr/local" "$HOME/.local"

# Define directories to link
directories=("repos" "Downloads" "notes")

# Create symlinks for all directories
for dir in "${directories[@]}"; do
    create_symlink "$data_PATH/$dir" "$HOME/$dir"
done

# X11 config files
x11_files=(".condarc" ".Xauthority" ".Xdefaults" ".Xmodmap" ".Xresources")
for file in "${x11_files[@]}"; do
    create_symlink "$HOME/repos/dotfiles/$file" "$HOME/$file"
done

# Tmux powerline theme
create_symlink "$data_PATH/repos/dotfiles/.config/tmux-powerline/themes/my-theme.sh" \
    "$HOME/.config/tmux-powerline/themes/my-theme.sh"

# Scripts
scripts=("check_ip.sh")
for script in "${scripts[@]}"; do
    create_symlink "$data_PATH/repos/dotfiles/scripts/$script" "$HOME/$script"
done
