#!/bin/bash

## run like this: ./compile_python_debian.sh 3.8.1 3.8.1 (for example)

PYTHON_VERSION=$1
PYTHON_RELEASE=$2

echo "Updating system...."
sudo apt update
sudo apt upgrade
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev   
sudo apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm 
sudo apt-get install -y libncurses5-dev  libncursesw5-dev xz-utils tk-dev

cd $HOME/Downloads

wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_RELEASE.tar.xz

DIR="$HOME/.python$PYTHON_RELEASE"

if [ -d $DIR ]
then
    echo "$0: directory '$DIR' exists."
    echo "Not overwriting existing Python installation. Exiting."
    exit 1
else
    echo "Creating $DIR..."
    mkdir $DIR
fi

tar -xvf Python-$PYTHON_RELEASE.tar.xz
cd Python-$PYTHON_RELEASE
#e we set LDFLAGS pointing to install directory if system does not have libpython3.6 Here we set LDFLAGS pointing to install directory if system does not have libpython3.6
./configure --prefix="$DIR" LDFLAGS="-Wl,--rpath=$DIR/lib"
#./configure --prefix="$DIR" --enabled-shared LDFLAGS="-Wl,--rpath=$DIR/lib"
make
make install
cd ~
rm -rf $HOME/Downloads/Python-$PYTHON_RELEASE
rm $HOME/Downloads/Python-$PYTHON_RELEASE.tar.xz
echo "Done...!"
