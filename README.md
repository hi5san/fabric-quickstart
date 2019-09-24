# Fabric Quickstart
A Quickstart Docker container for Hyperledger Fabric v1 (18.04LTS-bionic + Docker + fabric samples).

This Dockerfile creates Ubuntu64 18.04LTS (bionic) docker container pre-bundled with Docker within, and other dependent packages required to run Hyperledger Fabric v1.4 release (curr: 1.4.3).

Note:  Actually, using Ubuntu as base OS is not required to run Hyperledger Fabric.  Hyperledger Fabric can run directly on docker baseos.  If you're uninterested in Ubuntu, simply follow steps in the official page =).  The reason we prepared and are using Ubuntu here are only because we defined our project reference environment to base on Ubuntu.

# Usage
## Retrieve pre-built docker image from Dockerhub
There is a pre-built image on dockerhub.

`docker pull hi5san/fabric-quickstart:v1.4.3`

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

`docker run --name fabric-book --privileged -it -p 3001:3001 hi5san/fabric-quickstart:v1.4.3` 

or if built locally:

`docker run --name fabric-book --privileged -it -p 3001:3001 fabric-quickstart`  

Note, the port mappings (3001) are for the marbles sample demo.

Once the container is started:  
* Install Fabric docker images  
`./installFabric.sh`

Example run:  
```
user@3b81d88e8ac8:~$ ./installFabric.sh
Installing hyperledger/fabric-samples repo

===> Cloning hyperledger/fabric-samples repo and checkout v1.4.3
Cloning into 'fabric-samples'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 4071 (delta 0), reused 5 (delta 0), pack-reused 4066
Receiving objects: 100% (4071/4071), 1.43 MiB | 1.30 MiB/s, done.
Resolving deltas: 100% (2004/2004), done.
Note: checking out 'v1.4.3'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at f86ec95 [FAB-16390] Added filter for invalid transactions

Installing Hyperledger Fabric binaries

===> Downloading version 1.4.3 platform specific fabric binaries
===> Downloading:  https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/linux-amd64-1.4.3/hyperledger-fabric-linux-amd64-1.4.3.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 52.0M  100 52.0M    0     0  1217k      0  0:00:43  0:00:43 --:--:-- 2492k
==> Done.
===> Downloading version 1.4.3 platform specific fabric-ca-client binary
===> Downloading:  https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric-ca/hyperledger-fabric-ca/linux-amd64-1.4.3/hyperledger-fabric-ca-linux-amd64-1.4.3.tar.gz
...
===> List out hyperledger docker images
hyperledger/fabric-tools       1.4.3               18ed4db0cd57        4 weeks ago         1.55GB
hyperledger/fabric-tools       latest              18ed4db0cd57        4 weeks ago         1.55GB
hyperledger/fabric-ca          1.4.3               c18a0d3cc958        4 weeks ago         253MB
hyperledger/fabric-ca          latest              c18a0d3cc958        4 weeks ago         253MB
hyperledger/fabric-ccenv       1.4.3               3d31661a812a        4 weeks ago         1.45GB
hyperledger/fabric-ccenv       latest              3d31661a812a        4 weeks ago         1.45GB
hyperledger/fabric-orderer     1.4.3               b666a6ebbe09        4 weeks ago         173MB
hyperledger/fabric-orderer     latest              b666a6ebbe09        4 weeks ago         173MB
hyperledger/fabric-peer        1.4.3               fa87ccaed0ef        4 weeks ago         179MB
hyperledger/fabric-peer        latest              fa87ccaed0ef        4 weeks ago         179MB
hyperledger/fabric-javaenv     1.4.3               5ba5ba09db8f        7 weeks ago         1.76GB
hyperledger/fabric-javaenv     latest              5ba5ba09db8f        7 weeks ago         1.76GB
hyperledger/fabric-zookeeper   0.4.15              20c6045930c8        6 months ago        1.43GB
hyperledger/fabric-zookeeper   latest              20c6045930c8        6 months ago        1.43GB
hyperledger/fabric-kafka       0.4.15              b4ab82bbaf2f        6 months ago        1.44GB
hyperledger/fabric-kafka       latest              b4ab82bbaf2f        6 months ago        1.44GB
hyperledger/fabric-couchdb     0.4.15              8de128a55539        6 months ago        1.5GB
hyperledger/fabric-couchdb     latest              8de128a55539        6 months ago        1.5GB
```

# Running the Fabric network and the samples 
* Run fabric network  
```shell
$ cd fabric-samples/fabcar`
$ ./startFabric.sh
...
```

Example run
```
Submitting initLedger transaction to smart contract on mychannel
+ echo 'The transaction is sent to all of the peers so that chaincode is built before receiving the following requests'
The transaction is sent to all of the peers so that chaincode is built before receiving the following requests
+ docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"initLedger","Args":[]}' --waitForEvent --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer1.org1.example.com:8051 --peerAddresses peer0.org2.example.com:9051 --peerAddresses peer1.org2.example.com:10051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
 

2019-09-24 02:45:56.579 UTC [chaincodeCmd] ClientWait -> INFO 001 txid [1661bd92b862f108f430e025f567d5d9e802d7c571143c633cc61d3c3c0f51dd] committed with status (VALID) at peer1.org2.example.com:10051
2019-09-24 02:45:56.614 UTC [chaincodeCmd] ClientWait -> INFO 002 txid [1661bd92b862f108f430e025f567d5d9e802d7c571143c633cc61d3c3c0f51dd] committed with status (VALID) at peer1.org1.example.com:8051
2019-09-24 02:45:56.614 UTC [chaincodeCmd] ClientWait -> INFO 003 txid [1661bd92b862f108f430e025f567d5d9e802d7c571143c633cc61d3c3c0f51dd] committed with status (VALID) at peer0.org1.example.com:7051
2019-09-24 02:45:56.674 UTC [chaincodeCmd] ClientWait -> INFO 004 txid [1661bd92b862f108f430e025f567d5d9e802d7c571143c633cc61d3c3c0f51dd] committed with status (VALID) at peer0.org2.example.com:9051
2019-09-24 02:45:56.675 UTC [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 005 Chaincode invoke successful. result: status:200 
...
 set +x

Total setup execution time : 188 secs ...

Next, use the FabCar applications to interact with the deployed FabCar contract.
The FabCar applications are available in multiple programming languages.
Follow the instructions for the programming language of your choice:

JavaScript:

  Start by changing into the "javascript" directory:
    cd javascript

  Next, install all required packages:
    npm install

  Then run the following applications to enroll the admin user, and register a new user
  called user1 which will be used by the other applications to interact with the deployed
  FabCar contract:
    node enrollAdmin
    node registerUser

  You can run the invoke application as follows. By default, the invoke application will
  create a new car, but you can update the application to submit other transactions:
    node invoke

  You can run the query application as follows. By default, the query application will
  return all cars, but you can update the application to evaluate other transactions:
    node query

TypeScript:

  Start by changing into the "typescript" directory:
    cd typescript

  Next, install all required packages:
    npm install

  Next, compile the TypeScript code into JavaScript:
    npm run build

  Then run the following applications to enroll the admin user, and register a new user
  called user1 which will be used by the other applications to interact with the deployed
  FabCar contract:
    node dist/enrollAdmin
    node dist/registerUser

  You can run the invoke application as follows. By default, the invoke application will
  create a new car, but you can update the application to submit other transactions:
    node dist/invoke

  You can run the query application as follows. By default, the query application will
  return all cars, but you can update the application to evaluate other transactions:
    node dist/query

Java:

  Start by changing into the "java" directory:
    cd java

  Then, install dependencies and run the test using:
    mvn test

  The test will invoke the sample client app which perform the following:
    - Enroll admin and user1 and import them into the wallet (if they don't already exist there)
    - Submit a transaction to create a new car
    - Evaluate a transaction (query) to return details of this car
    - Submit a transaction to change the owner of this car
    - Evaluate a transaction (query) to return the updated details of this car
```

* Follow directions (using javascript chaincode)
```
$ cd javascript
$ npm install
...
$ node enrollAdmin.js
Wallet path: /home/user/fabric-samples/fabcar/javascript/wallet
Successfully enrolled admin user "admin" and imported it into the wallet
$ node registerUser.js
Wallet path: /home/user/fabric-samples/fabcar/javascript/wallet
Successfully registered and enrolled admin user "user1" and imported it into the wallet
$ node query.js
Wallet path: /home/user/fabric-samples/fabcar/javascript/wallet
Transaction has been evaluated, result is: [{"Key":"CAR0", "Record":{"colour":"blue","make":"Toyota","model":"Prius","owner":"Tomoko"}},{"Key":"CAR1", "Record":{"colour":"red","make":"Ford","model":"Mustang","owner":"Brad"}},{"Key":"CAR2", "Record":{"colour":"green","make":"Hyundai","model":"Tucson","owner":"Jin Soo"}},{"Key":"CAR3", "Record":{"colour":"yellow","make":"Volkswagen","model":"Passat","owner":"Max"}},{"Key":"CAR4", "Record":{"colour":"black","make":"Tesla","model":"S","owner":"Adriana"}},{"Key":"CAR5", "Record":{"colour":"purple","make":"Peugeot","model":"205","owner":"Michel"}},{"Key":"CAR6", "Record":{"colour":"white","make":"Chery","model":"S22L","owner":"Aarav"}},{"Key":"CAR7", "Record":{"colour":"violet","make":"Fiat","model":"Punto","owner":"Pari"}},{"Key":"CAR8", "Record":{"colour":"indigo","make":"Tata","model":"Nano","owner":"Valeria"}},{"Key":"CAR9", "Record":{"colour":"brown","make":"Holden","model":"Barina","owner":"Shotaro"}}]
```

* Shutdown the Fabric network  
```shell
$ cd ../../first-network
$ ./byfn.sh down
$ docker rmi $(docker images dev-* -q)
```
The last command is used to remove chaincode containers created in by the sample.

# Quiting
Exit out of the container, and from Docker Host, look for the container using `docker ps -a` and call `docker stop {container-Id}` and `docker rm {container-Id}`.  Then, remove your docker images if you want: `docker rmi IMAGE-ID`.


Finally, be sure to call `docker system prune` and `docker volume prune` to clean-up stale files.
