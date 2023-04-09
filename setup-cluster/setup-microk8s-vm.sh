#!/bin/bash

VM_NAME="microk8s-vm-sysdig"

# You can reset things back to defaults by deleting the VM and then let the script recreate
multipass delete $VM_NAME
multipass purge

# Provision your local cluster VM
multipass launch --cpus 4 --memory 8G --disk 20G --name $VM_NAME --cloud-init cloud-init.yaml --timeout 600 22.04

# Deploy the Sysdig Agent
multipass transfer ./sysdig-agent-helm-install.sh $VM_NAME:/home/ubuntu/
if [[ $OS == "Windows_NT" ]]; then
    multipass exec $VM_NAME -- sudo apt update -y
    multipass exec $VM_NAME -- sudo apt install dos2unix -y
    multipass exec $VM_NAME -- dos2unix //home/ubuntu/sysdig-agent-helm-install.sh
    multipass exec $VM_NAME -- chmod +x //home/ubuntu/sysdig-agent-helm-install.sh
    multipass exec $VM_NAME -- //home/ubuntu/sysdig-agent-helm-install.sh

else
    multipass exec $VM_NAME -- chmod +x /home/ubuntu/sysdig-agent-helm-install.sh
    multipass exec $VM_NAME -- /home/ubuntu/sysdig-agent-helm-install.sh
fi

# Copy the .kube/config to the local machine
cd ~/.kube
multipass transfer $VM_NAME:/home/ubuntu/.kube/config config
