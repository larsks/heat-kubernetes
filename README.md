Deploying Atomic + Kubernetes with Heat
=======================================

These [Heat][] templates will deploy a cluster of Nova instances
running [Kubernetes][] on top of [Project Atomic][].  The cluster uses
[Flannel][] to provide an overlay network connecting pods deployed on
different nodes.

You can determine the initial size of the cluster via a configuration
parameter when you deploy it, and the cluster will scale dynamically
(up to a specified maximum size) due to CPU load on the Kubernetes
nodes.

[heat]: https://wiki.openstack.org/wiki/Heat
[kubernetes]: https://github.com/GoogleCloudPlatform/kubernetes
[project atomic]: http://www.projectatomic.io/
[flannel]: https://github.com/coreos/flannel

## Requirements

### OpenStack

These templates will work with the Kilo version of Heat.
They will work with the Juno version of Heat as long as you have a
release that includes [this fix][] for bug [#1402894][].

[this fix]: https://review.openstack.org/#/c/182446/
[#1402894]: https://bugs.launchpad.net/heat/+bug/1402894

You should deploy some simple stacks in your environment to ensure
that Heat is configured correctly before attempting to use these
templates.

### Guest image

These templates require an Atomic disk image.  You can obtain disk
images from [Project Atomic][], as well as directly from [Fedora][]
and from [Red Hat][].

[fedora]: https://getfedora.org/en/cloud/download/atomic.html
[red hat]: https://access.redhat.com/articles/rhel-atomic-getting-started

These templates are known to work with RHEL Atomic 7.1.2 and Fedora 22
Atomic.

## Creating the stack

These templates define several parameters that can be used to
configure the stack; for details see the `parameters` section of
`kubecluster.yaml`.  While many of the parameters have reasonable
defaults, you will need to provide values for:

- `ssh_key_name` -- the name of an SSH key already installed in Nova
  that will be used for accessing your Kubernetes nodes.

- `server_image` -- the name of an image in Glance that will be used
  to instantiate the nodes.

You may need to provide a value for:

- `dns_nameserver` -- a nameserver that is reachable in your
  environment.  This defaults to one of the public Google nameservers
  (8.8.8.8), which may not be accessible (or useful) in some internal
  environments.

To provide the parameter values to the template you will create an
environment file that may look something like this:

    parameters:
      ssh_key_name: lars
      server_image: fedora-atomic
      dns_nameserver: 192.168.122.1

You will provide this file via the `-e` argument to `heat
stack-create`:

    heat stack-create -f kubecluster.yaml -e params.yaml my-kube-cluster

## Interacting with Kubernetes

You can get the ip address of the Kubernetes master using the `heat
output-show` command:

    $ heat output-show my-kube-cluster kube_master
    "192.168.200.86"

You can ssh into that server as the `minion` user:

    $ ssh minion@192.168.200.86

And once logged in you can run `kubectl` to interact with the
Kubernetes API:

    $ kubectl get minions
    NAME                LABELS       STATUS
    10.0.0.4            <none>       Ready

You can log into your nodes using the `minion` user as well.  You
can get a list of node addresses by running:

    $ heat output-show my-kube-cluster kube_minions_external
    [
      "192.168.200.182"
    ]

## Testing

The templates install some example Pod and Service descriptions into
`/etc/kubernetes/examples`.  You can deploy this with the following
commands:

    $ kubectl create -f /etc/kubernetes/examples/web.service
    $ kubectl create -f /etc/kubernetes/examples/web.replica

This will deploy a minimal webserver and a corresponding service.  You
can use `kubectl get pods` and `kubectl get services` to see the
results of these commands.

## License

Copyright 2014 Lars Kellogg-Stedman <lars@redhat.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use these files except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Contributing

Please submit bugs and pull requests via the [GitHub repository][] at
https://github.com/larsks/heat-kubernetes/.

When submitting pull requests:

- Please ensure that each pull request contains a single commit and
  contains only related changes.  Put unrelated changes in multiple
  pull requests.

- Please avoid conflating new features with
  stylistic/formatting/cleanup changes.

[github repository]: https://github.com/larsks/heat-kubernetes/

