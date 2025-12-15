#!/usr/bin/env zsh
set -euo pipefail

# Install cagent from https://github.com/docker/cagent
# This script downloads and installs cagent into ${HOME}/.local/bin

CAGENT_VERSION="${CAGENT_VERSION:?CAGENT_VERSION must be set}"
INSTALL_DIR="${HOME}/.local/bin"
BINARY_NAME="cagent-linux-amd64"
URL="https://github.com/docker/cagent/releases/download/${CAGENT_VERSION}/${BINARY_NAME}"

echo "Downloading cagent ${CAGENT_VERSION}..."

mkdir -p "$INSTALL_DIR"
curl -fsSL "$URL" -o "$INSTALL_DIR/cagent"
chmod +x "$INSTALL_DIR/cagent"

echo "Installed: $(cagent --version)"
