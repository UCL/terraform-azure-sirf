#!/bin/bash

sudo apt-get update

sudo apt-get install -y --no-install-recommends build-essential python-dev python-pip
#python3 -m pip install --upgrade pip
#python3 -m pip install setuptools
#python3 -m pip install jupyter
#python3 -m pip install matplotlib numpy scipy

pip install --upgrade pip
python2 -m pip install setuptools
python2 -m pip install ipykernel jupyter
python2 -m pip install matplotlib numpy scipy

sudo apt-get install -y swig expect
