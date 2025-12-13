#!/usr/bin/env zsh
set -euo pipefail

GO_VERSION="${GO_VERSION:?GO_VERSION must be set}"
GO_SHA256="${GO_SHA256:?GO_SHA256 must be set}"

TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
URL="https://go.dev/dl/${TARBALL}"

TMPDIR="$(mktemp -d)"
INSTALL_PATH="$HOME/.local/go"

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Downloading ${URL}..."
curl -fsSL "$URL" -o "$TMPDIR/$TARBALL"

echo "Verifying sha256..."
# Expect GO_SHA256 to match the tarball
echo "${GO_SHA256}  $TMPDIR/$TARBALL" | sha256sum -c -

echo "Extracting ${TARBALL}..."
tar -C "$TMPDIR" -xzf "$TMPDIR/$TARBALL"

echo "Removing existing $INSTALL_PATH (if any)..."
rm -rf "$INSTALL_PATH"

echo "Installing Go to $INSTALL_PATH..."
mv "$TMPDIR/go" "$INSTALL_PATH"
ln -sf "$INSTALL_PATH/bin/go" "$HOME/.local/bin/go"
ln -sf "$INSTALL_PATH/bin/gofmt" "$HOME/.local/bin/gofmt"

echo "Installed: $(go version)"

# Install go tools
echo "install-go.sh: Installing golangci-lint..."
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
echo "install-go.sh: Installing gosec..."
go install github.com/securego/gosec/v2/cmd/gosec@latest
