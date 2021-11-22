# Install go



# Install docker bench
git clone https://github.com/aquasecurity/docker-bench
cd  /docker-bench
go build -o docker-bench

# Find Vulnerabilities
./docker-bench --include-test-output >docker_bench.txt
cat docker_bench.txt | grep FAIL

# Build the docker image
docker build . -t opensuse/leap:latest -m 256mb --no-cache=true

# Delete docker image
docker image rm $docker_image -f

# Hardened 2.2
vim /etc/docker/daemon.json
-- add "icc": false

# Harded 2.15
vim /etc/docker/daemon.json
-- add "live-restore": true

# Hardening 4.5
echo $DOCKER_CONTENT_TRUST
export DOCKER_CONTENT_TRUST=1