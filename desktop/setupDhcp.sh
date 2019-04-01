#!/bin/bash

# stop if return code isn't 0
set -e
source global.conf
source helpers/generate_dhcpd.conf.sh
source helpers/generate_dhcpcd.conf.sh
set +u

function usage {
    cat <<EOF
This script configures the dhcp server in the personal computer, allowing a Raspberry Pi to be connected directly via ethernet.
It must be executed as the root user.
Dependencies: dhcp (dhcpd)


Usage: $program_name [--help|-h]
  $program_name executes this script
  $program_name [--help|-h] displays this message

EOF
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    usage
    exit 0
fi

set -u

ip address flush $ethernet_dev
ip link set $ethernet_dev up
ip addr add $ethernet_address_and_mask dev $ethernet_dev
systemctl start dhcpd4.service
