#!/bin/bash
sudo apt update -y &&
sudo apt upgrade -y &&
sudo apt install -y \
apt-transport-https \
ca-certificates \
mc \
atop \
htop \
curl \
gnupg-agent \
net-tools \
software-properties-common &&
# openjdk-8-jre-headless \
# sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz -P /opt/ &&
# sudo tar -zxvf /opt/latest-unix.tar.gz --directory /opt/
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
# sudo apt-get update -y &&
# sudo sudo apt-get install docker-ce docker-ce-cli containerd.io -y &&
# sudo usermod -aG docker ubuntu