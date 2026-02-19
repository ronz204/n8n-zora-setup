.PHONY: up-dev down-dev up-prod down-prod

up-dev:
	docker compose -f compose.dev.yml up -d

down-dev:
	docker compose -f compose.dev.yml down

up-prod:
	docker compose -f compose.prod.yml up -d

down-prod:
	docker compose -f compose.prod.yml down
