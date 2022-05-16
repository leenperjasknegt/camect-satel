#!/bin/bash

###################################################################
# API for connecting Camect with Satel Integra ETHM module.       #                                                                                                                                                                                     
# Author: JL                                                      #                            
###################################################################
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1
# Everything below will go to the file 'log.out':

echo "Did you accept the terms at https://camect.local and enabled Integration in Satel ETHM settings?"
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
sudo apt update > /dev/null 2>&1
sudo apt-get -y install python3-pip > /dev/null 2>&1
echo
echo "###################################################################"
echo "Installing IntegraPy"
echo "###################################################################"
echo
sudo pip3 install IntegraPy > /dev/null 2>&1
echo
echo "###################################################################"
echo "Installing Wget"
echo "###################################################################"
echo
sudo apt install wget > /dev/null 2>&1
echo
echo "###################################################################"
echo "Downloading & copy files"
echo "###################################################################"
echo
wget https://raw.githubusercontent.com/leenperjasknegt/camect-satel/main/camect.service > /dev/null 2>&1
wget https://raw.githubusercontent.com/leenperjasknegt/camect-satel/main/demo.py > /dev/null 2>&1
sudo mv demo.py /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py > /dev/null 2>&1
sudo mv camect.service /etc/systemd/system/camect.service > /dev/null 2>&1
echo
echo "###################################################################"
echo "IP adress Satel Integra ETHM:"
read varintegraip
if [ -z "$varintegraip" ]
then
      echo "Nothing changed"
else
sed -i "9c\ExecStart=/usr/bin/python3 -m IntegraPy.demo $varintegraip" /etc/systemd/system/camect.service
fi
echo
echo "###################################################################"
echo "Camect IP:"
read varcamectip
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
sudo systemctl stop camect.service > /dev/null 2>&1
sleep 2
sudo systemctl daemon-reload > /dev/null 2>&1
sleep 1
sudo systemctl enable camect.service > /dev/null 2>&1
echo
echo "###################################################################"
echo "Start Camect Service"
echo "###################################################################"
echo
sleep 1
sudo systemctl start camect.service > /dev/null 2>&1
echo
sleep 2
echo
sudo systemctl status camect.service
echo "###################################################################"
echo "INSTALLATION SUCCESFULL!"
echo "###################################################################"
echo
echo

