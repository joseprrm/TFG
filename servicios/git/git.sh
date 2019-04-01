#!/bin/bash
set -e
set -u
key=$(realpath $1)
repo=$2
if  [[ -z $(grep "^git" /etc/passwd) ]]; then
    useradd -s /usr/bin/git-shell git
fi

cat $key >> /etc/ssh/authorized_keys/git
mkdir -p /srv/git/$repo
cd /srv/git/$repo
git init --bare
cd ..
chown -R git:git $repo
