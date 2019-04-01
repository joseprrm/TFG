#/bin/bash
set -u 
set -e 

cat > $file_dhcpd <<EOF
#option domain-name-servers 8.8.8.8, 8.8.4.4;
#option subnet-mask $ethernet_lan_mask;
#option routers $ethernet_gateway;
subnet $ethernet_lan_address netmask $ethernet_lan_mask {
  range $ethernet_range_lower $ethernet_range_upper;
}
# Empty declaration for the WIFI network
subnet $wifi_lan_address netmask $wifi_lan_mask {
}
EOF
