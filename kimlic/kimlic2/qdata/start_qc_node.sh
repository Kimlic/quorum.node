#!/bin/bash
set -u
set -e

CORE_NODE_IP="$(dig +short $CORE_NODE_IP)"
CORE_BOOTNODE_IP="$(dig +short $CORE_BOOTNODE)"
NETID=87234
sleep 10
CORE_MASTERNODE_IP="$(dig +short $CORE_MASTERNODE_IP)"

BOOTNODE_ENODE=enode://6433e8fb82c4638a8a6d499d40eb7d8158883219600bfd49acb968e3a37ccced04c964fa87b3a78a2da1b71dc1b90275f4d055720bb67fad4a118a56925125dc@[$CORE_BOOTNODE_IP]:33445

GLOBAL_ARGS="--verbosity 6 --bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

cp qdata/kimlic2.conf .

PATTERN="s/CORE_NODE_IP/${CORE_NODE_IP}/g"
PATTERN2="s/CORE_MASTERNODE_IP/${CORE_MASTERNODE_IP}/g"

sed -i "$PATTERN" kimlic2.conf
sed -i "$PATTERN2" kimlic2.conf

echo "[*] Starting Constellation on kimlic2"
constellation-node kimlic2.conf 2> qdata/logs/constellation_kimlic2.log &
sleep 1
echo "[*] Started Constellation on kimlic2"

echo "[*] Starting Quorum on kimlic2"
PRIVATE_CONFIG=kimlic2.conf geth --datadir qdata $GLOBAL_ARGS --rpcport 22000 --port 21000 --blockmakeraccount "0x1245d58e25fb5b1703055f53310ec1ba1743e10b" --blockmakerpassword ""  --voteaccount "0x06d2ad006cca9acdd9d7bca8fd6b4e5a76806026" --votepassword "" --minblocktime 2 --maxblocktime 5 2>qdata/logs/kimlic2.log &
echo "[*] Started Quorum on kimlic2"

while true 
do 
 sleep 5
done

