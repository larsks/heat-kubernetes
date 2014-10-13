#!/bin/sh
#
# configure gluster volume

udevadm trigger

gluster_volume="$GLUSTER_VOLUME"
gluster_volume=${gluster_volume::20}
mke2fs -m0 -L gluster /dev/disk/by-id/virtio-$gluster_volume

mkdir -p /bricks
cat >> /etc/fstab <<EOF
/dev/disk/by-id/virtio-$gluster_volume /bricks ext4 defaults 1 2
EOF

mount /bricks

