# .devcontainer

the devcontainer that you run is made up of three main layers:

1. the bottom layer is defined in `base-image/Dockerfile` and doesn't include vscode features, extensions, or know
   that it's destined to be a devcontainer.  this image isn't published anywhere, but you can build it locally to
   test out changes with `make build-base` to save the build overhead that comes with vscode features.
2. the middle layer is the devcontainer including vscode features and extensions.  this is published to ghcr.io and
   includes everything in the `base-image/Dockerfile` plus anything defined in `devcontainer-image/devcontainer.json`
   while the ghcr.io image is built in a github workflow, you can also build it locally with `make build-devcontainer`
3. the top layer is the `.devcontainer/devcontainer.json` that you define, which will minimally look like:

   ```json
   {
       "name": "<your devcontainer name>",
       "image": "ghcr.io/numberoverzero/devcontainer:latest",
       "runArgs": [
            // if you have any, like:
            // "--network=host"
        ],
        // optional: if you want to run any script after the container comes up for the first time
        "postCreateCommand": ".devcontainer/postCreateCommand.sh",
        "customizations": {
            "vscode": {
                "settings": {
                    // // any vscode settings you want to add
                    // "files.insertFinalNewline": true
                },
                "extensions": [
                    // // any extensions to add:
                    // "ms-python.python"
                    // // or remove:
                    // "-tamasfe.even-better-toml"
                ]
            }
        },
        "features": {
            // // any features you want to add
            // "ghcr.io/devcontainers/features/go:1": {}
        }
    }
   ```

## but this `example` folder looks different

this `example` directory is an example of the top layer, but it points to the local image name
that comes from running `make build-devcontainer` instead of the image that's prebaked and available from ghcr.io.
this enables local testing without waiting on the github CI to build and publish a new image.