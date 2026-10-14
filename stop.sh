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

DIR="$(cd "$(dirname "$0")" && pwd)"   # the folder this script is in

    if [ -f "$DIR/nodeos.pid" ]; then
	pid=`cat "$DIR/nodeos.pid"`
	echo $pid
	kill $pid
	

	echo -ne "Stopping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
	rm -r "$DIR/nodeos.pid"
	
	DATE=$(date -d "now" +'%Y_%m_%d-%H_%M')
        if [ ! -d "$DIR/logs" ]; then
            mkdir "$DIR/logs"
        fi
        tar -pcvzf "$DIR/logs/stderr-$DATE.txt.tar.gz" -C "$DIR" stderr.txt stdout.txt


        echo -ne "\rNodeos Stopped.    \n"
    fi

