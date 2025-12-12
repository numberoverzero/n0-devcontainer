.PHONY: build-devcontainer build-devcontainer-all build-devcontainer-go installers


INSTALLER_ROOT := shared/build-root/installers


build-devcontainer: build-devcontainer-all build-devcontainer-go

build-devcontainer-all:
	BUILDX_METADATA_PROVENANCE=false BUILDX_NO_DEFAULT_ATTESTATIONS=1 npx @devcontainers/cli build \
		--workspace-folder devcontainer-all/devcontainer-image \
		--config devcontainer-all/devcontainer-image/devcontainer.json \
		--push false --log-level debug

build-devcontainer-go:
	BUILDX_METADATA_PROVENANCE=false BUILDX_NO_DEFAULT_ATTESTATIONS=1 npx @devcontainers/cli build \
		--workspace-folder devcontainer-go/devcontainer-image \
		--config devcontainer-go/devcontainer-image/devcontainer.json \
		--push false --log-level debug

installers:
	curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh -o "$(INSTALLER_ROOT)/install-uv.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$(INSTALLER_ROOT)/install-nvm.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://sh.rustup.rs -o "$(INSTALLER_ROOT)/install-rustup.sh"
	chmod +x $(INSTALLER_ROOT)/*.sh
