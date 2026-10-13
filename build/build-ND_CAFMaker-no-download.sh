#!/usr/bin/env bash
# Thin wrapper around build-ND_CAFMaker.sh --no-download.
# Builds ND_CAFMaker from the existing local source tree without re-cloning from GitHub.

ROOTFOLDER=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd)
exec bash "$ROOTFOLDER/build/build-ND_CAFMaker.sh" --no-download "$@"
