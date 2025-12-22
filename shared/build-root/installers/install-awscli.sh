#!/usr/bin/env zsh
set -euo pipefail

# AWS CLI v2 installer for Linux x86_64
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

AWSCLI_SHA256="${AWSCLI_SHA256:?AWSCLI_SHA256 must be set}"

TMPDIR="$(mktemp -d)"
INSTALL_PATH="$HOME/.local/aws-cli"

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Downloading AWS CLI v2..."
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$TMPDIR/awscliv2.zip"

echo "Verifying sha256..."
echo "${AWSCLI_SHA256}  $TMPDIR/awscliv2.zip" | sha256sum -c -

echo "Extracting..."
unzip -q "$TMPDIR/awscliv2.zip" -d "$TMPDIR"

echo "Removing existing $INSTALL_PATH (if any)..."
rm -rf "$INSTALL_PATH"

echo "Installing AWS CLI to $INSTALL_PATH..."
"$TMPDIR/aws/install" --install-dir "$INSTALL_PATH" --bin-dir "$HOME/.local/bin" --update

echo "Installed: $(aws --version)"
