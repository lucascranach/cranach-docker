FROM alpine:3.20

# Install necessary tools
RUN apk add --no-cache \
    curl \
    ca-certificates \
    gettext \
    tar

# Set Alertmanager version
ENV ALERTMANAGER_VERSION=0.28.1

# Download and extract Alertmanager
RUN curl -L https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz | \
    tar xz && \
    mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/alertmanager /bin/ && \
    mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool /bin/ && \
    rm -rf alertmanager-${ALERTMANAGER_VERSION}*

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /etc/alertmanager

ENTRYPOINT ["/entrypoint.sh"]