#!/bin/bash
set -u
set -e
key=$1
mkdir -p /mnt/data/share
mkdir -p /srv/ssh/jail
echo "hola"
mount -o bind /mnt/data/share /srv/ssh/jail
echo "/mnt/data/share /srv/ssh/jail  none   bind   0   0" >> /etc/fstab
groupadd sftponly
useradd -g sftponly -s /usr/bin/nologin -d /srv/ssh/jail sftponly

cat >> /etc/ssh/sshd_config <<EOF
Subsystem sftp /usr/lib/ssh/sftp-server

Match Group sftponly
  ChrootDirectory %h
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication no
EOF

mkdir /etc/ssh/authorized_keys
cat $key >> /etc/ssh/authorized_keys/sftponly
chmod 644 /etc/ssh/authorized_keys/sftponly
