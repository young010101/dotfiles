.PHONY: all install-mamba install-tools clean

all: install-mamba install-tools

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

clean:
	@echo "🧹 Cleaning up..."
	@rm -f Mambaforge-*.sh 