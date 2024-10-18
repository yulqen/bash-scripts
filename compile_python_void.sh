#!/bin/bash

## run like this: ./compile_python_debian.sh 3.8.1 3.8.1 (for example)

PYTHON_VERSION=$1

#echo "Updating system...."
sudo xbps-install -y make libssl3 zlib-devel
sudo xbps-install -y bzip3-devel readline-devel sqlite-devel wget curl llvm
sudo xbps-install -y ncurses-devel xz liblzma-devel tk-devel

cd $HOME/Downloads

wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz

DIR="$HOME/.python$PYTHON_VERSION"

if [ -d $DIR ]
then
    echo "$0: directory '$DIR' exists."
    echo "Not overwriting existing Python installation. Exiting."
    exit 1
else
    echo "Creating $DIR..."
    mkdir $DIR
fi

tar -xvf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION
#e we set LDFLAGS pointing to install directory if system does not have libpython3.6 Here we set LDFLAGS pointing to install directory if system does not have libpython3.6
./configure --prefix="$DIR" LDFLAGS="-Wl,--rpath=$DIR/lib"
#./configure --prefix="$DIR" --enabled-shared LDFLAGS="-Wl,--rpath=$DIR/lib"
make
make install
cd ~
rm -rf $HOME/Downloads/Python-$PYTHON_VERSION
rm $HOME/Downloads/Python-$PYTHON_VERSION.tar.xz
echo "Done...!"
