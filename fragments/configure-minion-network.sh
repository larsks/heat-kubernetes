#!/bin/sh

yum -y install openvswitch bridge-utils

netconf=/etc/sysconfig/network-scripts
bridge_address_base="$BRIDGE_ADDRESS_BASE"

myip=$(ip addr show eth0 | awk '$1 == "inet" {print $2}' | cut -f1 -d/)
myip_last_octet=${myip##*.}
bridge_address="${bridge_address_base}.${myip_last_octet}.1"

# Docker contains are attached to this bridge
cat > $netconf/ifcfg-kbr0 <<EOF
DEVICE=kbr0
TYPE=Bridge
IPADDR=${bridge_address}
NETMASK=255.255.255.0
ONBOOT=yes
STP=yes

# With the default forwarding delay of 15 seconds,
# many operations in a 'docker build' will simply timeout
# before the bridge starts forwarding.
DELAY=2
EOF

# This bridge will handle VXLAN tunnels
cat > $netconf/ifcfg-obr0 <<EOF
DEVICE=obr0
DEVICETYPE=ovs
TYPE=OVSBridge
ONBOOT=yes
BRIDGE=kbr0
STP=true
EOF

cat > $netconf/route-kbr0 <<EOF
${bridge_address_base}.0.0/16 dev kbr0 scope link src ${bridge_address}
EOF

# Container interface MTU must be reduced in order to
# prevent fragmentation problems when vxlan header is
# added to a host-MTU sized packet.
cat > /etc/sysconfig/docker <<EOF
OPTIONS="--selinux-enabled -b kbr0 --mtu 1450"
EOF

# start bridges
systemctl enable openvswitch
systemctl start openvswitch
ifup kbr0
ifup obr0

