.PHONY: build installers

INSTALLER_ROOT = base-image/build-root/installers

build:
	docker build -t n0-devcontainer-base:latest -f base-image/Dockerfile base-image/

installers:
	curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh -o "$(INSTALLER_ROOT)/install-uv.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$(INSTALLER_ROOT)/install-nvm.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://sh.rustup.rs -o "$(INSTALLER_ROOT)/install-rustup.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://static.pantsbuild.org/setup/get-pants.sh -o "$(INSTALLER_ROOT)/install-pants.sh"
	chmod +x $(INSTALLER_ROOT)/*.sh