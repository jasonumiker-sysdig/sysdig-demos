#!/bin/bash
# Regenerate Kubeconfig
# Run as root/sudo

microk8s config > /root/.kube/config
JANE_TOKEN=$(cat /home/ubuntu/sysdig-demos/setup-cluster/jane.token)
JOHN_TOKEN=$(cat /home/ubuntu/sysdig-demos/setup-cluster/john.token)
kubectl config set-context microk8s-jane --cluster=microk8s-cluster --namespace=team1 --user=jane
kubectl config set-context microk8s-john --cluster=microk8s-cluster --namespace=team2 --user=john
echo "- name: jane" >> /root/.kube/config
echo "  user:" >> /root/.kube/config
echo "    token: "$JANE_TOKEN >> /root/.kube/config
echo "- name: john" >> /root/.kube/config
echo "  user:" >> /root/.kube/config
echo "    token: "$JOHN_TOKEN >> /root/.kube/config
cp /root/.kube/config /home/ubuntu/.kube/config
chown ubuntu:ubuntu -R /home/ubuntu/.kube