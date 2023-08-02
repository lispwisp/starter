# Starter
This is a basic starter project that is designed to be used as a starting point to run your own minimal kubernetes cluster.
It includes configuration for a load balancer, metrics gathering and reporting, a k8s dashboard and a cert-manager.
Feel free to adapt it to suit your needs.

## Installation steps
For local installation on a single machine we need to virtualize a cluster.
For this walkthrough we will use multipass for the virtualization.
If you were installing on physical machines, the steps would be the same except we would not be managing virtual instances with multipass.

First install the latest multipass release from github https://github.com/canonical/multipass/releases.
Also acquire the latest release of terraform and install it.

We are going to run a real 4 node cluster directly on a host machine using multipass to virtualize the nodes in the cluster.
Obviously running an entire 4 node cluster on one consumer grade machine can be impractical unless you have powerful hardware.
The cluster configuration applied here contains the minimum recommended values for the development cluster we intend to run.
If you decide to use fewer resources you may end up with node toleration failures and/or failing nodes.
A production cluster may need more resources.
If your home machine isn't powerful enough, consider upgrading or renting physical or virtual resources.
If you do rent resources or have 4 physical machines and they all have ubuntu (preferably the same version) then you obviously do not need multipass and can just install microk8s directly on the hardware (if you want).

Set up a multi node HA cluster for microk8s.
(The following is adapted from [the directions on canonical](https://ubuntu.com/tutorials/getting-started-with-kubernetes-ha#1-overview))
```shell
multipass launch --cpus 2 --memory 4G --disk 120G -n node0; multipass exec node0 -- sudo snap install microk8s --classic; multipass exec node0 -- sudo usermod -a -G microk8s ubuntu; multipass exec node0 -- sudo chown -f -R ubuntu ~/.kube
multipass launch --cpus 2 --memory 4G --disk 120G -n node1; multipass exec node1 -- sudo snap install microk8s --classic; multipass exec node1 -- sudo usermod -a -G microk8s ubuntu; multipass exec node1 -- sudo chown -f -R ubuntu ~/.kube
multipass launch --cpus 2 --memory 4G --disk 120G -n node2; multipass exec node2 -- sudo snap install microk8s --classic; multipass exec node2 -- sudo usermod -a -G microk8s ubuntu; multipass exec node2 -- sudo chown -f -R ubuntu ~/.kube
multipass launch --cpus 2 --memory 4G --disk 120G -n node3; multipass exec node3 -- sudo snap install microk8s --classic; multipass exec node3 -- sudo usermod -a -G microk8s ubuntu; multipass exec node3 -- sudo chown -f -R ubuntu ~/.kube
```

Now have other nodes join node0 (note the input of subsequent commands depends on the output of prior commands; make sure to use the values you have)
```shell
multipass exec node0 -- microk8s add-node
#From the node you wish to join to this cluster, run the following:
#microk8s join 172.26.204.127:25000/11114966df53ae8532c1239a783d606f/030711e86ce6
#
#Use the '--worker' flag to join a node as a worker not running the control plane, eg:
#microk8s join 172.26.204.127:25000/11114966df53ae8532c1239a783d606f/030711e86ce6 --worker
#
#If the node you are adding is not reachable through the default interface you can use one of the following:
#microk8s join 172.26.204.127:25000/11114966df53ae8532c1239a783d606f/030711e86ce6
multipass exec node1 -- microk8s join 172.26.204.127:25000/11114966df53ae8532c1239a783d606f/030711e86ce6
multipass exec node0 -- microk8s add-node
#From the node you wish to join to this cluster, run the following:
#microk8s join 172.26.204.127:25000/adfb5feba91c73c53727772e922db789/030711e86ce6
#
#Use the '--worker' flag to join a node as a worker not running the control plane, eg:
#microk8s join 172.26.204.127:25000/adfb5feba91c73c53727772e922db789/030711e86ce6 --worker
#
#If the node you are adding is not reachable through the default interface you can use one of the following:
#microk8s join 172.26.204.127:25000/adfb5feba91c73c53727772e922db789/030711e86ce6
multipass exec node2 -- microk8s join 172.26.204.127:25000/adfb5feba91c73c53727772e922db789/030711e86ce6
multipass exec node0 -- microk8s add-node
#From the node you wish to join to this cluster, run the following:
#microk8s join 172.26.204.127:25000/de468f6c93fda60679c5e8790d3cbffe/030711e86ce6
#
#Use the '--worker' flag to join a node as a worker not running the control plane, eg:
#microk8s join 172.26.204.127:25000/de468f6c93fda60679c5e8790d3cbffe/030711e86ce6 --worker
#
#If the node you are adding is not reachable through the default interface you can use one of the following:
#microk8s join 172.26.204.127:25000/de468f6c93fda60679c5e8790d3cbffe/030711e86ce6
multipass exec node3 -- microk8s join 172.26.204.127:25000/de468f6c93fda60679c5e8790d3cbffe/030711e86ce6
```

List the nodes you have running
```shell
multipass list
#Name                    State             IPv4             Image
#node0                   Running           172.26.204.127   Ubuntu 22.04 LTS
#                                          10.1.135.128
#node1                   Running           172.26.204.133   Ubuntu 22.04 LTS
#                                          10.1.166.128
#node2                   Running           172.26.196.7     Ubuntu 22.04 LTS
#                                          10.1.104.0
#node3                   Running           172.26.204.33    Ubuntu 22.04 LTS
#                                          10.1.135.0
```

We can link `node0` to our kube config.
Sync your local `~/.kube/config` with this node so a plain `kubectl` will work without having to prefix it with `multipass kubectl` every time.
This will be important to allow terraform to function without additional configuration.
```shell
multipass exec node0 -- microk8s config > ~/.kube/config
```

Now check the state of the kubernetes cluster and wait until you see all nodes
```shell
kubectl get node
#NAME    STATUS   ROLES    AGE     VERSION
#node1   Ready    <none>   2m13s   v1.27.2
#node2   Ready    <none>   100s    v1.27.2
#node0   Ready    <none>   6m59s   v1.27.2
#node3   Ready    <none>   6s      v1.27.2
```

Enable the dependencies, ensure you use the private IP addresses for your nodes
```shell
multipass exec node0 -- microk8s enable rbac
multipass exec node0 -- microk8s enable hostpath-storage
multipass exec node0 -- microk8s enable metallb:172.26.204.127-172.26.204.127,172.26.204.133-172.26.204.133,172.26.196.7-172.26.196.7,172.26.204.33-172.26.204.33
```

If you run microk8s status within `node0` now you should see that you have a high availability microk8s cluster with 3 masters.
```shell
multipass exec node0 -- microk8s status
#microk8s is running
#high-availability: yes
#  datastore master nodes: 172.26.204.127:19001 172.26.204.133:19001 172.26.196.7:19001
#  datastore standby nodes: 172.26.204.33:19001
#addons:
#  enabled:
#    dns                  # (core) CoreDNS
#    ha-cluster           # (core) Configure high availability on the current node
#    helm                 # (core) Helm - the package manager for Kubernetes
#    helm3                # (core) Helm 3 - the package manager for Kubernetes
#    hostpath-storage     # (core) Storage class; allocates storage from host directory
#    metallb              # (core) Loadbalancer for your Kubernetes cluster
#    rbac                 # (core) Role-Based Access Control for authorisation
#    storage              # (core) Alias to hostpath-storage add-on, deprecated
#  disabled:
#    cert-manager         # (core) Cloud native certificate management
#    community            # (core) The community addons repository
#    dashboard            # (core) The Kubernetes dashboard
#    gpu                  # (core) Automatic enablement of Nvidia CUDA
#    host-access          # (core) Allow Pods connecting to Host services smoothly
#    ingress              # (core) Ingress controller for external access
#    kube-ovn             # (core) An advanced network fabric for Kubernetes
#    mayastor             # (core) OpenEBS MayaStor
#    metrics-server       # (core) K8s Metrics Server for API access to service metrics
#    minio                # (core) MinIO object storage
#    observability        # (core) A lightweight observability stack for logs, traces and metrics
#    prometheus           # (core) Prometheus operator for monitoring and logging
#    registry             # (core) Private image registry exposed on localhost:32000
```
We could enable plugins for dashboard, ingress, metrics-server, prometheus and cert-manager.
However, the configuration of these is a little canned and annoying to tweak.
For maximum flexibility and control, we are going to install these components (or equivalents) through kubernetes ourselves.

Now initialize terraform. Terraform kubernetes provider will pickup and recognize `~/.kube/config` automatically.
```
terraform init
```

Some CRDs provide other modules objects needed at planning time, some do not.
For simplicity, we just explicitly apply all CRDs before the first time we use `terraform apply`.
```
terraform apply -target="module.cert-manager-crd"
```

Now apply the entire infrastructure.
```
terraform apply
```
This command may take up to 10 minutes by default before timing out though this is configurable.
If your machine hasn't fully applied the infrastructure, just run this command again to resume.
On your first apply, cockroachdb will not successfully move out of pending state because it must be told to initialize explicitly.
I describe how to do that below.
From now on you can always use just `terraform apply` to sync the infrastructure.

You should also modify your DNS resolution to recognize these private IP addresses.
For example, on linux you can modify `/etc/hosts`.
On windows you should modify `C:\Windows\System32\drivers\etc\hosts`.
Add the following lines (use your node private IP address instead):
```
172.26.204.127 grafana.dev.snifflewafflefizzlefaffle.com
172.26.204.127 vmselect.dev.snifflewafflefizzlefaffle.com
172.26.204.127 kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com
```

Some browsers aggressively cache DNS even for private ip addresses.
If there is an existing certificate cached for the domain you are using then that can also cause issues.
You can forcibly flush DNS with:
```shell
ipconfig /flushdns
```

However, we modified our DNS so that we can resolve the host we configured.
For safety, double check that this points to the private IP address for your node and is not being resolved to something on the internet.
You can use dig or any other network tool if you want.
Here I am using ping.
```
ping kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com
# Pinging kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com [172.26.204.127] with 32 bytes of data:
# Reply from 172.26.204.127: bytes=32 time<1ms TTL=64
# Reply from 172.26.204.127: bytes=32 time<1ms TTL=64
```

If you set up your DNS resolution correctly you should be able to access the dashboard via (https://kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com/).

Note: the first `terraform apply` will time out after 10 minutes because cockroachdb requires one time manual intervention to start.
After startup, you will need to command cockroachdb to initialize with the current peer set.
```
kubectl exec -it -n cockroachdb cockroachdb-0 -- cockroach init --insecure --host localhost:26258
```

Kubernetes dashboard is available at this URI
https://kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com/

Grafana is available at this URI
https://grafana.dev.snifflewafflefizzlefaffle.com/

You can access vmselect ui at
https://vmselect.dev.snifflewafflefizzlefaffle.com/select/0/vmui

If you want to allow grafana to detect metrics recorded by Victoria Metrics, you should add a Prometheus datasource in grafana for the following URI
http://vmselect.monitoring.svc.cluster.local:8481/select/0/prometheus

This serves as a good common starting point to deploy your own minimal cluster.
From here the configuration for each cluster is very situation dependent and diverges quickly.
For example, depending on whether this is hosted on github or gitea or on prem will determine what continuous deployment looks like.
Here is a checklist to help you along:

1. Switch from self-signed certs to certs managed by a CA like let's encrypt (or an equivalent)
2. Depending on where you host the software, set up continuous deployment using GitOps (or an equivalent)
3. Use a terraform provider for GoDaddy (or an equivalent) to manage your actual domain and use that instead of snifflewafflefizzlefaffle.com
4. Decide whether you want to use hashicorp vault (or an equivalent) to store the terraform state

Modularizing the infrastructure using terraform parameterization would be premature before making the above decisions.
After you have settled on a decision for each of these, you may find it helpful to parameterize some of them https://developer.hashicorp.com/terraform/language/modules/syntax