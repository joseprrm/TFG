#!/bin/bash
DRIVE1=$1
DRIVE2=$2

mdadm --create --verbose --level=0 --metadata=1.2 --raid-devices=2 /dev/md/raid0_2drives ${DRIVE1} ${DRIVE2}
mdadm --detail --scan >> /etc/mdadm.conf
mdadm --assemble --scan
mkfs.ext4 -v -L raid0_2drives -m 0.5 -b 4096 -E stride=128,stripe-width=256 /dev/md/raid0_2drives
#128: 512/4
#256: 2*128
echo "DONE"
