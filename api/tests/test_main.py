from unittest.mock import MagicMock

from fastapi.testclient import TestClient

import main


client = TestClient(main.app)


def setup_mock_redis():
    mock_redis = MagicMock()
    mock_redis.lpush.return_value = None
    mock_redis.hset.return_value = None
    mock_redis.hget.return_value = b"queued"
    main.r = mock_redis
    return mock_redis


def test_create_job_returns_job_id():
    mock_redis = setup_mock_redis()

    response = client.post("/jobs")

    assert response.status_code == 200
    assert "job_id" in response.json()
    mock_redis.lpush.assert_called_once()
    mock_redis.hset.assert_called_once()


def test_get_job_returns_status():
    setup_mock_redis()

    response = client.get("/jobs/test-job-id")

    assert response.status_code == 200
    assert response.json()["status"] == "queued"


def test_health_endpoint_returns_ok():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "ok"