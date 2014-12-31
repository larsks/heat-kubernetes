#!/bin/sh

echo starting services
for service in etcd kube-apiserver kube-scheduler kube-controller-manager; do
  systemctl enable $service
  systemctl --no-block start $service
done


