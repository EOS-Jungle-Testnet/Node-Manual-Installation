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

NODEOSBINDIR="/opt/bin/bin"
DATADIR="/opt/Jungle4Testnet/Wallet"
WALLET_HOST="127.0.0.1"
WALLET_POSRT="3000"


$DATADIR/stop_wallet.sh
$NODEOSBINDIR/keosd --config-dir $DATADIR --wallet-dir $DATADIR --unix-socket-path $DATADIR/keosd.sock --http-server-address $WALLET_HOST:$WALLET_POSRT $@ & echo $! > $DATADIR/wallet.pid
