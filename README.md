# Welcome to the AntelopeIO/leap Jungle4.0 Testnet [manual node installation]  

Chain ID: 73e4385a2708e6d7048834fbc1079f2fabb17b3c125b146af438971e90716c4d  
Based on tag: v1.2.1  

Please join out Jungle testnet <a target="_blank" href="https://t.me/jungletestnet">Telegram channel</a>  
Network Monitor: https://monitor4.jungletestnet.io/  


! This repo is for manual installation. Please use our auto installer script for auto installation:  
https://github.com/EOS-Jungle-Testnet/Node-Auto-installation  


To start a Jungle 4 node you need install EOSIO software. You can compile from sources or install from precompiled binaries:  

# 1. Installing Spring  
---------------------------------------------------  
### Currently support the following operating systems:
 * Ubuntu 22.04 Jammy  
 * Ubuntu 20.04 Focal
# 1.1 Spring - Installing from sources   

A. Create folder, download sources, compile and install:  

## Complete instruction  
 * [Instruction](https://github.com/AntelopeIO/spring?tab=readme-ov-file#pinned-build)

If you use pinned-build you can got to next step 1.2  


# 1.2 Spring - installing from precompiled binaries  

A. Download the latest version of Spring for your OS from:  
https://github.com/AntelopeIO/spring/releases/download/v1.2.1/antelope-spring_1.2.1_amd64.deb   
For example, you need to download deb antelope-spring_1.2.1_amd64.deb              
To install it you can use apt:  

```
apt install ./antelope-spring_1.2.1_amd64.deb   
```
It will download all dependencies and install SpringO to /usr/opt/eosio/v2.0.13  
B. Copy binaries to keep old versions and make sym link to latest:  

```
 mkdir /opt/bin  
 mkdir /opt/bin/v1.2.1  
 cp /usr/bin/nodeos /opt/bin/v1.2.1/  
 cp /usr//bin/cleos /opt/bin/v1.2.1/  
 cp /usr/bin/keosd /opt/bin/v1.2.1/  
 ln -sf /opt/bin/v1.2.1 /opt/bin/bin  
```

So /opt/bin/bin will be point to latest binaries  

---------------------------------------------------------  
# 2. Update Spring software to new version  
 * [Instruction](https://github.com/AntelopeIO/spring?tab=readme-ov-file#pinned-build)


# 2.3 Update binaries  
To upgrade precompiled installation pleasse folow the same steps as in 1.2 (Installation from precompiled)  

------------------------------------------------------------------  

# 3. Install Jungle4.0 Testnet node [manual]  
    Check our auto installer script: https://github.com/EOS-Jungle-Testnet/Node-Auto-installation  

```
    mkdir /opt/Jungle4Testnet
    cd /opt/Jungle4Testnet
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
  - replace p2p-peer-address list with fresh generated on monitor site: http://monitor4.jungletestnet.io/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM:  
    chain-state-db-size-mb = 16384  
  
- Open TCP Ports (8888, 9876) for inbound traffic on your firewall/router  


- Start wallet, run  
```
cd /opt/Jungle4Testnet
./Wallet/start_wallet.sh  
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok. 


- Create your wallet file  
```
./cleos.sh wallet create --file pass.tx
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



- Check if you can access you node using link http://you_server:8888/v1/chain/get_info (<a href="http://jungle4.cryptolions.io/v1/chain/get_info" target="_blank">Example</a>)  


- If you would like to run a BP node you need register your node at Jungle4.0 Testnet monitor  
    http://monitor4.jungletestnet.io/#register  
    * In registartion form - PIN is your password to node information updates  
    After registration is complete - personal intallation script will be created for you. Skip this step in case of manual installation.  

==============================================================================================  

# 4.1 Restore/Start from Backup
   Download latest block and state archive for your OS from https://backup.cryptolions.io/Jungle/
   
   ```
   wget  https://backup.cryptolions.io/Jungle/full_backup/blocks-xxx.tar.gz  
   wget https://backup.cryptolions.io/Jungle/full_backup/snapshot-xxx.bin
   ```
   After downloaded extract their
   ```
   tar xzvf blocks-latest.tar.gz -C .
   tar xzvf state-latest.tar.gz -C .
   ```
   You got two folders block and state.  
   Ater that go to **NODE** folder, and remove files from folder blocks and state
   ```
   cd /opt/Jungle4Testnet
   rm blocks/*
   rm state/*
   ```
   After that go where you extracted archive and move file from folder 
   ```
   mv ~/blocks/* /opt/Jungle4Testnet/blocks/
   mv ~/state/* /opt/Jungle4Testnet/state/
   ```
   After files moved start your NODE
   ```
   ./start.sh
   ```
# 4.2 Restore/Start from Snapshots
   Download latest snapshot from http://backup.cryptolions.io/Jungle/snapshots/ to snapshots folder in your **NODE** directory
   ```
   cd /opt/Jungle4Testnet/snapshots/
   wget https://backup.cryptolions.io/Jungle/snapshots/latest-snapshot.bin
   ```
   after it downloaded run `start.sh` script with option `--snapshot` and snapshot file path
   ```
   cd /opt/Jungle4Testnet
   ./start.sh --snapshot /opt/Jungle4Testnet/snapshots/latest-snapshot.bin
   ```
 ---

# 5. Usefull Information  
  
# Jungle 4.0 Faucet - get free EOS Jungle tokens:  
  https://monitor4.jungletestnet.io/#faucet  

# Other Tools/Examples  
- In scripts folder you can find scripts examples: how to register bp, stake, vote, claimrewards, etc  
- Vote using monitor (prepare Cleos command or use scatter)  

- Create account:  
  https://monitor4.jungletestnet.io/#account  


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
 
# Jungle4 History nodes
**Hyperion History**    
https://jungle4.cryptolions.io/v2/docs/  
 

**State History endpoint**  

**Block Explorers**  
https://jungle4.cryptolions.io/v2/explore

--------------  

# Backups
### Full(blocks and states):
  * [Full backup](hhttps://backup.cryptolions.io/Jungle/full_backup/)  
### Snapshot:
  * [Snapshots](http://backup.cryptolions.io/Jungle/snapshots/)

--------------

by: <a target="_blank" href="http://CryptoLions.io">CryptoLions.io</a>  

Keybase account: cryptolions  
  
    
