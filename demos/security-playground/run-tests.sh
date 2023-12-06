#!/bin/bash
./example-curls.sh && \
./example-curls-restricted.sh && \
./example-curls-nodrift.sh && \
kubectl delete pods --all -n security-playground && \
kubectl delete pods --all -n security-playground-restricted && \
kubectl delete pods --all -n security-playground-nodrift && \
kubectl delete deployment nefarious-workload -n security-playground