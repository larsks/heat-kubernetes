#!/bin/sh
# install linkmanager for managing OVS links
# for minion overlay network.

yum -y install \
	python-netifaces python-requests \
	python-setuptools

git clone http://github.com/larsks/linkmanager.git \
	/opt/linkmanager

(
	cd /opt/linkmanager
	python setup.py install
	cp linkmanager.service /etc/systemd/system/linkmanager.service
)

cat > /etc/sysconfig/linkmanager <<EOF
OPTIONS="-s http://$KUBE_MASTER_IP:4001 -v -b obr0 --secret $LINKMANAGER_KEY"
EOF

systemctl enable linkmanager
systemctl start linkmanager

