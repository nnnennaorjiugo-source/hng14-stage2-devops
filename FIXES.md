# FIXES

## 1. Frontend hardcoded API URL
- File: `frontend/app.js`
- Problem: `API_URL` is hardcoded to `http://localhost:8000`
- Why it is wrong: inside containers, `localhost` points to the same container, not the API service
- Planned fix: read `API_URL` from environment variables

## 2. Frontend hardcoded listen port
- File: `frontend/app.js`
- Problem: app listens on port `3000` directly
- Why it is wrong: service configuration should come from environment variables
- Planned fix: read the frontend port from an environment variable

## 3. API hardcoded Redis host and port
- File: `api/main.py`
- Problem: Redis is configured as `host="localhost", port=6379`
- Why it is wrong: inside containers, the API container cannot reach Redis via localhost
- Planned fix: read `REDIS_HOST` and `REDIS_PORT` from environment variables

## 4. Worker hardcoded Redis host and port
- File: `worker/worker.py`
- Problem: Redis is configured as `host="localhost", port=6379`
- Why it is wrong: inside containers, the worker container cannot reach Redis via localhost
- Planned fix: read `REDIS_HOST` and `REDIS_PORT` from environment variables

## 5. Source files are minified into single lines
- Files: `frontend/app.js`, `api/main.py`, `worker/worker.py`
- Problem: source code is stored as single-line files
- Why it is wrong: hard to read, lint, test, maintain, and document with precise line-based fixes
- Planned fix: reformat files into normal readable source code before continuing

## 6. Frontend hardcoded API URL
- File: `frontend/app.js`
- Problem: `API_URL` was hardcoded to `http://localhost:8000`
- What I changed: replaced it with `process.env.API_URL || "http://api:8000"`
- Why it mattered: in containers, `localhost` points to the same container, not the API service

## 7. Frontend hardcoded port
- File: `frontend/app.js`
- Problem: frontend listened on port `3000` directly
- What I changed: replaced it with `process.env.FRONTEND_PORT || 3000`
- Why it mattered: configuration should come from environment variables

## 8. API hardcoded Redis host and port
- File: `api/main.py`
- Problem: Redis used `host="localhost", port=6379`
- What I changed: replaced it with `REDIS_HOST`, `REDIS_PORT`, and `REDIS_QUEUE` from environment variables
- Why it mattered: the API container will not reach Redis on localhost

## 9. Worker hardcoded Redis host and port
- File: `worker/worker.py`
- Problem: Redis used `host="localhost", port=6379`
- What I changed: replaced it with `REDIS_HOST`, `REDIS_PORT`, and `REDIS_QUEUE` from environment variables
- Why it mattered: the worker container will not reach Redis on localhost

## 10. Added API health endpoint
- File: `api/main.py`
- Problem: no simple health endpoint for container health checks
- What I changed: added `GET /health`
- Why it mattered: needed later for Docker health checks and deployment validation

## 11. Reformatted one-line source files
- Files: `frontend/app.js`, `api/main.py`, `worker/worker.py`
- Problem: files were shipped as one-line source code
- What I changed: reformatted them into readable multi-line files
- Why it mattered: easier to maintain, lint, test, and document with precise fixes