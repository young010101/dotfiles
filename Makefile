.PHONY: all install-mamba install-tools clean install-dotfiles

all: install-mamba install-tools install-dotfiles

install-mamba:
	@echo "📦 Installing Mambaforge..."
	@if ! command -v mamba &> /dev/null; then \
		if [[ "$$(uname)" == "Darwin" ]]; then \
			curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$$(uname)-$$(uname -m).sh"; \
			bash Mambaforge-$$(uname)-$$(uname -m).sh -b; \
			rm Mambaforge-$$(uname)-$$(uname -m).sh; \
		else \
			curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh"; \
			bash Mambaforge-Linux-x86_64.sh -b; \
			rm Mambaforge-Linux-x86_64.sh; \
		fi; \
		~/mambaforge/bin/mamba init; \
	else \
		echo "Mamba is already installed"; \
	fi

install-tools:
	@echo "🔧 Installing basic development tools..."
	@mamba install -y \
		curl \
		wget \
		git \
		make \
		cmake \
		gcc \
		python=3.10

install-dotfiles:
	@echo "🔗 Creating symbolic links for dotfiles..."
	@for file in .bashrc .zshrc .profile .bash_profile; do \
		if [ -f "$(HOME)/$$file" ]; then \
			timestamp=$$(date +%Y%m%d_%H%M%S); \
			echo "📦 Backing up existing $$file to $$file.$$timestamp"; \
			mv "$(HOME)/$$file" "$(HOME)/$$file.$$timestamp"; \
		fi; \
		echo "🔗 Creating symlink for $$file"; \
		ln -sv "$(PWD)/$$file" "$(HOME)/$$file"; \
	done

install-kitty-conf:
	@echo "🔗 Creating symbolic links for kitty..."
	@mkdir -p "$(HOME)/.config/kitty"
	@if [ -f "$(HOME)/.config/kitty/kitty.conf" ]; then \
		timestamp=$$(date +%Y%m%d_%H%M%S); \
		echo "📦 Backing up existing kitty.conf to kitty.conf.$$timestamp"; \
		mv "$(HOME)/.config/kitty/kitty.conf" "$(HOME)/.config/kitty/kitty.conf.$$timestamp"; \
	fi
	@echo "🔗 Creating symlink for kitty.conf"
	@ln -sv "$(PWD)/.config/kitty/kitty.conf" "$(HOME)/.config/kitty/kitty.conf"

install-tpm:
	@echo "Cloning TPM into ~/.tmux/plugins/tpm"
	@if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm; \
	else \
		echo "TPM is already installed."; \
	fi

clean:
	@echo "🧹 Cleaning up..."
	@rm -f Mambaforge-*.sh 
