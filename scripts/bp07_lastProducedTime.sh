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


PRODUCER="lioninjungle"
DEPTH=600   # blocks to look back, ~2 schedule rounds (21 producers x 12 blocks)

LIB="$(./cleos.sh get info | grep '"last_irreversible_block_num"' | grep -o '[0-9]*')"

for ((n = LIB; n > LIB - DEPTH; n--)); do
    BLOCK="$(./cleos.sh get block $n)"
    if echo "$BLOCK" | grep -q "\"producer\": \"$PRODUCER\""; then
        echo "$PRODUCER last produced block $n at $(echo "$BLOCK" | grep -m1 '"timestamp"' | cut -d'"' -f4) UTC"
        exit 0
    fi
done

echo "$PRODUCER did not produce any of the last $DEPTH blocks"
