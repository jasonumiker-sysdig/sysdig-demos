#!/bin/zsh
kubectl create secret -n mysql-sakila generic mysql-exporter --from-file=.my.cnf=./mysql-exporter.cnf
helm install -n mysql-sakila -f values.yaml --repo https://sysdiglabs.github.io/integrations-charts mysql-sakila-mysql-sakila-deployment mysql-exporter