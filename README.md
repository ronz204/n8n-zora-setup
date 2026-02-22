### N8N Zora Setup

Docker setup for running [n8n](https://n8n.io/) with PostgreSQL and Redis.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v20.10+) or Docker Engine + Compose plugin

### Setup

#### 1. Configure environment variables

Each service reads from a `.env` file in its `envs/` directory. Use the provided `.env.dev` or `.env.prod` files as starting points:

```bash
# Database
cp docker/database/envs/.env.dev docker/database/envs/.env

# n8n service
cp docker/service/envs/.env.dev docker/service/envs/.env
```

Then edit both `.env` files and set the passwords.

**`docker/database/envs/.env`**
```env
POSTGRES_DB=zora
POSTGRES_USER=zora
POSTGRES_PASSWORD=your_password   # set this
```

**`docker/service/envs/.env`**
```env
N8N_PORT=5678
N8N_PROTOCOL=http
N8N_HOST=localhost

N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=zora
N8N_BASIC_AUTH_PASSWORD=your_password   # set this

DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=zora
DB_POSTGRESDB_USER=zora
DB_POSTGRESDB_SCHEMA=public
DB_POSTGRESDB_PASSWORD=your_password   # must match POSTGRES_PASSWORD

GENERIC_TIMEZONE=America/Costa_Rica
TZ=America/Costa_Rica
```

> `DB_POSTGRESDB_PASSWORD` must be the same value as `POSTGRES_PASSWORD`.

#### 2. Start the services

```bash
docker compose up -d
```

This starts all three containers. n8n waits for both PostgreSQL and Redis to be healthy before starting.

#### 3. Access n8n

Open `http://localhost:5678` and log in with the credentials set in `docker/service/envs/.env`.

### Usage

```bash
# Start
docker compose up -d

# Stop (keep volumes)
docker compose down

# Stop and remove all data
docker compose down -v

# View logs
docker compose logs -f zora

# Restart n8n only
docker compose restart zora
```

### Project Structure

```
n8n-zora-setup/
├── compose.yml                 # Root orchestration (volumes, networks, includes)
└── docker/
    ├── cache/
    │   └── compose.yml         # Redis service
    ├── database/
    │   ├── compose.yml         # PostgreSQL service
    │   └── envs/
    │       ├── .env            # Active config (gitignored)
    │       ├── .env.dev        # Dev template
    │       └── .env.prod       # Prod template
    └── service/
        ├── compose.yml         # n8n service
        └── envs/
            ├── .env            # Active config (gitignored)
            ├── .env.dev        # Dev template
            └── .env.prod       # Prod template
```
