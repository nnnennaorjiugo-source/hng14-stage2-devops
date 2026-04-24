#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${IMAGE_TAG:-latest}"

echo "Starting simulated rolling deployment..."

docker network create stage2-deploy || true

docker run -d --name redis-deploy --network stage2-deploy redis:7-alpine

docker build -t api-new:${IMAGE_TAG} ./api
docker build -t worker-new:${IMAGE_TAG} ./worker
docker build -t frontend-new:${IMAGE_TAG} ./frontend

docker run -d --name api-new \
  --network stage2-deploy \
  -e REDIS_HOST=redis-deploy \
  -e REDIS_PORT=6379 \
  -e REDIS_QUEUE=job \
  api-new:${IMAGE_TAG}

echo "Waiting for new API health check..."

for i in {1..30}; do
  if docker exec api-new python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health')" 2>/dev/null; then
    echo "New API is healthy"
    break
  fi

  if [ "$i" -eq 30 ]; then
    echo "New API failed health check within 60 seconds"
    docker logs api-new || true
    exit 1
  fi

  sleep 2
done

docker run -d --name worker-new \
  --network stage2-deploy \
  -e REDIS_HOST=redis-deploy \
  -e REDIS_PORT=6379 \
  -e REDIS_QUEUE=job \
  worker-new:${IMAGE_TAG}

docker run -d --name frontend-new \
  --network stage2-deploy \
  -p 3000:3000 \
  -e FRONTEND_PORT=3000 \
  -e API_URL=http://api-new:8000 \
  frontend-new:${IMAGE_TAG}

echo "Waiting for new frontend health check..."

for i in {1..30}; do
  if curl -fsS http://localhost:3000/ >/dev/null; then
    echo "New frontend is healthy"
    break
  fi

  if [ "$i" -eq 30 ]; then
    echo "New frontend failed health check within 60 seconds"
    docker logs frontend-new || true
    exit 1
  fi

  sleep 2
done

echo "New version passed health checks. Rolling deployment successful."

docker rm -f frontend-old api-old worker-old 2>/dev/null || true
docker rename frontend-new frontend-old
docker rename api-new api-old
docker rename worker-new worker-old