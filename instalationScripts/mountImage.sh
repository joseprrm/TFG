#!/bin/bash
set -u 
set -e 

image=$(realpath $1) 

loop_device=$(losetup -Pf --show ${image})

boot_partition=${loop_device}p1
ext4_partition=${loop_device}p2

chroot=arch-chroot
boot=boot

mkdir $chroot
mkdir $boot

mount $boot_partition $boot
mount $ext4_partition $chroot

cp /usr/bin/qemu-arm-static ${chroot}/usr/bin
if [ ! -f /proc/sys/fs/binfmt_misc/arm ]; then
    echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:' > /proc/sys/fs/binfmt_misc/register
fi

mount -t proc /proc ${chroot}/proc
mount -o bind /dev ${chroot}/dev
mount -o bind /dev/pts ${chroot}/dev/pts
mount -o bind /sys ${chroot}/sys

# we will need enough entropy to be able initialize the pacman keyring
if ! systemctl is-active --quiet rngd ; then
    systemctl start rngd
fi
