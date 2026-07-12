# docker/Dockerfile
# Build environment for rpi5-qt-fastboot Yocto builds
#
# Based on the official kas image which already includes all
# Yocto Scarthgap host dependencies (python3, bitbake, git, etc.)

FROM kasproject/kas:5.4

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    bmap-tools \
    xxd \
    binutils \
    tree \
    minicom \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER kas

LABEL maintainer="mawaiskhan70" \
      project="rpi5-qt-fastboot" \
      yocto-release="scarthgap-5.0-lts"
