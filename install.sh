#!/bin/bash
echo "Integration Option needs to be enabled in ETHM setting"
echo
echo "Port needs to be on default 7094"
echo
echo "Accept terms on Camect device by surfing to https://camectip"
echo
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
echo ------------------------------------
echo "IP adress Satel Integra ETHM:"
read varintegraip
if [ -z "$varintegraip" ]
then
      echo "Nothing changed"
else
sed -i "9c\ExecStart=/usr/bin/python3 -m IntegraPy.demo $varintegraip" /etc/systemd/system/camect.service
fi
echo
echo ---------------------------------
echo
echo "IP adress Satel Integra ETHM:"
read varintegraip
echo "Wachtwoord Camect (prefix emailadres):"
read varcamectpassword
if [ -z "$varcamectip" ] && [ -z "$varcamectpassword" ]
then
      echo "Nothing changed"
else
sed -i "39c\           r = requests.post('https://'$varcamectip'/api/EnableAlert', data={'Enable': '0'}, verify=False, auth=('admin', '$varcamectpassword'))" /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py
sed -i "42c\           r = requests.post('https://'$varcamectip'/api/EnableAlert', verify=False, auth=('admin', '$varcamectpassword'))" /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py
fi
echo 
echo ------------------------------------
echo "Creating Camect Service"
echo
sudo systemctl daemon-reload
sudo systemctl enable camect.service
echo
echo "Start Camect Service"
echo
sudo systemctl start camect.service
echo
echo ------------------------------------
echo
echo "Change IP to Satel ETHM IP in following file: /etc/systemd/system/camect.service"
echo
echo "Change IP to Camect device IP in following file: /home/administrator/.local/lib/python3.8/site-packages/IntegraPy/demo.py"
echo
echo "Start the Camect service by sudo systemctl start camect.service"
echo
echo
echo
