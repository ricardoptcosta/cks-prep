My goal here is to create a kubernetes from scratch using kubeadm and gcp, starting with 3 nodes.

# Create the VMs

gcloud beta compute --project=cks-playground instances create master --zone=us-central1-a --machine-type=e2-medium --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=609548752574-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1804-bionic-v20210702 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=instance-1 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud beta compute --project=cks-playground instances create worker-1 --zone=us-central1-a --machine-type=e2-small --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=609548752574-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1804-bionic-v20210702 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=instance-1 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud beta compute --project=cks-playground instances create worker-2 --zone=us-central1-a --machine-type=e2-small --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=609548752574-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1804-bionic-v20210702 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=instance-1 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

# Access instances via SSH

- enable OSLogin `gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE`
- add ssh key `gcloud compute os-login ssh-keys add --key-file=/home/ric/.ssh/google_compute_engine.pub --ttl=30d`
- if in doubt get username with `gcloud compute os-login describe-profile`
- ssh into instances `ssh -i ~/.ssh/google_compute_engine ricardo_costa_container_solution@34.66.58.83`

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




# Stuff i tried but couldn't make it work

## Access an nginx deployment+service externally
Nodes don't have an external IP address, despite VMs having them


## EXPOSE KUBE APISERVER
- kubeadm init --apiserver-advertise-address:...
- expose the kube apiserver pod
probably same issue as nginx attempt

# Clear cluster

`gcloud compute instantes stop`
`gcloud compute instances delete`
