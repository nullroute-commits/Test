# Pipeline Executor Dockerfile
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    jq \
    make \
    gcc \
    g++ \
    docker.io \
    docker-compose \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies for CI/CD
COPY pyproject.toml /tmp/
RUN cd /tmp && \
    pip install --no-cache-dir -e ".[dev,security,docs]" && \
    pip install --no-cache-dir \
    ansible==9.9.0 \
    ansible-core==2.16.10 \
    docker-py \
    pre-commit

# Create working directory
WORKDIR /workspace

# Copy pipeline scripts
COPY docker/pipeline-executor/scripts /scripts
RUN chmod +x /scripts/*

# Set up pre-commit hooks cache
ENV PRE_COMMIT_HOME=/cache/pre-commit

ENTRYPOINT ["/scripts/entrypoint.sh"]