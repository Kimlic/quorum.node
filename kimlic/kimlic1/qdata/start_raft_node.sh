#!/bin/bash
set -u
set -e

CORE_NODE_IP="$(dig +short $CORE_NODE_IP)"
CORE_MASTERNODE_IP="$(dig +short $CORE_MASTERNODE_IP)"

GLOBAL_ARGS="--raft --nodiscover --rpc --rpcaddr 0.0.0.0 --verbosity 6 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

cp qdata/kimlic1.conf .

PATTERN="s/CORE_NODE_IP/${CORE_NODE_IP}/g"
PATTERN2="s/CORE_MASTERNODE_IP/${CORE_MASTERNODE_IP}/g"

sed -i "$PATTERN" kimlic1.conf
sed -i "$PATTERN2" kimlic1.conf

echo "[*] Starting Constellation on kimlic1"
constellation-node kimlic1.conf 2> qdata/logs/constellation_kimlic1.log &
sleep 1
echo "[*] Started Constellation on kimlic1"

echo "[*] Starting Quorum on kimlic1"
PRIVATE_CONFIG=kimlic1.conf geth --datadir qdata $GLOBAL_ARGS --rpcport 22000 --port 21000 2>qdata/logs/kimlic1.log &

echo "[*] Started Quorum on kimlic1"

while true 
do 
 sleep 5
done

