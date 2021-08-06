#! /bin/sh

master_node=cks-controlplane
worker_node_1=cks-node
gcp_zone=europe-west3-c
kubeconfig_file=/home/ric/.kube/gcp-config

# 
gcloud compute instances list

gcloud compute instances start ${master_node} ${worker_node_1}

# Fetch public IP address of master node
master_public_ip=$(gcloud compute instances describe ${master_node} \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Delete current apiserver cert and key
gcloud compute ssh ${master_node} --zone=${gcp_zone} \
  --command='sudo rm /etc/kubernetes/pki/apiserver.{crt,key}'

# Create new cert and key, including external IP address
gcloud compute ssh ${master_node} --zone=${gcp_zone} \
  --command="sudo kubeadm init phase certs apiserver --apiserver-cert-extra-sans=${master_public_ip}"

# Get Kubeconfig to local machine
scp -i ~/.ssh/google_compute_engine \
  ricardo_costa_container_solution@${master_public_ip}:/home/ricardo_costa_container_solution/.kube/config \
  ${kubeconfig_file}

# Change internal IP to external IP in Kubeconfig
master_private_ip=$(gcloud compute instances describe ${master_node} \
  --format='get(networkInterfaces[0].networkIP)')

sed -i "s/${master_private_ip}/${master_public_ip}/" ${kubeconfig_file}

# Set KUBECONFIG env var, in case it's not set
KUBECONFIG=${kubeconfig_file}

