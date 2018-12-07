#!/bin/bash

python -m pip install --upgrade pip
python -m pip install setuptools
python -m pip install jupyter

echo User = $USER

NOCORES=`nproc`
echo Using $NOCORES cores
mkdir ~/devel
cd ~/devel
git clone https://github.com/CCPPETMR/CCPPETMR_VM.git
cd CCPPETMR_VM
sudo bash scripts/INSTALL_prerequisites_with_apt-get.sh
bash scripts/UPDATE.sh -j `nproc`
bash scripts/update_VM.sh -j `nproc`

cd ~
sed -i -- "s/%%TARGETUSER%%/${USER}/g" jupyter.service
sudo mv jupyter.service /etc/systemd/system/jupyter.service
sudo chmod 755 /etc/systemd/system/jupyter.service

sudo mkdir -p /srv/jupyter
sudo mv launch.sh /srv/jupyter/launch.sh
sudo chmod 755 /srv/jupyter/launch.sh

cd /tmp
curl -O https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
bash Anaconda3-4.4.0-Linux-x86_64.sh -b
rm Anaconda3-4.4.0-Linux-x86_64.sh
export PATH=${PATH}:/home/${USER}/anaconda3/bin
echo 'export PATH=${PATH}:/home/${USER}/anaconda3/bin' >> /home/${USER}/.bashrc
source /home/${USER}/.bashrc
mkdir /home/${USER}/.jupyter
#conda install nb_conda -y
jupyter-notebook --generate-config --allow-root
cd /home/${USER}/.jupyter
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-subj "/C=UK/ST=London/L=London/O=University College London/OU=Institute of Nuclear Medicine/CN=." \
-keyout mycert.pem -out mycert.pem \

echo "c= get_config()" >> jupyter_notebook_config.py
echo "c.NotebookApp.certfile = u'/home/${USER}/.jupyter/mycert.pem'" >> jupyter_notebook_config.py
echo "c.NotebookApp.password = u'sha1:392e62632045:6884434c1d0255afe9ab6dbe45336e0cd472b2fe'" >> jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> jupyter_notebook_config.py
echo "c.NotebookApp.port = 9999" >> jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> jupyter_notebook_config.py
