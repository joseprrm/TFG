#!/bin/bash

yes | pacman -S fakeroot npm gcc
su admin<<EOF
cd /tmp
git clone https://aur.archlinux.org/python-raspberry-gpio.git
cd python-raspberry-gpio
yes | makepkg -si
EOF

#https://glasstty.com/wiki/index.php/Installing_Node_Red
npm install -g --unsafe-perm node-red
touch /usr/share/doc/python-rpi.gpio 
