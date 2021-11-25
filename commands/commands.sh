# Install go
-- Install wget
zypper install wget

-- Download go repo
wget http://download.opensuse.org/repositories/devel:/languages:/go/SLE_15_SP3/x86_64/go1.17-1.17.3-5.2.x86_64.rpm

-- Install go
zypper install go1.17-1.17.3-5.2.x86_64.rpm

# Install docker bench
git clone https://github.com/aquasecurity/docker-bench
cd  /docker-bench
go build -o docker-bench

# Find Vulnerabilities
./docker-bench --include-test-output >docker_bench.txt
cat docker_bench.txt | grep FAIL

# Find Vulnerabilities
./docker-bench --include-test-output >docker_bench2.txt
cat docker_bench2.txt | grep FAIL

# Build the docker image
docker build . -t opensuse/leap:latest -m 256mb --no-cache=true

# Delete docker image
docker image rm $docker_image -f

# Hardened 2.2
vim /etc/docker/daemon.json
-- add "icc": false

# Hardened 2.15
vim /etc/docker/daemon.json
-- add "live-restore": true

# Hardening 4.5
echo $DOCKER_CONTENT_TRUST
export DOCKER_CONTENT_TRUST=1


------------
# Hardening a Kubernetes Cluster

# Add ssh key to vagrant box -- using Git Bash for Windows
ssh-copy-id -i ~/.ssh/id_rsa root@192.168.50.101
ssh-copy-id -i ~/.ssh/id_rsa root@35.189.172.36
ssh-copy-id -i ~/.ssh/id_rsa root@35.240.209.110

# Exec Docker container on cluster nodes
docker run --pid=host -v /etc:/node/etc:ro -v /var:/node/var:ro -ti rancher/security-scan:v0.2.2 bash

# Scan using Kubebench
 -- Hardened Security Scan
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-hardened
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-hardened | grep FAIL

-- Permissive Security Scan
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-permissive
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-permissive | grep FAIL

# Hardening 1.2.6 Ensure that the --kubelet-certificate-authority argument is set as appropriate (Automated)
-- Changing etcd ownership to etcd
groupadd --gid 52034 etcd
useradd --comment "etcd service account" --uid 52034 --gid 52034 etcd
chown etcd:etcd /var/lib/etcd

-- Configure Kernel Runtime Param
cd /etc/sysctl.d
vim 90-kubelet.conf

-- If 90-kubelet.confdoes not exist, then run touch 90-kubelet.conf to create the file.
-- Set kernel configuration:
`
vm.overcommit_memory=1
vm.panic_on_oom=0
kernel.panic=10
kernel.panic_on_oops=1
kernel.keys.root_maxbytes=25000000
`

sysctl -p /etc/sysctl.d/90-kubelet.conf

# Verifying etcd ownership
docker run --pid=host -v /etc:/node/etc:ro -v /var:/node/var:ro -ti rancher/security-scan:v0.2.2 bash
kube-bench run --targets etcd --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-hardened | grep FAIL

# Baseline Hardening Complete
-- Update cluster.yaml with the configuration in https://rancher.com/docs/rancher/v2.0-v2.4/en/security/rancher-2.4/hardening-2.4/
rke up

docker run --pid=host -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -v /etc:/node/etc:ro -v /var:/node/var:ro -ti rancher/security-scan:v0.2.2 bash
kube-bench run --targets etcd --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-hardened | grep FAIL

-----------

# Install Syft
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# Install Grype
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.18.3

---------

-- Install Helm
helm install --kubeconfig kube_config_cluster.yml falco falcosecurity/falco --set falco.grpc.enabled=true --set falco.grpcOutput.enabled=true


------

# Check Prometheus Installation
kubectl --kubeconfig kube_config_cluster.yml --namespace default get pods -l "release=prometheus-operator-1637805526"

# Port Forward Prometheus
kubectl --kubeconfig kube_config_cluster.yml --namespace default port-forward prometheus-prometheus-operator-163780-prometheus-0 9090

# Port Forward Falco Exporter
kubectl --kubeconfig kube_config_cluster.yml port-forward --namespace default falco-exporter-fbm5r 9376

kubectl --kubeconfig kube_config_cluster.yml edit prometheus prometheus-operator-163780-prometheus

# Port Forward Grafana
kubectl --kubeconfig kube_config_cluster.yml --namespace default port-forward prometheus-operator-1637805526-grafana-58dbd6d64d-wffcp 3000


# View a sensitive file
 kubectl exec falco-mr8dk --kubeconfig kube_config_cluster.yml -- ls /etc -la
 kubectl exec falco-mr8dk --kubeconfig kube_config_cluster.yml cat etc/passwd
 kubectl --kubeconfig kube_config_cluster.yml cat etc/passwd
 kubectl --kubeconfig kube_config_cluster.yml exec -it falco-mr8dk /bin/bash


 kubectl logs falco-mr8dk --kubeconfig kube_config_cluster.yml | grep sensitive

