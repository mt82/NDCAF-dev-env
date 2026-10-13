#!/usr/bin/env bash
# Shared configuration sourced by all build/run scripts.
# ROOTFOLDER must be set by the caller before sourcing this file.

# --- duneanaobj ---
DUNEANAOBJ_REPO="https://github.com/DUNE/duneanaobj.git"
DUNEANAOBJ_BRANCH="hotfix/erroneous_srproxytarget_cetpath"
# Version string in CMakeLists.txt that gets patched to 99.99.99
DUNEANAOBJ_OLD_VER="04.02.00"
# Version and qualifier exposed to UPS after local installation
DUNEANAOBJ_VER="v99_99_99"
DUNEANAOBJ_QUAL="e26:debug"
DUNEANAOBJ_DIR="$ROOTFOLDER/duneanaobj"
DUNEANAOBJ_BUILD_DIR="$DUNEANAOBJ_DIR/build"

# --- ND_CAFMaker ---
NDCAFMAKER_REPO="https://github.com/DUNE/ND_CAFMaker.git"
NDCAFMAKER_BRANCH="main"
NDCAFMAKER_DIR="$ROOTFOLDER/ND_CAFMaker"
NDCAFMAKER_BUILD_DIR="$NDCAFMAKER_DIR/build"
NDCAFMAKER_INSTALL_DIR="$NDCAFMAKER_DIR/install"

# # --- duneanaobj ---
# DUNEANAOBJ_REPO="https://github.com/pgranger23/duneanaobj.git"
# DUNEANAOBJ_BRANCH="feat/dlp-detailed"
# # Version string in CMakeLists.txt that gets patched to 99.99.99
# DUNEANAOBJ_OLD_VER="04.00.00"
# # Version and qualifier exposed to UPS after local installation
# DUNEANAOBJ_VER="v99_99_99"
# DUNEANAOBJ_QUAL="e26:debug"
# DUNEANAOBJ_DIR="$ROOTFOLDER/duneanaobj"

# # --- ND_CAFMaker ---
# NDCAFMAKER_REPO="https://github.com/DUNE/ND_CAFMaker.git"
# NDCAFMAKER_BRANCH="182-adapt-nd_cafmaker-for-updated-pid-info"
# NDCAFMAKER_DIR="$ROOTFOLDER/ND_CAFMaker"

# --- Local UPS product area ---
MY_UPS_DIR="$ROOTFOLDER/ups"

# --- Build flags ---
export CXXFLAGS="-g -Wall -fPIC -DNO_ART -O0"

# --- DUNE environment ---
DUNE_SETUP="/cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh"

# --- Apptainer container ---
APPTAINER_BIN="/cvmfs/oasis.opensciencegrid.org/mis/apptainer/current/bin/apptainer"
CONTAINER_IMAGE="/cvmfs/singularity.opensciencegrid.org/fermilab/fnal-dev-sl7:latest"
# Debug container: SL7 image with gdb and gdbserver, used by debug/start-debug-container.sh
DEBUG_CONTAINER_IMAGE="$ROOTFOLDER/debug/fnal-dev-sl7-gdb/fnal-dev-sl7-gdb.sif"
APPTAINER_BINDS="/cvmfs,/exp,/nashome,/pnfs/dune,/opt,/run/user,/etc/hostname,/etc/hosts,/etc/krb5.conf"

# --- Run configuration ---
FCL_FILE="$ROOTFOLDER/jacobCAF-new-noTMS.fcl"
ANA_DIR="$ROOTFOLDER/ana"
