#!/bin/bash
set -u
set -e
target_device=${1}

mdadm --misc --zero-superblock ${target_device}

# Do not put blank lines until EOF (unless you know what you are doing), because they will be interpreted as a <CR> inside fdisk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk -W always ${target_device}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
    # default - partition 1
    # default - start at beginning of disk 
    # default - until the end of the disk
  w # write the partition table
  q # and we're done
EOF

partprobe
partition=${target_device}1
yes | mkfs.ext4 ${partition}
echo "DONE"
