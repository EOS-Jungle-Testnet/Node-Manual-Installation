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

ACCOUNT="acryptolions"
PUBKEY="EOS74wRrQt96rGaEEBNrqWNN4VBebuJGuZrECdBYqLqFCiRzvt3ja"
URL="http://cryptolions.io"

./cleos.sh system regproducer $ACCOUNT $PUBKEY "$URL" -p $ACCOUNT

