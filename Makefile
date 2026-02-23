.PHONY: up down stats clean

up:
	docker compose up -d

down:
	docker compose down

stats:
	docker compose ps

clean:
	docker compose down -v
