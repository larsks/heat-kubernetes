Overview
========

Heat templates in this directory are for implementations using
multiple network interfaces. The template creates a second Linux
bridge (kbr1) that connects to eth1 of Kubernetes minions.
The IP address of eth1 is moved to the kbr1 bridge. This allows
eth1 to bridge traffic between the virtual and physical network.

Since Kubernetes does not support multiple network interfaces on pods,
the template installs docker-spotter and pipework to manage a second
interface (eth1) on pods that include the CONFIG_NETWORK=true
ENV variable.

Since Neutron drops packets from unknown MAC addresses, traffic from
and behind the kbr1 bridge is block by security-groups. You can
flush iptables or apply the following port security extension patch:

https://review.openstack.org/#/c/126552/

The following new parameters have been introduced:

external_bridge_address_base specifies the first 3 octets of the
external Neutron network used to provide connectivity to kbr1
and eth1 of pods. Note: At this time, the external network must
be a /24.

Example: external_bridge_address_base: 192.168.225

container_external_network_id is the UUID of the Neutron network
used to provide external connectivity to containers. This network
should be associated to external_bridge_address_base and
container_external_subnet_id. Used to connect to minion and
container eth1

Example: container_external_network_id: be0eac49-f53e-43bc-b40c-d515f9ee2953

container_external_subnet_id is the UUID of the Neutron network
use to provide external connectivity to containers. This network
should be associated to external_bridge_address_base and
container_external_subnet_id. Used to connect to minion and
container eth1

Example: container_external_subnet_id: 005f6149-2e8c-42b0-9a5d-b0100979ac53
