.PHONY: build-devcontainer build-base installers


DEVCONTAINER_IMAGE_NAME := n0-devcontainer:latest
BASE_IMAGE_NAME := n0-devcontainer-base:latest
INSTALLER_ROOT := base-image/build-root/installers


build-devcontainer:
	npx @devcontainers/cli build \
		--workspace-folder devcontainer-image \
		--config devcontainer-image/devcontainer.json \
		--image-name $(DEVCONTAINER_IMAGE_NAME) \
		--push false --log-level debug

build-base:
	docker build -t $(BASE_IMAGE_NAME) -f base-image/Dockerfile base-image/

installers:
	curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh -o "$(INSTALLER_ROOT)/install-uv.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$(INSTALLER_ROOT)/install-nvm.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://sh.rustup.rs -o "$(INSTALLER_ROOT)/install-rustup.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://static.pantsbuild.org/setup/get-pants.sh -o "$(INSTALLER_ROOT)/install-pants.sh"
	chmod +x $(INSTALLER_ROOT)/*.sh
