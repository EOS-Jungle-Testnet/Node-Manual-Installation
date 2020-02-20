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


NODEOSBINDIR="/opt/bin/bin"
DATADIR="/opt/Jungle3Testnet"

$DATADIR/stop.sh
echo -e "Starting Nodeos \n";

ulimit -n 65535
ulimit -s 64000


$NODEOSBINDIR/nodeos --data-dir $DATADIR --config-dir $DATADIR "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/nodeos.pid
