#!/bin/sh
#
# configure kubernetes on the minions

yum -y install \
    kubernetes

sed -i '/^KUBE_ETCD_SERVERS=/ s|=.*|=http://$KUBE_MASTER_IP:4001|' \
	/etc/kubernetes/config

sed -i '
	/^MINION_ADDRESS=/ s/=.*/="0.0.0.0"/
	/^MINION_HOSTNAME=/ s/=.*/="'"$myip"'"/
' /etc/kubernetes/kubelet

sed -i '
	/^KUBE_API_ADDRESS=/ s/=.*/="$KUBE_MASTER_IP"/
	/^KUBE_MASTER=/ s/=.*/="$KUBE_MASTER_IP"/
' /etc/kubernetes/apiserver

cat >> /etc/environment <<EOF
KUBERNETES_MASTER=http://$KUBE_MASTER_IP:8080
EOF

for service in kubelet kube-proxy; do
	systemctl enable $service
	systemctl start $service
done

