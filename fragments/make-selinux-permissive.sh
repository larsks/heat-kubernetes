#!/bin/sh
#
# put selinux in permissive mode.  this is necessary to work around missing
# selinux policies for both kubernets volumes and for gluster.

echo "putting selinux in permissive mode"
setenforce 0
sed -i '/^SELINUX=/ s/=.*/=permissive/' /etc/selinux/config

