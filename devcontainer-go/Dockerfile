FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_HOME="/home/$USERNAME"
ARG BUILD_ROOT="/tmp/build-root"

ARG GO_VERSION="1.25.5"
ARG GO_SHA256="9e9b755d63b36acf30c12a9a3fc379243714c1c6d3dd72861da637f336ebb35b"

# =============================================================================
# PART 0: base dependencies
# =============================================================================
RUN apt update -y && \
    apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
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
COPY --chown=${USER_UID}:${USER_GID} shared/build-root ${BUILD_ROOT}

# =============================================================================
# PART 2: install development tools as user, not root
# =============================================================================
USER ${USERNAME}
SHELL [ "/bin/zsh", "-i", "-c" ]
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
    mkdir -p ${USER_HOME}/{.config,.aws,.ssh,.local/bin} && \
    # fixup user home permissions
    chown -R ${USERNAME}:${USERNAME} ${USER_HOME}

# go only
RUN ${BUILD_ROOT}/installers/install-go.sh

# drop build artifacts
RUN rm -rf ${BUILD_ROOT}

ENTRYPOINT [ "/bin/zsh", "-l" ]
CMD [ "-i" ]
