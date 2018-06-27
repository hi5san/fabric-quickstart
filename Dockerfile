FROM ubuntu:xenial

#add stuff
RUN apt-get update && \
    apt-get install -y sudo openssh-server vim screen jq && \
    echo 'shell /bin/bash' >> $HOME/.screenrc && \
    apt-get clean

#add user
RUN groupadd -g 1000 user && \
    useradd -g user -G sudo -m -s /bin/bash user && \
    echo 'user:user' | chpasswd && \
    echo 'Defaults visiblepw' >> /etc/sudoers && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#USER user
#WORKDIR /home/user

#add openjdk-8-jdk
#For 14.04
#RUN apt-get install -y software-properties-common
#RUN add-apt-repository ppa:openjdk-r/ppa
#RUN apt-get update -y
#RUN apt-get install -y openjdk-8-jdk

##HLF stuff
#Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https \
		       ca-certificates \
		       curl \
		       software-properties-common && \
    apt-get clean
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && \
    apt-get install -y docker-ce=17.09.0~ce-0~ubuntu && \
    apt-get clean && \
    curl -L "https://github.com/docker/compose/releases/download/1.12.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    usermod -aG docker user

#USER user:docker

USER user:docker
WORKDIR /home/user

#node v6
#RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo bash - && \
#node v8
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash - && \
    sudo apt-get update && \
    sudo apt-get install -y nodejs golang-1.9-go && \
    sudo apt-get clean && \
    mkdir $HOME/.config && \
    chown -R user:docker $HOME/.config && \
    echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc && \
    mkdir $HOME/go && \
    echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.bashrc
ENV PATH $PATH:/usr/lib/go-1.9/bin
#RUN sudo apt-get install -y go python

RUN echo '#!/bin/sh' > $HOME/installFabric.sh && \
#    echo 'curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0 1.1.0 0.4.6 -s' >> $HOME/installFabric.sh && \
    echo 'curl -sSL https://goo.gl/PKqygD | bash -s 1.1.0' >> $HOME/installFabric.sh && \
    chmod a+rx installFabric.sh
ENV PATH $PATH:/home/user/bin

RUN echo '#!/bin/sh' > $HOME/installSamples.sh && \
    echo 'echo Getting fabric samples..' >> $HOME/installSamples.sh && \
    echo 'git clone https://github.com/hyperledger/fabric-samples.git -b v1.1.0' >> $HOME/installSamples.sh && \
    echo 'cd fabric-samples; git clone https://github.com/IBM-Blockchain/marbles.git --single-branch --branch v5.0' >> $HOME/installSamples.sh && \
    echo 'cd marbles; sudo npm install gulp -g' >> $HOME/installSamples.sh && \
    echo 'sudo chown -R user:docker $HOME/.config' >> $HOME/installSamples.sh && \
    echo 'npm install' >> $HOME/installSamples.sh && \
    echo 'rm -fr $HOME/.hfc-key-store; mkdir -p $HOME/.hfc-key-store' >> $HOME/installSamples.sh && \
    chmod a+rx installSamples.sh && \
    ./installSamples.sh

RUN echo '#!/bin/sh' > $HOME/startFabricNet.sh && \
    echo '(cd fabric-samples/basic-network; ./start.sh)' >> $HOME/startFabricNet.sh && \
    chmod a+rx startFabricNet.sh

RUN echo '#!/bin/sh' > $HOME/stopFabricNet.sh && \
    echo '(cd fabric-samples/basic-network; ./stop.sh)' >> $HOME/stopFabricNet.sh && \
    echo 'docker rm $(docker ps -aq -f "name=dev-*") || true' >> $HOME/stopFabricNet.sh && \
    echo '(cd fabric-samples/basic-network; ./teardown.sh)' >> $HOME/stopFabricNet.sh && \
    chmod a+rx stopFabricNet.sh

RUN echo '#!/bin/sh' > $HOME/startDocker.sh && \
    echo 'sudo service docker start' >> $HOME/startDocker.sh && \
    chmod a+rx startDocker.sh

RUN echo '#!/bin/sh' > $HOME/tryMarbles.sh && \
    echo '(cd fabric-samples/marbles/scripts; node install_chaincode.js; node instantiate_chaincode.js)' >> $HOME/tryMarbles.sh && \
    echo '(cd fabric-samples/marbles; gulp marbles_local &)' >> $HOME/tryMarbles.sh && \
    chmod a+rx tryMarbles.sh

VOLUME /var/lib/docker
EXPOSE 3001

#ENV TZ JST-9

CMD sudo service docker start && /bin/bash

