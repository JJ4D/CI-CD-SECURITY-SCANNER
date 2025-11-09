.PHONY: build run test bandit audit precommit trivy

build:
	docker build -t cisec-scan:dev .

run:
	docker run --rm -p 8000:8000 cisec-scan:dev

test:
	pytest

bandit:
	bandit -q -r app

audit:
	pip-audit --strict

precommit:
	pre-commit run --all-files

trivy:
	trivy image --exit-code 1 --severity HIGH,CRITICAL cisec-scan:dev


