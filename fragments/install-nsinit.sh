#!/bin/sh
# this is required to implement "exec" type livenessProbes in
# kubernetes.

yum -y install golang-github-docker-libcontainer
ln -s /usr/bin/nsinit /usr/sbin/nsinit

