#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Check if mamba is installed
if ! command -v mamba &> /dev/null; then
    echo "📦 Installing Mambaforge..."
    
    # Download Mambaforge installer
    if [[ "$OSTYPE" == "darwin"* ]]; then
        curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
        bash Miniforge3-$(uname)-$(uname -m).sh -b
        rm Miniforge3-$(uname)-$(uname -m).sh
    else
        curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
        bash Miniforge3-Linux-x86_64.sh -b
        rm Miniforge3-Linux-x86_64.sh
    fi
    
    # Initialize shell
    ~/mambaforge/bin/mamba init
fi

# Install basic tools
echo "🔧 Installing basic development tools..."
mamba install -y \
    curl \
    wget \
    git \
    make \
    cmake \
    gcc \
    python=3.10

echo "✅ Setup complete! Please restart your shell."
