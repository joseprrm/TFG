#!/bin/bash
#set -e
set -u

image=$1
target=$2

dd if=$image of=$target bs=4M status=progress oflag=sync

sync

root_partition=${target}2
# Do not put blank lines until EOF (unless you know what you are doing), because they will be interpreted as a <CR> inside fdisk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk -W always ${target}
  d # delete
  2 # partition number 2 (the root partition)
  n # new partition
  p # primary partition
  2 # partition number 2
    # default - start next to the partiton1
    # default - until the end of the disk
  w # write the partition table
EOF

partprobe

e2fsck -y -f  ${root_partition}

resize2fs  ${root_partition}
sync
