# syntax=docker/dockerfile:1.7
FROM python:3.13-slim AS builder

ENV POETRY_VIRTUALENVS_CREATE=0 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements-dev.txt ./

RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY app ./app

FROM python:3.13-slim AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN addgroup --system appuser && \
    adduser --system --ingroup appuser appuser

COPY --from=builder /usr/local/lib/python3.13 /usr/local/lib/python3.13
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app/app ./app
COPY --from=builder /app/requirements.txt /app/requirements.txt

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]