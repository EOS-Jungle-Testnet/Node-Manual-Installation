# Welcome to the AntelopeIO/Spring Jungle4.0 Testnet [manual node installation]  

Chain ID: 73e4385a2708e6d7048834fbc1079f2fabb17b3c125b146af438971e90716c4d  
Based on tag: v1.2.2  

Please join out Jungle testnet <a target="_blank" href="https://t.me/jungletestnet">Telegram channel</a>  
Network Monitor: https://monitor4.jungletestnet.io/  


! The auto installer script (https://github.com/EOS-Jungle-Testnet/Node-Auto-installation) is outdated: it installs EOSIO v2.0.13, which can't run Jungle4 anymore. Please use this manual installation.  


To start a Jungle 4 node you need install AntelopeIO Spring software. You can compile from sources or install from precompiled binaries:  

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
https://github.com/AntelopeIO/spring/releases/download/v1.2.2/antelope-spring_1.2.2_amd64.deb   
For example, you need to download deb antelope-spring_1.2.2_amd64.deb              
To install it you can use apt:  

```
apt install ./antelope-spring_1.2.2_amd64.deb   
```
It will download all dependencies and install nodeos, cleos, keosd and spring-util to /usr/bin  
B. Copy binaries to keep old versions and make sym link to latest:  

```
 mkdir /opt/bin  
 mkdir /opt/bin/v1.2.2  
 cp /usr/bin/nodeos /opt/bin/v1.2.2/  
 cp /usr/bin/cleos /opt/bin/v1.2.2/  
 cp /usr/bin/keosd /opt/bin/v1.2.2/  
 cp /usr/bin/spring-util /opt/bin/v1.2.2/  
 ln -sfn /opt/bin/v1.2.2 /opt/bin/bin  
```

So /opt/bin/bin will be point to latest binaries  

---------------------------------------------------------  
# 2. Update Spring software to new version  
 * [Instruction](https://github.com/AntelopeIO/spring?tab=readme-ov-file#pinned-build)


# 2.1 Update binaries  
To upgrade precompiled installation pleasse folow the same steps as in 1.2 (Installation from precompiled)  

------------------------------------------------------------------  

# 3. Install Jungle4.0 Testnet node [manual]  

```
    mkdir /opt/Jungle4Testnet
    cd /opt/Jungle4Testnet
    git clone https://github.com/EOS-Jungle-Testnet/Node-Manual-Installation.git ./

```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

- Choose your producer name (12 symbols length only,  a-z 1-5 alowed only) and create own EOS key pair  
  you can create key pair using cleos command  
  `./cleos.sh create key --to-console`  


- If non BP node: use the same config, just comment out rows with producer-name and both signature-provider rows  
  
- Edit config.ini:  
  - server address: p2p-server-address = ENRT_YOUR_NODE_EXTERNAL_IP_ADDRESS:9876  

  - if BP: your producer name: producer-name = YOUR_BP_NAME  
  - if BP: add producer keypair for signing blocks (this pub key should be used in regproducer action):  
  signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE  
  - if BP: add your finalizer (BLS) keypair, see [3.1 Register finalizer key](#31-bp-register-finalizer-key-savanna):  
  signature-provider = YOUR_PUB_BLS_KEY_HERE=KEY:YOUR_PRIV_BLS_KEY_HERE  
  - replace p2p-peer-address list with fresh generated on monitor site: http://monitor4.jungletestnet.io/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM:  
    chain-state-db-size-mb = 16384  
  
- Open TCP port 9876 (p2p) for inbound traffic on your firewall/router. Open 8888 (HTTP API) only if you run a public API node, keep it closed on a BP node.  


- Start wallet, run  
```
cd /opt/Jungle4Testnet
./Wallet/start_wallet.sh  
```

**First run should be from a snapshot**, see [4. Start from Snapshot](#4-startrestore-from-snapshot).  
Syncing from genesis (`./start.sh --delete-all-blocks --genesis-json genesis.json`) replays the whole chain history and takes a very long time.  
Check logs stderr.txt if node is running ok. 


- Create your wallet file  
```
./cleos.sh wallet create --file pass.txt
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

# 3.1 BP: Register finalizer key (Savanna)  
Jungle4 runs Savanna consensus. A BP without an active finalizer key is **skipped** when the producer schedule is built, even if it has enough votes to be in top 21.  

A. Create a BLS key pair (keep the private key secret):  
```
/opt/bin/bin/spring-util bls create key --to-console
```
It prints `Private key: PVT_BLS_...`, `Public key: PUB_BLS_...` and `Proof of Possession: SIG_BLS_...`  

B. Add the BLS key to config.ini and restart the node:  
```
signature-provider = PUB_BLS_...=KEY:PVT_BLS_...
```
Without it your node produces blocks but does not vote on finality.  

C. Register the key on chain (edit and run `scripts/bp08_regFinalizerKey.sh`). The first registered key is activated automatically:  
```
./cleos.sh push action eosio regfinkey '["YOUR_BP_NAME","PUB_BLS_...","SIG_BLS_..."]' -p YOUR_BP_NAME
```

D. Check that the key is active:  
```
./cleos.sh get table eosio eosio finalizers -L YOUR_BP_NAME -U YOUR_BP_NAME
```

==============================================================================================  

# 4. Start/Restore from Snapshot
   Download the latest snapshot (provided by EOS Nation) to snapshots folder in your **NODE** directory and unpack it (`apt install zstd` if needed):  
   ```
   mkdir -p /opt/Jungle4Testnet/snapshots
   cd /opt/Jungle4Testnet/snapshots/
   wget -O latest-snapshot.bin.zst https://snapshots.eosnation.io/jungle4-v8/latest
   zstd -d latest-snapshot.bin.zst -o latest-snapshot.bin
   ```
   Start `start.sh` script with options `--delete-all-blocks` (removes old blocks and state, a snapshot can only be loaded into an empty state) and `--snapshot` with snapshot file path  
   ```
   cd /opt/Jungle4Testnet
   ./start.sh --delete-all-blocks --snapshot /opt/Jungle4Testnet/snapshots/latest-snapshot.bin
   ```
   Next restarts are just `./start.sh`  
 ---

# 5. Usefull Information  
  
# Jungle 4.0 Faucet - get free EOS Jungle tokens:  
  https://monitor4.jungletestnet.io/#faucet  

# Other Tools/Examples  
- In scripts folder you can find scripts examples: how to register bp, register finalizer key, stake, vote, claimrewards, etc  
- Vote using monitor (prepare Cleos command)  

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
List your last actions (Hyperion history API)  
```
curl "https://jungle4.cryptolions.io/v2/history/get_actions?account=<account name>&limit=10"
```
  
List staked/delegated  
```
./cleos.sh system listbw <account>   
```
 
# Jungle4 History nodes
**Hyperion History**    
https://jungle4.cryptolions.io/v2/docs/  
 

**Block Explorers**  
https://jungle4.cryptolions.io/v2/explore

--------------  

# Snapshots
  * [EOS Nation Jungle4 snapshots](https://snapshots.eosnation.io/) (latest: https://snapshots.eosnation.io/jungle4-v8/latest)

--------------

by: <a target="_blank" href="http://CryptoLions.io">CryptoLions.io</a>  

Keybase account: cryptolions  
  
