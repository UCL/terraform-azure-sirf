#!/bin/bash

sudo apt-get update
sudo apt-get install -y build-essential libinsighttoolkit4-dev
sudo apt-get install -y --no-install-recommends python-dev python-scipy python-numpy

export CMAKE_VERSION=3.11
export BUILD=0
cd /tmp
wget https://cmake.org/files/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.$BUILD.tar.gz
tar -xzvf cmake-$CMAKE_VERSION.$BUILD.tar.gz
cd cmake-$CMAKE_VERSION.$BUILD/
./bootstrap
make -j`nproc`
sudo make install