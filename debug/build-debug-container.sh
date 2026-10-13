#!/usr/bin/env bash
# Builds the debug Apptainer image (SL7 + gdb + gdbserver) from its definition file.
#
# Output: debug/fnal-dev-sl7-gdb/fnal-dev-sl7-gdb.sif  (DEBUG_CONTAINER_IMAGE in setup/setup-config.sh)
#
# Requires --fakeroot support or root privileges on the build host.

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)
source "$ROOTFOLDER/setup/setup-config.sh"

DEF_FILE="$ROOTFOLDER/debug/fnal-dev-sl7-gdb/fnal-dev-sl7.def"

echo "[INFO] Building debug container image"
echo "[INFO]   def:    $DEF_FILE"
echo "[INFO]   output: $DEBUG_CONTAINER_IMAGE"

"$APPTAINER_BIN" build --fakeroot "$DEBUG_CONTAINER_IMAGE" "$DEF_FILE"
