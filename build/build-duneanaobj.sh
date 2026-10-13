#!/usr/bin/env bash
# Clones, patches, and installs duneanaobj into the local UPS product area.
#
# The upstream version string in CMakeLists.txt is replaced with 99.99.99 so
# downstream tools can always depend on a fixed, locally-built version
# (DUNEANAOBJ_VER in setup/setup-config.sh) regardless of which upstream tag is checked out.
#
# Artifacts are written to:
#   duneanaobj/   – cloned source and build tree
#   ups/          – local UPS product area with the installed package
#
# Must be run inside an Apptainer container; re-launches itself automatically if not.

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)
source "$ROOTFOLDER/setup/setup-config.sh"

if [ -n "${APPTAINER_CONTAINER:-}" ]; then
    echo "[INFO] Inside container: building duneanaobj"

    # Start from a clean source tree
    rm -fr "$DUNEANAOBJ_DIR"

    # Clone the configured branch/tag
    git clone -b "$DUNEANAOBJ_BRANCH" "$DUNEANAOBJ_REPO" "$DUNEANAOBJ_DIR/duneanaobj"

    # Patch the version string so UPS registers the package as DUNEANAOBJ_VER
    sed -i "s:${DUNEANAOBJ_OLD_VER}:99.99.99:g" "$DUNEANAOBJ_DIR/duneanaobj/CMakeLists.txt"

    # Prepare a fresh local UPS product area
    rm -fr "$MY_UPS_DIR"
    mkdir -p "$MY_UPS_DIR"
    cp -a /cvmfs/dune.opensciencegrid.org/products/dune/.upsfiles "$MY_UPS_DIR/"
    export PRODUCTS="$MY_UPS_DIR:$PRODUCTS"

    source "$DUNE_SETUP"

    # Build and install into the local UPS area
    mkdir "$DUNEANAOBJ_BUILD_DIR"
    cd "$DUNEANAOBJ_BUILD_DIR"
    . "$DUNEANAOBJ_DIR/duneanaobj/ups/setup_for_development" -d
    buildtool -I "$MY_UPS_DIR" -ivT

    # Verify the installation and set up the environment
    ups list -aK+ duneanaobj
    setup duneanaobj "$DUNEANAOBJ_VER" -q "$DUNEANAOBJ_QUAL"
    export | grep ANA
else
    "$APPTAINER_BIN" exec \
        -B "$APPTAINER_BINDS" \
        --ipc --pid \
        "$CONTAINER_IMAGE" \
        bash "$0" "$@"
fi
