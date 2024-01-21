#!/usr/bin/env bash
VM_NAME="microk8s-vm-sysdig"
SETUP_DIR=$(pwd)

# You can reset things back to defaults by deleting the VM and then let the script recreate
multipass delete $VM_NAME
multipass purge

# Provision your local cluster VM
#multipass launch --cpus 8 --memory 16G --disk 30G --name $VM_NAME --cloud-init cloud-init.yaml --timeout 600 --bridged 22.04
multipass launch --cpus 8 --memory 16G --disk 30G --name $VM_NAME --cloud-init cloud-init.yaml --timeout 600 22.04

# Copy the .kube/config to the local machine
cd ~
multipass transfer $VM_NAME:/home/ubuntu/.kube/config config
mv config .kube

# Deploy Sysdig Agent
cd $SETUP_DIR
./sysdig-agent-helm-install.sh

# Deploy our demos
kubectl apply -k ../demos
