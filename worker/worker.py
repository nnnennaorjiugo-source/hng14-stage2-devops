import os
import time

import redis

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
REDIS_QUEUE = os.getenv("REDIS_QUEUE", "job")

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)


def process_job(job_id):
    print(f"Processing job {job_id}")
    time.sleep(2)
    r.hset(f"job:{job_id}", "status", "completed")
    print(f"Done: {job_id}")


while True:
    job = r.brpop(REDIS_QUEUE, timeout=5)
    if job:
        _, job_id = job
        process_job(job_id.decode())