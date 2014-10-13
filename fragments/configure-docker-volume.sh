#!/bin/sh
#
# set up docker volume

udevadm trigger

# we need to truncate the volume id, because apparently the system
# truncates device serial numbers to 20 characters.
docker_volume="$DOCKER_VOLUME"
docker_volume=${docker_volume::20}
mke2fs -m0 -L docker /dev/disk/by-id/virtio-$docker_volume

mkdir -p /var/lib/docker
cat >> /etc/fstab <<EOF
/dev/disk/by-id/virtio-$docker_volume /var/lib/docker ext4 defaults 1 2
EOF

mount /var/lib/docker
