#!/bin/sh
#
# perform yum upgrade and install common packages

yum -y remove NetworkManager
yum -y upgrade
yum -y install jq git tcpdump

