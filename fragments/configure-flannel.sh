#!/bin/sh

. /etc/sysconfig/heat-params

# wait for etcd to become active (we will need it to push the flanneld config)
while ! curl -sf http://localhost:4001/v2/keys/; do
  echo "waiting for etcd"
  sleep 1
done

if [ "$FLANNEL_USE_VXLAN" == "true" ]; then
	use_vxlan=1
fi

cat > /etc/sysconfig/flannel <<EOF
value={
  "Network": "$FLANNEL_NETWORK_CIDR",
  "Subnetlen": $FLANNEL_NETWORK_SUBNETLEN${use_vxlan:+",
  "Backend": {
    "Type": "vxlan"
  }"}
}
EOF

# put the flannel config in etcd
echo "creating flanneld config in etcd"
curl -sf -L http://localhost:4001/v2/keys/coreos.com/network/config \
  -X PUT \
  -d @/etc/sysconfig/flannel


