#!/bin/bash

echo "Installing Python3"
sudo apt-get -y install python3-pip

echo "Installing IntegraPy"
pip3 install IntegraPy

echo "Downloading & copy files"
mv demo.py /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py

echo "Creating Camect Service"
mv camect.service /etc/systemd/system/camect.service
systemctl daemon-reload
systemctl enable ethm.service

echo "Integration Option needs to be enabled in ETHM setting"
echo "Port needs to be on default 7094"
echo "Accept terms on Camect device by surfing to https://camectip"
echo "Change IP to Satel ETHM IP in following file: /etc/systemd/system/camect.service"
echo "Change IP to Camect device IP in following file: /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py"
echo "Start the Camect service by sudo systemctl start camect.service"
