#!/usr/bin/env zsh
set -euo pipefail

# required env:
#   PYTHON_VERSION
#   PANTS_VERSION
#   HOME

TEMPDIR=/tmp/configure-pants
mkdir -p $TEMPDIR
pushd $TEMPDIR

cat > pants.toml << EOF
[GLOBAL]
pants_version = "$PANTS_VERSION"
pants_subprocessdir = "$HOME/.pants.d/pids"
pants_workdir = "$HOME/.pants.d/workdir"

# https://www.pantsbuild.org/stable/docs/using-pants/key-concepts/backends
backend_packages = [
    "pants.backend.build_files.fmt.ruff",
    "pants.backend.awslambda.python",
    "pants.backend.docker",
    "pants.backend.python",
    "pants.backend.experimental.python.lint.ruff.check",
    "pants.backend.experimental.python.lint.ruff.format",
    "pants.backend.experimental.javascript",
    "pants.backend.experimental.typescript"
]

[python]
enable_resolves = true
interpreter_constraints = ["~=$PYTHON_VERSION"]

[python.resolves]
python-default = "python-default.lock"

[anonymous-telemetry]
enabled = false
EOF

cat > BUILD << EOF
python_requirement(
    requirements=["ruff"]
)
EOF

pants --version
pants generate-lockfiles
pants export \
    --export-py-editable-in-resolve=python-default \
    --py-resolve-format=mutable_virtualenv \
    --resolve=python-default
popd
rm -rf $TEMPDIR