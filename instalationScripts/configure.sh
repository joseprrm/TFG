#/bin/bash
uname -a

# set timezone
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# activate ntp
ln -sf /usr/lib/systemd/system/systemd-timesyncd.service /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service

# setup locale
echo "en_US.UTF-8 UTF-8">>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8">/etc/locale.conf
# aso no podem fero. sha de fer despues
#localectl set-locale LANG=en_US.UTF-8
# timedatectl set ntp-true

# fix the resolv.conf.
rm /etc/resolv.conf
echo "nameserver 8.8.8.8" >/etc/resolv.conf

pacman-key --init
pacman-key --populate archlinuxarm
yes | pacman -Syu

# yes | pacman -S vim tmux git cronie rsync restic mdadm wget bftpd parted sudo cowsay docker #borg 
yes | pacman -S sudo cowsay vim

cowsay "Welcome to the Raspberry Pi Arch Linux Server" >/etc/motd

cat >/etc/systemd/network/eth0.network <<EOF
[Match]
Name=eth0

[Network]
Address=192.168.1.40
Gateway=192.168.1.50
EOF

echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

userdel -f -r alarm
useradd -m -G wheel -s /bin/bash admin

mkdir /home/admin/.ssh
ssh-keygen -f /home/admin/.ssh/newKey

mv /home/admin/.ssh/newKey.pub /home/admin/.ssh/authorized_keys
chmod 644 /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh

cat >/etc/ssh/sshd_config <<EOF
Port 28374

AuthorizedKeysFile /etc/ssh/authorized_keys/%u  .ssh/authorized_keys

PasswordAuthentication no
PermitEmptyPasswords no

ChallengeResponseAuthentication no
PubkeyAuthentication yes
UsePAM yes
PrintMotd no # pam does that
EOF

cat >/home/admin/.bashrc <<EOF
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ \$- != *i* ]] && return

export TERM=xterm
export EDITOR=vim

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

sudo su
EOF
