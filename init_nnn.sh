#!/bin/bash

# Check if nnn is installed
if ! command -v nnn &> /dev/null; then
    echo "nnn is not installed. Please install it first."
    exit 1
fi

# Create config directory if it doesn't exist
NNN_CONFIG_DIR="$HOME/.config/nnn"
mkdir -p "$NNN_CONFIG_DIR"

# Create plugins directory
NNN_PLUG_DIR="$HOME/.config/nnn/plugins"
mkdir -p "$NNN_PLUG_DIR"

# Download plugins
echo "Downloading nnn plugins..."
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

# Set up basic nnn configuration
cat > "$HOME/.config/nnn/nnn.conf" << 'EOL'
# nnn configuration file

# Export required environment variables
export NNN_PLUG='f:finder;o:fzopen;p:preview-tui;d:diffs;t:nmount;v:imgview'
export NNN_FIFO=/tmp/nnn.fifo
export NNN_COLORS='2136'
export NNN_TRASH=1
export NNN_OPTS="deH"

# Use rifle as the default file opener
export NNN_OPENER="rifle"

# Enable cd on quit
export NNN_TMPFILE="/tmp/.lastd"
EOL

# Add configuration to shell rc file
SHELL_RC="$HOME/.$(basename $SHELL)rc"
if [ ! -f "$SHELL_RC" ]; then
    SHELL_RC="$HOME/.profile"
fi

# More robust check for existing configurations
if grep -q "source.*nnn.conf" "$SHELL_RC"; then
    echo "nnn configuration already exists in $SHELL_RC"
    echo "Skipping shell configuration..."
else
    echo -e "\n# nnn configuration" >> "$SHELL_RC"
    echo "source ~/.config/nnn/nnn.conf" >> "$SHELL_RC"
fi

# Check for existing n() function
if grep -q "^n ()" "$SHELL_RC"; then
    echo "nnn function 'n' already exists in $SHELL_RC"
    echo "Skipping function definition..."
else
    # Add cd on quit function
    echo 'n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}' >> "$SHELL_RC"
fi

echo "nnn initialization complete!"
echo "Please restart your shell or run 'source $SHELL_RC' to apply changes." 