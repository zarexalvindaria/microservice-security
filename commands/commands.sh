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

# Add ssh key to vagrant box
cat ~/.ssh/id_rsa.pub | ssh root@192.168.50.10 "cat >> ~/.ssh/authorized_keys"
cat ~/.ssh/id_rsa.pub | ssh root@192.168.50.10 "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"

sudo ssh-copy-id -i ~/.ssh/id_rsa root@192.168.50.101
