# N8N Zora Setup 🚀

A production-ready Docker setup for running [n8n](https://n8n.io/) (workflow automation tool) with PostgreSQL database. This setup provides a clean, modular configuration for both development and production environments.

## 🎯 What is this?

This project provides a Docker-based setup for n8n, a powerful workflow automation tool. It includes:

- **n8n**: Workflow automation platform (version 2.7.5)
- **PostgreSQL**: Database for storing n8n workflows and credentials (version 16-alpine)
- **Docker Compose**: Orchestration for easy deployment
- **Modular Configuration**: Separate configurations for development and production

## ✅ Prerequisites

Before you begin, make sure you have the following installed:

- **Docker Desktop** (Windows/Mac) or **Docker Engine** (Linux)
  - [Download Docker Desktop](https://www.docker.com/products/docker-desktop/)
  - Minimum version: 20.10.0+
- **Docker Compose** (usually included with Docker Desktop)
  - Minimum version: 2.0.0+
- **Make** (optional, for using Makefile commands)
  - Windows: Install via [Scoop](https://scoop.sh/#/apps?q=make) with `scoop install main/make`
  - Mac: Comes pre-installed or install via Homebrew `brew install make`
  - Linux: Usually pre-installed or `sudo apt-get install make`

### Verify Installation

Run these commands to verify your setup:

```bash
docker --version
docker compose version
make --version  # Optional
```

## 🚀 Quick Start

1. **Clone or download this repository**

2. **Configure environment variables**
   ```bash
   # Copy the example files
   cp ./docker/database/secrets/.env.example database/secrets/.env.dev
   cp ./docker/service/secrets/.env.example service/secrets/.env.dev
   ```

4. **Edit the environment files** and set your passwords:
   - `docker/database/secrets/.env.dev`
   - `docker/service/secrets/.env.dev`

5. **Start the services**
   ```bash
   # Using Make (recommended)
   make up-dev
   
   # OR using Docker Compose directly
   docker compose -f compose.dev.yml up -d
   ```

6. **Access n8n**
   - Open your browser and go to: `http://localhost:5678`
   - Login with the credentials you set in `service/secrets/.env.dev`

## 📖 Detailed Setup

### Step 1: Configure Database Environment

Edit `docker/database/secrets/.env.dev`:

```env
POSTGRES_DB=zora
POSTGRES_USER=zora
POSTGRES_PASSWORD=your_secure_password_here  # ⚠️ CHANGE THIS!
```

### Step 2: Configure N8N Environment

Edit `docker/service/secrets/.env.dev`:

```env
# N8N Configuration
N8N_PORT=5678
N8N_PROTOCOL=http
N8N_HOST=localhost

# Security - Login Credentials
N8N_BASIC_AUTH_USER=n8n              # ⚠️ Change to your preferred username
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_PASSWORD=your_password  # ⚠️ CHANGE THIS!

# Database Configuration
DB_TYPE=postgresdb
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_USER=zora
DB_POSTGRESDB_DATABASE=zora
DB_POSTGRESDB_SCHEMA=public
DB_POSTGRESDB_PASSWORD=your_secure_password_here  # ⚠️ Must match database password!

# Timezone
GENERIC_TIMEZONE=America/Costa_Rica  # Change to your timezone
TZ=America/Costa_Rica                # Change to your timezone
```

**Important Notes:**
- The `DB_POSTGRESDB_PASSWORD` must match the `POSTGRES_PASSWORD` from the database configuration
- Change the default usernames and passwords for security
- Adjust the timezone to your location

### Step 3: Start the Services

```bash
make up-dev
```

This will:
1. Pull the required Docker images (if not already downloaded)
2. Create Docker volumes for persistent data storage
3. Start PostgreSQL database
4. Wait for database to be healthy
5. Start n8n service

### Step 4: Verify Everything is Running

Check the status of your containers:

```bash
docker ps
```

You should see two containers running:
- `postgres-dev`
- `n8n-dev`

Check the logs:

```bash
# View n8n logs
docker logs n8n-dev

# View PostgreSQL logs
docker logs postgres-dev

# Follow logs in real-time
docker logs -f n8n-dev
```

## ⚙️ Configuration

### Environment Variables

#### N8N Service (`./docker/service/secrets/.env.dev`)

| Variable | Description | Default |
|----------|-------------|---------|
| `N8N_PORT` | Port where n8n will be accessible | `5678` |
| `N8N_PROTOCOL` | Protocol (http/https) | `http` |
| `N8N_HOST` | Hostname | `localhost` |
| `N8N_BASIC_AUTH_USER` | Login username | `n8n` |
| `N8N_BASIC_AUTH_PASSWORD` | Login password | *required* |
| `N8N_BASIC_AUTH_ACTIVE` | Enable basic authentication | `true` |
| `DB_TYPE` | Database type | `postgresdb` |
| `DB_POSTGRESDB_HOST` | Database host | `postgres` |
| `DB_POSTGRESDB_PORT` | Database port | `5432` |
| `DB_POSTGRESDB_DATABASE` | Database name | `zora` |
| `DB_POSTGRESDB_USER` | Database user | `zora` |
| `DB_POSTGRESDB_PASSWORD` | Database password | *required* |
| `GENERIC_TIMEZONE` | Timezone for n8n | `America/Costa_Rica` |

#### PostgreSQL Database (`database/secrets/.env.dev`)

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_DB` | Database name | `zora` |
| `POSTGRES_USER` | Database user | `zora` |
| `POSTGRES_PASSWORD` | Database password | *required* |

### Changing the Port

To run n8n on a different port:

1. Edit `service/secrets/.env.dev` and change `N8N_PORT`
2. Edit `docker/service/compose.base.yml` and update the ports mapping:
   ```yaml
   ports:
     - "8080:5678"  # Change 8080 to your desired port
   ```

## 🎮 Usage

### Starting the Services

```bash
# Development environment
make up-dev

# Or without Make
docker compose -f ./docker/compose.dev.yml up -d
```

### Stopping the Services

```bash
# Development environment (removes containers and volumes)
make down-dev

# Or without Make
docker compose -f ./docker/compose.dev.yml down -v
```

**Note:** The `-v` flag removes volumes, which will delete all your workflows and data. To keep your data, use:

```bash
docker compose -f ./docker/compose.dev.yml down
```

### Restarting Services

```bash
# Restart all services
docker compose -f ./docker/compose.dev.yml restart

# Restart only n8n
docker compose -f ./docker/compose.dev.yml restart n8n
```

### Accessing n8n Web Interface

1. Open your browser
2. Navigate to `http://localhost:5678`
3. Login with your configured credentials

### Viewing Logs

```bash
# All services
docker compose -f ./docker/compose.dev.yml logs

# Specific service
docker compose -f ./docker/compose.dev.yml logs n8n
docker compose -f ./docker/compose.dev.yml logs postgres

# Follow logs in real-time
docker compose -f ./docker/compose.dev.yml logs -f n8n
```

### Accessing the Database

```bash
# Connect to PostgreSQL
docker exec -it postgres-dev psql -U zora -d zora

# Common PostgreSQL commands:
# \dt          - List tables
# \d table     - Describe table
# \q           - Quit
```

## 📁 Project Structure

```
n8n-zora-setup/
├── README.md
├── Makefile                      # Convenience commands
└── docker/
    ├── compose.base.yml          # Base volumes and networks
    ├── compose.dev.yml           # Development environment orchestration
    ├── database/
    │   ├── compose.base.yml      # PostgreSQL base configuration
    │   ├── compose.dev.yml       # PostgreSQL dev configuration
    │   └── secrets/
    │       ├── .env.example      # Example database environment variables
    │       └── .env.dev          # Development database credentials
    └── service/
        ├── compose.base.yml      # n8n base configuration
        ├── compose.dev.yml       # n8n dev configuration
        └── secrets/
            ├── .env.example      # Example n8n environment variables
            └── .env.dev          # Development n8n configuration
```

### Key Files

- **compose.base.yml**: Defines shared Docker volumes and networks
- **compose.dev.yml**: Main orchestration file that includes all services
- **Makefile**: Provides convenient commands for managing the stack
- **secrets/.env.dev**: Environment-specific configuration (not committed to git)
- **secrets/.env.example**: Template for environment variables
