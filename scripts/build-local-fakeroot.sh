#!/usr/bin/env bash
set -euo pipefail

# Build psrall Apptainer images without sudo.
# Requires Apptainer fakeroot support to be configured on the host.

APPTAINER_TMPDIR="${APPTAINER_TMPDIR:-$PWD/.apptainer-tmp}"
APPTAINER_CACHEDIR="${APPTAINER_CACHEDIR:-$PWD/.apptainer-cache}"
TMPDIR="${TMPDIR:-$APPTAINER_TMPDIR}"

mkdir -p "$APPTAINER_TMPDIR" "$APPTAINER_CACHEDIR"
chmod 1777 "$APPTAINER_TMPDIR" || true

run_build() {
    local out="$1"
    local def="$2"

    env \
      -u MAKEFLAGS \
      -u MFLAGS \
      -u MAKELEVEL \
      -u GNUMAKEFLAGS \
      -u MAKEOVERRIDES \
      HOME="$HOME" \
      PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin${PATH:+:$PATH}" \
      APPTAINER_TMPDIR="$APPTAINER_TMPDIR" \
      APPTAINER_CACHEDIR="$APPTAINER_CACHEDIR" \
      TMPDIR="$TMPDIR" \
      apptainer build --fakeroot --notest --force "$out" "$def"
}

run_build psrbase.sif singularity/psrbase.def
run_build psrchive.sif singularity/psrchive.def
run_build psrenterprise.sif singularity/psrenterprise.def
run_build psrnessai.sif singularity/psrnessai.def
run_build psroptuna.sif singularity/psroptuna.def
run_build psrtime.sif singularity/psrtime.def
