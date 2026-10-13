#!/usr/bin/env bash
# Builds ND_CAFMaker and installs it under ND_CAFMaker/install/.
#
# Options:
#   --no-download   Skip the git clone step and build the existing local source tree.
#                   Use this when iterating on local changes without re-fetching from GitHub.
#
# Requires duneanaobj to have been installed first (build-duneanaobj.sh).
# Must be run inside an Apptainer container; re-launches itself automatically if not.

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)
source "$ROOTFOLDER/setup/setup-config.sh"

# Parse flags before potentially re-entering the container so they are forwarded via "$@"
NO_DOWNLOAD=0
for arg in "$@"; do
    [[ "$arg" == "--no-download" ]] && NO_DOWNLOAD=1
done

if [ -n "${APPTAINER_CONTAINER:-}" ]; then
    echo "[INFO] Inside container: building ND_CAFMaker (no-download=$NO_DOWNLOAD)"

    export PRODUCTS="$MY_UPS_DIR:$PRODUCTS"
    source "$DUNE_SETUP"

    if [ "$NO_DOWNLOAD" -eq 0 ]; then
        # Start from a clean checkout
        rm -rf "$NDCAFMAKER_DIR"
        git clone -b "$NDCAFMAKER_BRANCH" "$NDCAFMAKER_REPO" "$NDCAFMAKER_DIR"
    fi

    cd "$NDCAFMAKER_DIR"
    source ndcaf_setup_deps.sh debug

    # Replace the UPS duneanaobj with the locally-built version
    unsetup duneanaobj
    setup duneanaobj "$DUNEANAOBJ_VER" -q "$DUNEANAOBJ_QUAL"
    
    # Setup srproxy for the makeCAF tool, which is a dependency of ND_CAFMaker
    # Not clear if this is needed for the build itself, but it is needed for the smoke test at the end.
    setup srproxy v00.45 -q py3

    cmake -S . -B "$NDCAFMAKER_BUILD_DIR" -DCMAKE_INSTALL_PREFIX="$NDCAFMAKER_INSTALL_DIR" -DCMAKE_BUILD_TYPE=Debug
    cmake --build "$NDCAFMAKER_BUILD_DIR" --target install

    # Quick smoke test
    "$NDCAFMAKER_INSTALL_DIR/bin/makeCAF" --help 2>/dev/null
else
    "$APPTAINER_BIN" exec \
        -B "$APPTAINER_BINDS" \
        --ipc --pid \
        "$CONTAINER_IMAGE" \
        bash "$0" "$@"
fi
