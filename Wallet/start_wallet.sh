#!/bin/bash

################################################################################
# Jungle2.0 Scripts
#
# Scrip Created by http://CryptoLions.io
#
# https://github.com/EOS-Jungle-Testnet/Node-Installation
# https://github.com/CryptoLions
#
###############################################################################

NODEOSBINDIR="/opt/bin"
DATADIR="/opt/Jungle2Testnet/Wallet"
WALLET_HOST="127.0.0.1"
WALLET_POSRT="3000"


$DATADIR/stop_wallet.sh
$NODEOSBINDIR/keosd --config-dir $DATADIR --wallet-dir $DATADIR --http-server-address $WALLET_HOST:$WALLET_POSRT $@ & echo $! > $DATADIR/wallet.pid
