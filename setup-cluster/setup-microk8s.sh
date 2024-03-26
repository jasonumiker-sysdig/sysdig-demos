#!/usr/bin/env bash
# NOTE: Run this with sudo

# Install conntrack
#apt update && apt install conntrack -y

# Install microk8s on it
snap install microk8s --channel=1.29/stable --classic

# Move containerd to standard /run and /var/lib runtime paths
# Periodically I try to reconfigure the Sysdig Agent for the non-standand
# paths from micro8s (being a Snap) and I have yet to be able to get it to
# work - so I instead reconfigure microk8s to use the standard paths instead
microk8s stop
cp /var/snap/microk8s/current/args/containerd /var/snap/microk8s/current/args/containerd-orig
sed -i 's|--state ${SNAP_COMMON}/run/containerd|--state /var/run/containerd|g' /var/snap/microk8s/current/args/containerd
sed -i 's|--address ${SNAP_COMMON}/run/containerd.sock|--address /var/run/containerd/containerd.sock|g' /var/snap/microk8s/current/args/containerd
sed -i 's|--root ${SNAP_COMMON}/var/lib/containerd|--root /var/lib/containerd|g' /var/snap/microk8s/current/args/containerd
cp /var/snap/microk8s/current/args/ctr /var/snap/microk8s/current/args/ctr-orig
sed -i 's|--address=${SNAP_COMMON}/run/containerd.sock|--address /var/run/containerd/containerd.sock|g' /var/snap/microk8s/current/args/ctr
cp /var/snap/microk8s/current/args/kubelet /var/snap/microk8s/current/args/kubelet-orig
sed -i 's|--container-runtime-endpoint=${SNAP_COMMON}/run/containerd.sock|--container-runtime-endpoint=/var/run/containerd/containerd.sock|g' /var/snap/microk8s/current/args/kubelet
sed -i 's|--containerd=${SNAP_COMMON}/run/containerd.sock|--containerd=/var/run/containerd/containerd.sock|g' /var/snap/microk8s/current/args/kubelet
microk8s start
microk8s status --wait-ready

# Enable CoreDNS, RBAC, hostpath-storage
microk8s enable dns 
microk8s enable rbac 
microk8s enable hostpath-storage
#microk8s enable observability
microk8s status --wait-ready

# Install kubectl in VM
snap install kubectl --channel 1.29/stable --classic

# Install helm in VM
snap install helm --classic

# Install crictl in VM
#ARCH=$(dpkg --print-architecture)
#wget -q https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.29.0/crictl-v1.29.0-linux-$ARCH.tar.gz
#tar zxvf crictl-v1.29.0-linux-$ARCH.tar.gz -C /usr/local/bin
#rm -f crictl-v1.29.0-linux-$ARCH.tar.gz
echo "runtime-endpoint: unix:///var/run/containerd/containerd.sock" > /etc/crictl.yaml

# Set up the kubeconfig
mkdir /root/.kube
microk8s.config | cat - > /root/.kube/config

mkdir /home/ubuntu/.kube/
cp /root/.kube/config /home/ubuntu/.kube/config
chown ubuntu:ubuntu -R /home/ubuntu/.kube

# Wait for hostpath-provisioner to be up before we call it done
kubectl rollout status deployment hostpath-provisioner -n kube-system --timeout 300s