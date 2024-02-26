#!/bin/bash
# Disable exit on non 0
set +e
./example-curls.sh
./example-curls-restricted.sh
./example-curls-nodrift.sh
./example-curls-nomalware.sh
kubectl delete pods --all -n security-playground
kubectl delete pods --all -n security-playground-restricted
kubectl delete pods --all -n security-playground-restricted-nodrift
kubectl delete pods --all -n security-playground-restricted-nomalware
kubectl delete deployment nefarious-workload -n security-playground
