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

VOTER="acryptolions"
VOTEFOR="lioninjungle ohtigertiger"

./cleos.sh system voteproducer prods $VOTER $VOTEFOR -p $VOTER
