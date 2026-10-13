#!/usr/bin/env bash
# Sourceable environment setup for ND_CAFMaker.
# Sets up UPS, ND_CAFMaker dependencies, and the locally-built duneanaobj.
#
# ROOTFOLDER must be set by the caller before sourcing this file.
# After sourcing, NDCAFMAKER_DIR, FCL_FILE, ANA_DIR and all UPS commands are available.
#
# Note: changes the working directory to NDCAFMAKER_DIR because ndcaf_setup.sh
# uses relative paths; callers should cd back to their desired directory afterwards.

source "$ROOTFOLDER/setup/setup-config.sh"

export PRODUCTS="$MY_UPS_DIR:$PRODUCTS"

cd "$NDCAFMAKER_DIR"
source "$NDCAFMAKER_INSTALL_DIR/bin/ndcaf_setup.sh" debug

# Replace the UPS duneanaobj with the locally-built version
unsetup duneanaobj
setup duneanaobj "$DUNEANAOBJ_VER" -q "$DUNEANAOBJ_QUAL"
