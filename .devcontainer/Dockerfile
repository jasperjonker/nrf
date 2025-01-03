# Developer Image (zephyr-build)
# See https://github.com/zephyrproject-rtos/docker-image/blob/main/Dockerfile.ci
FROM docker.io/zephyrprojectrtos/ci:v0.27.4

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG PYTHON_VERSION=3.12
ARG GO_VERSION=1.23.2

# Nordic
# ARG nrf_sdk_branch=v2.7-branch
ENV NRF_TOOLCHAIN_VERSION=v2.9.0
ENV NRF_SDK_VERSION=v2.9.0
ARG NORDIC_COMMAND_LINE_TOOLS_VERSION="10-24-0/nrf-command-line-tools-10.24.0"
ARG arch=amd64

# ENV ZEPHYR_BASE="${HOME_DIR}/ncs/${NRF_SDK_VERSION}/zephyr"
ENV ZEPHYR_BASE="/workspace/${NRF_SDK_VERSION}/zephyr"
ENV NCS_TOOLCHAIN_VERSION="${NRF_TOOLCHAIN_VERSION}"

# Set non-interactive frontend for apt-get to skip any user confirmations
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME_DIR="/home/${USERNAME}"
ENV PYENV_ROOT="${HOME_DIR}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
ENV PATH="$PATH:/usr/local/go/bin"
ENV PATH="$PATH:/${HOME_DIR}/.local/bin"
ENV PATH="$PATH:/opt/SEGGER/JLink"

## Setup a user with sudo support
USER root

# General packages
RUN <<EOT
    set -e
    apt-get update -y
    apt-get -y install --no-install-recommends \
        zsh \
        gdb \
        gnupg2 \
        picocom \
        usbutils \
        udev
    rm -rf /var/lib/apt/lists/*
EOT

# Packages for python (pyenv)
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN <<EOT
    set -e
    apt-get update -y
    apt-get -y install --no-install-recommends \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libffi-dev \
        liblzma-dev \
        python3-openssl \
        libxml2-dev \
        libxmlsec1-dev \
        git
    rm -rf /var/lib/apt/lists/*
EOT

# Install go
RUN <<EOT
    set -e
    rm -rf /usr/local/go
    curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz
EOT

# Install mcumgr for mcuboot
RUN GOBIN=/usr/local/bin/ go install github.com/apache/mynewt-mcumgr-cli/mcumgr@latest

# Install dfu-util from source (needed to flash arduino boards)
RUN <<EOT
    set -e
    apt-get update -y
    apt-get -y install --no-install-recommends \
        libusb-1.0-0-dev \
        apt-utils \
        pandoc
    # && apt-get -y build-dep dfu-util
    rm -rf /var/lib/apt/lists/*
    git clone --depth=1 git://git.code.sf.net/p/dfu-util/dfu-util /opt/dfu-util
    cd /opt/dfu-util
    ./autogen.sh
	./configure
	make
    make install
EOT

# Install pre-commit tools
RUN <<EOT
    set -e
    apt-get update -y
    apt-get -y install --no-install-recommends \
        clang-tidy \
        uncrustify \
        cppcheck \
        cpplint \
        clang \
        libclang-dev
    rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT
    set -e
    git clone --branch 0.20 --depth 1 https://github.com/include-what-you-use/include-what-you-use.git /opt/include-what-you-use
    mkdir /opt/include-what-you-use/build
    cd /opt/include-what-you-use/build
    cmake -G "Unix Makefiles" ..
    make
    ln -s /opt/include-what-you-use/build/bin/include-what-you-use /usr/local/bin/include-what-you-use
EOT

# Install SEGGER J-Link tools
# RUN <<EOT
#     set -e
#     curl -d "accept_license_agreement=accepted&submit=Download+software" \
#         -X POST "https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.tgz" \
#         -o /tmp/JLink_Linux_x86_64.tgz
#     mkdir -p /opt/SEGGER/
#     tar -xzf /tmp/JLink_Linux_x86_64.tgz -C /opt/SEGGER/
#     mv /opt/SEGGER/JLink_Linux_V* /opt/SEGGER/JLink
#     rm /tmp/JLink_Linux_x86_64.tgz
# EOT

# gcc-multilib make = Host tools for native_sim build
# python 3.8 is installed by toolchain manager hence older version of libffi is required
RUN <<EOT
    set -e
    apt-get -y update
    apt-get -y upgrade
    apt-get -y install wget unzip clang-format gcc-multilib make libffi7
    apt-get -y clean
    rm -rf /var/lib/apt/lists/*
EOT

USER $USERNAME
WORKDIR $HOME_DIR

# Nordic command line tools
# Releases: https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/download
RUN <<EOT
    set -e
    NCLT_BASE=https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x
    echo "Host architecture: $arch"
    case $arch in
        "amd64")
            NCLT_URL="${NCLT_BASE}/${NORDIC_COMMAND_LINE_TOOLS_VERSION}_linux-amd64.tar.gz"
            ;;
        "arm64")
            NCLT_URL="${NCLT_BASE}/${NORDIC_COMMAND_LINE_TOOLS_VERSION}_linux-arm64.tar.gz"
            ;;
    esac
    echo "NCLT_URL=${NCLT_URL}"
    if [ ! -z "$NCLT_URL" ]; then
        mkdir tmp && cd tmp
        wget -O - "${NCLT_URL}" | tar --no-same-owner -xz
        # Install included JLink
        sudo mkdir /opt/SEGGER
        sudo tar xzf JLink_*.tgz -C /opt/SEGGER
        sudo mv /opt/SEGGER/JLink* /opt/SEGGER/JLink
        # Install nrf-command-line-tools
        sudo cp -r ./nrf-command-line-tools /opt
        sudo ln -s /opt/nrf-command-line-tools/bin/nrfjprog /usr/local/bin/nrfjprog
        sudo ln -s /opt/nrf-command-line-tools/bin/mergehex /usr/local/bin/mergehex
        cd .. && rm -rf tmp; \
    else
        echo "Skipping nRF Command Line Tools (not available for $arch)" ;
    fi
EOT

# Install toolchain
# Make nrfutil install in a shared location, because when used with GitHub
# Actions, the image will be launched with the home dir mounted from the local
# checkout.
# ENV NRFUTIL_HOME=/usr/local/share/nrfutil
RUN <<EOT
    set -e
    wget https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil
    chmod +x nrfutil
    sudo mv nrfutil /usr/local/bin
    nrfutil install toolchain-manager
    nrfutil install toolchain-manager search
    nrfutil toolchain-manager install --ncs-version ${NRF_TOOLCHAIN_VERSION}
    nrfutil toolchain-manager list
    rm -f ${HOME_DIR}/ncs/downloads/*
EOT

# Install pyenv
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"
RUN <<EOT
    set -e
    echo 'export PYENV_ROOT="${PYENV_ROOT}"' >> ${HOME_DIR}/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ${HOME_DIR}/.bashrc
    echo 'eval "$(pyenv init -)"' >> ${HOME_DIR}/.bashrc
    echo 'export PYENV_ROOT="${PYENV_ROOT}"' >> ${HOME_DIR}/.zshrc
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ${HOME_DIR}/.zshrc
    echo 'eval "$(pyenv init -)"' >> ${HOME_DIR}/.zshrc
EOT

# Install pyenv-virtualenv
RUN <<EOT
    set -e
    git clone --depth 1 https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    echo 'eval "$(pyenv virtualenv-init -)"' >> ${HOME_DIR}/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ${HOME_DIR}/.zshrc
EOT

# Install python with max performance
# https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#building-for-maximum-performance
RUN <<EOT
    set -e
    PROFILE_TASK='-m test.regrtest --pgo -j0' \
        PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' \
        PYTHON_CFLAGS='-march=native -mtune=native' \
        pyenv install --verbose "${PYTHON_VERSION}"
EOT

RUN <<EOT
    set -e
    pyenv virtualenv "${PYTHON_VERSION}" zephyr-dev
    pyenv global zephyr-dev
    echo 'pyenv global zephyr-dev' >> ${HOME_DIR}/.bashrc
    echo 'pyenv global zephyr-dev' >> ${HOME_DIR}/.zshrc
EOT

# Set up the Nordic SDK
# WORKDIR $HOME_DIR/ncs
# RUN <<EOT
#     set -e
#     west init -m https://github.com/nrfconnect/sdk-nrf --mr ${NRF_SDK_VERSION} ${NRF_SDK_VERSION}
#     cd ${NRF_SDK_VERSION}
#     west update
#     west zephyr-export
#     pip3 install --upgrade pip
#     pip3 install -r zephyr/scripts/requirements.txt
#     pip3 install -r nrf/scripts/requirements.txt
#     pip3 install -r bootloader/mcuboot/scripts/requirements.txt
# EOT

# NOTE: All user configuration (e.g. zshrc, nvim) should be done using dotfiles and added to your user vscode settings.json
