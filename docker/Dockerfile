# docker/Dockerfile
# Build environment for rpi5-qt-fastboot Yocto builds
#
# Based on the official kas image which already includes all
# Yocto Scarthgap host dependencies (python3, bitbake, git, etc.)
#
# Usage:
#   docker build -t rpi5-qt-fastboot-builder docker/
#   OR use kas-container which handles this automatically:
#   ./kas-container build kas/rpi5-sd.yml

FROM kasproject/kas:4.3

# Switch to root for package installation
USER root

# Install project-specific tools not included in the base kas image
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Image flashing tool — faster and safer than dd, uses .bmap files
    bmap-tools \
    # Binary inspection utilities — useful for debugging boot issues
    xxd \
    binutils \
    # Tree view of directory structures — handy for rootfs inspection
    tree \
    # Serial terminal — for connecting to RPi5 UART debug console
    minicom \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to kas default user
USER kas

# Label for identification
LABEL maintainer="mawaiskhan70" \
      project="rpi5-qt-fastboot" \
      yocto-release="scarthgap-5.0-lts"
