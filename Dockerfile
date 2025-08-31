# Multi-stage Dockerfile for Django 5 application
# Supports multi-architecture builds with Python 3.12.5
# Last updated: 2025-08-30 22:40:55 UTC by nullroute-commits

ARG PYTHON_VERSION=3.12.5
ARG BUILDPLATFORM=linux/amd64
ARG TARGETPLATFORM=linux/amd64

# Base stage with Python and system dependencies
FROM python:${PYTHON_VERSION}-slim as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libbz2-dev \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    curl \
    wget \
    git \
    netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app user
RUN groupadd -r app && useradd -r -g app app

# Development stage
FROM base as development

# Install development dependencies
COPY requirements/development.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy application code
COPY . /app/

# Create necessary directories
RUN mkdir -p /app/logs /app/staticfiles /app/media && \
    chown -R app:app /app

# Set permissions for entrypoint script
COPY docker-entrypoint-dev.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER app

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Testing stage
FROM base as testing

# Install test dependencies
COPY requirements/test.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy application code
COPY . /app/

# Create necessary directories
RUN mkdir -p /app/logs /app/staticfiles /app/media && \
    chown -R app:app /app

# Set permissions for entrypoint script
COPY docker-entrypoint-test.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER app

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "manage.py", "test"]

# Production stage
FROM base as production

# Install production dependencies
COPY requirements/production.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy application code
COPY . /app/

# Create necessary directories and set permissions
RUN mkdir -p /app/logs /app/staticfiles /app/media && \
    chown -R app:app /app

# Collect static files
RUN python manage.py collectstatic --noinput || true

# Set permissions for entrypoint script
COPY docker-entrypoint-prod.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER app

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--worker-class", "sync", "--max-requests", "1000", "--timeout", "30", "config.wsgi:application"]

# Default stage (production)
FROM production