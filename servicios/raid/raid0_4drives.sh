#!/bin/bash
drive1=$1
drive2=$2
drive3=$3
drive4=$4

mdadm --create --verbose --level=0 --metadata=1.2 --raid-devices=4 /dev/md/raid0_4drives ${drive1} ${drive2} ${drive3} ${drive4}
mdadm --detail --scan >> /etc/mdadm.conf
mdadm --assemble --scan
mkfs.ext4 -v -L raid0_4drives -m 0.5 -b 4096 -E stride=128,stripe-width=512 /dev/md/raid0_4drives
#128: 512/4
#512: 4*128
echo "DONE"
