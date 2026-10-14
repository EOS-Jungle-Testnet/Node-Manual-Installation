#!/bin/bash
################################################################################
# Jungle2.0 Scripts
#
# Scrip Created by CryptoLions.io
#
# https://github.com/EOS-Jungle-Testnet/Node-Installation
# https://github.com/CryptoLions
#
###############################################################################


DATADIR="$(cd "$(dirname "$0")" && pwd)"   # the folder this script is in
NODEOSBINDIR="$DATADIR/bin/bin"

case "$DATADIR" in *[[:space:]]*) echo "The node folder path has a space in it ($DATADIR); nodeos rejects such paths" >&2; exit 1 ;; esac
[ -f "$DATADIR/config.ini" ] || { echo "No config.ini in $DATADIR - run ./configure.sh first (README, section 3)" >&2; exit 1; }

"$DATADIR/stop.sh"
echo -e "Starting Nodeos \n";

ulimit -n 65535
ulimit -s 64000


"$NODEOSBINDIR/nodeos" --data-dir "$DATADIR" --config-dir "$DATADIR" "$@" > "$DATADIR/stdout.txt" 2> "$DATADIR/stderr.txt" &  echo $! > "$DATADIR/nodeos.pid"
