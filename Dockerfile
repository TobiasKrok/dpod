FROM alpine:latest

# Install debugging and networking tools
RUN apk add --no-cache \
    # Basic networking tools
    curl \
    wget \
    bind-tools \
    nmap \
    nmap-scripts \
    tcpdump \
    iperf3 \
    mtr \
    socat \
    netcat-openbsd \
    # DNS and network diagnostics
    iputils \
    iproute2 \
    net-tools \
    bridge-utils \
    # HTTP/API testing
    httpie \
    # Text editors
    vim \
    nano \
    # Utilities
    bash \
    git \
    jq \
    yq \
    tree \
    htop \
    procps \
    coreutils \
    findutils \
    grep \
    # Database clients
    postgresql-client \
    mysql-client \
    redis \
    # TLS/SSL tools
    openssl \
    ca-certificates \
    # Additional useful tools
    busybox-extras \
    strace \
    file \
    unzip \
    tar \
    gzip

# Install grpcurl for gRPC debugging
RUN wget -qO- https://github.com/fullstorydev/grpcurl/releases/download/v1.9.1/grpcurl_1.9.1_linux_x86_64.tar.gz | \
    tar -xz -C /usr/local/bin grpcurl && \
    chmod +x /usr/local/bin/grpcurl

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /root

# Keep container running
CMD ["/bin/bash", "-c", "trap : TERM INT; sleep infinity & wait"]
