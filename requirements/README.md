# Legacy Django Requirements

## ⚠️ Important Notice

These requirement files are for the **legacy Django implementation** and are **NOT used in production**.

## Current Production Dependencies

The actual production application uses **`pyproject.toml`** at the root of the repository with FastAPI dependencies.

## What's in These Files

### base.txt
```
Django==5.0.2
sqlalchemy==1.4.49
psycopg2-binary==2.9.9
python-memcached==1.59
pika==1.3.2
gunicorn==23.0.0
```

### development.txt
- Inherits from base.txt
- Adds: black, flake8, mypy, django-stubs, pytest, pytest-django

### production.txt
- Inherits from base.txt
- Adds: sentry-sdk, django-pylibmc, pylibmc, uwsgi

### test.txt
- Inherits from base.txt
- Testing dependencies

## Why These Exist

These requirements correspond to the Django application in the `app/` directory, which is legacy code not currently deployed.

## Actual Production Requirements

Production uses **pyproject.toml** with:
- **fastapi==0.115.4** (instead of Django)
- **uvicorn==0.32.1** (instead of Gunicorn/uWSGI)
- **sqlalchemy==2.0.36** (async version, not 1.4.49)
- **redis==5.2.0** (instead of Memcached)
- No RabbitMQ (pika) - uses async workers instead

## Installation Warning

**DO NOT** install these requirements for production deployment:

```bash
# ❌ WRONG - This installs Django (legacy)
pip install -r requirements/base.txt

# ✅ CORRECT - This installs FastAPI (current)
pip install -e ".[dev]"
```

## Recommended Action

1. **Keep for reference** - If the Django code in `app/` is kept for reference
2. **Move to legacy/** - Archive these with the Django code
3. **Delete** - If Django implementation is no longer needed

## Migration Notes

The Django requirements have these conflicts with FastAPI requirements:

| Package | Django (Legacy) | FastAPI (Current) |
|---------|----------------|-------------------|
| Web Framework | Django 5.0.2 | FastAPI 0.115.4 |
| Server | Gunicorn/uWSGI | Uvicorn |
| SQLAlchemy | 1.4.49 | 2.0.36 (async) |
| Cache | Memcached | Redis |
| Queue | RabbitMQ (pika) | Async workers |

You cannot install both sets of dependencies simultaneously without conflicts.

---

**Last Updated:** 2025-12-04  
**Production Use:** No (Use pyproject.toml instead)  
**Status:** Legacy/Reference Only
