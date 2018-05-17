# Steps to run Quorum nodes:
1. Download files from repository.

**Attention! If you want only run test project with docker files you may skip 2nd and 3td positions. Test project is in "kimlic" folder.**

2. Install docker ce and docker-compose. Instructions you may find on official site docker.com
   
```
   Hint:
   In my case after doing steps from instructions on docker.com i have error "Unable to locate package `docker-ce`"
   Solution - use instructions from best anwer here:
   https://unix.stackexchange.com/questions/363048/unable-to-locate-package-docker-ce-on-a-64bit-ubuntu?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
   They looks like the same but after using them docker realy installing.
```
3. Open script location in terminal and run script ('sudo ./setup.sh').

```
Setup:
"Would you like to use this with docker-compose support?" - yes.
"Please enter a project name:" - enter your name.
"Please enter the start port number [Default:22000]:" - you may set your own start port but default is ok.
"Please enter node name:" - node name.
"Lock key pair kim1 with password [none]:" and "Lock key pair kim1a with password [none]:" - default is ok.
"Is this a Block Maker Node?" - you need at least one block maker. 
*Hint: looks like to create transaction on node it must be block maker or there is must be only one block creater node, but for now im not sure.
"Is this the only block maker ? [y/N]:" - on your decision.
"Is this a Voter Node? [y/N]:" - you need at least one voter.

4. Open docker project directory and type "sudo docker-compose up". It must start nodes.
You may check nodes by sending request to rpc api. Open another terminal and write this command:
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' localhost:22001
*use your port which you provided to installation script. In default case it will be 22000 + index of node. In my case 22000-22002.
```

![Alt text](/../master/img/kimlic_default_test_env_setup.png "Example")

# Setup truffle(we need it for quick deploying contract and work with js web3):
To install truffle you may use this instruction http://www.techtonet.com/how-to-install-and-execute-truffle-on-an-ubuntu-16-04/
Replace text in file truffle.js in generated truffle project folder:

```js
module.exports = {
  networks: {
    KIM1: {
      host: "127.0.0.1",
      port: 22000,
      network_id: "*",
      gasPrice: 0,
      gas: 4612388
    },
    KIM2: {
      host: "127.0.0.1",
      port: 22001,
      network_id: "*",
      gasPrice: 0,
      gas: 4612388
    },
    KIM3: {
      host: "127.0.0.1",
      port: 22002,
      network_id: "*",
      gasPrice: 0,
      gas: 4612388
    }
  }
}

```

# Work with Quorum:
- for now Quorum have 0 price of gas and transaction cost is 0 but account need at least 1 wei to send transaction.
We can use truffle to send some ether to our account. For this write this commands:

```
truffle cosole --network KIM3
```
You may use any network if they correctly configurated.
When console opened:
```
web3.personal.listAccounts
```
For example i have response [ '0x639384d4c163fe8b00396a99190079732e072a25' ]
```
web3.eth.sendTransaction({from:"0x639384d4c163fe8b00396a99190079732e072a25", to:"0x18d149f6a2a6ba0dec4ad38af21e984a7e978bd7", value:"0x1"});
```
ok in few seconds we will have 1 wei in our account. Then we may send transactions from our account by jsonrpc api.


# Private transactions:
privateFor must be public key of another node(if incorrect request will return "Non-200 status code..."). For other node any getter return 0x even for creator account.
You may found public key at [docker files location]/[node name]/keys/[node name].pub


**Readme from script repository**
https://github.com/synechron-finlabs/quorum-maker/blob/master/README.md
