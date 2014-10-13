#!/bin/sh

echo "putting selinux in permissive mode"
setenforce 0
sed -i '/^SELINUX=/ s/=.*/=permissive/' /etc/selinux/config

