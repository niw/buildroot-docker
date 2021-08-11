FROM ubuntu:bionic

RUN \
  export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y \
    bash \
    bc \
    binutils \
    bison \
    build-essential \
    bzip2 \
    cpio \
    file \
    flex \
    g++ \
    gcc \
    git \
    gzip \
    libncurses5-dev \
    make \
    python3 \
    rsync \
    tar \
    unzip \
    wget \
  && rm -rf /var/lib/apt/lists/*

# Use the latest stable release.
# See <https://buildroot.org/download.html>.
RUN \
  git clone http://github.com/buildroot/buildroot \
    --branch 2021.05.x \
    --single-branch \
    --depth=1 \
    /buildroot

WORKDIR /buildroot

# Apply patches.
# The patch changes `Makefile` to always use `/output` as `O`.
# See the following comment why we can't use `/buildroot/output`.
COPY patches /buildroot/patches
RUN \
  GIT_COMMITTER_NAME=patches \
  GIT_COMMITTER_EMAIL=patches@example.com \
  git am patches/*.patch \
  && rm -rf patches

# Due to the implementation of Builroot `kconfig` which is using
# `rename(2)`, using Docker volume at `/buildroot/output` will fail with
# "Invalid cross-device link" error, when it moves config file
# from `/buildroot` to `/buildroot/output`.
#
# The cause is not obvious, and `make` is mostly silently failed with
# "Error during update of the configuration." message.
#
# This is not happening for the out of tree build because all files are
# placed in the output directory which is in the same volume.
VOLUME /output

VOLUME /buildroot/dl

CMD ["/bin/bash"]
