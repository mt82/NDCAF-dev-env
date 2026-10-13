# ND_CAFMaker build & run scripts

Shell scripts to clone, build, and run [ND_CAFMaker](https://github.com/DUNE/ND_CAFMaker) with a locally-built [duneanaobj](https://github.com/DUNE/duneanaobj) on DUNE computing nodes (SL7 via Apptainer).

## Prerequisites

- Access to `/cvmfs` (DUNE and OSG paths)
- Apptainer available at the path set in `setup/setup-config.sh`
- For the debug workflow: the debug container image must be built first (see [Debug](#debug))

## Directory layout

```
run-all.sh                    # full pipeline: build duneanaobj + ND_CAFMaker, then run
run-ND_CAFMaker.sh            # run only (assumes both packages already built)

build/
  build-duneanaobj.sh         # clone, patch, and install duneanaobj into local UPS area
  build-ND_CAFMaker.sh        # clone and build ND_CAFMaker
  build-ND_CAFMaker-no-download.sh  # rebuild ND_CAFMaker from existing local source

setup/
  setup-config.sh             # shared configuration (repos, branches, paths, run options)
  setup-ND_CAFMaker-env.sh    # sourceable UPS environment setup for ND_CAFMaker

debug/
  build-debug-container.sh    # build the SL7+gdb Apptainer image from its .def
  start-debug-container.sh    # launch makeCAF under gdbserver (port 2000)
  fnal-dev-sl7-gdb/
    fnal-dev-sl7.def          # Apptainer definition (SL7 + gdb + gdb-gdbserver)
    fnal-dev-sl7-gdb.sif      # built image (produced by build-debug-container.sh)
```

## Configuration

All tuneable parameters are in **`setup/setup-config.sh`**. Edit this file before running any script.

| Variable | Description |
|---|---|
| `DUNEANAOBJ_REPO` / `DUNEANAOBJ_BRANCH` | duneanaobj git remote and branch |
| `DUNEANAOBJ_DIR` / `DUNEANAOBJ_BUILD_DIR` | source root and build directory for duneanaobj |
| `NDCAFMAKER_REPO` / `NDCAFMAKER_BRANCH` | ND_CAFMaker git remote and branch |
| `NDCAFMAKER_DIR` / `NDCAFMAKER_BUILD_DIR` / `NDCAFMAKER_INSTALL_DIR` | source, build, and install directories for ND_CAFMaker |
| `MY_UPS_DIR` | local UPS product area (duneanaobj is installed here) |
| `FCL_FILE` | FCL configuration file passed to `makeCAF` |
| `ANA_DIR` | output directory for CAF files |
| `NUMEVTS` | number of events to process (`-1` means all) |
| `CONTAINER_IMAGE` | Apptainer image used for building and running |
| `DEBUG_CONTAINER_IMAGE` | Apptainer image used for the debug workflow |
| `APPTAINER_BINDS` | comma-separated bind paths forwarded to the container |

## Quick start

### Full pipeline (first time)

```bash
bash run-all.sh
```

Runs three steps in sequence, each in its own container invocation:
1. clones, patches, and installs duneanaobj as `v99_99_99` into the local UPS area
2. clones and builds ND_CAFMaker
3. runs `makeCAF` with the FCL file configured in `setup/setup-config.sh`

### Rebuild ND_CAFMaker after local edits (no re-clone)

```bash
bash build/build-ND_CAFMaker-no-download.sh
# or equivalently:
bash build/build-ND_CAFMaker.sh --no-download
```

### Run only

```bash
bash run-ND_CAFMaker.sh
```

Requires both duneanaobj and ND_CAFMaker to have been built at least once.

## Debug

The debug workflow uses a custom Apptainer image (SL7 + gdb + gdbserver) and launches `makeCAF` under `gdbserver` on port 2000, ready for remote debugging from any IDE or gdb client.

### 1. Build the debug image (once)

```bash
bash debug/build-debug-container.sh
```

Requires `--fakeroot` support on the build host (or replace with `sudo apptainer build`).

### 2. Start gdbserver

```bash
bash debug/start-debug-container.sh
```

`makeCAF` will block waiting for a debugger to connect.

### 3. Connect from gdb or an IDE

```
target remote <host>:2000
```

## How the local duneanaobj works

The upstream `CMakeLists.txt` version string (e.g. `04.02.01`) is patched to `99.99.99` at build time so downstream tools can pin a stable, locally-built version (`DUNEANAOBJ_VER` in `setup-config.sh`) regardless of which upstream tag is checked out. The built package is registered in the local UPS area (`MY_UPS_DIR`) and swapped in for the system duneanaobj at runtime via `unsetup`/`setup`.
