#!/bin/bash
#start monero_cpu_moneropool
kubectl run --kubeconfig kube_config_cluster.yml moneropool --image=servethehome/monero_cpu_moneropool:latest
#start minergate
kubectl run --kubeconfig kube_config_cluster.yml minergate --image=servethehome/monero_cpu_minergate:latest
#start cryptotonight
kubectl run --kubeconfig kube_config_cluster.yml minerogate --image=servethehome/universal_cryptonight:latest

echo "Can you identify the payload(s)?"