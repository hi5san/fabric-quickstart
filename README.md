# Fabric Quickstart
A Quickstart Docker container for Hyperledger Fabric v1 (18.04LTS-bionic + Docker + fabric samples).

This Dockerfile creates Ubuntu64 18.04LTS (bionic) docker container pre-bundled with Docker within, and other dependent packages required to run Hyperledger Fabric v1.2 release (curr: 1.2.0).

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

Installing hyperledger/fabric-samples repo

===> Cloning hyperledger/fabric-samples repo and checkout v1.2.0
Cloning into 'fabric-samples'...
remote: Enumerating objects: 1, done.
remote: Counting objects: 100% (1/1), done.
remote: Total 1863 (delta 0), reused 0 (delta 0), pack-reused 1862
Receiving objects: 100% (1863/1863), 642.42 KiB | 204.00 KiB/s, done.
Resolving deltas: 100% (910/910), done.
Note: checking out 'v1.2.0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at ed81d7b [FAB-10811] fabric-ca sample is broken on v1.2

Installing Hyperledger Fabric binaries

===> Downloading version 1.2.0 platform specific fabric binaries
===> Downloading:  https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/linux-amd64-1.2.0/hyperledger-fabric-linux-amd64-1.2.0.tar.gz

...
===> List out hyperledger docker images
hyperledger/fabric-ca          1.2.0               66cc132bd09c        3 months ago        252MB
hyperledger/fabric-ca          latest              66cc132bd09c        3 months ago        252MB
hyperledger/fabric-tools       1.2.0               379602873003        3 months ago        1.51GB
hyperledger/fabric-tools       latest              379602873003        3 months ago        1.51GB
hyperledger/fabric-ccenv       1.2.0               6acf31e2d9a4        3 months ago        1.43GB
hyperledger/fabric-ccenv       latest              6acf31e2d9a4        3 months ago        1.43GB
hyperledger/fabric-orderer     1.2.0               4baf7789a8ec        3 months ago        152MB
hyperledger/fabric-orderer     latest              4baf7789a8ec        3 months ago        152MB
hyperledger/fabric-peer        1.2.0               82c262e65984        3 months ago        159MB
hyperledger/fabric-peer        latest              82c262e65984        3 months ago        159MB
hyperledger/fabric-zookeeper   0.4.10              2b51158f3898        3 months ago        1.44GB
hyperledger/fabric-zookeeper   latest              2b51158f3898        3 months ago        1.44GB
hyperledger/fabric-kafka       0.4.10              936aef6db0e6        3 months ago        1.45GB
hyperledger/fabric-kafka       latest              936aef6db0e6        3 months ago        1.45GB
hyperledger/fabric-couchdb     0.4.10              3092eca241fc        3 months ago        1.61GB
hyperledger/fabric-couchdb     latest              3092eca241fc        3 months ago        1.61GB
```

# Running the Fabric network and the samples 
* Run fabric network  
```shell
$ cd fabric-samples/fabcar`
$ ./startFabric.sh
...
```

* Follow directions 
```
$ npm install
...
$ node enrollAdmin.js
 Store path:/home/user/fabric-samples/fabcar/hfc-key-store
(node:3698) DeprecationWarning: grpc.load: Use the @grpc/proto-loader module with grpc.loadPackageDefinition instead
Successfully enrolled admin user "admin"
...
$ node registerUser.js
 Store path:/home/user/fabric-samples/fabcar/hfc-key-store
(node:3711) DeprecationWarning: grpc.load: Use the @grpc/proto-loader module with grpc.loadPackageDefinition instead
Successfully loaded admin from persistence
Successfully registered user1 - secret:**********
Successfully enrolled member user "user1" 
User1 was successfully registered and enrolled and is ready to interact with the fabric network
$ node query.js
Store path:/home/user/fabric-samples/fabcar/hfc-key-store
(node:3724) DeprecationWarning: grpc.load: Use the @grpc/proto-loader module with grpc.loadPackageDefinition instead
Successfully loaded user1 from persistence
Query has completed, checking results
Response is  [{"Key":"CAR0", "Record":{"colour":"blue","make":"Toyota","model":"Prius","owner":"Tomoko"}},{"Key":"CAR1", "Record":{"colour":"red","make":"Ford","model":"Mustang","owner":"Brad"}},{"Key":"CAR2", "Record":{"colour":"green","make":"Hyundai","model":"Tucson","owner":"Jin Soo"}},{"Key":"CAR3", "Record":{"colour":"yellow","make":"Volkswagen","model":"Passat","owner":"Max"}},{"Key":"CAR4", "Record":{"colour":"black","make":"Tesla","model":"S","owner":"Adriana"}},{"Key":"CAR5", "Record":{"colour":"purple","make":"Peugeot","model":"205","owner":"Michel"}},{"Key":"CAR6", "Record":{"colour":"white","make":"Chery","model":"S22L","owner":"Aarav"}},{"Key":"CAR7", "Record":{"colour":"violet","make":"Fiat","model":"Punto","owner":"Pari"}},{"Key":"CAR8", "Record":{"colour":"indigo","make":"Tata","model":"Nano","owner":"Valeria"}},{"Key":"CAR9", "Record":{"colour":"brown","make":"Holden","model":"Barina","owner":"Shotaro"}}]
```

* Shutdown the Fabric network  
```shell
$ cd ../basic-network
$ ./teardown.sh
Killing cli                    ... done
Killing peer0.org1.example.com ... done
Killing ca.example.com         ... done
Killing couchdb                ... done
Killing orderer.example.com    ... done
Removing cli                    ... done
Removing peer0.org1.example.com ... done
Removing ca.example.com         ... done
Removing couchdb                ... done
Removing orderer.example.com    ... done
Removing network net_basic
85b8e6d05193
Untagged: dev-peer0.org1.example.com-fabcar-1.0-5c906e402ed29f20260ae42283216aa75549c571e2e380f3615826365d8269ba:latest
Deleted: sha256:585929b763a5e34977e9471dfe9b5aa58ee9d28e73727ee31dbe41c1645322f8
Deleted: sha256:55743a1d77cf618003979806c606c56cf7f96e754894082bb0207bd5f58606ca
Deleted: sha256:66c9bdcc86bbd74ff25bc6928d30930075c7a32d82588b9e043fde4e3526f9d1
Deleted: sha256:302ac00c5b351f41db14ab5750b9ce756c1e31b236f0548f72898cac5472935f
```

# Quiting
Look for the container using `docker ps -a` and call `docker rm {container-Id}`.

Remove your docker images if you want: `docker rmi IMAGE-ID`.

Finally, be sure to call `docker system prune` to clean-up stale files.
