#!/usr/bin/env bash
# Shared configuration sourced by all build/run scripts.
# ROOTFOLDER must be set by the caller before sourcing this file.

# --- duneanaobj ---
DUNEANAOBJ_REPO="https://github.com/DUNE/duneanaobj.git"
DUNEANAOBJ_BRANCH="main"
# Version string in CMakeLists.txt that gets patched to 99.99.99
DUNEANAOBJ_OLD_VER="04.02.01"
# Version and qualifier exposed to UPS after local installation
DUNEANAOBJ_VER="v99_99_99"
DUNEANAOBJ_QUAL="e26:debug"
DUNEANAOBJ_DIR="$ROOTFOLDER/duneanaobj"
DUNEANAOBJ_BUILD_DIR="$DUNEANAOBJ_DIR/build"

# --- ND_CAFMaker ---
NDCAFMAKER_REPO="https://github.com/DUNE/ND_CAFMaker.git"
NDCAFMAKER_BRANCH="130-create-a-branch-filler-for-sandreco-experimental"
NDCAFMAKER_DIR="$ROOTFOLDER/ND_CAFMaker"
NDCAFMAKER_BUILD_DIR="$NDCAFMAKER_DIR/build"
NDCAFMAKER_INSTALL_DIR="$NDCAFMAKER_DIR/install"

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
ANA_DIR="$ROOTFOLDER/ana"

# --- ND_CAFMaker input files ---
INPUT_PATH="/exp/dune/data/users/jlarkin/caftest/"

# Base run ID; all per-flavour variables default to this (override individually if needed)
RUNID="000003"

# Per-step paths (default to INPUT_PATH; override individually if files are in different directories)
PATH_GHEP="$INPUT_PATH"
PATH_SPINE="$INPUT_PATH"
PATH_TMS="$INPUT_PATH"
PATH_EDEPSIM="$INPUT_PATH"

PREFIX_GHEP_NDLARFID="MiniProdN5p3_NDComplex_FHC.genie.ndlarfid.sanddrift."
PREFIX_GHEP_ROCKANT="MiniProdN5p3_NDComplex_FHC.genie.rockantindlarfid.sanddrift."
RUNID_GHEP="$RUNID"
SUFFIX_GHEP=".GHEP.root"

PREFIX_SPINE="MiniProdN5p3_NDComplex_FHC.spine.full.sanddrift."
RUNID_SPINE="$RUNID"
SUFFIX_SPINE=".MLRECO_SPINE.hdf5"

PREFIX_TMS="MiniProdN5p3_NDComplex_FHC.tmsreco.full.sanddrift."
RUNID_TMS="$RUNID"
SUFFIX_TMS=".TMSRECO.root"

PREFIX_EDEPSIM="MiniProdN5p3_NDComplex_FHC.spill.full.sanddrift."
RUNID_EDEPSIM="$RUNID"
SUFFIX_EDEPSIM=".EDEPSIM_SPILLS.root"

OUTPUT_CAF="$ANA_DIR/output.root"
FCL_CAFMAKER_INPUT="$ROOTFOLDER/input.fcl"
