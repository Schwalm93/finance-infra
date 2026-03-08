# homelab-infra

Deployment repository for GoFinance in a home network.

This stack is designed for Portainer Stack deployment (GitOps-like):
- app code lives in `app-backend` and `app-frontend`
- this repo only deploys versioned container images

## Files
- `docker-compose.yml`: deploy stack with Postgres, backend, frontend, optional pgweb
- `.env.example`: required environment variables
- `db/`: Postgres image build context with schema bootstrap SQL

## Prerequisites
- Docker host in your LAN
- Portainer connected to this git repo
- Reachable container registry (for example `registry.example.lan`)

## Setup
1. Copy `.env.example` to `.env`.
2. Set `BACKEND_IMAGE` and `FRONTEND_IMAGE` to existing tags from your Forgejo pipelines.
3. Adjust database and exposed host ports if needed.
4. Deploy the stack via Portainer (`docker-compose.yml` + `.env`).
5. Configure your existing Nginx reverse proxy with hostnames for frontend and backend.

## Deploy Script
For manual updates on the Docker host, use `deploy.sh` from this folder:

```bash
chmod +x deploy.sh
./deploy.sh deploy
```

Useful commands:

```bash
./deploy.sh ps
./deploy.sh logs backend
./deploy.sh restart backend
./deploy.sh down
```

## Local Validation
From this folder:

```bash
docker-compose --env-file .env.example -f docker-compose.yml config
```

## Notes
- This stack does not run Traefik. Routing is handled by your existing Nginx reverse proxy.
- Recommended Nginx proxy targets:
  - `finance.lan` -> `http://<docker-host-ip>:3000` (or your configured `FRONTEND_PORT`)
  - `finance-api.lan` -> `http://<docker-host-ip>:8080` (or your configured `BACKEND_PORT`)
- Database schema is initialized from `db/init.sql` via `/docker-entrypoint-initdb.d` when the Postgres volume is empty.
- If you change `db/init.sql` after first startup, recreate the DB volume to apply bootstrap changes.
- `pgweb` is optional and only starts with profile `tools`:
- Default host port for `pgweb` is `18081` to avoid common `8081` conflicts (for example Pi-hole).

```bash
docker-compose --profile tools up -d
```
