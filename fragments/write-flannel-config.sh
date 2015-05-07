#!/bin/sh

. /etc/sysconfig/heat-params
. /etc/sysconfig/flanneld

FLANNEL_JSON=/etc/sysconfig/flannel-network.json

# Generate a flannel configuration that we will
# store into etcd using curl.
cat > $FLANNEL_JSON <<EOF
{
  "Network": "$FLANNEL_NETWORK_CIDR",
  "Subnetlen": $FLANNEL_NETWORK_SUBNETLEN,
  "Backend": {
    "Type": "$FLANNEL_BACKEND"
  }
}
EOF

