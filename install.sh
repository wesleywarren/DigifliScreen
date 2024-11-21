#!/usr/bin/bash

#version 0.1  11/20/2024
#Author: Wes Warren  wes@digifli.com
#
# Runs screens added on Digifli.com
set -e #exit on fail

LOGFILE="/home/pi/Digifli-install.log"
echo "Starting installation..." | tee $LOGFILE

echo "Installing python3-screeninfo..." | tee -a $LOGFILE
sudo apt install -y python3-screeninfo #need this 

echo "Updating lightdm configuration..." | tee -a $LOGFILE
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
sudo sed -i "s/#xserver-command=X/xserver-command=X -nocursor/" /etc/lightdm/lightdm.conf

cd /home/pi/


# Download necessary files
FILES=("server.py" "digifli.py" "digifliboot.sh")
BASE_URL="http://digifli.net/ws"

for FILE in "${FILES[@]}"; do
    echo "Downloading $FILE..." | tee -a $LOGFILE
    wget -q "$BASE_URL/$FILE" -O "/home/pi/$FILE"
    chmod 775 "/home/pi/$FILE"
done

echo "Setting up autostart..." | tee -a $LOGFILE
mkdir -p /home/pi/.config/autostart
cd /home/pi/.config/autostart
wget -q "$BASE_URL/digifli.desktop" -O /home/pi/.config/autostart/digifli.desktop


#echo "Downloading Unclutter..." | tee -a $LOGFILE
#sudo apt install -y unclutter


echo "All done getting ready to reboot..." | tee -a $LOGFILE

sudo reboot now