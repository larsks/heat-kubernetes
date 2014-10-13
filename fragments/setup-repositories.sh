#!/bin/sh

echo "setting up repositories"
yum -y install dnf-plugins-core
dnf -y copr enable walters/atomic-next
dnf -y copr enable larsks/fakedocker

sed -i 's/$releasever/21/g' /etc/yum.repos.d/_copr_walters-atomic-next.repo

