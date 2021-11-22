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


# Hardening 4.5


# Hardening 5.10
docker run --interactive --tty --memory 256m centos /bin/bash
docker run --interactive --tty --memory 256m opensuse/leap /bin/bash


