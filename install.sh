#!/bin/bash

echo "Installing Python3"
echo
sudo apt update
sudo apt-get -y install python3-pip
echo
echo "Installing IntegraPy"
echo
sudo pip3 install IntegraPy
echo
echo "Installing Wget"
sudo apt install wget
echo
echo "Downloading & copy files"
wget https://raw.githubusercontent.com/leenperjasknegt/camect-satel/main/camect.service
wget https://raw.githubusercontent.com/leenperjasknegt/camect-satel/main/demo.py
sudo mv demo.py /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py
sudo mv camect.service /etc/systemd/system/camect.service
echo
echo "Creating Camect Service"
sudo systemctl daemon-reload
sudo systemctl enable ethm.service
echo
echo "Integration Option needs to be enabled in ETHM setting"
echo
echo "Port needs to be on default 7094"
echo
echo "Accept terms on Camect device by surfing to https://camectip"
echo
echo "Change IP to Satel ETHM IP in following file: /etc/systemd/system/camect.service"
echo
echo "Change IP to Camect device IP in following file: /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py"
echo
echo "Start the Camect service by sudo systemctl start camect.service"
