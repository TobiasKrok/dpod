# Steps to Build and Push to GitHub Container Registry (GHCR)

## Prerequisites

1. **Enable Docker in WSL2**
   - Open Docker Desktop
   - Go to Settings → Resources → WSL Integration
   - Enable integration for your WSL distro
   - Click "Apply & Restart"

2. **GitHub Personal Access Token**
   - Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a name (e.g., "GHCR Push Token")
   - Select scopes:
     - `write:packages` (to upload packages)
     - `read:packages` (to download packages)
     - `delete:packages` (optional, to delete packages)
   - Click "Generate token"
   - **IMPORTANT**: Copy the token immediately (you won't see it again!)

## Step-by-Step Build and Push Process

### Step 1: Login to GHCR

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username:

```bash
# Export your token (replace with your actual token)
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

You should see: `Login Succeeded`

### Step 2: Build the Docker Image

```bash
# Navigate to the directory with the Dockerfile
cd /mnt/c/Git

# Build the image (replace YOUR_GITHUB_USERNAME)
docker build -t ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest .
```

This will take a few minutes as it downloads the base image and installs all tools.

### Step 3: (Optional) Test the Image Locally

```bash
# Run the container
docker run -it --rm ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest /bin/bash

# Inside the container, test some tools:
curl --version
nslookup google.com
jq --version

# Exit when done
exit
```

### Step 4: Push to GHCR

```bash
# Push the image
docker push ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest
```

### Step 5: Make the Package Public (Optional but Recommended)

1. Go to GitHub → Your Profile → Packages
2. Find `k8s-debug`
3. Click on it
4. Go to "Package settings" (right side)
5. Scroll down to "Change package visibility"
6. Click "Change visibility"
7. Select "Public"
8. Type the package name to confirm
9. Click "I understand, change package visibility"

## Quick Commands (All-in-One)

```bash
# Set your variables
export GITHUB_USERNAME=YOUR_GITHUB_USERNAME
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Login
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

# Build
cd /mnt/c/Git
docker build -t ghcr.io/$GITHUB_USERNAME/k8s-debug:latest .

# Push
docker push ghcr.io/$GITHUB_USERNAME/k8s-debug:latest
```

## Version Tagging (Best Practice)

It's good practice to tag versions:

```bash
# Build and tag with version
docker build -t ghcr.io/$GITHUB_USERNAME/k8s-debug:v1.0.0 .
docker tag ghcr.io/$GITHUB_USERNAME/k8s-debug:v1.0.0 ghcr.io/$GITHUB_USERNAME/k8s-debug:latest

# Push both tags
docker push ghcr.io/$GITHUB_USERNAME/k8s-debug:v1.0.0
docker push ghcr.io/$GITHUB_USERNAME/k8s-debug:latest
```

## Using the Image in Kubernetes

### Option 1: Quick Debug Pod

```bash
# Replace YOUR_GITHUB_USERNAME
kubectl run debug-pod \
  --image=ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest \
  --restart=Never \
  -- sleep infinity

# Exec into it
kubectl exec -it debug-pod -- /bin/bash
```

### Option 2: Using YAML

Create `debug-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
  labels:
    app: debug
spec:
  containers:
  - name: debug
    image: ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest
    command: ["/bin/bash"]
    args: ["-c", "sleep infinity"]
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "500m"
```

Apply it:

```bash
kubectl apply -f debug-pod.yaml
kubectl exec -it debug-pod -- /bin/bash
```

### Option 3: Deploy in Specific Namespace

```bash
kubectl run debug-pod \
  --image=ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest \
  --namespace=production \
  --restart=Never \
  -- sleep infinity
```

### Option 4: For Private Images

If you keep the package private, create a secret:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_TOKEN \
  --docker-email=YOUR_EMAIL
```

Then use it in your pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
spec:
  imagePullSecrets:
  - name: ghcr-secret
  containers:
  - name: debug
    image: ghcr.io/YOUR_GITHUB_USERNAME/k8s-debug:latest
    command: ["/bin/bash"]
    args: ["-c", "sleep infinity"]
```

## Troubleshooting

### "Cannot connect to Docker daemon"
```bash
# Check Docker is running
docker ps

# If not working, restart Docker Desktop or run:
sudo service docker start
```

### "unauthorized: authentication required"
```bash
# Make sure you're logged in
docker login ghcr.io

# Check your token has correct permissions
```

### "denied: installation not allowed to Write organization package"
```bash
# Make sure you're using your personal username, not an organization
# Or get admin access to the organization
```

## Cleanup

```bash
# Remove local image
docker rmi ghcr.io/$GITHUB_USERNAME/k8s-debug:latest

# Delete from Kubernetes
kubectl delete pod debug-pod

# Logout from GHCR
docker logout ghcr.io
```
