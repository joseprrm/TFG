#!/bin/bash
# stop if return code isn't 0
set -e 

function usage {
    program_name=$0
    cat <<EOF
This script installs Arch Linux ARM on specified drive. 
It must be executed as the root user. Do not use it with sudo, use su.
The tarball containing the filesystem can be downloaded previously with:
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

Dependencies: dosfstools TOOD

Usage: $program_name imageName tarball callback
        or
       $program_name [--help|-h] 
  Where:
    imageName  > name of the iso this programs creates
    tarball   -> tarball containing the root filesystem
    callback  -> script that is executed inside the chroot jail

$program_name [--help|-h] displays this message
EOF
}


if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    usage
    exit 0
fi

if [ -z "$1" ]
then
    echo "No image name provided, please provide one" 1>&2
    usage 1>&2
    exit 1
fi


if [ -z "$2" ]
then
    echo "no tar archive provided, please provide one" 1>&2
    usage 1>&2
    exit 1
fi

if [ -z "$2" ]
then
    echo "no callback script provided, please provide one" 1>&2
    usage 1>&2
    exit 1
fi

# stop if a variable is unset
set -u

image=$(realpath $1) 
tar_archive=$(realpath $2)
callback=$(realpath $3)

#dd of=${image} bs=1 seek=1200M count=0
fallocate -l 2000M ${image}

# Do not put blank lines until EOF (unless you know what you are doing), because they will be interpreted as a <CR> inside fdisk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk -W always ${image}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +100M # 100 MB boot parttion
  t # type
  c # set the first partition to W95 FAT32 (LBA) type
  n # new partition
  p # primary partition
  2 # partition number 2
    # default - start next to the partiton1
    # default - until the end of the disk
  w # write the partition table
  q # and we're done
EOF

loop_device=$(losetup -Pf --show ${image})

boot_partition=${loop_device}p1
ext4_partition=${loop_device}p2

mkfs.vfat $boot_partition
mkfs.ext4 $ext4_partition

chroot=arch-chroot
boot=boot

mkdir $chroot
mkdir $boot

mount $boot_partition $boot
mount $ext4_partition $chroot

bsdtar -xpf $tar_archive -C $chroot
sync

mv ${chroot}/boot/* ${boot}

if [ ! -f /proc/sys/fs/binfmt_misc/arm ]; then
    echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:' > /proc/sys/fs/binfmt_misc/register
fi

cp /usr/bin/qemu-arm-static ${chroot}/usr/bin

mount -t proc /proc ${chroot}/proc
mount -o bind /dev ${chroot}/dev
mount -o bind /dev/pts ${chroot}/dev/pts
mount -o bind /sys ${chroot}/sys

# we will need enough entropy to be able initialize the pacman keyring
if ! systemctl is-active --quiet rngd ; then
    systemctl start rngd
fi

chroot ${chroot} bash <${callback}

cp ${chroot}/home/admin/.ssh/newKey ./

exit 0
