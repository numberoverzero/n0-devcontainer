.PHONY: devcontainer devcontainer-all devcontainer-go installers


INSTALLER_ROOT := shared/build-root/installers


devcontainer: devcontainer-all devcontainer-go

devcontainer-all:
	BUILDX_METADATA_PROVENANCE=false BUILDX_NO_DEFAULT_ATTESTATIONS=1 npx @devcontainers/cli build \
		--workspace-folder devcontainer-all \
		--config devcontainer-all/devcontainer.json \
		--image-name devcontainer-all:local \
		--push false --log-level debug

devcontainer-go:
	BUILDX_METADATA_PROVENANCE=false BUILDX_NO_DEFAULT_ATTESTATIONS=1 npx @devcontainers/cli build \
		--workspace-folder devcontainer-go \
		--config devcontainer-go/devcontainer.json \
		--image-name devcontainer-go:local \
		--push false --log-level debug

installers:
	curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh -o "$(INSTALLER_ROOT)/install-uv.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$(INSTALLER_ROOT)/install-nvm.sh"
	curl --proto '=https' --tlsv1.2 -LsSf https://sh.rustup.rs -o "$(INSTALLER_ROOT)/install-rustup.sh"
	chmod +x $(INSTALLER_ROOT)/*.sh
