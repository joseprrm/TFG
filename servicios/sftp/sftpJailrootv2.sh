#!/bin/bash
set -u
set -e
key=$1
user=$2
mkdir -p /mnt/data/share
mkdir -p /srv/ssh/jail
if [[ -z $(mount | grep '/srv/ssh/jail') ]]; then
    mount -o bind /mnt/data/share /srv/ssh/jail
fi
if [[ -z $(grep '/srv/ssh/jail' /etc/fstab ]]; then 
    echo "/mnt/data/share /srv/ssh/jail  none   bind   0   0" >> /etc/fstab
fi
if  [[ -z $(grep '^sftponly' /etc/group) ]]; then
    groupadd sftponly
fi
if  [[ -z $(grep "^${user}" /etc/passwd) ]]; then
    useradd -g sftponly -s /usr/bin/nologin -d /srv/ssh/jail $user
    passwd $user
else
    echo "User already exists" 1>&2
    return 1
fi

cat >> /etc/ssh/sshd_config <<EOF
Subsystem sftp /usr/lib/ssh/sftp-server

Match Group sftponly
  ChrootDirectory %h
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication no
EOF

mkdir -p /etc/ssh/authorized_keys
cat $key >> /etc/ssh/authorized_keys/$user
chmod 644 /etc/ssh/authorized_keys/$user
