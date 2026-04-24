#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for frontend..."

for i in {1..30}; do
  if curl -fsS http://localhost:3000/ > /dev/null; then
    echo "Frontend is ready"
    break
  fi

  if [ "$i" -eq 30 ]; then
    echo "Frontend did not become ready"
    docker compose logs
    exit 1
  fi

  sleep 2
done

echo "Submitting job..."

JOB_RESPONSE=$(curl -sS -X POST http://localhost:3000/submit)
echo "Job response: $JOB_RESPONSE"

JOB_ID=$(echo "$JOB_RESPONSE" | python -c "import sys,json; print(json.load(sys.stdin)['job_id'])")

echo "Polling job: $JOB_ID"

timeout 60 bash -c "
while true; do
  STATUS_RESPONSE=\$(curl -sS http://localhost:3000/status/$JOB_ID)
  echo \"Status response: \$STATUS_RESPONSE\"
  STATUS=\$(echo \"\$STATUS_RESPONSE\" | python -c \"import sys,json; print(json.load(sys.stdin)['status'])\")

  if [ \"\$STATUS\" = \"completed\" ]; then
    echo 'Job completed successfully'
    exit 0
  fi

  sleep 2
done
"