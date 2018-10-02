FROM ubuntu:bionic

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
    apt-get install -y docker-ce docker-compose && \
    usermod -aG docker user

#USER user:docker

USER user:docker
WORKDIR /home/user

#node v6
#RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo bash - && \
#node v8
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash - && \
    sudo apt-get update && \
    sudo apt-get install -y nodejs golang && \
    sudo apt-get clean && \
    mkdir $HOME/.config && \
    chown -R user:docker $HOME/.config && \
    echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc && \
    mkdir $HOME/go && \
    echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.bashrc
ENV PATH $PATH:/usr/lib/go/bin
#RUN sudo apt-get install -y go python

RUN echo '#!/bin/sh' > $HOME/installFabric.sh && \
#    echo 'curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0 1.1.0 0.4.6 -s' >> $HOME/installFabric.sh && \
    echo 'curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/release-1.2/scripts/bootstrap.sh | bash' >> $HOME/installFabric.sh && \
    chmod a+rx installFabric.sh
ENV PATH $PATH:/home/user/bin

RUN echo '#!/bin/sh' > $HOME/startDocker.sh && \
    echo 'sudo service docker start' >> $HOME/startDocker.sh && \
    chmod a+rx startDocker.sh

VOLUME /var/lib/docker
EXPOSE 3001

#ENV TZ JST-9

CMD sudo service docker start && /bin/bash
