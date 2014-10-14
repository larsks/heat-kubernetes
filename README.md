# A Kubernetes cluster with Heat

These [Heat][] templates will deploy an *N*-node [Kubernetes][] cluster,
where *N* is the value of the `number_of_minions` parameter you
specify when creating the stack.

[heat]: https://wiki.openstack.org/wiki/Heat
[kubernetes]: https://github.com/GoogleCloudPlatform/kubernetes

The resulting cluster has a network configuration similar to that
produced by the Vagrant configuration distributed with Kubernetes: an
overlay network between the minions provides a unified address space
across the minions, such that any Docker container can contact any
other Docker container directly, regardless of the host on which they
are running.  The overlay network is created using [linkmanager][], a
quick hack that uses Open vSwitch and VXLAN tunnels to create the
overlay network.

[linkmanager]: https://github.com/larsks/linkmanager

The template deploy a Gluster cluster across the nodes, so you can
create cluster-wide shared filesystems.  Any Gluster volume you
create will be available automatically at `/gluster/<volume_name>`.

The cluster is based on Fedora 20, and makes use of the
[walters/atomic-next][] [COPR][] repository.

[walters/atomic-next]: https://copr.fedoraproject.org/coprs/walters/atomic-next/
[copr]: https://copr.fedoraproject.org/

**NB**: Fedora 20 initially shipped with a kernel that does not have
the necessary support for vxlan to work correctly.  If you are using
this image you will need to reboot your minions in order for things to
work correctly.  You should create an updated Fedora 20 image with a
newer kernel.

These templates are designed to work with the Icehouse version of
Heat, with https://review.openstack.org/#/c/121139/ applied (this
corrects a bug with template validation when using the "Fn::Join"
function).

## Requirements

This Gluster-enabled version requires a functioning Cinder service. By
default the templates will allocate, *on each minion*, a 20GB volume
for docker images and a 40GB image for Gluster.  Make sure you have
the necessary space available, or adjust the values of
`docker_volume_size` and `gluster_volume_size` appropriately.

## Validation

The Kubernetes cluster created by these templates is able to
successfully run the [guestbook example][guestbook] from the
Kubernetes repository.

[guestbook]: https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook

## Creating the stack

Create an environment file `local.yaml` with parameters specific to
your environment:

    parameters:
      ssh_key_name: lars
      external_network_id: 028d70dd-67b8-4901-8bdd-0c62b06cce2d
      dns_nameserver: 192.168.200.1

And then create the stack, referencing that environment file:

    heat stack-create -f kubecluster.yaml -e local.yaml my-kube-cluster

You must provide values for:

- `ssh_key_name`
- `external_network_id`

You will *probably* need to override the `server_image` default value,
as well.

Interacting with Kubernetes
===========================

**NB**: You will be able to log into the servers before Kubernetes is
ready; you can tail the `/var/log/cloud-init.log` file to see when the
software install and configuration is complete.

You can get the ip address of the Kubernetes master using the `heat
output-show` command:

    $ heat output-show my-kube-cluster kube_master
    "192.168.200.86"

You can ssh into that server as the `fedora` user:

    $ ssh fedora@192.168.200.86

And once logged in you can run `kubecfg`, etc:

    $ kubecfg list minions
    Minion identifier
    ----------
    10.0.0.4
    10.0.0.5

Gluster support
===============

These templates create a [Gluster][] cluster from the master and
minions, and set up autofs on the minions for convenient access to
gluster volumes.  If you create a new volume named `data`:

    # gluster volume create data replica 2 \
      192.168.113.4:/bricks/data \
      192.168.113.5:/bricks/data
    # gluster volume start data

Then you can immediately access that volume on the minions as
`/gluster/data`.

This can be used to provision persistent storage to pods using the
"volume" support in Kubernetes.

[gluster]: http://gluster.org/

