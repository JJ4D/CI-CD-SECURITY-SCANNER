# CI/CD Security Scanner

Lean FastAPI microservice wired with a DevSecOps-focused pipeline. This repo demonstrates how I take a small app from local development to automated security enforcement using modern tooling.

## Why This Project?

I built this project to illustrate how to integrate security into CI/CD in code. It shows:

- A minimal, production-style FastAPI health service.
- Automated testing, linting, and security scans (Bandit, pip-audit, Trivy) triggered locally and in GitHub Actions.
- A portable Docker build with a non-root runtime image.
- Pre-commit hooks that stop accidental credential leaks and maintain code quality.

Everything is intentionally lightweight so you can review the entire flow in a few minutes.

## Architecture Overview

- **`app/main.py`** – FastAPI app exposing `/health`.
- **`tests/test_health.py`** – Unit tests using pytest + TestClient.
- **`Dockerfile`** – Multi-stage build producing a slim, non-root image.
- **`requirements*.txt`** – Pinned runtime and dev dependencies.
- **`Makefile`** – One-liners for build, test, audit, and scan tasks.
- **`.pre-commit-config.yaml`** – Local guardrails for linting and secret detection.
- **`.github/workflows/ci.yml`** – GitHub Actions pipeline that mirrors local checks.

## Local Workflow

```bash
# Install dependencies (first time)
python -m venv .venv
. .venv/Scripts/activate  # PowerShell: .\.venv\Scripts\Activate.ps1
pip install -r requirements-dev.txt

# Run the service
uvicorn app.main:app --reload
# or via Docker + Makefile
make build
make run

# Quick quality/safety sweep
make test        # pytest
make bandit      # code security audit
make audit       # dependency vulnerabilities
make trivy       # container scan (requires Trivy installed)
```

The Makefile keeps muscle memory light; hooks (Ruff, detect-secrets) run automatically on commit.

## CI Pipeline (GitHub Actions)

Every push/PR triggers `.github/workflows/ci.yml` to:

1. Install pinned dependencies.
2. Execute unit tests.
3. Run Bandit (Python static analysis).
4. Run pip-audit with `--strict` (fails on known CVEs).
5. Build the Docker image.
6. Scan the container with Trivy (fails on HIGH/CRITICAL issues).

If anything fails, the workflow blocks the merge—showing “security as code” in action.

## Security Controls Snapshot

| Surface        | Tooling                              | Notes                                                    |
|----------------|---------------------------------------|----------------------------------------------------------|
| Source code    | Ruff, Bandit, detect-secrets          | Enforced via pre-commit and CI                           |
| Dependencies   | `pip-audit --strict`                  | Breaks builds on known CVEs                              |
| Container      | Hardened Dockerfile + Trivy           | Multi-stage build, non-root user, high/critical gating   |
| Process        | GitHub Actions workflow               | Guarantees parity between local + CI checks              |

## Conversation Starters / Interview Talking Points

- **Shift-left mindset:** Explain how pre-commit hooks prevent bad code and secrets from entering history.
- **Security gating:** Walk through the CI workflow and how each stage can block insecure artifacts.
- **Dependency hygiene:** Discuss why pip-audit caught issues (e.g., outdated Starlette) and how you fixed them.
- **Container hardening:** Mention multi-stage builds, removing build toolchains, and running as a non-root user.
- **Extensibility:** Highlight the roadmap below—AWS posture checks, Checkov on Terraform, GitHub code scanning, etc.

These points help demonstrate practical DevSecOps judgment, not just tool familiarity.

## Roadmap & Enhancements

- Add a boto3-driven script to validate AWS account posture (e.g., S3 encryption checks).
- Include a Terraform sample and run Checkov in CI for IaC scanning.
- Publish baseline security metrics (results summary badge, SBOM export).
- Expand the FastAPI app with a real endpoint and integration tests.

## License

MIT. Use it, adapt it, or fork it to showcase your own security automation skills.

