#!/bin/bash

###################################################################
# API for connecting Camect with Satel Integra ETHM module.       #                                                                                                                                                                                     
# Author: JL                                                      #                            
###################################################################


echo "Did you accept the terms at https://local.home.camect.com?"
echo "Did you enabled Integration in Satel ETHM settings and changed it to a static IP?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
echo
echo "###################################################################"
echo "Installing Python3"
echo "###################################################################"
echo
sudo apt update
sudo apt-get -y install python3-pip
echo
echo "###################################################################"
echo "Installing IntegraPy"
echo "###################################################################"
echo
sudo pip3 install IntegraPy
echo
echo "###################################################################"
echo "Installing Wget"
echo "###################################################################"
echo
sudo apt install wget
echo
echo "###################################################################"
echo "Downloading & copy files"
echo "###################################################################"
echo
wget https://raw.githubusercontent.com/leenperjasknegt/camect-satel/main/camect.service
wget https://raw.githubusercontent.com/leenperjasknegt/camect-satel/main/demo.py
sudo mv demo.py /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
sudo mv camect.service /etc/systemd/system/camect.service
echo
echo "###################################################################"
echo "Satel Integra LAN IP:"
read varintegraip
if [ -z "$varintegraip" ]
then
      echo "Nothing changed"
else
sed -i "9c\ExecStart=/usr/bin/python3 -m IntegraPy.demo $varintegraip" /etc/systemd/system/camect.service
fi
echo
echo "###################################################################"
echo "Visit https://local.home.camect.com and paste the link in here; for example: ebbabdd9a.l.home.camect.com)"
echo "## WARNING: WITHOUT HTTPS:// !! ##"
echo "Camect URL:"
read varcamectip
echo
echo "###################################################################"
echo
echo "Wachtwoord Camect (prefix emailadres):"
read varcamectpassword
if [ -z "$varcamectip" ] && [ -z "$varcamectpassword" ]
then
      echo "Nothing changed"
else
sudo sed -i "39c\           r = requests.post('https://$varcamectip/api/EnableAlert', data={'Enable': '0'}, verify=False, auth=('admin', '$varcamectpassword'))" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
sudo sed -i "42c\           r = requests.post('https://$varcamectip/api/EnableAlert', verify=False, auth=('admin', '$varcamectpassword'))" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
fi
echo
echo "###################################################################"
echo "Creating Camect Service"
echo "###################################################################"
echo
sudo systemctl stop camect.service
sleep 2
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable camect.service
echo
echo "###################################################################"
echo "Start Camect Service"
echo "###################################################################"
echo
sleep 1
sudo systemctl start camect.service
echo
sleep 2
echo
sudo systemctl status camect.service
echo "###################################################################"
echo "INSTALLATION SUCCESFULL!"
echo "###################################################################"
echo
echo

