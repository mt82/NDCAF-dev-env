#!/usr/bin/env bash
# Starts a debug container (SL7 + gdb) with ND_CAFMaker configured and
# makeCAF running under gdbserver on port 2000, ready for remote debugging.
#
# Connect from your IDE/gdb client with:
#   target remote <host>:2000

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)
source "$ROOTFOLDER/setup/setup-config.sh"

# $ROOTFOLDER is expanded by the outer shell; remaining \$-vars are expanded
# inside the container after setup/setup-ND_CAFMaker-env.sh has been sourced.
"$APPTAINER_BIN" exec \
    -B "$APPTAINER_BINDS" \
    --ipc --pid \
    "$DEBUG_CONTAINER_IMAGE" \
    bash -lc "
        ROOTFOLDER='$ROOTFOLDER'

        # --- Environment setup ---
        source \"\$ROOTFOLDER/setup/setup-ND_CAFMaker-env.sh\"

        # --- Run under gdbserver ---
        cd \"\$ROOTFOLDER\"
        exec gdbserver :2000 \"\$NDCAFMAKER_INSTALL_DIR/bin/makeCAF\" \"\$FCL_FILE\"
    "
