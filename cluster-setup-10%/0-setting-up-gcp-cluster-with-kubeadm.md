My goal here is to create a kubernetes from scratch using kubeadm and gcp, starting with 3 nodes.

# Create the VMs

```bash
gcloud beta compute --project=cks-playground instances create master --zone=us-central1-a --machine-type=e2-medium --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=609548752574-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1804-bionic-v20210702 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=instance-1 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```

```bash
gcloud beta compute --project=cks-playground instances create worker-1 --zone=us-central1-a --machine-type=e2-small --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=609548752574-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1804-bionic-v20210702 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=instance-1 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```

```bash
gcloud beta compute --project=cks-playground instances create worker-2 --zone=us-central1-a --machine-type=e2-small --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=609548752574-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1804-bionic-v20210702 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=instance-1 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```
# Access instances via SSH

- enable OSLogin `gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE`
- add ssh key `gcloud compute os-login ssh-keys add --key-file=/home/ric/.ssh/google_compute_engine.pub --ttl=30d`
- if in doubt get username with `gcloud compute os-login describe-profile`
- ssh into instances `ssh -i ~/.ssh/google_compute_engine ricardo_costa_container_solution@34.66.58.83`
## OR
- Simply access using `gcloud compute ssh <VM-NAME>`

# Instllation
## Option 1
https://docs.projectcalico.org/getting-started/kubernetes/self-managed-public-cloud/gce

## Option 2
### Install kubeadm, kubelet and kubectl in all machines

- follow https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

### Install containerd

- used this https://averagelinuxuser.com/kubernetes_containerd/
(need to better understand)

### Run sudo kubeadm init --pod-network-cidr=192.168.0.0/16
the option is related to Calico

### Install CNI 
- I used Calico

## Option 3
Use script from [killer.sh](https://itnext.io/cks-exam-series-1-create-cluster-security-best-practices-50e35aaa67ae)

# Expose services

## Access an nginx deployment+service externally
- Expose the nginx deployment with `kubectl expose deploy nginx --type=NodePort --name=nginx-np --port=80`
- Open firewall to access VM using tags (not great to use IPs because they are dynamics)
- Access the Nginx on the <NodePort-Public-IP>:<NodePort-Port>. Pay attention that the port is not the service's, ie, it's not 80 but in the 30000's range.

## Expose Kube Apiserver and access to it with local Kubectl 
(This section was automated with the script `start-cluster-update-kubectl.sh`. Run it with `source` instead of `sh` to preserve KUBECONFIG)
- The kube apiserver should already be exposed on <NodePort-Public-IP>:6443
- Update kubeadm configs adding a *Subject Alternative Names* option with the public ip:
  - first remove the apiserver cert and key `rm /etc/kubernetes/pki/apiserver.{crt,key}`
  - `kubeadm init phase certs apiserver --apiserver-cert-extra-sans=<PUBLIC-IP>`
- scp the kubeconfig file to local machine 
  - `scp -i ~/.ssh/google_compute_engine ricardo_costa_container_solution@<PUBLIC-IP>:/home/ricardo_costa_container_solution/.kube/config /home/ric/.kube/gcp-config`
  - update the server address in the kubeconfig file from internal ip to external ip

# Clear cluster

`gcloud compute instantes stop`
`gcloud compute instances delete`


