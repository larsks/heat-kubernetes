#!/bin/sh

. /etc/sysconfig/heat-params

echo "configuring kubernetes (master)"

sed -i '
  /^KUBE_ALLOW_PRIV=/ s/=.*/="--allow_privileged='"$KUBE_ALLOW_PRIV"'"/
' /etc/kubernetes/config

sed -i '
  /^KUBE_API_ADDRESS=/ s/=.*/="--address=0.0.0.0"/
' /etc/kubernetes/apiserver

sed -i '
  /^KUBELET_ADDRESSES=/ s/=.*/="--machines='"$MINION_ADDRESSES"'"/
' /etc/kubernetes/controller-manager

