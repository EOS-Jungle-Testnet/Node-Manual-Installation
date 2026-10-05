#!/bin/bash
################################################################################
# Jungle4 Scripts
#
# Scrip Created by CryptoLions.io
#
# https://github.com/EOS-Jungle-Testnet/Node-Manual-Installation
# https://github.com/CryptoLions
#
###############################################################################

# Savanna: a BP without an active finalizer key is skipped in the producer schedule.
# Create BLS keys with: /opt/bin/bin/spring-util bls create key --to-console
# and add "signature-provider = PUB_BLS_...=KEY:PVT_BLS_..." to config.ini

ACCOUNT="acryptolions"
BLS_PUBKEY="PUB_BLS_..."
BLS_POP="SIG_BLS_..."   # "Proof of Possession" from spring-util output

./cleos.sh push action eosio regfinkey "[\"$ACCOUNT\",\"$BLS_PUBKEY\",\"$BLS_POP\"]" -p $ACCOUNT
