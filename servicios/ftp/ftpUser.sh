#!/bin/bash
set -u
set -e
user=$1
if ! $(id $user &>/dev/null); then
    useradd -s /sbin/nologin -m $user

cat >> /etc/bftpd.conf << EOF
user $user{
}
EOF
fi

passwd $user

service=bftpd
systemctl start $service
if ! systemctl is-active --quiet $service ; then
    systemctl start $service
else
    systemctl restart $service
fi
