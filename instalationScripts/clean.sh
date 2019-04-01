#/bin/bash
kill -9 $(pgrep gpg-agent)
umount arch-chroot/{sys,proc,dev/pts,dev}
umount arch-chroot
umount boot
rmdir arch-chroot boot
losetup -D
