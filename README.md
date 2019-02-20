# Welcome to the EOS Jungle2.0 Testnet [manual node installation]  

Chain ID: e70aaab8997e1dfce58fbfac80cbbb8fecec7b99cf982a9444273cbc64c41473  
Based on tag: v1.6.2  

Please join out Jungle testnet <a target="_blank" href="https://t.me/jungletestnet">Telegram channel</a>  
Network Monitor: https://monitor.jungletestnet.io/  


! This repo is for manual installation. Please use our auto installer script for auto installation:  
https://github.com/EOS-Jungle-Testnet/Node-Auto-installation  


To start a Jungle 2 node you need install EOSIO software. You can compile from sources or install from precompiled binaries:  

# 1. Installing EOSIO  
---------------------------------------------------  

# 1.1 EOSIO - Installing from sources  

A. Create folder, download sources, compile and install:  

```
mkdir /opt/EOSIO  
cd /opt/EOSIO  

git clone https://github.com/eosio/eos --recursive    
cd eos  

git checkout v1.6.2  
git submodule update --init --recursive   

./eosio_build.sh -s EOS
./eosio_install.sh
```  

B. Copy binaries to keep old versions and make sym link to latest:  

```
mkdir /opt/bin
mkdir /opt/bin/v1.6.2
cp /opt/EOSIO/eos/build/programs/nodeos/nodeos /opt/bin/v1.6.2/
cp /opt/EOSIO/eos/build/programs/cleos/cleos /opt/bin/v1.6.2/
cp /opt/EOSIO/eos/build/programs/keosd/keosd /opt/bin/v1.6.2/
ln -sf /opt/bin/v1.6.2 /opt/bin/bin
```

So /opt/bin/bin will point to latest binaries  


# 1.2 EOSIO - installing from precompiled binaries  

A. Download the latest version of EOSIO for your OS from:  
https://github.com/EOSIO/eos/releases/tag/v1.6.2   
For example, for ubuntu 18.04 you need to download deb package eosio_1.5.0-1-ubuntu-18.04_amd64.deb  
To install it you can use apt:  
```
apt install ./eosio_1.5.0-1-ubuntu-18.04_amd64.deb
```
It will download all dependencies and install EOSIO to /usr/opt/eosio/1.6.2 
B. Copy binaries to keep old versions and make sym link to latest:  

```
 mkdir /opt/bin
 mkdir /opt/bin/v1.6.2
 cp /usr/opt/eosio/1.6.2/bin/nodeos /opt/bin/v1.6.2/
 cp /usr/opt/eosio/1.6.2/bin/cleos /opt/bin/v1.6.2/
 cp /usr/opt/eosio/1.6.2/bin/keosd /opt/bin/v1.6.2/
 ln -sf /usr/opt/eosio/1.6.2/bin /opt/bin/bin
```

So /opt/bin/bin will be point to latest binaries  

---------------------------------------------------------  
# 2. Update EOSIO software to new version  

# 2.1 Update sources  

```
cd /opt/EOSIO/eos
git checkout -f
git branch -f
git pull
git checkout v1.6.2   
git submodule update --init --recursive   


./eosio_build.sh -s EOS
./eosio_uninstall.sh
./eosio_install.sh

mkdir /opt/bin/v1.6.2
cp /opt/EOSIO/eos/build/programs/nodeos/nodeos /opt/bin/v1.6.2/
cp /opt/EOSIO/eos/build/programs/cleos/cleos /opt/bin/v1.6.2/
cp /opt/EOSIO/eos/build/programs/keosd/keosd /opt/bin/v1.6.2/
ln -sf /opt/bin/v1.6.2 /opt/bin/bin
```  


# 2.2 Update binaries  
To upgrade precompiled installation pleasse folow the same steps as in 1.2 (Installation from precompiled)  

------------------------------------------------------------------  

# 3. Install Jungle2.0 Testnet node [manual]  
    Check our auto installer script: https://github.com/EOS-Jungle-Testnet/Node-Auto-installation  

```
    mkdir /opt/Jungle2Testnet
    cd /opt/Jungle2Testnet
    git clone https://github.com/EOS-Jungle-Testnet/Node-Manual-Installation.git ./

```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

- Choose your producer name (12 symbols length only,  a-z 1-5 alowed only) and create own EOS key pair  
  you can create key pair using cleos command  
  `./cleos.sh create key`  
   or using Scatter or <a target="_blank" href="https://nadejde.github.io/eos-token-sale/">here</a>. 


- If non BP node: use the same config, just comment out rows with producer-name and signature-provider  
  
- Edit config.ini:  
  - server address: p2p-server-address = ENRT_YOUR_NODE_EXTERNAL_IP_ADDRESS:9876  

  - if BP: your producer name: producer-name = YOUR_BP_NAME  
  - if BP: add producer keypair for signing blocks (this pub key should be used in regproducer action):  
  signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE  
  - replace p2p-peer-address list with fresh generated on monitor site: http://monitor.jungletestnet.io/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM:  
    chain-state-db-size-mb = 16384  
  
- Open TCP Ports (8888, 9876) on your firewall/router  


- Start wallet, run  
```
cd /opt/Jungle2Testnet
./Wallet/start_wallet.sh  
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok. 


- Create your wallet file  
```
./cleos.sh wallet create --to-file pass.tx
```
Your password will be in pass.txt it will be used when unlock wallet  


- Unlock your wallet  
```
./cleos.sh wallet unlock  
```
enter the wallet password.  


- Import your key  
```
./cleos.sh wallet import
```
Enter your private key  



- Check if you can access you node using link http://you_server:8888/v1/chain/get_info (<a href="http://jungle2.cryptolions.io/v1/chain/get_info" target="_blank">Example</a>)  


- If you would like to run a BP node you need register your node at Jungle2.0 Testnet monitor  
    http://monitor.jungletestnet.io/#register  
    * In registartion form - PIN is your password to node information updates  
    After registration is complete - personal intallation script will be created for you. Skip this step in case of manual installation.  

==============================================================================================  
# 4. Usefull Information  
  
# Jungle 2.0 Faucet - get free EOS Jungle tokens:  
  http://monitor.jungletestnet.io/#faucet  

# Other Tools/Examples  
- In scripts folder you can find scripts examples: how to register bp, stake, vote, claimrewards, etc  
- Vote using monitor (prepare Cleos command or use scatter)  

- Create account:  
  http://monitor.jungletestnet.io/#account  


- Cleos commands:  

Send EOS
```
./cleos.sh transfer <your account> <receiver account> "1.0000 EOS" "test memo text"
```
Get Balance  
```
./cleos.sh get currency balance eosio.token <account name>
```
Create account  
```
./cleos.sh system newaccount --stake-net "10.0000 EOS" --stake-cpu "10.0000 EOS" --buy-ram-bytes 4096 <your accountr> <new account> <pkey1> <pkey2>
```  
List registered producers (-l <limit>)  
```
./cleos.sh get table eosio eosio producers -l 100  
```
List your last action (use -h to get help, do not work now, works with history node only)  
```
./cleos.sh get actions <account name>
```
  
List staked/delegated  
```
./cleos.sh system listbw <account>   
```
 
# Jungle2 History nodes
Full history node (filter-on = *):  History Nodes:  
http://junglehistory.cryptolions.io:18888  
https://junglehistory.cryptolions.io:443 
  
Mongo History:  
http://junglehistory.cryptolions.io  
https://junglehistory.cryptolions.io:4433  



by: <a target="_blank" href="http://CryptoLions.io">CryptoLions.io</a>  

Keybase account: cryptolions  
  
    
