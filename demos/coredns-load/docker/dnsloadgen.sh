#!/bin/bash
while true
do
    dig kube-dns.kube-system.svc.cluster.local | grep -oEe 'Query time: [0-9]+ msec'
done