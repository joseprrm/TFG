#!/bin/bash

su root<<EOF
pacman -S dhcp iptables dosfstools net-tools python python-kivy wget sshpass partprobe rng-tools haveged
EOF

cd /tmp
git clone https://aur.archlinux.org/qemu-arm-static.git
cd qemu-arm-static
yes | makepkg -si
