#!/bin/bash

# Provision a Gerrit development environment

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y build-essential automake autoconf
sudo apt-get install -y openjdk-7-jre-headless openjdk-7-jdk ant
sudo apt-get install -y git

git clone https://github.com/facebook/watchman.git
cd watchman
./autogen.sh
./configure
make
sudo make install
cd ..

echo "Please wait, this will take a while..."
git clone https://gerrit.googlesource.com/buck
cd buck
sudo sh -c 'echo "PATH=$(pwd)/bin:$PATH" >> /etc/profile'
cd ..

sudo chown --recursive vagrant.vagrant watchman
sudo chown --recursive vagrant.vagrant buck

cd /vagrant
echo "Please wait, this will take a while..."
git clone --recursive https://gerrit.googlesource.com/gerrit
sudo chown --recursive vagrant.vagrant gerrit