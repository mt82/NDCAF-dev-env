#!/usr/bin/env bash
# Runs makeCAF using the installed ND_CAFMaker binary.
#
# Input:  FCL_FILE  (configured in setup/setup-config.sh, default: jacobCAF.fcl)
# Output: CAF files written to ANA_DIR (configured in setup/setup-config.sh, default: ana/)
#
# Requires ND_CAFMaker to have been built first (build/build-ND_CAFMaker.sh).
# Must be run inside an Apptainer container; re-launches itself automatically if not.

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)
source "$ROOTFOLDER/setup/setup-config.sh"

if [ -n "${APPTAINER_CONTAINER:-}" ]; then
    echo "[INFO] Inside container: running ND_CAFMaker"

    # --- Environment setup ---
    source "$ROOTFOLDER/setup/setup-ND_CAFMaker-env.sh"

    # --- Generate input FCL ---
    bash "$ROOTFOLDER/setup/setup-ND_CAFMaker-input.sh"

    # --- Run ---
    cd "$ROOTFOLDER"
    mkdir -p "$ANA_DIR"
    "$NDCAFMAKER_INSTALL_DIR/bin/makeCAF" "$FCL_CAFMAKER_INPUT"
else
    "$APPTAINER_BIN" exec \
        -B "$APPTAINER_BINDS" \
        --ipc --pid \
        "$CONTAINER_IMAGE" \
        bash "$0" "$@"
fi
