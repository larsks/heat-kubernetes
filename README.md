A Kubernetes cluster with Heat
==============================

These [Heat][] templates will deploy an *N*-node [Kubernetes][] cluster,
where *N* is the value of the `number_of_minions` parameter you
specify when creating the stack.

The resulting cluster has a network configuration similar to that
produced by the Vagrant configuration distributed with Kubernetes: an
overlay network between the minions provides a unified address space
across the minions, such that any Docker container can contact any
other Docker container directly, regardless of the host on which they
are running.

The Kubernetes cluster created by these templates is able to
successfully run the [guestbook example][guestbook].

[guestbook]: https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook

The cluster is based on Fedora 20, and makes use of the
[walters/atomic-next][] [COPR][] repository.

These templates are designed to work with the Icehouse version of
Heat, with https://review.openstack.org/#/c/121139/ applied (this
corrects a bug with template validation when using the "Fn::Join"
function).

[heat]: https://wiki.openstack.org/wiki/Heat
[kubernetes]: https://github.com/GoogleCloudPlatform/kubernetes
[walters/atomic-next]: https://copr.fedoraproject.org/coprs/walters/atomic-next/
[copr]: https://copr.fedoraproject.org/

Creating the stack
==================

Creating an environment file `local.yaml` with parameters specific to
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

