
# Install docker bench
1. git clone https://github.com/aquasecurity/docker-bench
2. cd  /docker-bench
3. go build -o docker-bench

# Find Vulnerabilities
1. ./docker-bench --include-test-output >docker_bench.txt
2. cat docker-bench.txt | grep FAIL
