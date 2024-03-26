#!/usr/bin/env bash
VM_NAME="microk8s-vm-sysdig"
SETUP_DIR=$(pwd)

# You can reset things back to defaults by deleting the VM and then let the script recreate
multipass delete $VM_NAME --purge

# Provision your local cluster VM
multipass launch --cpus 5 --memory 6G --disk 20G --name $VM_NAME --cloud-init cloud-init.yaml --timeout 600 22.04

# Copy the .kube/config to the local machine
cd ~
multipass transfer $VM_NAME:/home/ubuntu/.kube/config config
mv config .kube

# Deploy Sysdig Agent
cd $SETUP_DIR
./sysdig-agent-helm-install.sh

# Deploy our demos
#kubectl apply -k ../demos
kubectl apply -k ../example-scenarios/k8s-manifests
