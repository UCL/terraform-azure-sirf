#!/bin/bash

#python -m pip install --upgrade pip
#python -m pip install jupyter
#python -m pip install setuptools

echo User = $USER

NOCORES=`nproc`
echo Using $NOCORES cores

#cd /tmp
#curl -O https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
#bash Anaconda3-4.4.0-Linux-x86_64.sh -b
#rm Anaconda3-4.4.0-Linux-x86_64.sh
#export PATH=${PATH}:/home/${USER}/anaconda3/bin
#echo 'export PATH=${PATH}:/home/${USER}/anaconda3/bin' >> /home/${USER}/.bashrc
#source /home/${USER}/.bashrc

##export PYTHON_EXECUTABLE=/home/${USER}/anaconda3/bin/python3

#conda create -n py36 python=3.6 -y
#source activate py36
#conda install gcc -y

mkdir ~/devel
cd ~/devel
git clone https://github.com/CCPPETMR/CCPPETMR_VM.git
cd CCPPETMR_VM
sudo bash scripts/INSTALL_prerequisites_with_apt-get.sh

sudo apt-get purge cmake -y

export CMAKE_VERSION=3.13
export BUILD=1
cd /tmp
wget https://cmake.org/files/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.$BUILD.tar.gz
tar -xzvf cmake-$CMAKE_VERSION.$BUILD.tar.gz
cd cmake-$CMAKE_VERSION.$BUILD/
./bootstrap
make -j`nproc`
sudo make install

cd ~/devel/CCPPETMR_VM
bash scripts/UPDATE.sh -j `nproc`
bash scripts/update_VM.sh -j `nproc`

cd ~
sed -i -- "s/%%TARGETUSER%%/${USER}/g" jupyter.service
sudo mv jupyter.service /etc/systemd/system/jupyter.service
sudo chmod 755 /etc/systemd/system/jupyter.service

sudo mkdir -p /srv/jupyter
sed -i -- "s/%%TARGETUSER%%/${USER}/g" launch.sh
sudo mv launch.sh /srv/jupyter/launch.sh
sudo chmod 755 /srv/jupyter/launch.sh

mkdir /home/${USER}/.jupyter
jupyter-notebook --generate-config --allow-root
cd /home/${USER}/.jupyter
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-subj "/C=UK/ST=London/L=London/O=University College London/OU=Institute of Nuclear Medicine/CN=." \
-keyout mycert.pem -out mycert.pem \

cd ~
bash jupyter_set_pwd.sh ${JUPPWD}

echo "c= get_config()" >> jupyter_notebook_config.py
echo "c.NotebookApp.certfile = u'/home/${USER}/.jupyter/mycert.pem'" >> jupyter_notebook_config.py

NEWPWD=`cat ~/.jupyter/jupyter_notebook_config.json | grep password | cut -d'"' -f4`
echo "c.NotebookApp.password = u'${NEWPWD}'" >> jupyter_notebook_config.py

echo "c.NotebookApp.ip = '*'" >> jupyter_notebook_config.py
echo "c.NotebookApp.port = ${JUPPORT}" >> jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> jupyter_notebook_config.py
