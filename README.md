# Fabric Quickstart
A Quickstart Docker container for Hyperledger Fabric v1 (16.04LTS-xenial + Docker + fabric samples &amp; scripts).

This Dockerfile creates Ubuntu64 16.04LTS (xenial) docker container pre-bundled with Docker within, and other dependent packages required to run Hyperledger Fabric v1 release (curr: 1.0.5).  Also, the samples (official samples and also [marbles](https://github.com/IBM-Blockchain/marbles#use-marbles)) are pre-installed, with utility scripts for ease of trying things out.  See the Dockerfile for details.

Note:  Actually, using Ubuntu as base OS is not required to run Hyperledger Fabric.  Hyperledger Fabric can run directly on docker baseos.  If you're uninterested in Ubuntu, simply follow steps in the official page =).  The reason we prepared and are using Ubuntu here are only because we defined our project reference environment to base on Ubuntu.

# Usage
## Retrieve pre-built docker image from Dockerhub
There is a pre-built image on dockerhub.

`docker pull hi5san/fabric-quickstart`

Or, you could build locally.
## Building Docker images locally
* Clone Dockerfile.  
`git clone git@github.ibm.com:fabric-book/fabric-quickstart.git`
* Build docker images and tag it as "fabric-quickstart".  
`docker build fabric-quickstart -t fabric-quickstart`

Note: The pulls/builds of images will take several minutes and approx. 1GB in storage.

## Run docker container and install Fabric network
* Run container

If pulled from remote:  

`docker run --name fabric-book --privileged -it -p 3001:3001 hi5san/fabric-quickstart` 

or if built locally:

`docker run --name fabric-book --privileged -it -p 3001:3001 fabric-quickstart`  

Note, the port mappings (3001) are for the marbles sample demo.

Once the container is started:  
* Install Fabric docker images  
`./installFabric.sh`

Example run:  
```
user@3b81d88e8ac8:~$ ./installFabric.sh 
===> Downloading platform binaries
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 22.6M  100 22.6M    0     0  1943k      0  0:00:11  0:00:11 --:--:-- 1813k
===> Pulling fabric Images
==> FABRIC IMAGE: peer

x86_64-1.0.4: Pulling from hyperledger/fabric-peer
d5c6f90da05d: Downloading [==============================>                    ]  28.51MB/47.26MB
1300883d87d5: Download complete 
c220aa3cfc1b: Download complete 
2e9398f099dc: Download complete 
dc27a084064f: Download complete 
87675a6d4030: Download complete 
93e601aafda8: Download complete 
278385815258: Download complete 
78f3c6b30e0c: Downloading
...
===> List out hyperledger docker images
hyperledger/fabric-ca          latest              8e691b3509bf        4 weeks ago         238MB
hyperledger/fabric-ca          x86_64-1.0.4        8e691b3509bf        4 weeks ago         238MB
hyperledger/fabric-tools       latest              6051774928a6        4 weeks ago         1.33GB
hyperledger/fabric-tools       x86_64-1.0.4        6051774928a6        4 weeks ago         1.33GB
hyperledger/fabric-couchdb     latest              cf24b91dfeb1        4 weeks ago         1.5GB
hyperledger/fabric-couchdb     x86_64-1.0.4        cf24b91dfeb1        4 weeks ago         1.5GB
hyperledger/fabric-kafka       latest              7a9d6f3c4a7c        4 weeks ago         1.29GB
hyperledger/fabric-kafka       x86_64-1.0.4        7a9d6f3c4a7c        4 weeks ago         1.29GB
hyperledger/fabric-zookeeper   latest              53c4a0d95fd4        4 weeks ago         1.3GB
hyperledger/fabric-zookeeper   x86_64-1.0.4        53c4a0d95fd4        4 weeks ago         1.3GB
hyperledger/fabric-orderer     latest              b17741e7b036        4 weeks ago         151MB
hyperledger/fabric-orderer     x86_64-1.0.4        b17741e7b036        4 weeks ago         151MB
hyperledger/fabric-peer        latest              1ce935adc397        4 weeks ago         154MB
hyperledger/fabric-peer        x86_64-1.0.4        1ce935adc397        4 weeks ago         154MB
hyperledger/fabric-javaenv     latest              a517b70135c7        4 weeks ago         1.41GB
hyperledger/fabric-javaenv     x86_64-1.0.4        a517b70135c7        4 weeks ago         1.41GB
hyperledger/fabric-ccenv       latest              856061b1fed7        4 weeks ago         1.28GB
hyperledger/fabric-ccenv       x86_64-1.0.4        856061b1fed7        4 weeks ago         1.28GB
```

# Running the Fabric network and the samples 
* Run fabric network  
`./startFabricNet.sh`

```

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose.yml down
Removing network net_basic
WARNING: Network net_basic not found.

docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb
Creating network "net_basic" with the default driver
Creating orderer.example.com
Creating couchdb
Creating ca.example.com
Creating peer0.org1.example.com
...
# Join peer0.org1.example.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block
2017-12-04 03:45:05.848 UTC [msp] GetLocalMSP -> DEBU 001 Returning existing local MSP
2017-12-04 03:45:05.848 UTC [msp] GetDefaultSigningIdentity -> DEBU 002 Obtaining default signing identity
2017-12-04 03:45:05.850 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized
2017-12-04 03:45:05.851 UTC [msp/identity] Sign -> DEBU 004 Sign: plaintext: 0A86070A5C08011A0C08C18993D10510...3242E47F4E7F1A080A000A000A000A00 
2017-12-04 03:45:05.851 UTC [msp/identity] Sign -> DEBU 005 Sign: digest: 70F33AF4F13AD74AE1FD915007B77617AA2B26E2C0B116069AE92D1BB93EF399 
2017-12-04 03:45:05.929 UTC [channelCmd] executeJoin -> INFO 006 Peer joined the channel!
2017-12-04 03:45:05.929 UTC [main] main -> INFO 007 Exiting.....
```

* Run marbles  
The "tryMarbles.sh" will:   
1. run the chaincode install script   
2. run the chaincode instantiate script  
3. Run the Marbles demo app  

```
user@3b81d88e8ac8:~$ cat tryMarbles.sh 
#!/bin/sh
(cd fabric-samples/marbles/scripts; node install_chaincode.js; node instantiate_chaincode.js)
(cd fabric-samples/marbles; gulp marbles_local &)
```

Example run:  
```
user@3b81d88e8ac8:~$ ./tryMarbles.sh 
info: Loaded config file /home/user/fabric-samples/marbles/config/marbles_local.json
info: Loaded creds file /home/user/fabric-samples/marbles/config/blockchain_creds_local.json
---------------------------------------
info: Lets install some chaincode - marbles v4
...
info: Fetching EVERYTHING...
debug: [fcw] Querying Chaincode: read_everything()
debug: [fcw] Sending query req: chaincodeId=marbles, fcn=read_everything, args=[], txId=null
debug: [fcw] Peer Query Response - len: 30 type: object
debug: [fcw] Successful query transaction.
debug: Looking for marble owner: amy
debug: Did not find marble username: amy
info: We need to make marble owners

info: Detected that we have NOT launched successfully yet
debug: Open your browser to http://localhost:3001 and login as "admin" to initiate startup

```

* Connect to running marbles app (port:3001 on localhost)  
Open a browser of choice on host PC, and connect to port 3001.

http://localhost:3001/

The marbles app's initial page (create admin user) should be shown.

See [the marbles docs](https://github.com/IBM-Blockchain/marbles#use-marbles) for how to play with it.


* Shutdown the Fabric network  
`./stopFabricNet.sh`





