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

## Locally

1. Clone this repository:

   ```sh
   git clone git@github.com:jasperjonker/nrf.git
   ```

1. Install the nrf toolchain. Easiest is using the NRF Connect VSCode extension.

1. Install NRF Connect SDK (here using NRF SDK version 2.9.0):

   ```sh
   west init -m https://github.com/nrfconnect/sdk-nrf --mr v2.9.0
   ```

   ```sh
   west update
   ```

   or use the extension, but you might need to symlink libunistring: `sudo ln -s /usr/lib64/libunistring.so.5 /usr/lib64/libunistring.so.2` (at least on Fedora/Ubuntu 24).

1. Install the python packages (use a virtualenv):

   ```sh
   pip install --upgrade pip && \
   pip install -r zephyr/scripts/requirements.txt && \
   pip install -r nrf/scripts/requirements.txt && \
   pip install -r bootloader/mcuboot/scripts/requirements.txt
   ```

1. Install [nrfutil](https://www.nordicsemi.com/Products/Development-tools/nRF-Util/Download#infotabs)

   ```sh
   chmod +x ./nrfutil
   sudo mkdir -p /opt/nordic
   sudo mv nrfutil /opt/nordic/
   ```

   And update your `PATH` to include `/opt/nordic` by adding it to your `~/.bashrc` or `~/.zshrc`:

   ```sh
   PATH="$PATH:/opt/nordic"
   ```

