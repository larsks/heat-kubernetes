#!/bin/sh

# Under atomic, we need to make sure the 'docker' group exists in 
# /etc/group (because /lib/group cannot be modified by usermod).
if ! grep -q docker /etc/group; then
	grep docker /lib/group >> /etc/group
fi

# make centos user a member of the docker group
# (so you can run docker commands as the centos user)
usermod -G docker centos

