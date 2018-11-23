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

FROM="acryptolions"
TO="acryptolions"

NET="40.0000 EOS"
CPU="40.0000 EOS"


./cleos.sh system delegatebw $FROM $TO "$NET" "$CPU" -p $FROM
