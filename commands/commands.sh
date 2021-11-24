# Install go



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

# Exec Docker container on cluster nodes
docker run --pid=host -v /etc:/node/etc:ro -v /var:/node/var:ro -ti rancher/security-scan:v0.2.2 bash

# Scan using Kubebench
 -- Hardened Security Scan
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-hardened
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-hardened | grep FAIL

-- Permissive Security Scan
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-permissive
kube-bench run --targets etcd,master,controlplane,policies --scored --config-dir=/etc/kube-bench/cfg --benchmark rke-cis-1.6-permissive | grep FAIL

