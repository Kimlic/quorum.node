#!/bin/bash
set -u
set -e

CORE_NODE_IP="$(dig +short $CORE_NODE_IP)"
CORE_MASTERNODE_IP="$(dig +short $CORE_MASTERNODE_IP)"

GLOBAL_ARGS="--raft --nodiscover --rpc --rpcaddr 0.0.0.0 --verbosity 6 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

cp qdata/kimlic3.conf .

PATTERN="s/CORE_NODE_IP/${CORE_NODE_IP}/g"
PATTERN2="s/CORE_MASTERNODE_IP/${CORE_MASTERNODE_IP}/g"

sed -i "$PATTERN" kimlic3.conf
sed -i "$PATTERN2" kimlic3.conf

echo "[*] Starting Constellation on kimlic3"
constellation-node kimlic3.conf 2> qdata/logs/constellation_kimlic3.log &
sleep 1
echo "[*] Started Constellation on kimlic3"

echo "[*] Starting Quorum on kimlic3"
PRIVATE_CONFIG=kimlic3.conf geth --datadir qdata $GLOBAL_ARGS --rpcport 22000 --port 21000 2>qdata/logs/kimlic3.log &

echo "[*] Started Quorum on kimlic3"

while true 
do 
 sleep 5
done

