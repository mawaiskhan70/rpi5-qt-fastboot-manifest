#!/bin/bash
# scripts/flash.sh
# Flash built image to SD card or NVMe using bmaptool
#
# Usage:
#   ./scripts/flash.sh sd /dev/sdX       → flash SD card image
#   ./scripts/flash.sh nvme /dev/sdX     → flash NVMe image (via USB adapter)
#
# WARNING: /dev/sdX will be completely overwritten.
# Double-check your device with: lsblk

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ---------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------
TARGET="${1}"
DEVICE="${2}"

if [[ -z "${TARGET}" || -z "${DEVICE}" ]]; then
    echo "Usage: $0 [sd|nvme] /dev/sdX"
    echo ""
    echo "List available devices with: lsblk"
    exit 1
fi

# ---------------------------------------------------------------
# Locate the built image
# ---------------------------------------------------------------
IMAGE_DIR="${REPO_ROOT}/build/tmp/deploy/images/raspberrypi5"

case "${TARGET}" in
    sd)
        IMAGE=$(ls "${IMAGE_DIR}"/*-sd*.wic 2>/dev/null | head -1)
        ;;
    nvme)
        IMAGE=$(ls "${IMAGE_DIR}"/*-nvme*.wic 2>/dev/null | head -1)
        ;;
    *)
        echo "ERROR: Unknown target '${TARGET}'. Use 'sd' or 'nvme'."
        exit 1
        ;;
esac

if [[ -z "${IMAGE}" ]]; then
    echo "ERROR: No built image found in ${IMAGE_DIR}"
    echo "Run ./scripts/build.sh ${TARGET} first."
    exit 1
fi

# ---------------------------------------------------------------
# Safety check — confirm before writing
# ---------------------------------------------------------------
echo "==> Target device : ${DEVICE}"
echo "==> Image to flash: ${IMAGE}"
echo ""
echo "WARNING: ALL DATA ON ${DEVICE} WILL BE DESTROYED."
read -p "Type 'yes' to continue: " CONFIRM

if [[ "${CONFIRM}" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi

# ---------------------------------------------------------------
# Flash using bmaptool (fast) or dd (fallback)
# ---------------------------------------------------------------
if command -v bmaptool &>/dev/null; then
    echo "==> Flashing with bmaptool..."
    sudo bmaptool copy "${IMAGE}" "${DEVICE}"
else
    echo "==> bmaptool not found, falling back to dd..."
    echo "    Install bmaptool for faster flashing: sudo apt install bmap-tools"
    sudo dd if="${IMAGE}" of="${DEVICE}" bs=4M status=progress conv=fsync
fi

echo ""
echo "==> Flash complete. Safe to remove ${DEVICE}."
