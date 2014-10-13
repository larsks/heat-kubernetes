#!/bin/sh
#
# install gluster

yum -y install glusterfs-server autofs

mkdir /gluster
cat > /etc/auto.gluster <<'EOF'
#!/bin/sh
opts="-fstype=glusterfs,nodev,nosuid"
echo "$opts 127.0.0.1:/$1"
EOF
chmod 755 /etc/auto.gluster

cat > /etc/auto.master.d/gluster.autofs <<EOF
/gluster /etc/auto.gluster
EOF

for service in glusterd autofs; do
	systemctl enable $service
	systemctl start $service
done

