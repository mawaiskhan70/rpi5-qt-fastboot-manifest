#!/bin/bash
# scripts/build.sh
# Thin wrapper around kas-container for rpi5-qt-fastboot builds
#
# Usage:
#   ./scripts/build.sh sd          → full SD card image build
#   ./scripts/build.sh nvme        → full NVMe image build
#   ./scripts/build.sh sd shell    → drop into BitBake shell (SD config)
#   ./scripts/build.sh nvme shell  → drop into BitBake shell (NVMe config)
#   ./scripts/build.sh sd bitbake <recipe>  → build single recipe

set -e  # exit immediately on any error

# ---------------------------------------------------------------
# Resolve script and repo root locations
# ---------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
KAS_CONTAINER="${REPO_ROOT}/kas-container"

# ---------------------------------------------------------------
# Validate kas-container is present
# ---------------------------------------------------------------
if [[ ! -f "${KAS_CONTAINER}" ]]; then
    echo "ERROR: kas-container not found at ${KAS_CONTAINER}"
    echo "Run: curl -fsSL https://raw.githubusercontent.com/siemens/kas/refs/heads/master/kas-container -o kas-container && chmod +x kas-container"
    exit 1
fi

# ---------------------------------------------------------------
# Parse target argument (sd or nvme)
# ---------------------------------------------------------------
TARGET="${1:-sd}"   # default to sd if no argument given

case "${TARGET}" in
    sd)
        KAS_CONFIG="kas/rpi5-sd.yml"
        ;;
    nvme)
        KAS_CONFIG="kas/rpi5-nvme.yml"
        ;;
    *)
        echo "ERROR: Unknown target '${TARGET}'. Use 'sd' or 'nvme'."
        echo "Usage: $0 [sd|nvme] [shell|bitbake <recipe>]"
        exit 1
        ;;
esac

# ---------------------------------------------------------------
# Parse command (build, shell, or bitbake <recipe>)
# ---------------------------------------------------------------
COMMAND="${2:-build}"   # default to full build

cd "${REPO_ROOT}"

case "${COMMAND}" in
    build)
        echo "==> Building target: ${TARGET} using ${KAS_CONFIG}"
        "${KAS_CONTAINER}" build "${KAS_CONFIG}"
        ;;
    shell)
        echo "==> Dropping into kas shell for target: ${TARGET}"
        echo "    BitBake is ready — run: bitbake <recipe-name>"
        "${KAS_CONTAINER}" shell "${KAS_CONFIG}"
        ;;
    bitbake)
        RECIPE="${3}"
        if [[ -z "${RECIPE}" ]]; then
            echo "ERROR: No recipe specified."
            echo "Usage: $0 ${TARGET} bitbake <recipe-name>"
            exit 1
        fi
        echo "==> Building recipe: ${RECIPE} for target: ${TARGET}"
        "${KAS_CONTAINER}" shell "${KAS_CONFIG}" -c "bitbake ${RECIPE}"
        ;;
    *)
        echo "ERROR: Unknown command '${COMMAND}'."
        echo "Usage: $0 [sd|nvme] [build|shell|bitbake <recipe>]"
        exit 1
        ;;
esac
