#!/bin/bash
echo "Did you accept the terms at https://camect.local and enabled Integration in Satel ETHM settings?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
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
sudo mv demo.py /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
sudo mv camect.service /etc/systemd/system/camect.service
echo
echo ------------------------------------
echo

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
echo "Camect IP:"
read varcamectip
echo "Wachtwoord Camect (prefix emailadres):"
read varcamectpassword
if [ -z "$varcamectip" ] && [ -z "$varcamectpassword" ]
then
      echo "Nothing changed"
else
sudo sed -i "39c\           r = requests.post('https://'$varcamectip'/api/EnableAlert', data={'Enable': '0'}, verify=False, auth=('admin', '$varcamectpassword'))" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
sudo sed -i "42c\           r = requests.post('https://'$varcamectip'/api/EnableAlert', verify=False, auth=('admin', '$varcamectpassword'))" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
fi

echo 
echo ------------------------------------
echo
echo "Creating Camect Service"
echo
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable camect.service
echo
echo "Start Camect Service"
echo
sleep 1
sudo systemctl start camect.service
echo
echo ------------------------------------
echo

