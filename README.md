# Django 5 Multi-Architecture CI/CD Pipeline

A comprehensive Django 5 application with SQLAlchemy, PostgreSQL 17, RBAC (Role-Based Access Control), audit logging, and containerized CI/CD pipeline using Docker Compose.

## Overview

This project demonstrates a production-ready Django 5 application with the following features:

- **Django 5.0.2** with Python 3.12.5
- **PostgreSQL 17.2** database with optimized configuration
- **SQLAlchemy 1.4.49** for advanced ORM capabilities
- **Memcached 1.6.22** for high-performance caching
- **RabbitMQ 3.12.8** for message queuing and async processing
- **RBAC System** for fine-grained access control
- **Audit Logging** for comprehensive activity tracking
- **Multi-architecture Docker support** (linux/amd64, linux/arm64)
- **Containerized CI/CD pipeline** using Docker Compose
- **Code quality tools** (Black, Flake8, MyPy)

## Quick Start

### Prerequisites

- Docker 24.0.7+
- Docker Compose 2.18.1+
- Git

### Development Environment

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nullroute-commits/Test.git
   cd Test
   ```

2. **Start development environment:**
   ```bash
   ./scripts/start-dev.sh
   ```

3. **Access the application:**
   - Django App: http://localhost:8000
   - Admin Panel: http://localhost:8000/admin (admin/admin123)
   - Database Admin: http://localhost:8080
   - RabbitMQ Management: http://localhost:15672 (guest/guest)
   - Mailhog: http://localhost:8025

### Testing

Run the complete test suite:
```bash
./scripts/start-test.sh
```

Run specific test types:
```bash
# Unit tests only
docker-compose -f ci/docker-compose.ci.yml run unit-tests

# Integration tests only
docker-compose -f ci/docker-compose.ci.yml run integration-tests

# Code quality checks
docker-compose -f ci/docker-compose.ci.yml run lint-check
```

### Production Deployment

1. **Configure environment:**
   ```bash
   cp environments/.env.production.example environments/.env.production
   # Edit the file with production values
   ```

2. **Deploy:**
   ```bash
   ./scripts/start-prod.sh
   ```

## Architecture

### System Components

```
┌───────────────────────────────────────────────────────────────────────────┐
│                           Presentation Layer                               │
│                                                                           │
│    ┌─────────────┐     ┌────────────────┐      ┌────────────────┐        │
│    │ Nginx 1.24  │────▶│ Django 5.0.2   │      │ Admin Interface│        │
│    │ Load Balancer│     │ Web Application│      │ Management     │        │
│    └─────────────┘     └────────────────┘      └────────────────┘        │
└───────────────────────────────────────────────────────────────────────────┘
                                    │
┌───────────────────────────────────────────────────────────────────────────┐
│                           Application Layer                                │
│                                                                           │
│    ┌───────────────┐     ┌────────────────┐      ┌────────────────┐      │
│    │ RBAC System   │     │ Audit Logging  │      │ Business Logic │      │
│    │ Authorization │     │ Activity Track │      │ Django Apps    │      │
│    └───────────────┘     └────────────────┘      └────────────────┘      │
└───────────────────────────────────────────────────────────────────────────┘
                                    │
┌───────────────────────────────────────────────────────────────────────────┐
│                           Data Layer                                       │
│                                                                           │
│    ┌───────────────┐     ┌────────────────┐      ┌────────────────┐      │
│    │ PostgreSQL 17 │     │ Memcached      │      │ RabbitMQ       │      │
│    │ Database      │     │ Cache          │      │ Message Broker │      │
│    └───────────────┘     └────────────────┘      └────────────────┘      │
└───────────────────────────────────────────────────────────────────────────┘
```

### Key Features

#### RBAC (Role-Based Access Control)
- User, Role, and Permission models
- Hierarchical permission system
- Cached permission checks for performance
- Decorator-based access control

#### Audit Logging
- Comprehensive activity tracking
- Model change detection
- Request/response logging
- User authentication monitoring
- Sensitive data sanitization

#### Caching and Message Queuing

**Memcached:**
- Distributed memory caching system
- Connection pooling for efficient resource usage
- Automatic key namespacing to prevent collisions
- Configurable timeout handling
- Cache decorator for easy function result caching

**RabbitMQ:**
- Message broker for asynchronous processing
- Durable queues and messages for reliability
- Dead-letter queues for failed message handling
- Automatic reconnection for fault tolerance
- Task queue decorator for easy asynchronous execution

#### Multi-Architecture Support
- Supports linux/amd64 and linux/arm64 platforms
- Docker Buildx for cross-platform builds
- Optimized images for each architecture

## Development

### Code Quality

The project enforces high code quality standards:

```bash
# Format code
black app/ config/ --line-length 120

# Lint code
flake8 app/ config/ --max-line-length=120

# Type checking
mypy app/ config/

# Security scanning
bandit -r app/ -f json
safety check -r requirements/base.txt
```

### Pre-commit Hooks

Install pre-commit hooks to ensure code quality:
```bash
./scripts/pre-commit.sh
git config core.hooksPath scripts/
```

### Environment Configuration

The application uses environment-specific configuration:

- **Development:** `config/settings/development.py`
- **Testing:** `config/settings/testing.py`
- **Production:** `config/settings/production.py`

Environment variables are organized in separate files:
- `.env.app` - Application settings
- `.env.db` - Database configuration
- `.env.cache` - Memcached settings
- `.env.queue` - RabbitMQ configuration
- `.env.security` - Security settings
- `.env.logging` - Logging configuration

## CI/CD Pipeline

### Containerized Pipeline

The CI/CD pipeline runs entirely in Docker containers:

```bash
# Run full CI pipeline
docker-compose -f ci/docker-compose.ci.yml up

# Individual pipeline stages
docker-compose -f ci/docker-compose.ci.yml run ci-runner lint
docker-compose -f ci/docker-compose.ci.yml run ci-runner test
docker-compose -f ci/docker-compose.ci.yml run ci-runner build
docker-compose -f ci/docker-compose.ci.yml run ci-runner deploy staging
```

### Pipeline Stages

1. **Lint:** Code quality checks (Black, Flake8, MyPy, Bandit)
2. **Test:** Unit and integration tests with coverage
3. **Build:** Multi-architecture Docker image builds
4. **Security:** Vulnerability scanning
5. **Deploy:** Environment-specific deployments

### Promotion Workflow

```bash
# Promote to test environment
./ci/scripts/promote-to-test.sh

# Promote to production
./ci/scripts/promote-to-release.sh
```

## API Documentation

### Health Check
```
GET /health/
```
Returns application health status.

### Admin Interface
```
GET /admin/
```
Django admin interface for user and system management.

## Security

### Security Features
- HTTPS/TLS support
- CSRF protection
- XSS prevention
- SQL injection protection
- Rate limiting
- Session security
- Input validation
- Output encoding

### Security Headers
- X-Frame-Options
- X-Content-Type-Options
- X-XSS-Protection
- Content-Security-Policy
- Strict-Transport-Security

## Monitoring and Logging

### Logging
- Structured logging with JSON format
- Log rotation and archival
- Centralized log aggregation
- Error tracking with Sentry (production)

### Monitoring
- Health check endpoints
- Prometheus metrics (production)
- Database performance monitoring
- Cache hit/miss ratios
- Queue depth monitoring

## Deployment

### Environment-Specific Deployments

**Development:**
```bash
docker-compose -f docker-compose.development.yml up
```

**Testing:**
```bash
docker-compose -f docker-compose.testing.yml up
```

**Production:**
```bash
docker-compose -f docker-compose.production.yml up
```

### Scaling

Scale web workers:
```bash
docker-compose -f docker-compose.production.yml up -d --scale web=3
```

## Troubleshooting

### Common Issues

1. **Database Connection Issues:**
   ```bash
   # Check database logs
   docker-compose logs db
   
   # Test connection
   docker-compose exec web python manage.py dbshell
   ```

2. **Cache Issues:**
   ```bash
   # Check Memcached status
   docker-compose exec memcached echo "stats" | nc localhost 11211
   ```

3. **Queue Issues:**
   ```bash
   # Check RabbitMQ status
   docker-compose exec rabbitmq rabbitmqctl status
   ```

### Debug Mode

Enable debug logging:
```bash
export LOG_LEVEL=DEBUG
export DJANGO_LOG_LEVEL=DEBUG
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following code quality standards
4. Run tests and ensure they pass
5. Submit a pull request

### Development Workflow

1. **Setup:** `./scripts/start-dev.sh`
2. **Test:** `./scripts/start-test.sh`
3. **Lint:** `./ci/lint.sh`
4. **Build:** `./ci/build.sh`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For questions and support:
- GitHub Issues: [https://github.com/nullroute-commits/Test/issues](https://github.com/nullroute-commits/Test/issues)
- Documentation: See the `docs/` directory for detailed documentation

---

**Last updated:** 2025-08-30 22:40:55 UTC by nullroute-commits