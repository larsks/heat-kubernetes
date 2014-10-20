#!/bin/bash

# This script expects the following to be installed:
# curl, libguestfs-tools-c

IMAGE=Fedora-x86_64-20-20140618-sda.qcow2

if [ -n $IMAGE ]; then
    curl -O http://archive.fedoraproject.org/pub/alt/openstack/20/x86_64/$IMAGE
fi

PACKAGES="jq,dnf,dnf-plugins-core,openvswitch,bridge-utils,docker-io,git\
,python-netifaces,python-requests,tcpdump,python-setuptools"

virt-customize \
    --add $IMAGE \
    --update \
    --install $PACKAGES \
    --run-command "dnf -y copr enable walters/atomic-next" \
    --run-command "dnf -y copr enable larsks/fakedocker" \
    --install kubernetes \
    --root-password password:password

# SELinux relabeling requires virt-customize to have networking disabled
# https://bugzilla.redhat.com/show_bug.cgi?id=1122907
virt-customize --add $IMAGE --selinux-relabel --no-network
