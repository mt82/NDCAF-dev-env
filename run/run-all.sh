#!/usr/bin/env bash
# Full build-and-run pipeline:
#   1. build/build-duneanaobj.sh   – clone, patch, and install duneanaobj as v99_99_99
#   2. build/build-ND_CAFMaker.sh  – clone and build ND_CAFMaker
#   3. run/run-ND_CAFMaker.sh – run makeCAF with the FCL file from setup/setup-config.sh
#
# Any options passed here are forwarded to build/build-ND_CAFMaker.sh (e.g. --no-download).
# Each step runs in its own Apptainer container invocation.

set -euo pipefail

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)

echo "[run-all] Step 1/3: building duneanaobj"
bash "$ROOTFOLDER/build/build-duneanaobj.sh"

echo "[run-all] Step 2/3: building ND_CAFMaker"
bash "$ROOTFOLDER/build/build-ND_CAFMaker.sh" "$@"

echo "[run-all] Step 3/3: running ND_CAFMaker"
bash "$ROOTFOLDER/run/run-ND_CAFMaker.sh"

echo "[run-all] Done."
