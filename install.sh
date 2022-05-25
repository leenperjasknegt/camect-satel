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
sudo apt update
echo
if [ $(dpkg-query -W -f='${Status}' python3-pip 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo
  echo "###################################################################"
  echo "Installing Python3"
  echo "###################################################################"
  echo
  suo apt-get -y install python3-pip;
fi
echo
if [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo
  echo "###################################################################"
  echo "Installing Python3"
  echo "###################################################################"
  echo
  suo apt install wget;
fi
echo
echo
echo "###################################################################"
echo "Installing IntegraPy"
echo "###################################################################"
echo
sudo pip3 install IntegraPy
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
echo "Visit https://local.home.camect.com and paste the link in here; for example: https://ebbabdd9a.l.home.camect.com"
echo "## WARNING:  WITH HTTPS:// !! ##"
echo "Camect URL:"
read varcamecturl
echo
echo "###################################################################"
echo
echo "Wachtwoord Camect (prefix emailadres):"
echo "For example: camect@gmail.com => prefix: camect"
read varcamectpassword
if [ -z "$varcamecturl" ] && [ -z "$varcamectpassword" ]
then
      echo "Nothing changed"
else
sudo sed -i "12c\camecturl = '$varcamecturl'" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
sudo sed -i "13c\camectpassword = '$varcamectpassword'" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
fi
echo
echo "###################################################################"
echo "Satel Intergra Partition name:"
echo "*** Don't use <'> !!! ***"
read varintegrapartition
if [ -z "$varintegrapartition" ]
then
      echo "Nothing changed"
else
sudo sed -i "15c\integrapartition = '$varintegrapartition'" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
fi
echo
echo "###################################################################"
echo "Satel Intergra (extra) Zone name:"
echo "You can use an extra zone that needs to be closed at the same time the partition is armed to enable the Camect alerts"
echo "** If you don't please leave the field empty ***"
read varintegrazone
if [ -z "$varintegrazone" ]
then
      echo "Nothing changed"
else
sudo sed -i "14c\integrazone = '$varintegrazone'" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
fi


echo
echo "###################################################################"
read -p "Do you want to inverse the zone? From NC to NO? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  echo
  echo "Normally Closed"
  sudo sed -i "43c\    if integrapartition in armed_partitions and not integrazone in violated_zones :" /usr/local/lib/python3.8/dist-packages/IntegraPy/demo.py
else
  echo
  echo "Normally Open";
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

