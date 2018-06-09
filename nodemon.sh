#!/bin/bash
# Eswede nodemon 1.1 - RESPAWN Masternode Monitoring
#If you find this script helpful
# ...please donate to the devfound: RPWN  **oMoN1fqkp7Rz9QfRDPAsjsfKM2uNskq76V**
# or BTC to **1HA19fBDYPPCFuaLemWbNFnDRGXpfNG2Ui**

#...please donate RPWN to the devfound: oMoN1fqkp7Rz9QfRDPAsjsfKM2uNskq76V

#--ESWEDE

#Processing command line params
if [ -z $1 ]; then dly=1; else dly=$1; fi   # Default refresh time is 1 sec

datadir="/home/$USER/.RPWNcore$2"   # Default datadir is /root/.RPWNcore
 
# Install jq if it's not present
dpkg -s jq 2>/dev/null >/dev/null || sudo apt-get -y install jq

#It is a one-liner script for now
watch -ptn $dly "echo '===========================================================================
Outbound connections to other RESPAWN nodes [RPWN datadir: $datadir]
===========================================================================
Node IP               Ping    Rx/Tx     Since  Hdrs   Height  Time   Ban
Address               (ms)   (KBytes)   Block  Syncd  Blocks  (min)  Score
==========================================================================='
RPWN-cli -datadir=$datadir getpeerinfo | jq -r '.[] | select(.inbound==false) | \"\(.addr),\(.pingtime*1000|floor) ,\
\(.bytesrecv/1024|floor)/\(.bytessent/1024|floor),\(.startingheight) ,\(.synced_headers) ,\(.synced_blocks)  ,\
\((now-.conntime)/60|floor) ,\(.banscore)\"' | column -t -s ',' && 
echo '==========================================================================='
uptime
echo '==========================================================================='
echo 'Masternode Status: \n# RESPAWN masternode status' && RPWN-cli -datadir=$datadir masternode status
echo '==========================================================================='
echo 'Sync Status: \n# RESPAWN mnsync status' &&  RPWN-cli -datadir=$datadir mnsync status
echo '==========================================================================='
echo 'Masternode Information: \n# RESPAWN getinfo' && RPWN-cli -datadir=$datadir getinfo
echo '==========================================================================='
echo 'Usage: nodemon.sh [refresh delay] [datadir index]'
echo 'Example: nodemon.sh 10 22 will run every 10 seconds and query RPWNd in /$USER/.RPWNcore22'
echo '\n\nPress Ctrl-C to Exit...'"
