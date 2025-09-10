FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_HOME="/home/$USERNAME"
ARG BUILD_ROOT="/tmp/build-root"

ARG PYTHON_VERSION="3.13"
ARG PANTS_VERSION="2.27.0"
ARG NODE_VERSION="24"

# =============================================================================
# PART 0: base dependencies
# =============================================================================
RUN apt update -y && \
    apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        # (note: fossil apt version lags by a few minor versions but seems fine)
        fossil \
        git \
        jq \
        less \
        locales \
        lsb-release \
        lsof \
        make \
        man-db \
        manpages \
        manpages-dev \
        nano \
        net-tools \
        openssh-client \
        pkg-config \
        rust-c \
        sqlite3 \
        sudo \
        tree \
        rsync \
        unzip \
        wget \
        xz-utils \
        yq \
        zip \
        zsh \
        unminimize
RUN apt update && apt upgrade -y --no-install-recommends && apt autoremove -y
RUN yes | unminimize

# =============================================================================
# PART 1: create user, grab build context
# =============================================================================
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "en_DK.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LC_TIME=en_DK.UTF-8

RUN userdel -f -r ubuntu && \
    echo ${USER_GID} && \
    groupadd -g ${USER_GID} ${USERNAME} && \
    useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/zsh ${USERNAME} && \
    echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > "/etc/sudoers.d/${USERNAME}" && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# copy all of our build context into the container so we can run installer scripts
COPY --chown=${USER_UID}:${USER_GID} build-root ${BUILD_ROOT}

# =============================================================================
# PART 2: install all of our development tools as user, not root
# =============================================================================
USER ${USERNAME}
SHELL [ "/bin/zsh", "-c" ]
ENV SHELL=/bin/zsh

# configure ~, zsh, oh-my-zsh
#     Logic from devcontainers, licensed under MIT license:
#     MIT License
#     Copyright (c) 2022 Microsoft Corporation.
#     https://github.com/devcontainers/features/blob/a69dd5c8be227b635c007233e1a840e3e336fd05/LICENSE
#     https://github.com/devcontainers/features/blob/a69dd5c8be227b635c007233e1a840e3e336fd05/src/common-utils/main.sh#L538
RUN umask g-w,o-w && \
    git clone --depth=1 \
        -c core.eol=lf \
        -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        "https://github.com/ohmyzsh/ohmyzsh" "${USER_HOME}/.zsh" 2>&1 && \
    cd "${USER_HOME}/.zsh" && \
    git repack -a -d -f --depth=1 --window=1 && \
    cp -a ${BUILD_ROOT}/home/. ${USER_HOME}/. && \
    # aws, ssh are usually bind mounted from host
    mkdir -p ${USER_HOME}/.config ${USER_HOME}/.aws ${USER_HOME}/.ssh && \
    # fixup user home permissions
    chown -R ${USERNAME}:${USERNAME} ${USER_HOME}


# uv
RUN ${BUILD_ROOT}/installers/install-uv.sh && \
    source ${USER_HOME}/.zshrc && \
    uv python install ${PYTHON_VERSION} --preview
# pants
RUN source ${USER_HOME}/.zshrc && \
    ${BUILD_ROOT}/installers/install-pants.sh && \
    source ${USER_HOME}/.zshrc && \
    PYTHON_VERSION=${PYTHON_VERSION} PANTS_VERSION=${PANTS_VERSION} HOME=${USER_HOME} ${BUILD_ROOT}/installers/configure-pants.sh
# nvm, global dev packages
RUN ${BUILD_ROOT}/installers/install-nvm.sh && \
    source ${USER_HOME}/.zshrc && \
    nvm install ${NODE_VERSION} && \
    nvm use ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    npm install --global @biomejs/biome esbuild sqlite3 typescript wrangler
# rust (note: apt version does not allow self update)
RUN ${BUILD_ROOT}/installers/install-rustup.sh -y && \
    source ${USER_HOME}/.zshrc && \
    rustup self update && \
    rustup toolchain install nightly && rustup update
    # TODO: add cross-compilation targets here with:
    #   rustup target add <triple>

# drop build artifacts
RUN rm -rf ${BUILD_ROOT}

ENTRYPOINT [ "/bin/zsh", "-l" ]
CMD [ "-i" ]
