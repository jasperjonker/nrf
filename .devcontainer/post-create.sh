#!/bin/bash

# These commands can only run once the workspace volume is mounted.
# All other commands should be in .devcontainer/Dockerfile.
pyenv global zephyr-dev

# Check python version
python --version

# Update west project
# west update

# Set up the Nordic SDK
if [ ! -d "${NRF_SDK_VERSION}" ]; then
    west init -m https://github.com/nrfconnect/sdk-nrf --mr ${NRF_SDK_VERSION} ${NRF_SDK_VERSION}
else
    echo "Directory ${NRF_SDK_VERSION} already exists. Skipping west init."
fi
cd ${NRF_SDK_VERSION}
west update
west zephyr-export
pip3 install --upgrade pip
pip3 install -r zephyr/scripts/requirements.txt
pip3 install -r nrf/scripts/requirements.txt
pip3 install -r bootloader/mcuboot/scripts/requirements.txt
cd ..

# install pre-commit
# pip install --upgrade pre-commit

# pre-commit install

# pre-commit run --files app/west.yml

# # Install zephyr j-link plugin
# cd modules/debug/jlink-zephyr
# mkdir build && cd build
# cmake ..
# cmake --build .
