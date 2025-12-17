# n0 devcontainer

* **svn**: git, fossil
* **lang**: nvm, rustup, uv, go

### vscode extensions

* **infra**: ssh, docker
* **providers**: aws
* **lang**: python, rust, sql _(postgres, sqlite)_, ts, go


### vscode features

* docker-in-docker


## Sample .devcontainer/devcontainer.json

```
{
    "name": "my-cool-devcontainer-go",
    "image": "ghcr.io/numberoverzero/devcontainer-go:latest",
    "runArgs": [
        "--env", "TZ=America/New_York"
    ],
    "mounts": [
        // make host credentials and configs available in the container
        "source=${env:HOME}/.aws,target=/home/vscode/.aws,type=bind,consistency=consistent",
        "source=${env:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=consistent",
        "source=${env:HOME}/.claude,target=/home/vscode/.claude,type=bind,consistency=consistent",
        "source=${env:HOME}/.gitconfig,target=/home/vscode/.gitconfig,type=bind,readonly"
    ],
    "customizations": {
        "vscode": {
            "extensions": [
                // additional extensions here
            ]
        }
    }
}

```
