# Sysdig Kubernetes Demos

This repository will set up a VM running Microk8s using Multipass. It works on Windows, Mac or Linux.

It was designed to run the [example-scenarios](https://github.com/jasonumiker-sysdig/example-scenarios) that you see in the [Kraken V2 workshop](https://github.com/jasonumiker-sysdig/sysdig-aws-workshop-instructions).

To bring in the example-scenarios run the following command:
git submodule update --init

To deploy the workshop:
1. Have installed multipass on the machine in question  - https://multipass.run/install
1. cd to setup-cluster
1. Copy sysdig-agent-values.yaml.clusterscanner.orig to sysdig-agent-values.yaml
1. Update the missing fields (the xxx's)
1. Run setup-microk8s-vm.sh
