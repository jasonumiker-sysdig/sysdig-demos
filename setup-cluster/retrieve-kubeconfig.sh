#!/usr/bin/env bash
multipass exec microk8s-vm-sysdig -- sudo //home/ubuntu/sysdig-demos/setup-cluster/regenerate-kubeconfig.sh
cd ~
multipass transfer microk8s-vm-sysdig:/home/ubuntu/.kube/config config
mv config .kube