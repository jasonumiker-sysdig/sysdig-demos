#!/usr/bin/env bash
kubectl create ns sysdig-agent
helm repo add sysdig https://charts.sysdig.com
helm repo update
helm install sysdig-agent --namespace sysdig-agent -f sysdig-agent-values.yaml.onprem sysdig/sysdig-deploy
