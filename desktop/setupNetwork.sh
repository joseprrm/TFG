#!/bin/bash

# ha de ser ejecutado como root
set -u
set -e

source global.conf

# borramos cualquier direccion que haya en el interfaz ethernet
ip address flush dev $ethernet_dev
# nos aseguramos de que el interfaz ethernet este encendido
ip link set $ethernet_dev up

# borramos la tabla de enrutamiento principal (ID 254)
ip route flush table 254

# anyadimos la direccion interfaz ethernet
ip address add $ethernet_address_and_mask broadcast + dev $ethernet_dev

# actualizamos la tabla de enrutamiento principal
route add -host $raspberry_pi_address metric 1 dev $ethernet_dev
route add -net $wifi_lan_address_and_mask metric 10 dev $wifi_dev
route add default gw $wifi_gateway_address metric 20 

# activamos el forwarding de ipv4 y el NAT
sysctl net.ipv4.ip_forward=1 > /dev/null
iptables -t nat -A POSTROUTING -o $wifi_dev -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ethernet_dev -o $wifi_dev -j ACCEPT
