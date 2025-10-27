# Complete Tool Usage Guide

## Network Connectivity Tools

### curl
HTTP client for making requests and testing APIs.

```bash
# Basic GET request
curl http://service-name:8080/api/endpoint

# Verbose output (shows headers, TLS handshake)
curl -v https://api.example.com

# Follow redirects
curl -L http://example.com

# POST with JSON data
curl -X POST http://api:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"test","email":"test@example.com"}'

# Download file
curl -O http://example.com/file.tar.gz

# Test with custom headers
curl -H "Authorization: Bearer token123" http://api:8080/protected

# Show only response headers
curl -I http://example.com

# Test connection timeout
curl --connect-timeout 5 http://slow-service:8080
```

### wget
Non-interactive network downloader.

```bash
# Download file
wget http://example.com/file.tar.gz

# Continue interrupted download
wget -c http://example.com/large-file.iso

# Download recursively
wget -r http://example.com/docs/

# Mirror a website
wget --mirror --convert-links --page-requisites http://example.com

# Save with different filename
wget -O custom-name.tar.gz http://example.com/file.tar.gz
```

### httpie
User-friendly HTTP client with syntax highlighting.

```bash
# Simple GET (http is the command)
http GET http://api:8080/users

# POST with JSON (automatic)
http POST http://api:8080/users name=john email=john@example.com

# Custom headers
http GET http://api:8080/protected Authorization:"Bearer token123"

# Download file
http --download http://example.com/file.tar.gz

# Form submission
http --form POST http://api:8080/upload file@/path/to/file.txt
```

## DNS and Name Resolution

### nslookup
Query DNS servers for domain information.

```bash
# Basic lookup
nslookup google.com

# Lookup specific record type
nslookup -type=MX google.com

# Query specific DNS server
nslookup google.com 8.8.8.8

# Kubernetes service lookup
nslookup service-name.namespace.svc.cluster.local

# Reverse DNS lookup
nslookup 8.8.8.8
```

### dig
Advanced DNS lookup tool with detailed output.

```bash
# Basic query
dig google.com

# Query specific record type
dig google.com MX
dig google.com AAAA  # IPv6
dig google.com TXT

# Short answer only
dig +short google.com

# Query specific DNS server
dig @8.8.8.8 google.com

# Reverse DNS lookup
dig -x 8.8.8.8

# Trace DNS resolution path
dig +trace google.com

# Query all record types
dig google.com ANY

# Kubernetes service
dig service-name.namespace.svc.cluster.local
```

### host
Simple DNS lookup utility.

```bash
# Basic lookup
host google.com

# Specific record type
host -t MX google.com

# Reverse lookup
host 8.8.8.8

# Verbose output
host -v google.com
```

## Network Connectivity Testing

### ping
Test network connectivity using ICMP.

```bash
# Basic ping
ping google.com

# Ping specific number of times
ping -c 4 google.com

# Ping with interval
ping -i 2 google.com  # 2 second interval

# Flood ping (requires root)
ping -f google.com

# Set packet size
ping -s 1000 google.com
```

### traceroute
Trace the network path to a destination.

```bash
# Basic trace
traceroute google.com

# Use ICMP instead of UDP
traceroute -I google.com

# Specify max hops
traceroute -m 15 google.com

# Use specific port
traceroute -p 443 google.com
```

### mtr
Combination of ping and traceroute with real-time updates.

```bash
# Interactive mode
mtr google.com

# Report mode (10 cycles)
mtr --report --report-cycles 10 google.com

# Use TCP instead of ICMP
mtr --tcp google.com

# Specify port
mtr --tcp --port 443 google.com

# Show both hostnames and IPs
mtr --show-ips google.com
```

### netcat (nc)
Swiss army knife for TCP/UDP connections.

```bash
# Test if port is open
nc -zv hostname 80

# Test port range
nc -zv hostname 80-443

# Connect to service
nc hostname 80

# Listen on port (server mode)
nc -l 8080

# Transfer file
# Receiver: nc -l 8080 > received_file
# Sender: nc hostname 8080 < file_to_send

# UDP mode
nc -u hostname 53

# Chat between two containers
# Container 1: nc -l 8080
# Container 2: nc container1 8080

# Port scanning
nc -zv -w 2 hostname 1-1000
```

### telnet
Connect to remote hosts on specific ports.

```bash
# Test port connectivity
telnet hostname 80

# Test SMTP
telnet mail.example.com 25

# Test HTTP manually
telnet example.com 80
# Then type: GET / HTTP/1.1
# Host: example.com
```

## Network Analysis

### tcpdump
Capture and analyze network traffic.

```bash
# Capture all traffic on all interfaces
tcpdump -i any

# Capture on specific interface
tcpdump -i eth0

# Capture traffic to/from specific host
tcpdump host 10.0.0.5

# Capture traffic on specific port
tcpdump port 80

# Capture HTTP traffic
tcpdump -i any -A port 80

# Save to file
tcpdump -i any -w capture.pcap

# Read from file
tcpdump -r capture.pcap

# Capture DNS queries
tcpdump -i any port 53

# Filter by network
tcpdump net 192.168.1.0/24

# Capture with timestamps
tcpdump -i any -tttt

# Limit packet count
tcpdump -c 100

# Complex filter: HTTP requests to specific host
tcpdump -i any 'tcp port 80 and host 10.0.0.5'
```

### nmap
Network scanner for discovering hosts and services.

```bash
# Scan single host
nmap 192.168.1.1

# Scan subnet
nmap 192.168.1.0/24

# Scan specific ports
nmap -p 80,443 hostname

# Scan port range
nmap -p 1-1000 hostname

# Scan all ports
nmap -p- hostname

# Service version detection
nmap -sV hostname

# OS detection
nmap -O hostname

# Fast scan (top 100 ports)
nmap -F hostname

# Ping scan (discover hosts)
nmap -sn 192.168.1.0/24

# TCP SYN scan (stealthy)
nmap -sS hostname

# Aggressive scan
nmap -A hostname
```

### socat
Advanced relay tool for bidirectional data transfer.

```bash
# Port forwarding
socat TCP-LISTEN:8080,fork TCP:backend-service:80

# Proxy connections
socat TCP-LISTEN:3306,fork TCP:mysql-server:3306

# Create SSL tunnel
socat TCP-LISTEN:443,fork OPENSSL:backend:443

# Connect to Unix socket
socat - UNIX-CONNECT:/var/run/docker.sock

# UDP relay
socat UDP-LISTEN:514,fork UDP:syslog-server:514
```

### iperf3
Network bandwidth testing tool.

```bash
# Server mode
iperf3 -s

# Client mode (test to server)
iperf3 -c server-hostname

# Test for 30 seconds
iperf3 -c server-hostname -t 30

# Reverse mode (server sends)
iperf3 -c server-hostname -R

# UDP test
iperf3 -c server-hostname -u

# Parallel streams
iperf3 -c server-hostname -P 10

# Test specific bandwidth
iperf3 -c server-hostname -b 100M
```

## Database Clients

### psql (PostgreSQL)
PostgreSQL command-line client.

```bash
# Connect to database
psql -h postgres-host -U username -d database_name

# Connect with connection string
psql postgresql://user:password@host:5432/dbname

# Execute single query
psql -h postgres-host -U username -d database -c "SELECT * FROM users;"

# Execute SQL file
psql -h postgres-host -U username -d database -f script.sql

# List databases
psql -h postgres-host -U username -l

# Common psql commands (inside psql):
\l          # List databases
\c dbname   # Connect to database
\dt         # List tables
\d+ table   # Describe table
\du         # List users
\q          # Quit
```

### mysql
MySQL/MariaDB command-line client.

```bash
# Connect to database
mysql -h mysql-host -u username -p database_name

# Execute query
mysql -h mysql-host -u username -p -e "SELECT * FROM users;" database_name

# Execute SQL file
mysql -h mysql-host -u username -p database_name < script.sql

# Common commands (inside mysql):
SHOW DATABASES;
USE database_name;
SHOW TABLES;
DESCRIBE table_name;
SELECT * FROM table_name;
exit;
```

### redis-cli
Redis command-line client.

```bash
# Connect to Redis
redis-cli -h redis-host -p 6379

# Connect with authentication
redis-cli -h redis-host -a password

# Execute single command
redis-cli -h redis-host GET mykey

# Common Redis commands:
PING                    # Test connection
SET key value          # Set key
GET key                # Get value
KEYS *                 # List all keys
DEL key                # Delete key
EXISTS key             # Check if key exists
TTL key                # Get key expiration
FLUSHALL               # Clear all data
INFO                   # Server information
```

## API Testing

### grpcurl
gRPC client for testing gRPC services.

```bash
# List services
grpcurl -plaintext grpc-service:9090 list

# List methods of a service
grpcurl -plaintext grpc-service:9090 list my.package.MyService

# Describe service
grpcurl -plaintext grpc-service:9090 describe my.package.MyService

# Call method
grpcurl -plaintext -d '{"name": "test"}' \
  grpc-service:9090 \
  my.package.MyService/GetUser

# With TLS
grpcurl -d '{"name": "test"}' \
  grpc-service:9090 \
  my.package.MyService/GetUser

# With authentication header
grpcurl -H "Authorization: Bearer token" \
  -d '{"name": "test"}' \
  grpc-service:9090 \
  my.package.MyService/GetUser
```

## Data Processing

### jq
JSON processor and filter.

```bash
# Pretty print JSON
echo '{"name":"john","age":30}' | jq '.'

# Extract field
echo '{"name":"john","age":30}' | jq '.name'

# Array element
echo '[1,2,3,4,5]' | jq '.[2]'

# Filter array
echo '[{"name":"john","age":30},{"name":"jane","age":25}]' | jq '.[] | select(.age > 26)'

# Map array
echo '[1,2,3]' | jq 'map(. * 2)'

# Keys
echo '{"a":1,"b":2}' | jq 'keys'

# Combine with curl
curl -s http://api:8080/users | jq '.[] | .name'

# Multiple outputs
echo '{"a":1,"b":2,"c":3}' | jq '.a, .b'
```

### yq
YAML processor (similar to jq).

```bash
# Read YAML
yq eval '.' file.yaml

# Extract field
yq eval '.metadata.name' pod.yaml

# Update field
yq eval '.metadata.labels.env = "prod"' -i file.yaml

# Convert YAML to JSON
yq eval -o=json '.' file.yaml

# Convert JSON to YAML
yq eval -P '.' file.json
```

## System Monitoring

### htop
Interactive process viewer.

```bash
# Launch htop
htop

# Key shortcuts inside htop:
# F5 - Tree view
# F6 - Sort by
# F9 - Kill process
# F10 - Quit
# / - Search
# Space - Tag process
```

### strace
Trace system calls and signals.

```bash
# Trace a command
strace ls

# Trace a running process
strace -p PID

# Trace specific system calls
strace -e open,read ls

# Trace with timestamps
strace -t ls

# Count system call time
strace -c ls

# Trace all threads
strace -f command

# Output to file
strace -o trace.log ls
```

## Security and TLS

### openssl
Cryptography and SSL/TLS toolkit.

```bash
# Test SSL connection
openssl s_client -connect example.com:443

# Show certificate
openssl s_client -connect example.com:443 -showcerts

# Check certificate dates
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates

# Test specific TLS version
openssl s_client -connect example.com:443 -tls1_2

# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# View certificate details
openssl x509 -in cert.pem -text -noout

# Check private key
openssl rsa -in key.pem -check

# Verify certificate
openssl verify cert.pem

# Test cipher suites
openssl s_client -connect example.com:443 -cipher 'ECDHE-RSA-AES256-GCM-SHA384'
```

## File Operations

### tree
Display directory structure.

```bash
# Show directory tree
tree

# Limit depth
tree -L 2

# Show hidden files
tree -a

# Show file sizes
tree -h

# Show only directories
tree -d

# Pattern matching
tree -P '*.yaml'
```

## Kubernetes-Specific Examples

```bash
# Test internal service DNS
nslookup my-service.default.svc.cluster.local

# Test service endpoint
curl http://my-service.default.svc.cluster.local:8080/health

# Check connectivity to external service
curl -v https://api.external.com

# Test database connection from pod
psql -h postgres.default.svc.cluster.local -U myuser -d mydb

# Capture traffic between services
tcpdump -i any -n host 10.0.0.5

# Test port connectivity
nc -zv my-service.default.svc.cluster.local 8080

# Query cluster DNS
dig @10.96.0.10 my-service.default.svc.cluster.local

# Test gRPC service
grpcurl -plaintext my-grpc-service:9090 list
```

## Troubleshooting Common Issues

### DNS Resolution Issues
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test cluster DNS
nslookup kubernetes.default.svc.cluster.local

# Detailed DNS query
dig +trace my-service.default.svc.cluster.local
```

### Network Connectivity Issues
```bash
# Test basic connectivity
ping -c 4 service-name

# Check routing
ip route

# Test port
nc -zv service-name 8080

# Trace route
traceroute service-name

# Check network interfaces
ip addr show
```

### Service Discovery Issues
```bash
# List environment variables (Kubernetes injects service info)
env | grep SERVICE

# Check service endpoints
nslookup service-name.namespace.svc.cluster.local

# Test with IP directly
curl http://10.0.0.5:8080
```

### Performance Issues
```bash
# Network throughput (requires iperf3 server)
iperf3 -c server-host

# Latency test
mtr --report service-host

# DNS lookup time
time nslookup service-name
```
