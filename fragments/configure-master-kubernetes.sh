#!/bin/sh
#
# install and enable kubernetes

yum -y install kubernetes
sed -i '
	/^KUBE_API_ADDRESS=/ s/=.*/="0.0.0.0"/
	/^MINION_ADDRESSES=/ s/=.*/="$MINION_ADDRESSES"/
' /etc/kubernetes/apiserver

for service in etcd kube-apiserver kube-scheduler kube-controller-manager; do
	systemctl enable $service
	systemctl start $service
done

