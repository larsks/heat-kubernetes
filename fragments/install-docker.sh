#!/bin/sh
#
# install and enable docker

yum -y install \
	docker-io

systemctl enable docker.socket
systemctl start docker.socket

# make fedora user a member of the docker group
# (so you can run docker commands as the fedora user)
usermod -G docker fedora

