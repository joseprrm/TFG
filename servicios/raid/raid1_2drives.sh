#!/bin/bash
drive1=$1
drive2=$2

mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 /dev/md/raid1_2drives ${drive1} ${drive2}
mdadm --detail --scan >> /etc/mdadm.conf
mdadm --assemble --scan
mkfs.ext4 /dev/md/raid1_2drives
echo "DONE"
