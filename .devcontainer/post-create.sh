#!/bin/bash

# These commands can only run once the workspace volume is mounted.
# All other commands should be in .devcontainer/Dockerfile.
pyenv global zephyr-dev

# Check python version
python --version

# Update west project
# west update

# Install zephyr dependencies
pip install --upgrade pip
# pip install -r zephyr/scripts/requirements.txt
# pip install -r bootloader/mcuboot/scripts/requirements.txt

# install pre-commit
# pip install --upgrade pre-commit

# pre-commit install

# pre-commit run --files app/west.yml

# # Install zephyr j-link plugin
# cd modules/debug/jlink-zephyr
# mkdir build && cd build
# cmake ..
# cmake --build .
