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

WALLET="http://127.0.0.1:3000"
NODE="http://127.0.0.1:8888"



$NODEOSBINDIR/cleos -u $NODE --wallet-url $WALLET "$@"
