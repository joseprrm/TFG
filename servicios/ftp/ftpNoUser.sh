#!/bin/bash
yes | pacman -S bftpd

file=/etc/bftpd.conf
declare -r tempdir=/tmp/ftpNoUser
mkdir $tempdir

sed 's/DENY_LOGIN="Anonymous login disabled."/#&/' $file > ${tempdir}/output
mv ${tempdir}/output $file

rm -r $tempdir

service=bftpd
systemctl start $service
if ! systemctl is-active --quiet $service ; then
    systemctl start $service
else
    systemctl restart $service
fi
