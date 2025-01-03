# Nordic with vscode devcontainer

This sample shows how to use the nordic SDK (with zephyr) in a vscode devcontainer.

## Dev-Container Installation (Recommended)

1. **Use VSCode Dev-Container**:
   - Open the root folder of this application in [Visual Studio Code](https://code.visualstudio.com/).
   - Ensure you can run dev-containers. Follow [the guide](https://code.visualstudio.com/docs/devcontainers/containers#_installation) here, which pretty much summarizes to:
        - Have [Docker](https://docs.docker.com/engine/install/fedora/) installed
        - Have [Visual Studio Code](https://code.visualstudio.com/Download) installed
        - Have the [dev-container plugin](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed for vscode.
   - Select `Reopen in Container`. This takes a while as it needs to compile quite a few things. In the bottom right you can see the progress/open the logs.

1. **Build the Project**:
   - Open the `nRF Connect` extension on the left side. Toolchain & SDK are already installed and should be detected automatically. You just need to give it the board and application you are using.

1. **Setup udev Rules** (Linux only):
   - Install the rules from [this guide](https://github.com/NordicSemiconductor/nrf-udev) if needed.
