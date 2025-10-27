# Complete Setup Guide

This guide walks you through setting up automated builds for the Kubernetes debug pod image using GitHub Actions and GHCR.

## Prerequisites

- GitHub account
- Git installed locally
- (Optional) Docker installed for local testing

## Step 1: Create GitHub Repository

### Option A: Create New Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the "+" icon → "New repository"
3. Repository name: `dpod` (or your preferred name)
4. Description: "Kubernetes debugging pod with networking tools"
5. Choose Public or Private
6. Click "Create repository"

### Option B: Use Existing Repository

If you already have a repository, you can use it. The dpod directory can be:
- At the root of your repository, or
- In a subdirectory (you'll need to adjust the Dockerfile path in the workflow)

## Step 2: Push Code to GitHub

```bash
# Navigate to dpod directory
cd /mnt/c/Git/dpod

# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Kubernetes debug pod with networking tools"

# Add remote (replace YOUR_USERNAME and REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Verify GitHub Actions Workflow

1. Go to your repository on GitHub
2. Click on the "Actions" tab
3. You should see the "Build and Push to GHCR" workflow running
4. Click on it to see the build progress

**Note**: The workflow has necessary permissions (`packages: write`) already configured, so no additional setup is needed!

## Step 4: Wait for Build to Complete

The first build will:
- Set up the build environment
- Build the Docker image for both `linux/amd64` and `linux/arm64`
- Push to GitHub Container Registry
- Create attestations for supply chain security

This typically takes 3-5 minutes.

## Step 5: Make Package Public (Recommended)

By default, packages are private. To make it public:

1. Go to your GitHub profile (click your avatar → Your profile)
2. Click on "Packages" tab
3. Find and click on the package (it might be named `dpod` or your repo name)
4. Click "Package settings" (on the right sidebar)
5. Scroll to "Danger Zone" → "Change package visibility"
6. Click "Change visibility"
7. Select "Public"
8. Type the package name to confirm
9. Click "I understand the consequences, change package visibility"

## Step 6: Use Your Image

### Get the Image URL

Your image URL will be:
```
ghcr.io/YOUR_USERNAME/REPO_NAME:latest
```

For example, if your username is `johndoe` and repo is `dpod`:
```
ghcr.io/johndoe/dpod:latest
```

### Deploy in Kubernetes

```bash
# Quick deployment
kubectl run debug-pod \
  --image=ghcr.io/YOUR_USERNAME/REPO_NAME:latest \
  --restart=Never \
  -- sleep infinity

# Access the pod
kubectl exec -it debug-pod -- /bin/bash

# Inside the pod, test tools
nslookup google.com
curl https://api.github.com
```

## Step 7: Create Version Releases (Optional)

To create versioned releases:

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
```

This will create multiple tags in GHCR:
- `v1.0.0`
- `1.0.0`
- `1.0`
- `1`
- `latest`

## Using Private Images

If you keep your package private, you need to authenticate Kubernetes:

### Create Image Pull Secret

```bash
# Create GitHub token with read:packages scope
# Go to GitHub → Settings → Developer settings → Personal access tokens

# Create secret in Kubernetes
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_TOKEN \
  --docker-email=YOUR_EMAIL

# Or create in specific namespace
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_TOKEN \
  --docker-email=YOUR_EMAIL \
  --namespace=production
```

### Use Secret in Pod

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
    image: ghcr.io/YOUR_USERNAME/dpod:latest
    command: ["/bin/bash", "-c", "sleep infinity"]
```

## Workflow Features

The GitHub Actions workflow includes:

### Multi-Platform Builds
- Builds for `linux/amd64` (Intel/AMD)
- Builds for `linux/arm64` (ARM, Apple Silicon, AWS Graviton)

### Intelligent Tagging
- `latest` tag for main branch
- Version tags for git tags (e.g., `v1.0.0`)
- Branch-specific tags
- SHA-based tags for exact traceability

### Build Caching
- Uses GitHub Actions cache for faster builds
- Subsequent builds are much faster (30s-1min instead of 3-5min)

### Security
- Generates build attestations
- Provides supply chain provenance
- No tokens required (uses automatic `GITHUB_TOKEN`)

## Troubleshooting

### Workflow Fails with "permission denied"

The workflow requires `packages: write` permission. This is already set in the workflow file:

```yaml
permissions:
  contents: read
  packages: write
```

If it still fails, check:
1. Actions are enabled in repository settings
2. You're the repository owner (or have admin access)

### Can't Find Package

1. Check the Actions tab to see if the build succeeded
2. Go to your profile → Packages
3. The package name matches your repository name
4. Package might be private by default

### Image Pull Error in Kubernetes

```
Failed to pull image "ghcr.io/username/repo:latest": rpc error: code = Unknown desc = failed to pull and unpack image "ghcr.io/username/repo:latest": failed to resolve reference "ghcr.io/username/repo:latest": pull access denied, repository does not exist or may require authorization
```

**Solutions:**
- Make the package public (see Step 5)
- Or create an image pull secret (see "Using Private Images" above)

### Build Takes Too Long

First build takes 3-5 minutes. Subsequent builds should be faster due to caching.

To speed up:
- Remove unused tools from Dockerfile
- Use a smaller base image
- Enable layer caching (already enabled)

## Advanced: Multi-Directory Setup

If your repository has multiple projects and dpod is in a subdirectory:

1. Move the `.github` folder to repository root:
   ```bash
   mv /mnt/c/Git/dpod/.github /mnt/c/Git/.github
   ```

2. Update the workflow context:
   ```yaml
   - name: Build and push Docker image
     uses: docker/build-push-action@v5
     with:
       context: ./dpod  # Add subdirectory path
       # ... rest of config
   ```

## Next Steps

- Read [TOOL_GUIDE.md](TOOL_GUIDE.md) for detailed tool usage
- Customize the Dockerfile to add/remove tools
- Set up multiple debug images for different scenarios
- Create deployment manifests for different namespaces

## Support

For issues with:
- **The tools**: See [TOOL_GUIDE.md](TOOL_GUIDE.md)
- **GitHub Actions**: Check the Actions tab in your repository
- **GHCR**: Visit [GitHub Container Registry docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
