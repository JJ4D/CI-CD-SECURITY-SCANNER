from fastapi.testclient import TestClient

from app.main import app, SERVICE_NAME

client = TestClient(app)


def test_health_returns_ok_status():
    response = client.get("/health")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "ok"
    assert payload["service"] == SERVICE_NAME
    assert "timestamp" in payload
    assert "uptime_seconds" in payload
