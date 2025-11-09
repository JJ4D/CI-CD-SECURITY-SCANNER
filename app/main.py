from datetime import datetime, timezone
from fastapi import FastAPI

SERVICE_NAME = "ci-cd-security-scanner"
START_TIME = datetime.now(tz=timezone.utc)

app = FastAPI(title=SERVICE_NAME, version="0.1.0")


@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": SERVICE_NAME,
        "timestamp": datetime.now(tz=timezone.utc).isoformat(),
        "uptime_seconds": (datetime.now(tz=timezone.utc) - START_TIME).total_seconds(),
    }
