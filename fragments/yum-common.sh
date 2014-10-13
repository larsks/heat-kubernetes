#!/bin/sh
yum -y remove NetworkManager
yum -y upgrade
yum -y install jq git tcpdump

