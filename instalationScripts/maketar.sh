#!/bin/bash
set -u 
set -e 

image=$(realpath $1) 
tar=$(realpath $2)

loop_device=$(losetup -Pf --show ${image})

boot_partition=${loop_device}p1
ext4_partition=${loop_device}p2

chroot=arch-chroot
boot=boot


mkdir $chroot
mkdir $boot

mount $boot_partition $boot
mount $ext4_partition $chroot


rm -r ${chroot}/boot
cp -r $boot ${chroot}/boot

tar -czvf $tar -C $chroot .
