#!/bin/bash

# Provision a Gerrit development environment

sudo apt-get update
sudo apt-get upgrade

# Download build tools
sudo apt-get install -y zip curl
sudo apt-get install -y build-essential automake autoconf
sudo apt-get install -y git

# Download Java, Ant
sudo apt-get install -y python-software-properties
sudo sh -c 'yes | add-apt-repository ppa:webupd8team/java'
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y ant

# Get watchman installed
git clone https://github.com/facebook/watchman.git
cd watchman
./autogen.sh
./configure
make
sudo make install
cd ..

# Get Buck
echo "Please wait, this will take a while..."
git clone https://gerrit.googlesource.com/buck
cd buck
sudo sh -c 'echo "PATH=$(pwd)/bin:$PATH" >> /etc/profile'
cd ..

cat > .buckrc <<EOF
export BUCK_EXTRA_JAVA_ARGS="-XX:MaxPermSize=512m -Xms8000m -Xmx16000m"
EOF
sudo chown vagrant.vagrant .buckrc

sudo chown --recursive vagrant.vagrant watchman
sudo chown --recursive vagrant.vagrant buck

cd /vagrant
echo "Please wait, this will take a while..."
git clone --recursive https://gerrit.googlesource.com/gerrit
sudo chown --recursive vagrant.vagrant gerrit