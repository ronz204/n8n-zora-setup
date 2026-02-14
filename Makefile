.PHONY: up-dev down-dev up-prod down-prod

up-dev:
	docker compose -f ./docker/compose.dev.yml up -d

down-dev:
	docker compose -f ./docker/compose.dev.yml down -v

up-prod:
	docker compose -f ./docker/compose.prod.yml up -d

down-prod:
	docker compose -f ./docker/compose.prod.yml down -v
