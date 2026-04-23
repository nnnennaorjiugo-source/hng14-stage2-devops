FROM python:3.12-alpine

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY worker.py .

RUN chown -R appuser:appgroup /app

USER appuser

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c "import os, redis; r=redis.Redis(host=os.getenv('REDIS_HOST','redis'), port=int(os.getenv('REDIS_PORT','6379'))); r.ping()" || exit 1

CMD ["python", "worker.py"]