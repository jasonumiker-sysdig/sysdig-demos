#!/bin/bash

VM_NAME="microk8s-vm-sysdig"

# You can reset things back to defaults by deleting the VM and then let the script recreate
multipass delete $VM_NAME
multipass purge

# Provision your local cluster VM
multipass launch --cpus 4 --memory 8G --disk 20G --name $VM_NAME --cloud-init cloud-init.yaml --timeout 600 22.04

# Copy the .kube/config to the local machine
cd ~/.kube
multipass transfer $VM_NAME:/home/ubuntu/.kube/config config

# Deploy Sysdig Agent
./sysdig-agent-helm-install.sh

# Deploy our demos
kubectl apply -k ../demos