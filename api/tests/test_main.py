from fastapi.testclient import TestClient
from unittest.mock import MagicMock
import api.main as main

client = TestClient(main.app)


def setup_mock_redis():
    mock = MagicMock()

    # mock for create_job
    mock.lpush.return_value = None
    mock.hset.return_value = None

    # mock for get_job
    mock.hget.return_value = b"queued"

    main.r = mock
    return mock


def test_create_job():
    setup_mock_redis()

    response = client.post("/jobs")
    assert response.status_code == 200
    assert "job_id" in response.json()


def test_get_job_status():
    setup_mock_redis()

    response = client.get("/jobs/test-id")
    assert response.status_code == 200
    assert response.json()["status"] == "queued"


def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"