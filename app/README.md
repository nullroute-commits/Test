# Legacy Django Implementation

## ⚠️ Important Notice

This directory contains a **legacy Django 5 implementation** that is **NOT currently deployed or used** in the production system.

## Current State

- **Status:** Legacy/Reference Code
- **Framework:** Django 5.0.2
- **Purpose:** Historical reference and potential future migration source
- **Lines of Code:** ~2,196 lines

## What's Here

This directory contains a complete Django application with:

### Core Components (`app/core/`)

1. **Models (`models.py`)** - 250+ lines
   - User model with RBAC support
   - Role and Permission models
   - AuditLog model for audit trails
   - System configuration models
   - All using SQLAlchemy with PostgreSQL

2. **RBAC System (`rbac.py`)** - 450+ lines
   - Role-based access control implementation
   - Permission checking and validation
   - Caching layer integration
   - Session management

3. **Audit System (`audit.py`)** - 530+ lines
   - Comprehensive audit logging
   - Model change tracking
   - Request/response logging
   - Authentication event logging

4. **Database Connection (`db/connection.py`)** - 130+ lines
   - SQLAlchemy connection management
   - Session handling
   - Connection pooling

5. **Cache Layer (`cache/memcached.py`)** - 120+ lines
   - Memcached integration
   - Caching strategies
   - Cache invalidation

6. **Queue System (`queue/rabbitmq.py`)** - 100+ lines
   - RabbitMQ integration
   - Message publishing
   - Queue management

### Configuration (`app/settings.py`)

Complete Django settings with:
- PostgreSQL 17 database configuration
- Memcached caching setup
- RabbitMQ message broker configuration
- Security settings
- Logging configuration
- RBAC and audit settings

## Why Is This Here?

This code represents a previous Django-based implementation of the system. It contains:

- ✅ Well-implemented RBAC (Role-Based Access Control)
- ✅ Comprehensive audit logging system
- ✅ Database models and relationships
- ✅ Caching and queue integration
- ✅ Production-ready configuration

## Current Production System

The **actual deployed application** uses:

- **Framework:** FastAPI (Python 3.13)
- **Location:** `src/` directory
- **Server:** Uvicorn (async ASGI)
- **Database:** PostgreSQL 17 with async SQLAlchemy
- **Cache:** Redis
- **Task Queue:** Async background workers

See `src/api/main.py` for the current FastAPI application.

## Relationship to Requirements

### Conflict Alert

There are TWO sets of dependencies in this repository:

1. **`requirements/` directory** - Django dependencies (this legacy code)
   - Django==5.0.2
   - sqlalchemy==1.4.49
   - python-memcached==1.59
   - pika==1.3.2 (RabbitMQ)
   
2. **`pyproject.toml`** - FastAPI dependencies (current production)
   - fastapi==0.115.4
   - uvicorn==0.32.1
   - sqlalchemy==2.0.36 (async)
   - redis==5.2.0

The `pyproject.toml` dependencies are what's actually used in production.

## Should This Be Deleted?

**Not necessarily.** This code could be valuable as:

1. **Reference Implementation** - Shows how RBAC and audit systems were designed
2. **Migration Source** - Could be ported to FastAPI if needed
3. **Feature Documentation** - Documents business logic and requirements
4. **Historical Record** - Preserves architectural decisions

However, it should be clearly marked as legacy and not actively maintained.

## How to Use This Code

### If you want to run the Django version:

```bash
# Install Django dependencies
pip install -r requirements/development.txt

# Run migrations
python manage.py migrate

# Start development server
python manage.py runserver
```

**Note:** This will conflict with the FastAPI application which also runs on port 8000.

### If you want to reference the code:

- Look at `app/core/models.py` for data model designs
- Check `app/core/rbac.py` for RBAC implementation patterns
- Review `app/core/audit.py` for audit logging strategies

## Migration Path

If you need to port features from this Django implementation to FastAPI:

1. **Models:** Convert Django/SQLAlchemy models to async SQLAlchemy in `src/models/`
2. **RBAC:** Implement as FastAPI dependencies and middleware
3. **Audit:** Use FastAPI middleware and async logging
4. **Cache:** Replace Memcached with Redis async client
5. **Queue:** Replace RabbitMQ with async task workers

## Recommended Action

Consider one of these options:

1. **Archive:** Move to `legacy/` or `archive/` directory with timestamp
2. **Document:** Keep as-is with this README for reference
3. **Port:** Gradually migrate useful features to FastAPI implementation
4. **Remove:** Delete if no longer needed (ensure git history is preserved)

---

**Last Updated:** 2025-12-04  
**Maintained:** No (Legacy Code)  
**Production Use:** No (FastAPI is used instead)
