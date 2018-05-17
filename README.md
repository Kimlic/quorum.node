# Steps to run Quorum nodes:
1. Download files from repository.

**Attention! If you want only run test project with docker files you may skip steps 2 and 3 below. Test project is in "kimlic" folder.**

2. Install docker ce and docker-compose. Instructions you may find on official site docker.com
   
```
   Hint: If you face error "Unable to locate package `docker-ce`" after docker installation you may find solution here:
   https://unix.stackexchange.com/questions/363048/unable-to-locate-package-docker-ce-on-a-64bit-ubuntu?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
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
"Is this the only block maker ? [y/N]:" - y.
"Is this a Voter Node? [y/N]:" - you need at least one voter.
```
```
Hint: looks like to create transaction on node it must be block maker or there is must be only one block creater node, but for now im not sure.
```
4. Open docker project directory and type "sudo docker-compose up". You should see nodes starting up.
You may check nodes by sending request to rpc api. Open another terminal and run:
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' localhost:22001
*use your port which you provided to installation script. In default case it will be 2200{index of node}. In my case 22000-22002.


![Alt text](/../master/img/kimlic_default_test_env_setup.png "Example")

# Setup truffle(required for quick deploying contract and work with web3 js):
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
We can use truffle to send some ether to our account, follow steps below:

```
truffle cosole --network KIM3
```
You may use any network if they correctly configurated.
When console opened:
```
web3.personal.listAccounts
```
In our case we had  [ '0x639384d4c163fe8b00396a99190079732e072a25' ] account in response
```
web3.eth.sendTransaction({from:"0x639384d4c163fe8b00396a99190079732e072a25", to:"0x18d149f6a2a6ba0dec4ad38af21e984a7e978bd7", value:"0x1"});
```
Just in few seconds we will have 1 wei on our account. Then we may send transactions from our account using jsonrpc api.


# Private transactions:
privateFor must be public key of another node. You may found public key at [docker files location]/[node name]/keys/[node name].pub
In case of invalid value for this param request will return "Non-200 status code..."). For nodes which are not indicated in "privateFor" any getter return 0x even for contract creator.


**Readme from script repository**
https://github.com/synechron-finlabs/quorum-maker/blob/master/README.md
