# Kubernetes Debug Pod

A comprehensive debugging container image for Kubernetes troubleshooting, packed with essential networking and debugging tools.

## Included Tools

### Networking & DNS
- `curl`, `wget` - HTTP clients
- `nslookup`, `dig`, `host` - DNS lookup tools
- `ping`, `traceroute`, `mtr` - Network connectivity testing
- `netcat` (nc) - TCP/UDP connections
- `socat` - Advanced data relay
- `tcpdump` - Network packet analyzer
- `nmap` - Network scanner
- `iperf3` - Network performance testing

### HTTP/API Testing
- `httpie` - User-friendly HTTP client
- `grpcurl` - gRPC client

### Database Clients
- `psql` - PostgreSQL client
- `mysql` - MySQL/MariaDB client
- `redis-cli` - Redis client

### Utilities
- `bash`, `vim`, `nano` - Shell and text editors
- `jq`, `yq` - JSON/YAML processors
- `git` - Version control
- `htop` - Process viewer
- `strace` - System call tracer
- `openssl` - TLS/SSL toolkit

## Usage

### Deploy as a Pod

```bash
kubectl run debug-pod --image=ghcr.io/YOUR_USERNAME/k8s-debug:latest --restart=Never -- sleep infinity
```

### Interactive Shell

```bash
kubectl exec -it debug-pod -- /bin/bash
```

### Deploy with YAML

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
spec:
  containers:
  - name: debug
    image: ghcr.io/YOUR_USERNAME/k8s-debug:latest
    command: ["/bin/bash", "-c", "sleep infinity"]
```

### Common Debugging Tasks

```bash
# DNS lookup
nslookup service-name.namespace.svc.cluster.local

# Test HTTP endpoint
curl -v http://service-name:port/health

# Check connectivity
nc -zv service-name port

# Network trace
tcpdump -i any -n host service-ip

# Test database connection
psql -h postgres-service -U username -d database
```

## Building and Publishing

This image is automatically built and published to GitHub Container Registry (GHCR) using GitHub Actions.

### Automatic Builds

The image is automatically built and pushed when:
- **Push to main/master**: Creates `latest` tag
- **Version tags**: Push a tag like `v1.0.0` to create version-specific tags
- **Manual trigger**: Use "Run workflow" in GitHub Actions tab

### Setup Instructions

1. **Fork or create this repository on GitHub**

2. **Enable GitHub Actions**
   - Go to your repository settings
   - Navigate to Actions → General
   - Ensure "Allow all actions and reusable workflows" is enabled

3. **Make package public (optional)**
   - After first build, go to your GitHub profile → Packages
   - Click on the `k8s-debug` package
   - Go to Package settings → Change visibility → Public

4. **Trigger a build**
   ```bash
   # Method 1: Push to main branch
   git push origin main

   # Method 2: Create a version tag
   git tag v1.0.0
   git push origin v1.0.0

   # Method 3: Use GitHub UI
   # Go to Actions tab → Build and Push to GHCR → Run workflow
   ```

### Manual Build (if needed)

```bash
docker build -t ghcr.io/YOUR_USERNAME/dpod:latest .
docker push ghcr.io/YOUR_USERNAME/dpod:latest
```
