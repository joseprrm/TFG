#/bin/bash
set -u
set -e

cat > $file_dhcpcd <<EOF 
hostname
duid
persistent
option rapid_commit
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
option interface_mtu
require dhcp_server_identifier
slaac private
noipv4ll
# Until here it is the default configuration in Arch Linux

# This avoids the creation default routes in the routing table in the ethernet interface
interface ${ethernet_dev}
  nogateway
EOF
