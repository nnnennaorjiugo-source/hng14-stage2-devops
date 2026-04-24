# Stage 2 DevOps – Containerized Job System

## What this project is

A simple microservices system with:

* Frontend (Node.js) → submit jobs & check status
* API (FastAPI) → creates jobs
* Worker (Python) → processes jobs
* Redis → queue between API and worker

The goal is to show how to run, test, and deploy a system, not just build it.

---

## Prerequisites

Make sure you have:

* Docker
* Docker Compose
* Git

---

## How to run from scratch

### 1. Clone the repo

git clone https://github.com/nnnennaorjiugo-source/hng14-stage2-devops.git
cd hng14-stage2-devops

### 2. Start the full stack

docker compose up --build

---

## What success looks like

If everything is working:

* Open:
  http://localhost:3000

* You should see logs like:

Frontend running on port 3000
Uvicorn running on http://0.0.0.0:8000
Redis ready to accept connections

---

## Quick test

### Submit a job

curl -X POST http://localhost:3000/submit

You should get:

{
"job_id": "some-id"
}

---

### Check job status

curl http://localhost:3000/status/<job_id>

First:

{
"status": "queued"
}

Then after a few seconds:

{
"status": "completed"
}

If you see this transition, the system is working correctly.

---

## Environment variables

Example (.env.example):

FRONTEND_PORT=3000
API_URL=http://api:8000
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_QUEUE=job

---

## Notes

* All services run inside Docker
* Redis is internal (not exposed)
* No secrets are stored in the repo
* Configuration is environment-based

---

## Repository

https://github.com/nnnennaorjiugo-source/hng14-stage2-devops
