#!/usr/bin/env bash
VM_NAME="microk8s-vm-sysdig"
multipass exec $VM_NAME -- sudo //home/ubuntu/sysdig-demos/setup-cluster/regenerate-kubeconfig.sh
cd ~
multipass transfer $VM_NAME:/home/ubuntu/.kube/config config
mv config .kube